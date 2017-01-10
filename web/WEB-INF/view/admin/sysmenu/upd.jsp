<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/inc_ctx.jsp"%>
<%@ include file="/common/inc_css.jsp"%>
<%@ include file="/common/inc_js.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/lib/ztree/css/zTreeStyle/zTreeStyle.css" />
<script type="text/javascript" src="${ctx}/lib/ztree/js/jquery.ztree.all.min.js"></script>
<script type="text/javascript">
/**********************************************************/
/* zTree配置 */
/**********************************************************/
//menuTree 的参数配置
var menuSetting = {
	async: 
	{
		enable: true,
		url:"getMenuTreeNodes.action?id=${po.m.pid}"
	} 
};
// permitTree 的参数配置
var permitSetting = {
	async: 
	{
		enable: true,
		url:"getPermitTreeNodes.action?id=${po.m.tc_sys_permit_id}"
	}
};
// zTree的初始化
$(function(){
    var s1 = $("#modal_sel1").ztreeSelectorModal({treeid:"tree_menu",
    											  title:"请选择上级菜单节点",
    											  setting:menuSetting,
    											  callback:{
    												  onConfirm:function(modalObj,rtnVal){
    													  console.info(rtnVal);
    													  $("#sel_menu").val(rtnVal.vName);
    													  $("#pid").val(rtnVal.vId);
    												  }
    											  }
    });
    var s2 = $("#modal_sel2").ztreeSelectorModal({treeid:"tree_permit",
    											  title:"请选择权限节点",
    											  setting:permitSetting,
    											  callback:{
    												  onConfirm:function(modalObj,rtnVal){
    													  console.info(rtnVal);
    													  $("#sel_permit").val(rtnVal.vName);
    													  $("#tc_sys_permit_id").val(rtnVal.vId);
    												  }
    											  }
    });
    $("#sel_menu").click(function(){
    	s1.modal("show");
    });
    $("#sel_permit").click(function(){
    	s2.modal("show");
    });
});
/**********************************************************/
/* 界面回调函数 */
/**********************************************************/
$gwen.form.callback = function(){
	if($gwen.result.type == 1){
		location.href = "get.action";
	}
};
</script>
</head>
<body>
<!-- title -->
<ol class="breadcrumb">
	<li class="active">修改</li>
</ol>
<!-- form -->
<form id="dataForm" role="form" action="upd2.action" method="post">
	<div class="form-group"><label for="tc_code">菜单代号：</label><input type="text" class="form-control" id="tc_code" name="po.m.tc_code" value="${po.m.tc_code}"/></div>
	<div class="form-group"><label for="tc_name">菜单名称：</label><input type="text" class="form-control" id="tc_name" name="po.m.tc_name" value="${po.m.tc_name}"/></div>
	<div class="form-group"><label for="tc_url">菜单URL：</label><input type="text" class="form-control" id="tc_url" name="po.m.tc_url" value="${po.m.tc_url}"/></div>
	<div class="form-group"><label for="tc_order">菜单排序号：</label><input type="text" class="form-control" id="tc_order" name="po.m.tc_order" value="${po.m.tc_order}"/></div>
	<div class="form-group"><label for="tc_sys_permit_id">绑定权限：</label>
		<input type="text" class="form-control" id="sel_permit" value="${po.m.tc_sys_permit_name}"/>
		<input type="hidden" class="form-control" id="tc_sys_permit_id" name="po.m.tc_sys_permit_id" value="${po.m.tc_sys_permit_id}"/>
	</div>
	<div class="form-group"><label for="pid">父节点：</label>
		<input type="text" class="form-control" id="sel_menu" value="${po.m.tc_p_name}"/>
		<input type="hidden" class="form-control" id="pid" name="po.m.pid" value="${po.m.pid}"/>
	</div>
	<input type="hidden" name="po.m.id" value="${po.m.id}">
	<button type="submit" class="btn btn-default" id="dataFormSave"><i class="glyphicon glyphicon-floppy-save"></i></button>
	<button type="button" class="btn btn-default" id="back" onclick="window.history.back()"><i class="glyphicon glyphicon-arrow-left"></i></button>
</form>
<!-- modal -->
<div id="modal_sel1"></div>
<div id="modal_sel2"></div>
</body>
</html>