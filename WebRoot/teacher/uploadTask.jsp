<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<title>SWFUpload Demos - Simple Demo</title>
<link href="${pageContext.request.contextPath}/css/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/javaScript/swfu/swfupload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/javaScript/swfu/swfupload.queue.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/javaScript/swfu/fileprogress.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/javaScript/swfu/handlers.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/javaScript/jquery-1.8.0.min.js"></script>
<script type="text/javascript">
		var swfu;
		window.onload = function() {
			//是否选择上传实验指导书
			var oYes=document.getElementById('yes');
			var oNo=document.getElementById('no');
			var oS=document.getElementById('select');
			var oSure=document.getElementById('sure');
			oYes.onclick=function(){
				oS.style.display='inline';
				oYes.style.display='none';
				oSure.style.display='none';
			};
			oNo.onclick=function(){
				oS.style.display='none';
				oSure.style.display='inline';
				oYes.style.display='inline';
			};
			oSure.onclick=function(){
				onlyTaskName();
			};
			
			var settings = {
				flash_url : "${pageContext.request.contextPath}/javaScript/swfu/swfupload.swf",
				upload_url: '${pageContext.request.contextPath}/teacher/TaskUtil_addTask',
				file_post_name : "file",
				file_size_limit : "30 MB",
				file_types : "*.*",
				file_types_description : "All Files",
				file_upload_limit : 100,
				file_queue_limit : 0,
				custom_settings : {
					progressTarget : "fsUploadProgress"
				},
				debug: false,

				// Button settings
				button_image_url: "${pageContext.request.contextPath}/images/uploadbtn.png",
				button_width: "65",
				button_height: "26",
				button_placeholder_id: "spanButtonPlaceHolder",
				
				// The event handler functions are defined in handlers.js
				file_queued_handler : fileQueued,
				file_queue_error_handler : fileQueueError,
				file_dialog_complete_handler : fileDialogComplete,
				
				//文件选择好后可以在这里设置上传参数post_params{},调用handlers.js中的uploadStart()方法
				upload_start_handler : uploadStartFile,
				
				upload_progress_handler : uploadProgress,
				upload_error_handler : uploadError,
				upload_success_handler : uploadSuccess
			};

			swfu = new SWFUpload(settings);
	     };
	     
	     function uploadStartFile(){
	    	//上传文件前在这设置参数
	    	var teacherCourseId = "<%=request.getParameter("teacherCourseId")%>";
			var userId = '${sessionScope.user.userId}';
			var taskName = document.getElementById("taskName").value;
			var courseId = <%=request.getParameter("courseId")%>;
			var obj = {
						 "courseId":courseId,
						 "taskName":taskName,
						 "teacherCourseId":teacherCourseId,
						 "userId":userId
				};
			 swfu.setPostParams(obj);
	     };
	     
	     //只上传文件名
	     function onlyTaskName(){
		    	var teacherCourseId = "<%=request.getParameter("teacherCourseId")%>";
		    	var userId = '${sessionScope.user.userId}';
		    	var taskName = document.getElementById("taskName").value;
		    	var courseId = <%=request.getParameter("courseId")%>;
		    	var obj = {
		    						 "courseId":courseId,
		    						 "taskName":taskName,
		    						 "teacherCourseId":teacherCourseId,
		    						 "userId":userId
		    				};
		    	 if(taskName == ""){
		    		 alert("任务名称不能为空！");
					 return false;
		    	 }else{ 
		    			 $.ajax({
				    		 url:'${pageContext.request.contextPath}/teacher/TaskUtil_addTask',
				    			type:'post',
				    			data:obj,
				    			dataType:'json',
				    			success:function(b){
				    				alert(b);
				    				}
				    	 });
		    		 }
		    	 }
	     
	     //选择文件时上传任务
	     function uploadTaskName(){
	    	var teacherCourseId = "<%=request.getParameter("teacherCourseId")%>";
	    	var userId = '${sessionScope.user.userId}';
	    	var taskName = document.getElementById("taskName").value;
	    	var courseId = <%=request.getParameter("courseId")%>;
	    	var obj = {
	    						 "courseId":courseId,
	    						 "taskName":taskName,
	    						 "teacherCourseId":teacherCourseId,
	    						 "userId":userId
	    				};
	    	 if(taskName == ""){
	    		 alert("任务名称不能为空！");
				 return false;
	    	 }else{
	    		 if(!swfu.startUpload()){		     
		    		 return true;
	    		 }
	    		 else{ 
	    			 $.ajax({
			    		 url:'${pageContext.request.contextPath}/teacher/TaskUtil_addTask',
			    			type:'post',
			    			data:obj,
			    			dataType:'json',
			    			success:function(b){
			    				alert(b);
			    			}
			    	 });
	    			 swfu.startUpload();
	    		 }
	    	 }
	     }; 
	
	     
	  
	     /*//模拟alert()弹出框
	     
	     function myAlert(str,caption){
			    this.disappear=function(){
					 $("#bgdiv").remove();
					 $("#msgdiv").remove();
					 $("#msgtitle").remove();
					 msgobj=null;
					 msgdiv=null;
				};
			disappear();
			   this.m_text=str;
			   this.m_caption=caption;
			   this.m_width=200;
			   this.m_height=130;
			   this.m_wait=3000;
			   this.m_fade=1500;
			   this.m_bordercolor="#336699";
			   this.m_titlecolor="lightblue";
			   var msgw,msgh,bordercolor;
			   msgw=m_width;//提示窗口的宽度
			   msgh=m_height;//提示窗口的高度
			   titleheight=25 //提示窗口标题高度
			   bordercolor=m_bordercolor;//提示窗口的边框颜色
			   titlecolor=m_titlecolor;//提示窗口的标题颜色
			   
			   var swidth,sheight;
			   swidth=document.body.offsetWidth;
			   sheight=document.body.offsetHeight;
			   if (sheight<screen.height){
					sheight=screen.height;
			   }if(msgobj==null){
					var msgobj=document.createElement("div");
			   }
			   msgobj.setAttribute("id","msgdiv");
			   msgobj.setAttribute("align","center");
			   msgobj.style.background="white";
			   msgobj.style.border="1px solid " + bordercolor;
			   msgobj.style.position = "absolute";
				msgobj.style.left = "50%";
				msgobj.style.top = "50%";
				msgobj.style.font="12px/1.6em verdana, geneva, arial, helvetica, sans-serif";
				msgobj.style.marginLeft = "-115px" ;
				msgobj.style.marginTop = -115+document.documentElement.scrollTop+"px";
				msgobj.style.width = msgw + "px";
				msgobj.style.height =msgh + "px";
				msgobj.style.textAlign = "center";
				msgobj.style.lineHeight = (msgh-titleheight) + "px";
				msgobj.style.zIndex = "10001";
				if(title==null){
					 var title=document.createElement("h4");
				}
			     title.setAttribute("id","msgtitle");
			     title.setAttribute("align","left");
			     title.style.margin="0";
			     title.style.padding="3px";
			     title.style.background=bordercolor;
			     title.style.filter="progid:dximagetransform.microsoft.alpha(startx=20, starty=20, finishx=100, finishy=100,style=1,opacity=75,finishopacity=100);";
			     title.style.opacity="0.75";
			     title.style.border="1px solid " + bordercolor;
			     title.style.height="18px";
			     title.style.font="12px verdana, geneva, arial, helvetica, sans-serif";
			     title.style.color="white";
			     title.style.cursor="pointer";
			     title.innerHTML="消息提示";
			     title.onclick=function(){
			  disappear();
			                }
			document.body.appendChild(msgobj);
			document.getElementById("msgdiv").appendChild(title);
			var txt=document.createElement("p");
			txt.style.margin="1em 0"
			txt.setAttribute("id","msgtxt");
			txt.innerHTML=str;
			             document.getElementById("msgdiv").appendChild(txt);
			
			this.fadeout=function(){
			   $("#bgdiv").fadeOut(1000);
			$("#msgdiv").fadeOut(1000);
			$("#msgtitle").fadeOut(1000,function(){disappear()});
			}
			setTimeout("fadeout()",500);
			};*/
	</script>
</head>
<body>

<div id="content">
	<form  method="post" enctype="multipart/form-data" >
		<div>
			<span><b>任务名称</b></span>
			<span>
				<input id="taskName" type="text" value="" style="border-color:gray;"/>
			</span>
		 <input type="button" id="sure" value="发布任务" style="width:60px;display:inline;height:24px;font-size:1em;">
		</div>
		<div><input style="margin-right:5px;width:60px;display:block;" type="button" id="yes" value="上传文件"><div>
		<div id="select" style="display:none;">
			<div><b>您只能上传30M以内的文件哦</b></div>
			<div class="fieldset flash" id="fsUploadProgress">
				<span class="legend">请选择实验指导书</span>
			</div>
			<div id="swfupload_btn">
				<span id="spanButtonPlaceHolder"></span>
				<!-- 文件名称为num -->
				<input type="button" id="start" value="上传并发布任务" onclick="uploadTaskName()"  style="margin-left: 2px;"/>
				<input type="button" id="no" value="取消上传" style="margin-left: 5px;">
			</div>
		</div>
	</form>
</div>

</body>
</html>
