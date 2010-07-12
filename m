Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0GLW44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:56:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39468 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab0GLW41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:56:27 -0400
From: Nishanth Menon <nm@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 07/11] staging: tidspbridge: replace CONST with c standard const
Date: Mon, 12 Jul 2010 17:56:05 -0500
Message-Id: <1278975369-7687-8-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1278975369-7687-1-git-send-email-nm@ti.com>
References: <1278975369-7687-1-git-send-email-nm@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/staging/tidspbridge/core/chnl_sm.c         |    4 ++--
 drivers/staging/tidspbridge/core/io_sm.c           |    2 +-
 drivers/staging/tidspbridge/core/msg_sm.c          |    2 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |    2 +-
 .../staging/tidspbridge/include/dspbridge/chnl.h   |    2 +-
 .../staging/tidspbridge/include/dspbridge/cmm.h    |    2 +-
 .../staging/tidspbridge/include/dspbridge/cod.h    |    2 +-
 .../staging/tidspbridge/include/dspbridge/dev.h    |    8 ++++----
 .../staging/tidspbridge/include/dspbridge/disp.h   |    4 ++--
 .../staging/tidspbridge/include/dspbridge/dmm.h    |    2 +-
 .../tidspbridge/include/dspbridge/dspchnl.h        |    4 ++--
 .../tidspbridge/include/dspbridge/dspdefs.h        |   10 +++++-----
 .../staging/tidspbridge/include/dspbridge/dspio.h  |    2 +-
 .../staging/tidspbridge/include/dspbridge/dspmsg.h |    2 +-
 drivers/staging/tidspbridge/include/dspbridge/io.h |    2 +-
 .../staging/tidspbridge/include/dspbridge/nldr.h   |    4 ++--
 .../tidspbridge/include/dspbridge/nldrdefs.h       |    4 ++--
 .../staging/tidspbridge/include/dspbridge/node.h   |   10 +++++-----
 .../staging/tidspbridge/include/dspbridge/proc.h   |    6 +++---
 .../staging/tidspbridge/include/dspbridge/pwr.h    |    4 ++--
 drivers/staging/tidspbridge/pmgr/chnl.c            |    2 +-
 drivers/staging/tidspbridge/pmgr/cmm.c             |    2 +-
 drivers/staging/tidspbridge/pmgr/cod.c             |    4 ++--
 drivers/staging/tidspbridge/pmgr/dev.c             |    4 ++--
 drivers/staging/tidspbridge/pmgr/dmm.c             |    2 +-
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    2 +-
 drivers/staging/tidspbridge/pmgr/io.c              |    2 +-
 drivers/staging/tidspbridge/rmgr/disp.c            |    4 ++--
 drivers/staging/tidspbridge/rmgr/nldr.c            |    4 ++--
 drivers/staging/tidspbridge/rmgr/node.c            |   14 +++++++-------
 drivers/staging/tidspbridge/rmgr/proc.c            |    8 ++++----
 drivers/staging/tidspbridge/rmgr/pwr.c             |    4 ++--
 32 files changed, 65 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/chnl_sm.c b/drivers/staging/tidspbridge/core/chnl_sm.c
