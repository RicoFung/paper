<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/inc_ctx.jsp"%>
<%@ include file="/common/inc_css.jsp"%>
<%@ include file="/common/inc_js.jsp"%>
<%@ include file="/common/inc_js_btn_permit.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/res/ztree/css/zTreeStyle/zTreeStyle.css" />
<script type="text/javascript" src="${ctx}/res/ztree/js/jquery.ztree.all.min.js"></script>
<script type="text/javascript" src="${ctx}/res/rex/js/view.get.js"></script>
<script type="text/javascript">
/**********************************************************/
/* 全局函数 */
/**********************************************************/
$(function() {
	$rex.view.get.init.toolbar();
	$rex.view.get.init.modalFormQuery();
	$rex.view.get.init.table("${queryParams.f_page}","${queryParams.f_pageSize}");
	initTree();
	initBtnPermit("${sessionScope.CUR_MENU_PERMIT_ID}");
});
/**********************************************************/
/* 初始化配置 */
/**********************************************************/
$rex.view.get.config.setPreFormParams = function(){
 	$("#f_tc_p_name").val(typeof("${queryParams.f_tc_p_name}")=="undefined"?"":"${queryParams.f_tc_p_name}");
	$("#f_tc_code").val(typeof("${queryParams.f_tc_code}")=="undefined"?"":"${queryParams.f_tc_code}");
	$("#f_tc_name").val(typeof("${queryParams.f_tc_name}")=="undefined"?"":"${queryParams.f_tc_name}");
};
$rex.view.get.config.formParams = function(p){
	p.tc_p_name = $("#f_tc_p_name").val();
	p.tc_code = $("#f_tc_code").val();
	p.tc_name = $("#f_tc_name").val();
    return p;
};
$rex.view.get.config.urlParams = function(){
	return {f_tc_p_name : $("#f_tc_p_name").val(),
		   	f_tc_code : $("#f_tc_code").val(),
		   	f_tc_name : $("#f_tc_name").val()};
};
$rex.view.get.config.tableColumns = 
[
    {title:'菜单代号', field:'m.tc_code', align:'center', valign:'middle', sortable:false},
    {title:'菜单名称', field:'m.tc_name', align:'center', valign:'middle', sortable:false},
    {title:'菜单URL', field:'m.tc_url', align:'center', valign:'middle', sortable:false},
    {title:'菜单排序号', field:'m.tc_order', align:'center', valign:'middle', sortable:false},
    {title:'绑定权限', field:'m.tc_sys_permit_name', align:'center', valign:'middle', sortable:false},
    {title:'父节点', field:'m.tc_p_name', align:'center', valign:'middle', sortable:false}
];
$rex.view.get.callback.delRows = function(){
	zTreeObj.reAsyncChildNodes(null, "refresh"); // 刷新zTree
};
$rex.view.get.callback.onLoadSuccess = function(){
	initBtnPermit("${sessionScope.CUR_MENU_PERMIT_ID}");
};
/**********************************************************/
/* zTree配置 */
/**********************************************************/
// zTree 的参数配置
var zTreeObj;
var setting = 
{
	view: 
	{
		selectedMulti: false
	},
	check: 
	{
		enable: false
	},
	async: 
	{
		enable: true,
		url:"getMenuTreeNodes.action"
	},
	data: 
	{
		key: 
		{
			name:"tc_name"
		},
		simpleData: 
		{
			idKey:"id",
			pIdKey:"pid",
			enable: true
		}
	},
	callback: {
	}
};
// zTree的初始化
function initTree(){
    zTreeObj = $.fn.zTree.init($("#menuTree"), setting);
    // 全部展开/折叠
    $("#expandAll").click(function(){
    	var zTree = $.fn.zTree.getZTreeObj("menuTree");
        if($(this).prop("checked")==true){
        	zTree.expandAll(true);
        }else{
        	zTree.expandAll(false);
        }
    });
}
</script>
</head>
<body class="body-content">
<!-- toolbar
======================================================================================================= -->
<div id="toolbar">
<button type="button" class="btn btn-default" id="bar_btn_add" pbtnId="pbtn_add"><i class="glyphicon glyphicon-plus"></i></button>
<button type="button" class="btn btn-default" id="bar_btn_del" pbtnId="pbtn_del"><i class="glyphicon glyphicon-remove"></i></button>
<button type="button" class="btn btn-default" id="bar_btn_query" pbtnId="pbtn_query" data-toggle="modal" data-target="#modal_form_query"><i class="glyphicon glyphicon-search"></i></button>
</div>
<!-- data list
======================================================================================================= -->
<div class="wrapper">
	<div class="row clearfix">
		<div class="col-md-10 column">
			<fieldset>
				<table id="tb_list"></table>
			</fieldset>
		</div>
		<div class="col-md-2 column">
			<fieldset>
				<input type="checkbox" id="expandAll"/><label for="expandAll">&nbsp;展开</label>
				<ul id="menuTree" class="ztree" style="overflow:auto"></ul>
			</fieldset>
		</div>
	</div>
</div>
<!-- query form modal
======================================================================================================= -->
<form id="form_query">
<div id="modal_form_query" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modal_label" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
			   <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			   <h4 class="modal-title" id="modal_label">筛选条件</h4>
			</div>
			<div class="modal-body">
				<!-- queryForm -->
				<div class="form-group">
					 <label for="f_tc_p_name">父节点名称：</label><input type="text" class="form-control input-sm" id="f_tc_p_name"/>
					 <label for="f_tc_name">菜单代号：</label><input type="text" class="form-control input-sm" id="f_tc_code"/>
					 <label for="f_tc_name">菜单名称：</label><input type="text" class="form-control input-sm" id="f_tc_name"/>
				</div>
			</div>
			<div class="modal-footer">
			   <button type="reset" class="btn btn-default"><i class="glyphicon glyphicon-repeat"></i></button>
			   <button type="button" class="btn btn-primary" id="form_query_btn"><i class="glyphicon glyphicon-ok"></i></button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal -->
</div>
</form>
</body>
</html>

