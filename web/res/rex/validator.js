$rex.validator = {
	/**
	 * prop
	 * 定义规则算法 
	 */
	rules:{
		/**
		 * prop
		 * 各种规则算法实现
		 */
		fn:{
			required:function(v){
				return v.length>0;
			},
			minLength:function(v,l){
				return v.length>=l;
			},
			maxLength:function(v,l){
				return v.length<=l;
			},
			number:function(v){
				var r = /^(\-|\+)?\d+(\.\d+)?$/;
				return r.test(v);
			},
			integer:function(v){
				var r = /^-?\d+$/;
				return r.test(v);
			},
			email:function(v){
				var r = /^([\w-_]+(?:\.[\w-_]+)*)@((?:[a-z0-9]+(?:-[a-zA-Z0-9]+)*)+\.[a-z]{2,6})$/i;
				return r.test(v);
			},
			idno:function(v){
			},
			url:function(v){
				
			}
		},
		/**
		 * prop
		 *  定义规则提示信息 
		 */
		msgs:{
			"required":"必填",
			"minLength":"字符串长度不足",
			"maxLength":"字符串长度过大",
			"number":"输入类型必须为数字",
			"integer":"输入类型必须为整数",
			"email":"email邮箱格式不合法",
			"idno":"身份证号格式不合法",
			"url":"url格式不合法"
		},
	},
	/**
	 * fn
	 * 添加提示
	 */
	addMsg:function(ruleName, $e){
		$e.parent().addClass("has-error");
		var msg = $rex.validator.rules.msgs[ruleName];
		if(typeof($e.attr("validate-msg"))!="undefined") msg = $e.attr("validate-msg");
		if($e.next(".control-label").length>0){
			$e.next(".control-label").text(msg);
		}
		else{
			$e.after("<label class=\"control-label\">"+msg+"</label>");
		}
	},
	/**
	 * fn
	 * 移除提示
	 */
	removeMsg:function($e){
		$e.parent().removeClass("has-error");
		$e.next(".control-label").remove();
	},
	
	/**
	 * fn
	 * 执行验证
	 */
	check:function(){
		var v = true;
		var a = [];
		//遍历验证每个被标记为“validate”的表单元素
		$("[validate]").each(function(i){
			if(typeof($(this).attr("validate-rule-required"))!="undefined"){
				var ruleName = "required";
				var inputValue = $(this).val();
				if(!$rex.validator.rules.fn[ruleName](inputValue)){
					$rex.validator.addMsg(ruleName,$(this));
					a[i] = false;
					return;
				}else{
					$rex.validator.removeMsg($(this));
					a[i] = true;
				}
			}
			if(typeof($(this).attr("validate-rule-inputType"))!="undefined"){
				var ruleName = $(this).attr("validate-rule-inputType");
				var inputValue = $(this).val();
				if(!$rex.validator.rules.fn[ruleName](inputValue)){
					$rex.validator.addMsg(ruleName,$(this));
					a[i] = false;
					return;
				}else{
					$rex.validator.removeMsg($(this));
					a[i] = true;
				}
			}
			if(typeof($(this).attr("validate-rule-minLength"))!="undefined"){
				var ruleName = "minLength";
				var inputValue = $(this).val();
				var referValue = $(this).attr("validate-rule-minLength");
				if(!$rex.validator.rules.fn[ruleName](inputValue, referValue)){
					$rex.validator.addMsg(ruleName,$(this));
					a[i] = false;
					return;
				}else{
					$rex.validator.removeMsg($(this));
					a[i] = true;
				}
			}
			if(typeof($(this).attr("validate-rule-maxLength"))!="undefined"){
				var ruleName = "maxLength";
				var inputValue = $(this).val();
				var referValue = $(this).attr("validate-rule-maxLength");
				if(!$rex.validator.rules.fn[ruleName](inputValue, referValue)){
					$rex.validator.addMsg(ruleName,$(this));
					a[i] = false;
					return;
				}else{
					$rex.validator.removeMsg($(this));
					a[i] = true;
				}
			}
		});
		if(a.indexOf(false)!=-1) v=false;
		return v;
	}
};