index b669bc0..25fe1a2 100644
--- a/drivers/staging/tidspbridge/core/chnl_sm.c
+++ b/drivers/staging/tidspbridge/core/chnl_sm.c
@@ -383,7 +383,7 @@ func_cont:
  */
 int bridge_chnl_create(OUT struct chnl_mgr **phChnlMgr,
 			      struct dev_object *hdev_obj,
-			      IN CONST struct chnl_mgrattrs *pMgrAttrs)
+			      IN const struct chnl_mgrattrs *pMgrAttrs)
 {
 	int status = 0;
 	struct chnl_mgr *chnl_mgr_obj = NULL;
@@ -777,7 +777,7 @@ int bridge_chnl_idle(struct chnl_object *chnl_obj, u32 dwTimeOut,
  */
 int bridge_chnl_open(OUT struct chnl_object **phChnl,
 			    struct chnl_mgr *hchnl_mgr, s8 chnl_mode,
-			    u32 uChnlId, CONST IN struct chnl_attr *pattrs)
+			    u32 uChnlId, const IN struct chnl_attr *pattrs)
 {
 	int status = 0;
 	struct chnl_mgr *chnl_mgr_obj = hchnl_mgr;
diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 280b22d..73ba306 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -163,7 +163,7 @@ static int register_shm_segs(struct io_mgr *hio_mgr,
  */
 int bridge_io_create(OUT struct io_mgr **phIOMgr,
 			    struct dev_object *hdev_obj,
-			    IN CONST struct io_attrs *pMgrAttrs)
+			    IN const struct io_attrs *pMgrAttrs)
 {
 	int status = 0;
 	struct io_mgr *pio_mgr = NULL;
diff --git a/drivers/staging/tidspbridge/core/msg_sm.c b/drivers/staging/tidspbridge/core/msg_sm.c
index 7b7a4be..576dac0 100644
--- a/drivers/staging/tidspbridge/core/msg_sm.c
+++ b/drivers/staging/tidspbridge/core/msg_sm.c
@@ -383,7 +383,7 @@ func_end:
  *      Put a message onto a msg_ctrl queue.
  */
 int bridge_msg_put(struct msg_queue *msg_queue_obj,
-			  IN CONST struct dsp_msg *pmsg, u32 utimeout)
+			  IN const struct dsp_msg *pmsg, u32 utimeout)
 {
 	struct msg_frame *msg_frame_obj;
 	struct msg_mgr *hmsg_mgr;
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 33fcef5..0a4b054 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -237,7 +237,7 @@ static void bad_page_dump(u32 pa, struct page *pg)
  *      Bridge Driver entry point.
  */
 void bridge_drv_entry(OUT struct bridge_drv_interface **ppDrvInterface,
-		   IN CONST char *driver_file_name)
+		   IN const char *driver_file_name)
 {
 
 	DBC_REQUIRE(driver_file_name != NULL);
diff --git a/drivers/staging/tidspbridge/include/dspbridge/chnl.h b/drivers/staging/tidspbridge/include/dspbridge/chnl.h
index 89315dc..4e3d99e 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/chnl.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/chnl.h
@@ -79,7 +79,7 @@ extern int chnl_close(struct chnl_object *chnl_obj);
  */
 extern int chnl_create(OUT struct chnl_mgr **phChnlMgr,
 			      struct dev_object *hdev_obj,
-			      IN CONST struct chnl_mgrattrs *pMgrAttrs);
+			      IN const struct chnl_mgrattrs *pMgrAttrs);
 
 /*
  *  ======== chnl_destroy ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cmm.h b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
index 493ff56..5b902c1 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cmm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
@@ -87,7 +87,7 @@ extern void *cmm_calloc_buf(struct cmm_object *hcmm_mgr,
  */
 extern int cmm_create(OUT struct cmm_object **ph_cmm_mgr,
 			     struct dev_object *hdev_obj,
-			     IN CONST struct cmm_mgrattrs *pMgrAttrs);
+			     IN const struct cmm_mgrattrs *pMgrAttrs);
 
 /*
  *  ======== cmm_destroy ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cod.h b/drivers/staging/tidspbridge/include/dspbridge/cod.h
index 6914247..4edc6a1 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cod.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cod.h
@@ -93,7 +93,7 @@ extern void cod_close(struct cod_libraryobj *lib);
  */
 extern int cod_create(OUT struct cod_manager **phManager,
 			     char *pstrZLFile,
-			     IN OPTIONAL CONST struct cod_attrs *attrs);
+			     IN OPTIONAL const struct cod_attrs *attrs);
 
 /*
  *  ======== cod_delete ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dev.h b/drivers/staging/tidspbridge/include/dspbridge/dev.h
index 434c128..126adaa 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dev.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dev.h
@@ -91,7 +91,7 @@ extern u32 dev_brd_write_fxn(void *pArb,
  */
 extern int dev_create_device(OUT struct dev_object
 				    **phDevObject,
-				    IN CONST char *driver_file_name,
+				    IN const char *driver_file_name,
 				    struct cfg_devnode *dev_node_obj);
 
 /*
@@ -126,8 +126,8 @@ extern int dev_create_device(OUT struct dev_object
  */
 extern int dev_create_iva_device(OUT struct dev_object
 					**phDevObject,
-					IN CONST char *driver_file_name,
-					IN CONST struct cfg_hostres
+					IN const char *driver_file_name,
+					IN const struct cfg_hostres
 					*pHostConfig,
 					struct cfg_devnode *dev_node_obj);
 
