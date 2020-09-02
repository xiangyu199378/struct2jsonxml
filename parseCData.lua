-- 解析结构体, 获取结构体的成员变量名
local ffi = require("ffi");
local def = require("bundle://app/define");

local parseCData = nil

local function getCTypeMembers(ctype)
    return ffi.keys(ctype);
end

local function getCType(cdata)
    local typename = string.match(tostring(cdata), "[^<]*<([^([*&]+)");
    local arrlen = string.match(tostring(cdata), '%[([^%]]+)%]');

    if arrlen == "?" then
        error("Can not convert '?' to number.");
    end
    return typename or '', tonumber(arrlen);
end

local function isStructCType(tp)
    local struct = string.match(tp, "struct");
    if not struct then
        return false;
    end
    return true;
end

local function isCDataArray(cdata)
    local ctype, arrlen = getCType(cdata);
    if not arrlen then
        return false;
    end
    return true;
end

local function isCDataStruct(cdata)
    local ctype, arrlen = getCType(cdata);
    if arrlen then
        return false;
    end
    return isStructCType(ctype);
end

local function array2table(cdata)
    local ret = {};
    local ctype, arrlen = getCType(cdata);

    for i=0, arrlen-1, 1 do
        table.insert(ret, parseCData(cdata[i]));
    end
    
    return ret;
end

local function struct2table(cdata)
    local ret = {};
    
    local ctype = getCType(cdata);

    -- 获取该类型的结构的成员变量名称
    local members = getCTypeMembers(ctype);
    for i,vname in ipairs(members) do
        ret[vname] = parseCData(cdata[vname]);
    end
    return ret;
end

parseCData = function (cdata)
    if isCDataArray(cdata) then
        return array2table(cdata)

    elseif isCDataStruct(cdata) then
        return struct2table(cdata)
    end

    return tonumber(cdata);
end

return {
    getCTypeMembers = getCTypeMembers;
    parseCData = parseCData;
};