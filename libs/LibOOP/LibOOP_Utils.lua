local MAJOR = "LibOOP-1.0"
--[===[@alpha@
MAJOR = MAJOR.."-alpha"
--@end-alpha@]===]
local MINOR = 0
local REQMINOR = 0

local function test(LibOOP)
	-- LibOOP:Class()
	local C = LibOOP:Class()
	assert(type(C)=="table", "C = LibOOP:Class()")
	local D = LibOOP:Class()
	assert(type(D)=="table", "D = LibOOP:Class()")
	
	-- <class>:Extend()
	local C2 = C:Extend()
	assert(type(C2)=="table", "C2 = C:Extend()")
	local C3 = C2:Extend()
	assert(type(C3)=="table", "C3 = C2:Extend()")
	local D2 = D:Extend()
	assert(type(D2)=="table", "D2 = D:Extend()")
	
	-- <class>:GetSuperClass()
	assert(C:GetSuperClass()==false, "C:GetSuperClass() == false")
	assert(C2:GetSuperClass()==C, "C2:GetSuperClass() == C")
	assert(C3:GetSuperClass()==C2, "C3:GetSuperClass() == C2")
	assert(D:GetSuperClass()==false, "D:GetSuperClass() == false")
	assert(D2:GetSuperClass()==D, "D2:GetSuperClass() == D")
	
	-- <class>:SubClassOf([super[, direct]])
	assert(C:SubClassOf()==true, "C:SubClassOf() == true")
	assert(C:SubClassOf(C)==true, "C:SubClassOf(C) == true")
	assert(C:SubClassOf(C,true)==false, "C:SubClassOf(C,true) == false")
	assert(C:SubClassOf(C2)==false, "C:SubClassOf(C2) == false")
	assert(C:SubClassOf(C2,true)==false, "C:SubClassOf(C2,true) == false")
	assert(C:SubClassOf(D)==false, "C:SubClassOf(D) == false")
	assert(C:SubClassOf(D,true)==false, "C:SubClassOf(D) == false")
	assert(C:SubClassOf(D2)==false, "C:SubClassOf(D2) == false")
	assert(C:SubClassOf(D2,true)==false, "C:SubClassOf(D2) == false")
	assert(C:SubClassOf(1)==false, "C:SubClassOf(1) == false")
	assert(C:SubClassOf(2,true)==false, "C:SubClassOf(2,true) == false")
	assert(C2:SubClassOf()==true, "C2:SubClassOf() == true")
	assert(C2:SubClassOf(C)==true, "C2:SubClassOf(C) == true")
	assert(C2:SubClassOf(C,true)==true, "C2:SubClassOf(C,true) == true")
	assert(C2:SubClassOf(C2)==true, "C2:SubClassOf(C2) == true")
	assert(C2:SubClassOf(C2,true)==false, "C2:SubClassOf(C2,true) == false")
	assert(C2:SubClassOf(C3)==false, "C2:SubClassOf(C3) == false")
	assert(C2:SubClassOf(C3,true)==false, "C2:SubClassOf(C3) == false")
	assert(C2:SubClassOf(D)==false, "C2:SubClassOf(D) == false")
	assert(C2:SubClassOf(D,true)==false, "C2:SubClassOf(D,true) == false")
	assert(C2:SubClassOf(D2)==false, "C2:SubClassOf(D2) == false")
	assert(C2:SubClassOf(D2,true)==false, "C2:SubClassOf(D2,true) == false")
	assert(C2:SubClassOf(3)==false, "C2:SubClassOf(3) == false")
	assert(C2:SubClassOf(4,true)==false, "C2:SubClassOf(4) == false")
	
	-- class method
	function C:test() return "test C" end
	assert(type(C.test)=="function", "function C:test() return 'test C' end")
	assert(C:test()=="test C", "C:test() == 'test C'")
	
	-- class method inheritance
	assert(C2.test==C.test, "C2.test == C.test")
	assert(C2:test()=="test C", "C2:test() == 'test C'")
	assert(C3.test==C.test, "C3.test == C.test")
	assert(C3:test()=="test C", "C3:test() == 'test C'")
	assert(D.test==nil, "D.test == nil")
	
	-- class method override
	function C2:test(s) return "test("..tostring(s)..")C2" end
	assert(type(C2.test)=="function", "function C2:test(s) return 'test('..s..')C2' end")
	assert(C2.test~=C.test, "C2.test ~= C.test")
	assert(C2:test(5)=="test(5)C2", "C2:test(5) == 'test(5)C2'")
	assert(C3.test==C2.test, "C3.test == C2.test")
	assert(C3:test(6)=="test(6)C2", "C3:test(6) == 'test(6)C2'")
	assert(D.test==nil, "D.test == nil")
	
	-- <class>:Super(method[, ...])
	assert(C2:Super('test')=="test C", "C2:Super('test') == 'test C'")
	assert(C3:Super('test')=="test C", "C3:Super('test') == 'test C'")
	local status,result = pcall(function() C:Super("test") end)
	assert(status==false and result~="failed to find inherited class method test", "!! C:Super('test') => failed")
	local status,result = pcall(function() C2:Super("SubClassOf",C) end)
	assert(status==false and result~="failed to find inherited class method SubClassOf", "!! C2:Super('SubClassOf',C) => failed")
	local status,result = pcall(function() C2:Super("fake") end)
	assert(status==false and result~="failed to find inherited class method fake", "!! C2:Super('fake') => failed")
	
	-- <class>:function() self:Super(method[, ...]) end
	function C2:test(a,b) return tostring(a).."("..self:Super("test")..")"..tostring(b) end
	assert(type(C2.test)=="function", "function C2:test(a,b) return a..'('..self:Super('test')..')'..b end")
	assert(C2:test(7,8)=="7(test C)8", "C2:test(7,8) == '7(test C)8'")
	assert(C3.test==C2.test, "C3.test == C2.test")
	assert(C3:test(9,10)=="9(test C)10", "C3:test(9,10) == '9(test C)10'")
	
	-- non-overridable class methods
	local status,result = pcall(function() function C2:GetSuperClass() return "gsc" end end)
	assert(status==false and result~="not allowed to redefine class method GetSuperClass", "!! function C2:GetSuperClass() end => not allowed")
	assert(C2:GetSuperClass()==C, "C2:GetSuperClass() == C")
	local status,result = pcall(function() function C2:SubClassOf() return "sco" end end)
	assert(status==false and result~="not allowed to redefine class method SubClassOf", "!! function C2:SubClassOf() end => not allowed")
	assert(C2:SubClassOf(C,true)==true, "C2:SubClassOf(C,true) == true")
	local status,result = pcall(function() function C2:Super() return "s" end end)
	assert(status==false and result~="not allowed to redefine class method Super", "!! function C2:Super() end => not allowed")
	assert(C2:test(7,8)=="7(test C)8", "C2:test(7,8) == '7(test C)8'")
	assert(C3:test(9,10)=="9(test C)10", "C3:test(9,10) == '9(test C)10'")
	
	-- <class>:Extend() override
	function D:Extend(a)
		local ext = self:Super('Extend')
		ext.prop = a
		return ext
	end
	assert(type(D.Extend)=="function", "function D:Extend(a) ... end")
	assert(C2.Extend==C.Extend, "C2.Extend == C.Extend")
	assert(D.Extend~=C.Extend, "D.Extend ~= C.Extend")
	local D2 = D:Extend(11)
	assert(type(D2)=="table", "D2 = D:Extend(11)")
	assert(D2:SubClassOf(D)==true, "D2:SubClassOf(D) == true")
	assert(D2.prop==11, "D2.prop == 11")
	local D3 = D2:Extend(12)
	assert(type(D3)=="table", "D3 = D2:Extend(12)")
	assert(D3:SubClassOf(D2)==true, "D3:SubClassOf(D2) == true")
	assert(D2.prop==11, "D2.prop == 11")
	assert(D3.prop==12, "D3.prop == 12")
	
	
	-- <class>:New()
	local oC = C:New()
	assert(type(oC)=="table", "oC = C:New()")
	local oC2 = C2:New()
	assert(type(oC2)=="table", "oC2 = C2:New()")
	local oC3 = C3:New()
	assert(type(oC3)=="table", "oC3 = C3:New()")
	
	-- <class>()
	local oD = D()
	assert(type(oD)=="table", "oD = D()")
	
	-- <object>:Clone()
	oC.iprop = 13
	assert(oC.iprop==13, "oC.iprop = 13")
	local o2C = oC:Clone()
	assert(type(o2C)=="table", "o2C = oC:Clone()")
	assert(o2C.iprop==13, "o2C.iprop == 13")
	oC.iprop = 14
	assert(oC.iprop==14, "oC.iprop = 14")
	assert(o2C.iprop==13, "o2C.iprop == 13")
	
	-- <object>:GetClass()
	assert(oC:GetClass()==C, "oC:GetClass() == C")
	assert(oC2:GetClass()==C2, "oC2:GetClass() == C2")
	assert(oC3:GetClass()==C3, "oC3:GetClass() == C3")
	
	-- <object>:InstanceOf([class[, direct]])
	assert(oC:InstanceOf()==true, "oC:InstanceOf() == true")
	assert(oC:InstanceOf(C)==true, "oC:InstanceOf(C) == true")
	assert(oC:InstanceOf(C,true)==true, "oC:InstanceOf(C,true) == true")
	assert(oC:InstanceOf(C2)==false, "oC:InstanceOf(C2) == false")
	assert(oC:InstanceOf(C2,true)==false, "oC:InstanceOf(C2,true) == false")
	assert(oC:InstanceOf(D)==false, "oC:InstanceOf(D) == false")
	assert(oC:InstanceOf(D,true)==false, "oC:InstanceOf(D,true) == false")
	assert(oC:InstanceOf(D2)==false, "oC:InstanceOf(D2) == false")
	assert(oC:InstanceOf(D2,true)==false, "oC:InstanceOf(D2,true) == false")
	assert(oC:InstanceOf(15)==false, "oC:InstanceOf(15) == false")
	assert(oC:InstanceOf(16,true)==false, "oC:InstanceOf(16,true) == false")
	assert(oC2:InstanceOf()==true, "oC2:InstanceOf() == true")
	assert(oC2:InstanceOf(C)==true, "oC2:InstanceOf(C) == true")
	assert(oC2:InstanceOf(C,true)==false, "oC2:InstanceOf(C,true) == false")
	assert(oC2:InstanceOf(C2)==true, "oC2:InstanceOf(C2) == true")
	assert(oC2:InstanceOf(C2,true)==true, "oC2:InstanceOf(C2,true) == true")
	assert(oC2:InstanceOf(C3)==false, "oC2:InstanceOf(C3) == false")
	assert(oC2:InstanceOf(C3,true)==false, "oC2:InstanceOf(C3,true) == false")
	assert(oC2:InstanceOf(D)==false, "oC2:InstanceOf(D) == false")
	assert(oC2:InstanceOf(D,true)==false, "oC2:InstanceOf(D,true) == false")
	assert(oC2:InstanceOf(D2)==false, "oC2:InstanceOf(D2) == false")
	assert(oC2:InstanceOf(D2,true)==false, "oC2:InstanceOf(D2,true) == false")
	assert(oC2:InstanceOf(17)==false, "oC2:InstanceOf(17) == false")
	assert(oC2:InstanceOf(18,true)==false, "oC2:InstanceOf(18,true) == false")
	
	-- instance method
	assert(type(C.prototype)=="table", "C.prototype")
	function C.prototype:itest() return "itest("..tostring(self.iprop)..")oC" end
	assert(type(C.prototype.itest)=="function", "function C.prototype:itest() return 'itest('..self.iprop..')oC' end")
	assert(oC.itest==C.prototype.itest, "oC.itest == C.prototype.itest")
	assert(o2C.itest==C.prototype.itest, "o2C.itest == C.prototype.itest")
	assert(oC:itest()=="itest(14)oC", "oC:itest() == 'itest(14)oC'")
	assert(o2C:itest()=="itest(13)oC", "oC:itest() == 'itest(13)oC'")
	
	-- instance method inheritance
	assert(C2.prototype.itest==C.prototype.itest, "C2.prototype.itest == C.prototype.itest")
	assert(oC2.itest==oC.itest, "oC2.itest == oC.itest")
	assert(oC2:itest()=="itest(nil)oC", "oC2:itest() == 'itest(nil)oC'")
	assert(oC3.itest==oC.itest, "oC3.itest == oC.itest")
	assert(oC3:itest()=="itest(nil)oC", "oC3:itest() == 'itest(nil)oC'")
	assert(D.prototype.itest==nil, "D.prototype.itest == nil")
	assert(oD.itest==nil, "oD.itest == nil")
	
	-- instance method override
	function C2.prototype:itest(a) return "itest oC2:"..tostring(a) end
	assert(type(C2.prototype.itest)=="function", "function C2.prototype:itest(a) return 'itest oC2:'..a end")
	assert(C2.prototype.itest~=C.prototype.itest, "C2.prototype.itest ~= C.prototype.itest")
	assert(oC2:itest(19)=="itest oC2:19", "oC2:itest(19) == 'itest oC2:19'")
	assert(oC3:itest(20)=="itest oC2:20", "oC3:itest(20) == 'itest oC2:20'")
	assert(D.prototype.itest==nil, "D.prototype.itest == nil")
	assert(oD.itest==nil, "oD.itest == nil")
	
	-- <object>:Super(method[, ...])
	oC2.iprop = 21
	assert(oC2.iprop==21, "oC2.iprop = 21")
	oC3.iprop = 22
	assert(oC3.iprop==22, "oC3.iprop = 22")
	assert(oC2:Super('itest')=="itest(21)oC", "oC2:Super('itest') == 'itest(21)oC'")
	assert(oC3:Super('itest')=="itest(22)oC", "oC3:Super('itest') == 'itest(22)oC'")
	local status,result = pcall(function() oC:Super("itest") end)
	assert(status==false and result~="failed to find inherited instance method itest", "!! oC:Super('itest') => failed")
	local status,result = pcall(function() oC2:Super("InstanceOf",C) end)
	assert(status==false and result~="failed to find inherited instance method InstanceOf", "!! oC2:Super('InstanceOf',C) => failed")
	local status,result = pcall(function() oC2:Super("fake") end)
	assert(status==false and result~="failed to find inherited instance method fake", "!! oC2:Super('fake') => failed")
	
	-- <prototype>:function() self:Super(method[, ...]) end
	function C2.prototype:itest(a,b) return tostring(a).."("..self:Super("itest")..")"..tostring(b) end
	assert(type(C2.prototype.itest)=="function", "function C2.prototype:itest(a,b) return a..'('..self:Super('itest')..')'..b end")
	assert(oC2.itest==C2.prototype.itest, "oC2.itest == C2.prototype.itest")
	assert(oC2:itest(23,24)=="23(itest(21)oC)24", "C2:test(23,24) == '23(itest(21)oC)24'")
	assert(oC3.itest==oC2.itest, "oC3.test == oC2.itest")
	assert(oC3:itest(25,26)=="25(itest(22)oC)26", "C3:test(25,26) == '25(itest(22)oC)26'")
	
	-- <object>:function() self:Super(method[, ...]) end
	function oC3:itest(a,b) return "<<"..self:Super("itest",a,b)..">>" end
	assert(type(oC3.itest)=="function", "function oC3:itest(a,b) return '<<'..self:Super('itest',a,b)..'>>' end")
	assert(oC3.itest~=C3.prototype.itest, "oC3.itest ~= C3.prototype.itest")
	assert(oC3:Super("itest","x","y")=="x(itest(22)oC)y", "oC3:Super('itest','x','y')=='x(itest(22)oC)y'")
	assert(oC3:itest(27,28)=="<<27(itest(22)oC)28>>", "oC3:itest(27,28) == '<<27(itest(22)oC)28>>'")
	
	-- non-overridable instance methods
	local status,result = pcall(function() function C2.prototype:GetClass() return "gc" end end)
	assert(status==false and result~="not allowed to redefine instance method GetClass", "!! function C2.prototype:GetClass() end => not allowed")
	local status,result = pcall(function() function oC2:GetClass() return "ogc" end end)
	assert(status==false and result~="not allowed to redefine instance method GetClass", "!! function oC2:GetClass() end => not allowed")
	assert(oC2:GetClass()==C2, "oC2:GetClass() == C2")
	local status,result = pcall(function() function C2.prototype:InstanceOf() return "io" end end)
	assert(status==false and result~="not allowed to redefine instance method InstanceOf", "!! function C2.prototype:InstanceOf() end => not allowed")
	local status,result = pcall(function() function oC2:InstanceOf() return "oio" end end)
	assert(status==false and result~="not allowed to redefine instance method InstanceOf", "!! function oC2:InstanceOf() end => not allowed")
	assert(oC2:InstanceOf(C2,true)==true, "oC2:InstanceOf(C2,true) == true")
	local status,result = pcall(function() function C2.prototype:Super() return "s" end end)
	assert(status==false and result~="not allowed to redefine instance method Super", "!! function C2.prototype:Super() end => not allowed")
	local status,result = pcall(function() function oC2:Super() return "os" end end)
	assert(status==false and result~="not allowed to redefine instance method Super", "!! function oC2:Super() end => not allowed")
	assert(oC2:itest(29,30)=="29(itest(21)oC)30", "C2:test(29,30) == '29(itest(21)oC)30'")
	assert(oC3:itest(31,32)=="<<31(itest(22)oC)32>>", "oC3:itest(31,32) == '<<31(itest(22)oC)32>>'")
	
	-- <object>:Clone() override
	function D.prototype:Clone(a)
		local obj = self:Super('Clone')
		obj.iprop = obj.iprop + a
		return obj
	end
	assert(type(D.prototype.Clone)=="function", "function D.prototype:Clone(a) ... end")
	assert(oC2.Clone==oC.Clone, "oC2.Clone == oC.Clone")
	assert(oD.Clone~=oC.Clone, "oD.Clone ~= oC.Clone")
	oD.iprop = 33
	assert(oD.iprop==33, "oD.iprop = 33")
	local o2D = oD:Clone(34)
	assert(type(o2D)=="table", "o2D = oD:Clone(34)")
	assert(o2D:InstanceOf(D)==true, "o2D:InstanceOf(D) == true")
	assert(o2D.iprop==67, "o2D.iprop == 67")
	local oD2 = D2()
	oD2.iprop = 35
	assert(oD2.iprop==35, "oD2.iprop = 35")
	local o2D2 = oD2:Clone(36)
	assert(type(o2D2)=="table", "o2D2 = oD2:Clone(36)")
	assert(o2D2:InstanceOf(D2)==true, "o2D2:InstanceOf(D2) == true")
	assert(oD2.iprop==35, "o2D.iprop == 35")
	assert(o2D2.iprop==71, "o2D2.iprop == 71")
	
	-- <class>:New() override
	function D2:New(n)
		local obj = self:Super('New')
		obj.name = n
		return obj
	end
	assert(type(D2.New)=="function", "function D2:New() ... end")
	assert(C.New==D.New, "C.New == D.New")
	assert(D2.New~=D.New, "D2.New ~= D.New")
	local o3D2 = D2:New("adam")
	assert(type(o3D2)=="table", "o3D2 = D2:New('adam')")
	assert(o3D2.name=="adam", "o3D2.name == 'adam'")
	local oD3 = D3("bob")
	assert(oD3.name=="bob", "oD3.name == 'bob'")
	
	-- <class>:New() disable
	D3.New = false
	assert(D3.New~=D2.New, "D3.New = false")
	local status,result = pcall(function() D3:New() end)
	assert(status==false and type(result)=="string", "!! D3:New() => failed")
	local status,result = pcall(function() D3() end)
	assert(status==false and result~="failed to instantiate using class-call, :New() is not a function", "!! D3() => failed")
	
	
	-- LibOOP:GetClass(object)
	assert(LibOOP:GetClass(oC)==C, "LibOOP:GetClass(oC) == C")
	assert(LibOOP:GetClass(oC2)==C2, "LibOOP:GetClass(oC2) == C2")
	assert(LibOOP:GetClass(C)==nil, "LibOOP:GetClass(C) == nil")
	assert(LibOOP:GetClass(37)==nil, "LibOOP:GetClass(37) == nil")
	
	-- LibOOP:GetSuperClass(class)
	assert(LibOOP:GetSuperClass(C)==false, "LibOOP:GetSuperClass(C) == false")
	assert(LibOOP:GetSuperClass(C2)==C, "LibOOP:GetSuperClass(C2) == C")
	assert(LibOOP:GetSuperClass(D2)==D, "LibOOP:GetSuperClass(D2) == D")
	assert(LibOOP:GetSuperClass(oC)==nil, "LibOOP:GetSuperClass(oC) == nil")
	assert(LibOOP:GetSuperClass(oC2)==nil, "LibOOP:GetSuperClass(oC2) == nil")
	assert(LibOOP:GetSuperClass(oD)==nil, "LibOOP:GetSuperClass(oD) == nil")
	assert(LibOOP:GetSuperClass(38)==nil, "LibOOP:GetSuperClass(38) == nil")
	
	-- LibOOP:InstanceOf(object[, class[, direct]])
	assert(LibOOP:InstanceOf(oC2)==true, "LibOOP:InstanceOf(oC2) == true")
	assert(LibOOP:InstanceOf(oC2,C)==true, "LibOOP:InstanceOf(oC2,C) == true")
	assert(LibOOP:InstanceOf(oC2,C,true)==false, "LibOOP:InstanceOf(oC2,C,true) == false")
	assert(LibOOP:InstanceOf(oC2,C2)==true, "LibOOP:InstanceOf(oC2,C2) == true")
	assert(LibOOP:InstanceOf(oC2,C2,true)==true, "LibOOP:InstanceOf(oC2,C2,true) == true")
	assert(LibOOP:InstanceOf(oC2,C3)==false, "LibOOP:InstanceOf(oC2,C3) == false")
	assert(LibOOP:InstanceOf(oC2,D)==false, "LibOOP:InstanceOf(oC2,D) == false")
	assert(LibOOP:InstanceOf(oC2,39)==false, "LibOOP:InstanceOf(oC2,39) == false")
	assert(LibOOP:InstanceOf(oC2,40,true)==false, "LibOOP:InstanceOf(oC2,40,true) == false")
	assert(LibOOP:InstanceOf(41)==nil, "LibOOP:InstanceOf(41) == nil")
	assert(LibOOP:InstanceOf(42,C)==nil, "LibOOP:InstanceOf(42,C) == nil")
	assert(LibOOP:InstanceOf(43,C,true)==nil, "LibOOP:InstanceOf(43,C,true) == nil")
	assert(LibOOP:InstanceOf(44,45)==nil, "LibOOP:InstanceOf(44,45) == nil")
	assert(LibOOP:InstanceOf(46,47,true)==nil, "LibOOP:InstanceOf(46,47,true) == nil")
	
	-- LibOOP:SubClassOf()
	assert(LibOOP:SubClassOf(C3)==true, "LibOOP:SubClassOf(C3) == true")
	assert(LibOOP:SubClassOf(C3,C)==true, "LibOOP:SubClassOf(C3,C) == true")
	assert(LibOOP:SubClassOf(C3,C,true)==false, "LibOOP:SubClassOf(C3,C,true) == false")
	assert(LibOOP:SubClassOf(C3,C2)==true, "LibOOP:SubClassOf(C3,C2) == true")
	assert(LibOOP:SubClassOf(C3,C2,true)==true, "LibOOP:SubClassOf(C3,C2,true) == true")
	assert(LibOOP:SubClassOf(C3,C3)==true, "LibOOP:SubClassOf(C3,C3) == true")
	assert(LibOOP:SubClassOf(C3,C3,true)==false, "LibOOP:SubClassOf(C3,C3,true) == false")
	assert(LibOOP:SubClassOf(C3,D)==false, "LibOOP:SubClassOf(C3,D) == false")
	assert(LibOOP:SubClassOf(C3,48)==false, "LibOOP:SubClassOf(C3,48) == false")
	assert(LibOOP:SubClassOf(C3,49,true)==false, "LibOOP:SubClassOf(C3,49,true) == false")
	assert(LibOOP:SubClassOf(50)==nil, "LibOOP:SubClassOf(50) == nil")
	assert(LibOOP:SubClassOf(51,C)==nil, "LibOOP:SubClassOf(51,C) == nil")
	assert(LibOOP:SubClassOf(52,C,true)==nil, "LibOOP:SubClassOf(52,C,true) == nil")
	assert(LibOOP:SubClassOf(53,54)==nil, "LibOOP:SubClassOf(53,54) == nil")
	assert(LibOOP:SubClassOf(55,56,true)==nil, "LibOOP:SubClassOf(55,56,true) == nil")
	
	-- LibOOP:Super()
	assert(LibOOP:Super(C2,"test")=="test C", "LibOOP:Super(C2,'test') == 'test C'")
	assert(LibOOP:Super(C3,"test")=="test C", "LibOOP:Super(C3,'test') == 'test C'")
	assert(LibOOP:Super(oC2,"itest")=="itest(21)oC", "LibOOP:Super(oC2,'itest') == 'itest(21)oC'")
	assert(LibOOP:Super(oC3,"itest","w","z")=="w(itest(22)oC)z", "LibOOP:Super(oC3,'itest','w','z') == 'w(itest(22)oC)z'")
	assert(LibOOP:Super(57,"test")==nil, "LibOOP:Super(57,'test') == nil")
	
	
	return true
end -- test()

SlashCmdList["LIBOOP"] = function(args)
	-- bail out if the library core is older than supported or newer than these utilities
	local LibOOP,libminor = LibStub(MAJOR)
	if (libminor < REQMINOR or libminor > MINOR) then
		print("LibOOP: Utilities rev. "..MINOR.." are not compatible with library rev. "..libminor..".")
		return
	end
	if (args == "test") then
		print("LibOOP: Running self-test...")
		assert(test(LibOOP)==true, "LibOOP self-test failed")
		print("LibOOP: ...passed.")
	else
		print(MAJOR.." standalone utilities rev. "..MINOR)
		print("'/liboop test' to run self-test")
	end
end
SLASH_LIBOOP1 = "/liboop"