@@ -490,7 +490,7 @@ extern int dev_get_node_manager(struct dev_object
  *      0:        *pul_value contains the symbol value;
  */
 extern int dev_get_symbol(struct dev_object *hdev_obj,
-				 IN CONST char *pstrSym, OUT u32 * pul_value);
+				 IN const char *pstrSym, OUT u32 * pul_value);
 
 /*
  *  ======== dev_get_bridge_context ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/disp.h b/drivers/staging/tidspbridge/include/dspbridge/disp.h
index 2fd14b0..421b260 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/disp.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/disp.h
@@ -50,7 +50,7 @@
  */
 extern int disp_create(OUT struct disp_object **phDispObject,
 			      struct dev_object *hdev_obj,
-			      IN CONST struct disp_attr *pDispAttrs);
+			      IN const struct disp_attr *pDispAttrs);
 
 /*
  *  ======== disp_delete ========
@@ -147,7 +147,7 @@ extern int disp_node_create(struct disp_object *hDispObject,
 				   struct node_object *hnode,
 				   u32 ul_fxn_addr,
 				   u32 ul_create_fxn,
-				   IN CONST struct node_createargs
+				   IN const struct node_createargs
 				   *pargs, OUT nodeenv *pNodeEnv);
 
 /*
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dmm.h b/drivers/staging/tidspbridge/include/dspbridge/dmm.h
index 1ce1b65..1581ebb 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dmm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dmm.h
@@ -59,7 +59,7 @@ extern int dmm_delete_tables(struct dmm_object *dmm_mgr);
 
 extern int dmm_create(OUT struct dmm_object **phDmmMgr,
 			     struct dev_object *hdev_obj,
-			     IN CONST struct dmm_mgrattrs *pMgrAttrs);
+			     IN const struct dmm_mgrattrs *pMgrAttrs);
 
 extern bool dmm_init(void);
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspchnl.h b/drivers/staging/tidspbridge/include/dspbridge/dspchnl.h
index 5661bca..0eb0d9d 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspchnl.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspchnl.h
@@ -26,7 +26,7 @@
 
 extern int bridge_chnl_create(OUT struct chnl_mgr **phChnlMgr,
 				     struct dev_object *hdev_obj,
-				     IN CONST struct chnl_mgrattrs
+				     IN const struct chnl_mgrattrs
 				     *pMgrAttrs);
 
 extern int bridge_chnl_destroy(struct chnl_mgr *hchnl_mgr);
@@ -35,7 +35,7 @@ extern int bridge_chnl_open(OUT struct chnl_object **phChnl,
 				   struct chnl_mgr *hchnl_mgr,
 				   s8 chnl_mode,
 				   u32 uChnlId,
-				   CONST IN OPTIONAL struct chnl_attr
+				   const IN OPTIONAL struct chnl_attr
 				   *pattrs);
 
 extern int bridge_chnl_close(struct chnl_object *chnl_obj);
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
index 536816b..d92f82c 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
@@ -326,7 +326,7 @@ typedef int(*fxn_chnl_create) (OUT struct chnl_mgr
 				      **phChnlMgr,
 				      struct dev_object
 				      * hdev_obj,
-				      IN CONST struct
+				      IN const struct
 				      chnl_mgrattrs * pMgrAttrs);
 
 /*
@@ -411,7 +411,7 @@ typedef int(*fxn_chnl_open) (OUT struct chnl_object
 				    struct chnl_mgr *hchnl_mgr,
 				    s8 chnl_mode,
 				    u32 uChnlId,
-				    CONST IN OPTIONAL struct
+				    const IN OPTIONAL struct
 				    chnl_attr * pattrs);
 
 /*
@@ -745,7 +745,7 @@ typedef int(*fxn_dev_destroy) (struct bridge_dev_context *hDevContext);
  */
 typedef int(*fxn_io_create) (OUT struct io_mgr **phIOMgr,
 				    struct dev_object *hdev_obj,
-				    IN CONST struct io_attrs *pMgrAttrs);
+				    IN const struct io_attrs *pMgrAttrs);
 
 /*
  *  ======== bridge_io_destroy ========
@@ -915,7 +915,7 @@ typedef int(*fxn_msg_get) (struct msg_queue *msg_queue_obj,
  *  Ensures:
  */
 typedef int(*fxn_msg_put) (struct msg_queue *msg_queue_obj,
-				  IN CONST struct dsp_msg *pmsg, u32 utimeout);
+				  IN const struct dsp_msg *pmsg, u32 utimeout);
 
 /*
  *  ======== bridge_msg_register_notify ========
@@ -1048,6 +1048,6 @@ struct bridge_drv_interface {
  *      Called during the Device_Init phase.
  */
 void bridge_drv_entry(OUT struct bridge_drv_interface **ppDrvInterface,
-		   IN CONST char *driver_file_name);
+		   IN const char *driver_file_name);
 
 #endif /* DSPDEFS_ */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspio.h b/drivers/staging/tidspbridge/include/dspbridge/dspio.h
