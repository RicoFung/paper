package admin.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import admin.entity.SysRole;
import admin.entity.SysUser;
import admin.service.SysRoleService;
import admin.service.SysUserService;
import chok.devwork.BaseAction;
import chok.devwork.PageNav;
import chok.util.CollectionUtil;
import chok.util.EncryptionUtil;


@SuppressWarnings("serial")
@Controller
@Scope("prototype")
@ParentPackage(value="struts-default")
@Namespace("/admin/sysuser")
public class SysUserAction extends BaseAction<SysUser>
{
	@Autowired
	private SysUserService service;
	@Autowired
	private SysRoleService roleService;
	
	//实体类
	private SysUser po;
	public SysUser getPo() {return po;}
	public void setPo(SysUser po) {this.po = po;}
	
	@Action(value="add1",results={ @Result(name = "success", location = "/WEB-INF/view/admin/sysuser/add.jsp")})
	public String add1() 
	{
		setQueryParams(getReq().getParameterValueMap(false, true));
		return "success";
	}
	@Action(value="add2")
	public void add2() 
	{
		service.add(po);
		print("1");
	}
	
	@Action(value="del")
	public void del() 
	{
		try
		{
			service.del(CollectionUtil.toLongArray(getReq().getLongArray("id[]", 0l)));
			getResult().setSuccess(true);
		}
		catch(Exception e)
		{
			getResult().setSuccess(false);
			getResult().setMsg(e.getMessage());
		}
		printJson(getResult());
	}
	
	@Action(value="upd1",results={ @Result(name = "success", location = "/WEB-INF/view/admin/sysuser/upd.jsp")})
	public String upd1() 
	{
		setQueryParams(getReq().getParameterValueMap(false, true));
		po = service.getById(getReq().getLong("id"));
		return "success";
	}
	@Action(value="upd2")
	public void upd2() 
	{
		service.upd(po);
		print("1");
	}
	
	@Action(value="updPwd1",results={ @Result(name = "success", location = "/WEB-INF/view/admin/sysuser/updPwd.jsp")})
	public String updPwd1() 
	{
		setQueryParams(getReq().getParameterValueMap(false, true));
		po = service.getById(getReq().getLong("id"));
		return "success";
	}
	@Action(value="updPwd2")
	public void updPwd2() 
	{
		try 
		{
			po = service.getById(getReq().getLong("id"));
			if(!EncryptionUtil.getMD5(getReq().getString("old_password")).equals(po.getString("tc_password")))
			{
				getResult().setSuccess(false);
				getResult().setMsg("原密码不正确");
			}
			else
			{
				po.set("tc_password", EncryptionUtil.getMD5(getReq().getString("new_password")));
				service.updPwd(po);
				getResult().setSuccess(true);
			}
		}
		catch (Exception e)
		{
			getResult().setSuccess(false);
			getResult().setMsg(e.getMessage());
		}
		printJson(getResult());
	}

	@Action(value="getById",results={ @Result(name = "success", location = "/WEB-INF/view/admin/sysuser/getById.jsp")})
	public String getById() 
	{
		setQueryParams(getReq().getParameterValueMap(false, true));
		po = service.getById(getReq().getLong("id"));
		return "success";
	}
	
	@Action(value="getMyInfo",results={ @Result(name = "success", location = "/WEB-INF/view/admin/sysuser/getMyInfo.jsp")})
	public String getMyInfo() 
	{
		setQueryParams(getReq().getParameterValueMap(false, true));
		po = service.getById(getReq().getLong("id"));
		return "success";
	}

	@Action(value="get",results={ @Result(name = "success", location = "/WEB-INF/view/admin/sysuser/get.jsp")})
	public String get() 
	{
		setQueryParams(getReq().getParameterValueMap(false, true));
		return "success";
	}
	
	@Action(value="getJson")
	public void getJson()
	{
		Map m = getReq().getParameterValueMap(false, true);
		getResult().put("total",service.getCount(m));
		getResult().put("rows",service.get(m));
		printJson(getResult().getData());
	}
	
	@Action(value="getRoleTreeNodes")
	public void getRoleTreeNodes()
	{
		List<SysRole> resultData = roleService.get(null);
		List<Object> treeNodes = new ArrayList<Object>();
		for(SysRole o : resultData)
		{
			treeNodes.add(o.getM());
		}
		printJson(treeNodes);
	}
	
	@Action(value="getRoleTreeNodesByUser")
	public void getRoleTreeNodesByUser()
	{
		Map m = new HashMap();
		m.put("tc_sys_user_id", getReq().getLong("id"));
		List<SysRole> userRoleData = roleService.getByUserId(m);
		List<SysRole> roleData = roleService.get(null);
		List<Object> treeNodes = new ArrayList<Object>();
		
		for(int i=0; i<roleData.size(); i++)
		{
			SysRole o = roleData.get(i);
			for(int j=0; j<userRoleData.size(); j++)
			{
				SysRole o1 = userRoleData.get(j);
				if(o.getLong("id") == o1.getLong("id"))
				{
					o.set("checked", true);
				}
			}
			treeNodes.add(o.getM());
		}
		printJson(treeNodes);
	}
}