index 275697a..563b779 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspio.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspio.h
@@ -28,7 +28,7 @@
 
 extern int bridge_io_create(OUT struct io_mgr **phIOMgr,
 				   struct dev_object *hdev_obj,
-				   IN CONST struct io_attrs *pMgrAttrs);
+				   IN const struct io_attrs *pMgrAttrs);
 
 extern int bridge_io_destroy(struct io_mgr *hio_mgr);
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspmsg.h b/drivers/staging/tidspbridge/include/dspbridge/dspmsg.h
index a10634e..d01d756 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspmsg.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspmsg.h
@@ -42,7 +42,7 @@ extern int bridge_msg_get(struct msg_queue *msg_queue_obj,
 				 struct dsp_msg *pmsg, u32 utimeout);
 
 extern int bridge_msg_put(struct msg_queue *msg_queue_obj,
-				 IN CONST struct dsp_msg *pmsg, u32 utimeout);
+				 IN const struct dsp_msg *pmsg, u32 utimeout);
 
 extern int bridge_msg_register_notify(struct msg_queue *msg_queue_obj,
 					  u32 event_mask,
diff --git a/drivers/staging/tidspbridge/include/dspbridge/io.h b/drivers/staging/tidspbridge/include/dspbridge/io.h
index e1610f1..0a25829 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/io.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/io.h
@@ -51,7 +51,7 @@
  */
 extern int io_create(OUT struct io_mgr **phIOMgr,
 			    struct dev_object *hdev_obj,
-			    IN CONST struct io_attrs *pMgrAttrs);
+			    IN const struct io_attrs *pMgrAttrs);
 
 /*
  *  ======== io_destroy ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/nldr.h b/drivers/staging/tidspbridge/include/dspbridge/nldr.h
index b1dbccd..14bea86 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/nldr.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/nldr.h
@@ -26,14 +26,14 @@
 #define NLDR_
 
 extern int nldr_allocate(struct nldr_object *nldr_obj,
-				void *priv_ref, IN CONST struct dcd_nodeprops
+				void *priv_ref, IN const struct dcd_nodeprops
 				*node_props,
 				OUT struct nldr_nodeobject **phNldrNode,
 				IN bool *pf_phase_split);
 
 extern int nldr_create(OUT struct nldr_object **phNldr,
 			      struct dev_object *hdev_obj,
-			      IN CONST struct nldr_attrs *pattrs);
+			      IN const struct nldr_attrs *pattrs);
 
 extern void nldr_delete(struct nldr_object *nldr_obj);
 extern void nldr_exit(void);
diff --git a/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h b/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
index 9be0483..abe44a5 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
@@ -129,7 +129,7 @@ enum nldr_phase {
  */
 typedef int(*nldr_allocatefxn) (struct nldr_object *nldr_obj,
 				       void *priv_ref,
-				       IN CONST struct dcd_nodeprops
+				       IN const struct dcd_nodeprops
 				       * node_props,
 				       OUT struct nldr_nodeobject
 				       **phNldrNode,
@@ -158,7 +158,7 @@ typedef int(*nldr_allocatefxn) (struct nldr_object *nldr_obj,
  */
 typedef int(*nldr_createfxn) (OUT struct nldr_object **phNldr,
 				     struct dev_object *hdev_obj,
-				     IN CONST struct nldr_attrs *pattrs);
+				     IN const struct nldr_attrs *pattrs);
 
 /*
  *  ======== nldr_delete ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/node.h b/drivers/staging/tidspbridge/include/dspbridge/node.h
index e9d8439..4c6c31b 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/node.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/node.h
@@ -56,9 +56,9 @@
  *      error:              *ph_node == NULL.
  */
 extern int node_allocate(struct proc_object *hprocessor,
-				IN CONST struct dsp_uuid *pNodeId,
-				OPTIONAL IN CONST struct dsp_cbdata
-				*pargs, OPTIONAL IN CONST struct dsp_nodeattrin
+				IN const struct dsp_uuid *pNodeId,
+				OPTIONAL IN const struct dsp_cbdata
+				*pargs, OPTIONAL IN const struct dsp_nodeattrin
 				*attr_in,
 				OUT struct node_object **ph_node,
 				struct process_context *pr_ctxt);
@@ -470,7 +470,7 @@ extern int node_pause(struct node_object *hnode);
  *  Ensures:
  */
 extern int node_put_message(struct node_object *hnode,
-				   IN CONST struct dsp_msg *pmsg, u32 utimeout);
+				   IN const struct dsp_msg *pmsg, u32 utimeout);
 
 /*
  *  ======== node_register_notify ========
@@ -554,7 +554,7 @@ extern int node_terminate(struct node_object *hnode,
  *
  */
 extern int node_get_uuid_props(void *hprocessor,
-				      IN CONST struct dsp_uuid *pNodeId,
+				      IN const struct dsp_uuid *pNodeId,
 				      OUT struct dsp_ndbprops
 				      *node_props);
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/proc.h b/drivers/staging/tidspbridge/include/dspbridge/proc.h
index 230828c..9ad0934 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/proc.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/proc.h
@@ -52,7 +52,7 @@ extern char *iva_img;
  *      When attr_in is NULL, the default timeout value is 10 seconds.
  */
 extern int proc_attach(u32 processor_id,
-			      OPTIONAL CONST struct dsp_processorattrin
+			      OPTIONAL const struct dsp_processorattrin
 			      *attr_in, void **ph_processor,
 			      struct process_context *pr_ctxt);
 
@@ -329,8 +329,8 @@ extern int proc_get_trace(void *hprocessor, u8 * pbuf, u32 max_size);
  *      can load the processor.
  */
 extern int proc_load(void *hprocessor,
-			    IN CONST s32 argc_index, IN CONST char **user_args,
-			    IN CONST char **user_envp);
+			    IN const s32 argc_index, IN const char **user_args,
+			    IN const char **user_envp);
 
 /*
  *  ======== proc_register_notify ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/pwr.h b/drivers/staging/tidspbridge/include/dspbridge/pwr.h
index 63ccf8c..5fc85ea 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/pwr.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/pwr.h
@@ -45,7 +45,7 @@
  *      -EPERM:          General failure, unable to send sleep command to
  *                          the DSP.
  */
-extern int pwr_sleep_dsp(IN CONST u32 sleepCode, IN CONST u32 timeout);
+extern int pwr_sleep_dsp(IN const u32 sleepCode, IN const u32 timeout);
 
 /*
  *  ======== pwr_wake_dsp ========
@@ -66,7 +66,7 @@ extern int pwr_sleep_dsp(IN CONST u32 sleepCode, IN CONST u32 timeout);
  *      -EPERM:          General failure, unable to send wake command to
  *                          the DSP.
  */
-extern int pwr_wake_dsp(IN CONST u32 timeout);
+extern int pwr_wake_dsp(IN const u32 timeout);
 
 /*
  *  ======== pwr_pm_pre_scale ========
diff --git a/drivers/staging/tidspbridge/pmgr/chnl.c b/drivers/staging/tidspbridge/pmgr/chnl.c
index 9007bfd..d2c089c 100644
--- a/drivers/staging/tidspbridge/pmgr/chnl.c
+++ b/drivers/staging/tidspbridge/pmgr/chnl.c
@@ -53,7 +53,7 @@ static u32 refs;
  */
 int chnl_create(OUT struct chnl_mgr **phChnlMgr,
 		       struct dev_object *hdev_obj,
-		       IN CONST struct chnl_mgrattrs *pMgrAttrs)
+		       IN const struct chnl_mgrattrs *pMgrAttrs)
 {
 	int status;
 	struct chnl_mgr *hchnl_mgr;
diff --git a/drivers/staging/tidspbridge/pmgr/cmm.c b/drivers/staging/tidspbridge/pmgr/cmm.c
index 8300f97..160aa36 100644
--- a/drivers/staging/tidspbridge/pmgr/cmm.c
+++ b/drivers/staging/tidspbridge/pmgr/cmm.c
@@ -242,7 +242,7 @@ void *cmm_calloc_buf(struct cmm_object *hcmm_mgr, u32 usize,
  */
 int cmm_create(OUT struct cmm_object **ph_cmm_mgr,
 		      struct dev_object *hdev_obj,
-		      IN CONST struct cmm_mgrattrs *pMgrAttrs)
+		      IN const struct cmm_mgrattrs *pMgrAttrs)
 {
 	struct cmm_object *cmm_obj = NULL;
 	int status = 0;
diff --git a/drivers/staging/tidspbridge/pmgr/cod.c b/drivers/staging/tidspbridge/pmgr/cod.c
index d2c8e69..61bdaa9 100644
--- a/drivers/staging/tidspbridge/pmgr/cod.c
+++ b/drivers/staging/tidspbridge/pmgr/cod.c
@@ -110,7 +110,7 @@ static s32 cod_f_close(struct file *filp)
 	return 0;
 }
 
-static struct file *cod_f_open(CONST char *psz_file_name, CONST char *pszMode)
+static struct file *cod_f_open(const char *psz_file_name, const char *pszMode)
 {
 	mm_segment_t fs;
 	struct file *filp;
@@ -217,7 +217,7 @@ void cod_close(struct cod_libraryobj *lib)
  *
  */
 int cod_create(OUT struct cod_manager **phMgr, char *pstrDummyFile,
-		      IN OPTIONAL CONST struct cod_attrs *attrs)
+		      IN OPTIONAL const struct cod_attrs *attrs)
 {
 	struct cod_manager *mgr_new;
 	struct dbll_attrs zl_attrs;
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index 4509468..d95167d 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -132,7 +132,7 @@ u32 dev_brd_write_fxn(void *pArb, u32 ulDspAddr, void *pHostBuf,
  *      PM board (device).
  */
 int dev_create_device(OUT struct dev_object **phDevObject,
-			     IN CONST char *driver_file_name,
+			     IN const char *driver_file_name,
 			     struct cfg_devnode *dev_node_obj)
 {
 	struct cfg_hostres *host_res;
@@ -691,7 +691,7 @@ int dev_get_node_manager(struct dev_object *hdev_obj,
  *  ======== dev_get_symbol ========
  */
 int dev_get_symbol(struct dev_object *hdev_obj,
-			  IN CONST char *pstrSym, OUT u32 * pul_value)
+			  IN const char *pstrSym, OUT u32 * pul_value)
 {
 	int status = 0;
 	struct cod_manager *cod_mgr;
diff --git a/drivers/staging/tidspbridge/pmgr/dmm.c b/drivers/staging/tidspbridge/pmgr/dmm.c
index 11bd2b5..23c932c 100644
--- a/drivers/staging/tidspbridge/pmgr/dmm.c
+++ b/drivers/staging/tidspbridge/pmgr/dmm.c
@@ -119,7 +119,7 @@ int dmm_create_tables(struct dmm_object *dmm_mgr, u32 addr, u32 size)
  */
 int dmm_create(OUT struct dmm_object **phDmmMgr,
 		      struct dev_object *hdev_obj,
-		      IN CONST struct dmm_mgrattrs *pMgrAttrs)
+		      IN const struct dmm_mgrattrs *pMgrAttrs)
 {
 	struct dmm_object *dmm_obj = NULL;
 	int status = 0;
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 8555aad..4667507 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -905,7 +905,7 @@ u32 procwrap_load(union Trapped_Args *args, void *pr_ctxt)
 	if (DSP_SUCCEEDED(status)) {
 		status = proc_load(args->args_proc_load.hprocessor,
 				   args->args_proc_load.argc_index,
-				   (CONST char **)argv, (CONST char **)envp);
+				   (const char **)argv, (const char **)envp);
 	}
 func_cont:
 	if (envp) {
diff --git a/drivers/staging/tidspbridge/pmgr/io.c b/drivers/staging/tidspbridge/pmgr/io.c
index 9f687e0..83171f1 100644
--- a/drivers/staging/tidspbridge/pmgr/io.c
+++ b/drivers/staging/tidspbridge/pmgr/io.c
@@ -47,7 +47,7 @@ static u32 refs;
  *      CHNL and msg_ctrl
  */
 int io_create(OUT struct io_mgr **phIOMgr, struct dev_object *hdev_obj,
-		     IN CONST struct io_attrs *pMgrAttrs)
+		     IN const struct io_attrs *pMgrAttrs)
 {
 	struct bridge_drv_interface *intf_fxns;
 	struct io_mgr *hio_mgr = NULL;
diff --git a/drivers/staging/tidspbridge/rmgr/disp.c b/drivers/staging/tidspbridge/rmgr/disp.c
index eedf32a..a1defff 100644
--- a/drivers/staging/tidspbridge/rmgr/disp.c
+++ b/drivers/staging/tidspbridge/rmgr/disp.c
@@ -89,7 +89,7 @@ static int send_message(struct disp_object *disp_obj, u32 dwTimeout,
  */
 int disp_create(OUT struct disp_object **phDispObject,
 		       struct dev_object *hdev_obj,
-		       IN CONST struct disp_attr *pDispAttrs)
+		       IN const struct disp_attr *pDispAttrs)
 {
 	struct disp_object *disp_obj;
 	struct bridge_drv_interface *intf_fxns;
@@ -251,7 +251,7 @@ int disp_node_change_priority(struct disp_object *disp_obj,
 int disp_node_create(struct disp_object *disp_obj,
 			    struct node_object *hnode, u32 ulRMSFxn,
 			    u32 ul_create_fxn,
-			    IN CONST struct node_createargs *pargs,
+			    IN const struct node_createargs *pargs,
 			    OUT nodeenv *pNodeEnv)
 {
 	struct node_msgargs node_msg_args;
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index f59a981..b4f7620 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -324,7 +324,7 @@ static u32 find_gcf(u32 a, u32 b);
  *  ======== nldr_allocate ========
  */
 int nldr_allocate(struct nldr_object *nldr_obj, void *priv_ref,
-			 IN CONST struct dcd_nodeprops *node_props,
+			 IN const struct dcd_nodeprops *node_props,
 			 OUT struct nldr_nodeobject **phNldrNode,
 			 IN bool *pf_phase_split)
 {
@@ -426,7 +426,7 @@ int nldr_allocate(struct nldr_object *nldr_obj, void *priv_ref,
  */
 int nldr_create(OUT struct nldr_object **phNldr,
 		       struct dev_object *hdev_obj,
-		       IN CONST struct nldr_attrs *pattrs)
+		       IN const struct nldr_attrs *pattrs)
 {
 	struct cod_manager *cod_mgr;	/* COD manager */
 	char *psz_coff_buf = NULL;
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 4cc14fd..e5851bb 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -252,7 +252,7 @@ static int get_fxn_address(struct node_object *hnode, u32 * pulFxnAddr,
 				  u32 uPhase);
 static int get_node_props(struct dcd_manager *hdcd_mgr,
 				 struct node_object *hnode,
-				 CONST struct dsp_uuid *pNodeId,
+				 const struct dsp_uuid *pNodeId,
 				 struct dcd_genericobj *pdcdProps);
 static int get_proc_props(struct node_mgr *hnode_mgr,
 				 struct dev_object *hdev_obj);
@@ -291,9 +291,9 @@ enum node_state node_get_state(void *hnode)
  *      Allocate GPP resources to manage a node on the DSP.
  */
 int node_allocate(struct proc_object *hprocessor,
-			 IN CONST struct dsp_uuid *pNodeId,
-			 OPTIONAL IN CONST struct dsp_cbdata *pargs,
-			 OPTIONAL IN CONST struct dsp_nodeattrin *attr_in,
+			 IN const struct dsp_uuid *pNodeId,
+			 OPTIONAL IN const struct dsp_cbdata *pargs,
+			 OPTIONAL IN const struct dsp_nodeattrin *attr_in,
 			 OUT struct node_object **ph_node,
 			 struct process_context *pr_ctxt)
 {
@@ -2094,7 +2094,7 @@ func_end:
  *      message, or a timeout occurs.
  */
 int node_put_message(struct node_object *hnode,
-			    IN CONST struct dsp_msg *pmsg, u32 utimeout)
+			    IN const struct dsp_msg *pmsg, u32 utimeout)
 {
 	struct node_mgr *hnode_mgr = NULL;
 	enum node_type node_type;
@@ -2888,7 +2888,7 @@ void get_node_info(struct node_object *hnode, struct dsp_nodeinfo *pNodeInfo)
  */
 static int get_node_props(struct dcd_manager *hdcd_mgr,
 				 struct node_object *hnode,
-				 CONST struct dsp_uuid *pNodeId,
+				 const struct dsp_uuid *pNodeId,
 				 struct dcd_genericobj *pdcdProps)
 {
 	u32 len;
@@ -3004,7 +3004,7 @@ static int get_proc_props(struct node_mgr *hnode_mgr,
  *      Fetch Node UUID properties from DCD/DOF file.
  */
 int node_get_uuid_props(void *hprocessor,
-			       IN CONST struct dsp_uuid *pNodeId,
+			       IN const struct dsp_uuid *pNodeId,
 			       OUT struct dsp_ndbprops *node_props)
 {
 	struct node_mgr *hnode_mgr = NULL;
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index c912572..8ca7852 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -272,7 +272,7 @@ static inline struct page *get_mapping_page(struct dmm_map_object *map_obj,
  */
 int
 proc_attach(u32 processor_id,
-	    OPTIONAL CONST struct dsp_processorattrin *attr_in,
+	    OPTIONAL const struct dsp_processorattrin *attr_in,
 	    void **ph_processor, struct process_context *pr_ctxt)
 {
 	int status = 0;
@@ -469,7 +469,7 @@ int proc_auto_start(struct cfg_devnode *dev_node_obj,
 		argv[0] = sz_exec_file;
 		argv[1] = NULL;
 		/* ...and try to load it: */
-		status = proc_load(p_proc_object, 1, (CONST char **)argv, NULL);
+		status = proc_load(p_proc_object, 1, (const char **)argv, NULL);
 		if (DSP_SUCCEEDED(status))
 			status = proc_start(p_proc_object);
 	}
@@ -1055,8 +1055,8 @@ bool proc_init(void)
  *      This will be an OEM-only function, and not part of the DSP/BIOS Bridge
  *      application developer's API.
  */
-int proc_load(void *hprocessor, IN CONST s32 argc_index,
-		     IN CONST char **user_args, IN CONST char **user_envp)
+int proc_load(void *hprocessor, IN const s32 argc_index,
+		     IN const char **user_args, IN const char **user_envp)
 {
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
diff --git a/drivers/staging/tidspbridge/rmgr/pwr.c b/drivers/staging/tidspbridge/rmgr/pwr.c
index ec6d181..4f5e498 100644
--- a/drivers/staging/tidspbridge/rmgr/pwr.c
+++ b/drivers/staging/tidspbridge/rmgr/pwr.c
@@ -36,7 +36,7 @@
  *  ======== pwr_sleep_dsp ========
  *    Send command to DSP to enter sleep state.
  */
-int pwr_sleep_dsp(IN CONST u32 sleepCode, IN CONST u32 timeout)
+int pwr_sleep_dsp(IN const u32 sleepCode, IN const u32 timeout)
 {
 	struct bridge_drv_interface *intf_fxns;
 	struct bridge_dev_context *dw_context;
@@ -79,7 +79,7 @@ int pwr_sleep_dsp(IN CONST u32 sleepCode, IN CONST u32 timeout)
  *  ======== pwr_wake_dsp ========
  *    Send command to DSP to wake it from sleep.
  */
-int pwr_wake_dsp(IN CONST u32 timeout)
+int pwr_wake_dsp(IN const u32 timeout)
 {
 	struct bridge_drv_interface *intf_fxns;
 	struct bridge_dev_context *dw_context;
-- 
1.6.3.3

