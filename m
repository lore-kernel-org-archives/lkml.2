Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab0GLW45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:56:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39124 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab0GLW4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:56:21 -0400
From: Nishanth Menon <nm@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 10/11] staging: tidspbridge: remove OUT define
Date: Mon, 12 Jul 2010 17:56:08 -0500
Message-Id: <1278975369-7687-11-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1278975369-7687-1-git-send-email-nm@ti.com>
References: <1278975369-7687-1-git-send-email-nm@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove OUT modifier which makes no sense for linux kernel

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/staging/tidspbridge/core/chnl_sm.c         |   14 ++++----
 drivers/staging/tidspbridge/core/io_sm.c           |   12 +++---
 drivers/staging/tidspbridge/core/msg_sm.c          |    4 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |   14 ++++----
 drivers/staging/tidspbridge/core/tiomap_io.c       |    2 +-
 drivers/staging/tidspbridge/core/tiomap_io.h       |    4 +-
 drivers/staging/tidspbridge/gen/uuidutil.c         |    4 +-
 .../staging/tidspbridge/include/dspbridge/cfg.h    |   14 ++++----
 .../staging/tidspbridge/include/dspbridge/chnl.h   |    2 +-
 .../staging/tidspbridge/include/dspbridge/cmm.h    |   12 +++---
 .../staging/tidspbridge/include/dspbridge/cod.h    |   10 +++---
 .../staging/tidspbridge/include/dspbridge/dbdcd.h  |   20 ++++++------
 .../staging/tidspbridge/include/dspbridge/dev.h    |   30 +++++++++---------
 .../staging/tidspbridge/include/dspbridge/disp.h   |    4 +-
 .../staging/tidspbridge/include/dspbridge/dmm.h    |    4 +-
 .../staging/tidspbridge/include/dspbridge/drv.h    |    4 +-
 .../tidspbridge/include/dspbridge/dspapi-ioctl.h   |    2 +-
 .../tidspbridge/include/dspbridge/dspchnl.h        |   10 +++---
 .../tidspbridge/include/dspbridge/dspdefs.h        |   24 +++++++-------
 .../staging/tidspbridge/include/dspbridge/dspdrv.h |    2 +-
 .../staging/tidspbridge/include/dspbridge/dspio.h  |    4 +-
 .../staging/tidspbridge/include/dspbridge/dspmsg.h |    4 +-
 drivers/staging/tidspbridge/include/dspbridge/io.h |    2 +-
 .../staging/tidspbridge/include/dspbridge/io_sm.h  |    8 ++--
 .../staging/tidspbridge/include/dspbridge/mgr.h    |   14 ++++----
 .../staging/tidspbridge/include/dspbridge/msg.h    |    2 +-
 .../staging/tidspbridge/include/dspbridge/nldr.h   |    6 ++--
 .../tidspbridge/include/dspbridge/nldrdefs.h       |    6 ++--
 .../staging/tidspbridge/include/dspbridge/node.h   |   20 ++++++------
 .../tidspbridge/include/dspbridge/nodepriv.h       |    2 +-
 .../staging/tidspbridge/include/dspbridge/proc.h   |    8 ++--
 .../staging/tidspbridge/include/dspbridge/strm.h   |   14 ++++----
 .../tidspbridge/include/dspbridge/uuidutil.h       |    4 +-
 drivers/staging/tidspbridge/pmgr/chnl.c            |    2 +-
 drivers/staging/tidspbridge/pmgr/cmm.c             |   12 +++---
 drivers/staging/tidspbridge/pmgr/cod.c             |    6 ++--
 drivers/staging/tidspbridge/pmgr/dev.c             |   34 ++++++++++----------
 drivers/staging/tidspbridge/pmgr/dmm.c             |    4 +-
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    2 +-
 drivers/staging/tidspbridge/pmgr/io.c              |    2 +-
 drivers/staging/tidspbridge/pmgr/msg.c             |    2 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |   32 +++++++++---------
 drivers/staging/tidspbridge/rmgr/disp.c            |    6 ++--
 drivers/staging/tidspbridge/rmgr/drv.c             |    6 ++--
 drivers/staging/tidspbridge/rmgr/dspdrv.c          |    2 +-
 drivers/staging/tidspbridge/rmgr/mgr.c             |   14 ++++----
 drivers/staging/tidspbridge/rmgr/nldr.c            |    6 ++--
 drivers/staging/tidspbridge/rmgr/node.c            |   22 ++++++------
 drivers/staging/tidspbridge/rmgr/proc.c            |    8 ++--
 drivers/staging/tidspbridge/rmgr/strm.c            |   12 +++---
 drivers/staging/tidspbridge/services/cfg.c         |    8 ++--
 51 files changed, 233 insertions(+), 233 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/chnl_sm.c b/drivers/staging/tidspbridge/core/chnl_sm.c
index 2189796..efc167a 100644
--- a/drivers/staging/tidspbridge/core/chnl_sm.c
+++ b/drivers/staging/tidspbridge/core/chnl_sm.c
@@ -81,7 +81,7 @@ static void free_chirp_list(struct lst_list *pList);
 static struct chnl_irp *make_new_chirp(void);
 
 static int search_free_channel(struct chnl_mgr *chnl_mgr_obj,
-				      OUT u32 *pdwChnl);
+				      u32 *pdwChnl);
 
 /*
  *  ======== bridge_chnl_add_io_req ========
@@ -381,7 +381,7 @@ func_cont:
  *      Create a channel manager object, responsible for opening new channels
  *      and closing old ones for a given board.
  */
-int bridge_chnl_create(OUT struct chnl_mgr **phChnlMgr,
+int bridge_chnl_create(struct chnl_mgr **phChnlMgr,
 			      struct dev_object *hdev_obj,
 			      const struct chnl_mgrattrs *pMgrAttrs)
 {
@@ -534,7 +534,7 @@ int bridge_chnl_flush_io(struct chnl_object *chnl_obj, u32 dwTimeOut)
  *      Retrieve information related to a channel.
  */
 int bridge_chnl_get_info(struct chnl_object *chnl_obj,
-			     OUT struct chnl_info *pInfo)
+			     struct chnl_info *pInfo)
 {
 	int status = 0;
 	struct chnl_object *pchnl = (struct chnl_object *)chnl_obj;
@@ -568,7 +568,7 @@ int bridge_chnl_get_info(struct chnl_object *chnl_obj,
  *      Note: Ensures Channel Invariant (see notes above).
  */
 int bridge_chnl_get_ioc(struct chnl_object *chnl_obj, u32 dwTimeOut,
-			    OUT struct chnl_ioc *pIOC)
+			    struct chnl_ioc *pIOC)
 {
 	int status = 0;
 	struct chnl_object *pchnl = (struct chnl_object *)chnl_obj;
@@ -711,7 +711,7 @@ func_end:
  *      Retrieve information related to the channel manager.
  */
 int bridge_chnl_get_mgr_info(struct chnl_mgr *hchnl_mgr, u32 uChnlID,
-				 OUT struct chnl_mgrinfo *pMgrInfo)
+				 struct chnl_mgrinfo *pMgrInfo)
 {
 	int status = 0;
 	struct chnl_mgr *chnl_mgr_obj = (struct chnl_mgr *)hchnl_mgr;
@@ -775,7 +775,7 @@ int bridge_chnl_idle(struct chnl_object *chnl_obj, u32 dwTimeOut,
  *  ======== bridge_chnl_open ========
  *      Open a new half-duplex channel to the DSP board.
  */
-int bridge_chnl_open(OUT struct chnl_object **phChnl,
+int bridge_chnl_open(struct chnl_object **phChnl,
 			    struct chnl_mgr *hchnl_mgr, s8 chnl_mode,
 			    u32 uChnlId, const struct chnl_attr *pattrs)
 {
@@ -997,7 +997,7 @@ static struct chnl_irp *make_new_chirp(void)
  *      Search for a free channel slot in the array of channel pointers.
  */
 static int search_free_channel(struct chnl_mgr *chnl_mgr_obj,
-				      OUT u32 *pdwChnl)
+				      u32 *pdwChnl)
 {
 	int status = -ENOSR;
 	u32 i;
diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 87e59ca..4552c3e 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -133,7 +133,7 @@ struct io_mgr {
 
 /* Function Prototypes */
 static void io_dispatch_chnl(struct io_mgr *pio_mgr,
-				OUT struct chnl_object *pchnl, u8 iMode);
+				struct chnl_object *pchnl, u8 iMode);
 static void io_dispatch_msg(struct io_mgr *pio_mgr,
 			    struct msg_mgr *hmsg_mgr);
 static void io_dispatch_pm(struct io_mgr *pio_mgr);
@@ -161,7 +161,7 @@ static int register_shm_segs(struct io_mgr *hio_mgr,
  *  ======== bridge_io_create ========
  *      Create an IO manager object.
  */
-int bridge_io_create(OUT struct io_mgr **phIOMgr,
+int bridge_io_create(struct io_mgr **phIOMgr,
 			    struct dev_object *hdev_obj,
 			    const struct io_attrs *pMgrAttrs)
 {
@@ -839,7 +839,7 @@ func_end:
  *      Proc-copy chanl dispatch.
  */
 static void io_dispatch_chnl(struct io_mgr *pio_mgr,
-				OUT struct chnl_object *pchnl, u8 iMode)
+				struct chnl_object *pchnl, u8 iMode)
 {
 	if (!pio_mgr)
 		goto func_end;
@@ -919,7 +919,7 @@ static void io_dispatch_pm(struct io_mgr *pio_mgr)
  *      out the dispatch of I/O as a non-preemptible event.It can only be
  *      pre-empted      by an ISR.
  */
-void io_dpc(OUT unsigned long pRefData)
+void io_dpc(unsigned long pRefData)
 {
 	struct io_mgr *pio_mgr = (struct io_mgr *)pRefData;
 	struct chnl_mgr *chnl_mgr_obj;
@@ -1014,7 +1014,7 @@ void io_mbox_msg(u32 msg)
  *      interrupts the DSP.
  */
 void io_request_chnl(struct io_mgr *pio_mgr, struct chnl_object *pchnl,
-			u8 iMode, OUT u16 *pwMbVal)
+			u8 iMode, u16 *pwMbVal)
 {
 	struct chnl_mgr *chnl_mgr_obj;
 	struct shm *sm;
@@ -1793,7 +1793,7 @@ int io_sh_msetting(struct io_mgr *hio_mgr, u8 desc, void *pargs)
  *      Gets the Processor's Load information
  */
 int bridge_io_get_proc_load(struct io_mgr *hio_mgr,
-				OUT struct dsp_procloadstat *pProcStat)
+				struct dsp_procloadstat *pProcStat)
 {
 	pProcStat->curr_load = hio_mgr->shared_mem->load_mon_info.curr_dsp_load;
 	pProcStat->predicted_load =
diff --git a/drivers/staging/tidspbridge/core/msg_sm.c b/drivers/staging/tidspbridge/core/msg_sm.c
index 7fd85ce..d9c2e76 100644
--- a/drivers/staging/tidspbridge/core/msg_sm.c
+++ b/drivers/staging/tidspbridge/core/msg_sm.c
@@ -48,7 +48,7 @@ static void free_msg_list(struct lst_list *msgList);
  *      Create an object to manage message queues. Only one of these objects
  *      can exist per device object.
  */
-int bridge_msg_create(OUT struct msg_mgr **phMsgMgr,
+int bridge_msg_create(struct msg_mgr **phMsgMgr,
 			     struct dev_object *hdev_obj,
 			     msg_onexit msgCallback)
 {
@@ -120,7 +120,7 @@ func_end:
  *      on the DSP.
  */
 int bridge_msg_create_queue(struct msg_mgr *hmsg_mgr,
-				OUT struct msg_queue **phMsgQueue,
+				struct msg_queue **phMsgQueue,
 				u32 msgq_id, u32 max_msgs, void *arg)
 {
 	u32 i;
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 3731fd0..aa94f3a 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -76,7 +76,7 @@
 /* Forward Declarations: */
 static int bridge_brd_monitor(struct bridge_dev_context *dev_context);
 static int bridge_brd_read(struct bridge_dev_context *dev_context,
-				  OUT u8 *pbHostBuf,
+				  u8 *pbHostBuf,
 				  u32 dwDSPAddr, u32 ul_num_bytes,
 				  u32 ulMemType);
 static int bridge_brd_start(struct bridge_dev_context *dev_context,
@@ -102,12 +102,12 @@ static int bridge_brd_mem_map(struct bridge_dev_context *hDevContext,
 				  struct page **mapped_pages);
 static int bridge_brd_mem_un_map(struct bridge_dev_context *hDevContext,
 				     u32 ulVirtAddr, u32 ul_num_bytes);
-static int bridge_dev_create(OUT struct bridge_dev_context
+static int bridge_dev_create(struct bridge_dev_context
 					**ppDevContext,
 					struct dev_object *hdev_obj,
 					struct cfg_hostres *pConfig);
 static int bridge_dev_ctrl(struct bridge_dev_context *dev_context,
-				  u32 dw_cmd, OUT void *pargs);
+				  u32 dw_cmd, void *pargs);
 static int bridge_dev_destroy(struct bridge_dev_context *dev_context);
 static u32 user_va2_pa(struct mm_struct *mm, u32 address);
 static int pte_update(struct bridge_dev_context *hDevContext, u32 pa,
@@ -236,7 +236,7 @@ static void bad_page_dump(u32 pa, struct page *pg)
  *  purpose:
  *      Bridge Driver entry point.
  */
-void bridge_drv_entry(OUT struct bridge_drv_interface **ppDrvInterface,
+void bridge_drv_entry(struct bridge_drv_interface **ppDrvInterface,
 		   const char *driver_file_name)
 {
 
@@ -304,7 +304,7 @@ static int bridge_brd_monitor(struct bridge_dev_context *hDevContext)
  *      Reads buffers for DSP memory.
  */
 static int bridge_brd_read(struct bridge_dev_context *hDevContext,
-				  OUT u8 *pbHostBuf, u32 dwDSPAddr,
+				  u8 *pbHostBuf, u32 dwDSPAddr,
 				  u32 ul_num_bytes, u32 ulMemType)
 {
 	int status = 0;
@@ -785,7 +785,7 @@ static int bridge_brd_write(struct bridge_dev_context *hDevContext,
  *  ======== bridge_dev_create ========
  *      Creates a driver object. Puts DSP in self loop.
  */
-static int bridge_dev_create(OUT struct bridge_dev_context
+static int bridge_dev_create(struct bridge_dev_context
 					**ppDevContext,
 					struct dev_object *hdev_obj,
 					struct cfg_hostres *pConfig)
@@ -954,7 +954,7 @@ func_end:
  *      Receives device specific commands.
  */
 static int bridge_dev_ctrl(struct bridge_dev_context *dev_context,
-				  u32 dw_cmd, OUT void *pargs)
+				  u32 dw_cmd, void *pargs)
 {
 	int status = 0;
 	struct bridge_ioctl_extproc *pa_ext_proc =
diff --git a/drivers/staging/tidspbridge/core/tiomap_io.c b/drivers/staging/tidspbridge/core/tiomap_io.c
index b2d516b..4a43927 100644
--- a/drivers/staging/tidspbridge/core/tiomap_io.c
+++ b/drivers/staging/tidspbridge/core/tiomap_io.c
@@ -51,7 +51,7 @@ bool symbols_reloaded = true;
  *      Copies DSP external memory buffers to the host side buffers.
  */
 int read_ext_dsp_data(struct bridge_dev_context *hDevContext,
-			     OUT u8 *pbHostBuf, u32 dwDSPAddr,
+			     u8 *pbHostBuf, u32 dwDSPAddr,
 			     u32 ul_num_bytes, u32 ulMemType)
 {
 	int status = 0;
diff --git a/drivers/staging/tidspbridge/core/tiomap_io.h b/drivers/staging/tidspbridge/core/tiomap_io.h
index 243636d..eb08f1b 100644
--- a/drivers/staging/tidspbridge/core/tiomap_io.h
+++ b/drivers/staging/tidspbridge/core/tiomap_io.h
@@ -48,14 +48,14 @@
  * is configured by the combination of DSP MMU and shm Memory manager in the CDB
  */
 extern int read_ext_dsp_data(struct bridge_dev_context *dev_context,
-				    OUT u8 *pbHostBuf, u32 dwDSPAddr,
+				    u8 *pbHostBuf, u32 dwDSPAddr,
 				    u32 ul_num_bytes, u32 ulMemType);
 
 /*
  *  ======== write_dsp_data ========
  */
 extern int write_dsp_data(struct bridge_dev_context *dev_context,
-				 OUT u8 *pbHostBuf, u32 dwDSPAddr,
+				 u8 *pbHostBuf, u32 dwDSPAddr,
 				 u32 ul_num_bytes, u32 ulMemType);
 
 /*
diff --git a/drivers/staging/tidspbridge/gen/uuidutil.c b/drivers/staging/tidspbridge/gen/uuidutil.c
index 17434b6..e13bbf2 100644
--- a/drivers/staging/tidspbridge/gen/uuidutil.c
+++ b/drivers/staging/tidspbridge/gen/uuidutil.c
@@ -36,7 +36,7 @@
  *      Note: snprintf format specifier is:
  *      %[flags] [width] [.precision] [{h | l | I64 | L}]type
  */
-void uuid_uuid_to_string(struct dsp_uuid *uuid_obj, OUT char *pszUuid,
+void uuid_uuid_to_string(struct dsp_uuid *uuid_obj, char *pszUuid,
 			 s32 size)
 {
 	s32 i;			/* return result from snprintf. */
@@ -75,7 +75,7 @@ static s32 uuid_hex_to_bin(char *buf, s32 len)
  *  Purpose:
  *      Converts a string to a struct dsp_uuid.
  */
-void uuid_uuid_from_string(char *pszUuid, OUT struct dsp_uuid *uuid_obj)
+void uuid_uuid_from_string(char *pszUuid, struct dsp_uuid *uuid_obj)
 {
 	s32 j;
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cfg.h b/drivers/staging/tidspbridge/include/dspbridge/cfg.h
index 0e7961d..bdf7b37 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cfg.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cfg.h
@@ -51,7 +51,7 @@ extern void cfg_exit(void);
  *      0:        *pdwAutoStart contains autostart mask for this devnode.
  */
 extern int cfg_get_auto_start(struct cfg_devnode *dev_node_obj,
-				     OUT u32 *pdwAutoStart);
+				     u32 *pdwAutoStart);
 
 /*
  *  ======== cfg_get_cd_version ========
@@ -70,7 +70,7 @@ extern int cfg_get_auto_start(struct cfg_devnode *dev_node_obj,
  *      0:    Success.
  *      else:       *pdwVersion is NULL.
  */
-extern int cfg_get_cd_version(OUT u32 *pdwVersion);
+extern int cfg_get_cd_version(u32 *pdwVersion);
 
 /*
  *  ======== cfg_get_dev_object ========
@@ -91,7 +91,7 @@ extern int cfg_get_cd_version(OUT u32 *pdwVersion);
  *      else:       *pdwValue is set to 0L.
  */
 extern int cfg_get_dev_object(struct cfg_devnode *dev_node_obj,
-				     OUT u32 *pdwValue);
+				     u32 *pdwValue);
 
 /*
  *  ======== cfg_get_exec_file ========
@@ -113,7 +113,7 @@ extern int cfg_get_dev_object(struct cfg_devnode *dev_node_obj,
  *                  devnode.
  */
 extern int cfg_get_exec_file(struct cfg_devnode *dev_node_obj,
-				    u32 buf_size, OUT char *pstrExecFile);
+				    u32 buf_size, char *pstrExecFile);
 
 /*
  *  ======== cfg_get_object ========
@@ -130,7 +130,7 @@ extern int cfg_get_exec_file(struct cfg_devnode *dev_node_obj,
  *      0:    *pdwValue is set to the retrieved u32(non-Zero).
  *      else:       *pdwValue is set to 0L.
  */
-extern int cfg_get_object(OUT u32 *pdwValue, u8 dw_type);
+extern int cfg_get_object(u32 *pdwValue, u8 dw_type);
 
 /*
  *  ======== cfg_get_perf_value ========
@@ -146,7 +146,7 @@ extern int cfg_get_object(OUT u32 *pdwValue, u8 dw_type);
  *      pfEnablePerf != NULL;
  *  Ensures:
  */
-extern void cfg_get_perf_value(OUT bool *pfEnablePerf);
+extern void cfg_get_perf_value(bool *pfEnablePerf);
 
 /*
  *  ======== cfg_get_zl_file ========
@@ -168,7 +168,7 @@ extern void cfg_get_perf_value(OUT bool *pfEnablePerf);
  *                  for this devnode.
  */
 extern int cfg_get_zl_file(struct cfg_devnode *dev_node_obj,
-				  u32 buf_size, OUT char *pstrZLFileName);
+				  u32 buf_size, char *pstrZLFileName);
 
 /*
  *  ======== cfg_init ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/chnl.h b/drivers/staging/tidspbridge/include/dspbridge/chnl.h
index aa6cd77..2b49b76 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/chnl.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/chnl.h
@@ -77,7 +77,7 @@ extern int chnl_close(struct chnl_object *chnl_obj);
  *                              board without an intervening call to
  *                              chnl_destroy() will fail.
  */
-extern int chnl_create(OUT struct chnl_mgr **phChnlMgr,
+extern int chnl_create(struct chnl_mgr **phChnlMgr,
 			      struct dev_object *hdev_obj,
 			      const struct chnl_mgrattrs *pMgrAttrs);
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cmm.h b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
index 70e9dc5..8bae008 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cmm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
@@ -62,7 +62,7 @@
  */
 extern void *cmm_calloc_buf(struct cmm_object *hcmm_mgr,
 			    u32 usize, struct cmm_attrs *pattrs,
-			    OUT void **pp_buf_va);
+			    void **pp_buf_va);
 
 /*
  *  ======== cmm_create ========
@@ -85,7 +85,7 @@ extern void *cmm_calloc_buf(struct cmm_object *hcmm_mgr,
  *  Ensures:
  *
  */
-extern int cmm_create(OUT struct cmm_object **ph_cmm_mgr,
+extern int cmm_create(struct cmm_object **ph_cmm_mgr,
 			     struct dev_object *hdev_obj,
 			     const struct cmm_mgrattrs *pMgrAttrs);
 
@@ -163,7 +163,7 @@ extern int cmm_free_buf(struct cmm_object *hcmm_mgr,
  *  Ensures:
  */
 extern int cmm_get_handle(void *hprocessor,
-				 OUT struct cmm_object **ph_cmm_mgr);
+				 struct cmm_object **ph_cmm_mgr);
 
 /*
  *  ======== cmm_get_info ========
@@ -182,7 +182,7 @@ extern int cmm_get_handle(void *hprocessor,
  *
  */
 extern int cmm_get_info(struct cmm_object *hcmm_mgr,
-			       OUT struct cmm_info *cmm_info_obj);
+			       struct cmm_info *cmm_info_obj);
 
 /*
  *  ======== cmm_init ========
@@ -295,7 +295,7 @@ extern void *cmm_xlator_alloc_buf(struct cmm_xlatorobject *xlator,
  *  Ensures:
  *
  */
-extern int cmm_xlator_create(OUT struct cmm_xlatorobject **phXlator,
+extern int cmm_xlator_create(struct cmm_xlatorobject **phXlator,
 				    struct cmm_object *hcmm_mgr,
 				    struct cmm_xlatorattrs *pXlatorAttrs);
 
@@ -359,7 +359,7 @@ extern int cmm_xlator_free_buf(struct cmm_xlatorobject *xlator,
  *
  */
 extern int cmm_xlator_info(struct cmm_xlatorobject *xlator,
-				  OUT u8 **paddr,
+				  u8 **paddr,
 				  u32 ul_size, u32 uSegId, bool set_info);
 
 /*
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cod.h b/drivers/staging/tidspbridge/include/dspbridge/cod.h
index 25817fc..3850de2 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cod.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cod.h
@@ -91,7 +91,7 @@ extern void cod_close(struct cod_libraryobj *lib);
  *      pstrZLFile != NULL
  *  Ensures:
  */
-extern int cod_create(OUT struct cod_manager **phManager,
+extern int cod_create(struct cod_manager **phManager,
 			     char *pstrZLFile,
 			     const struct cod_attrs *attrs);
 
@@ -227,7 +227,7 @@ extern int cod_get_loader(struct cod_manager *cod_mgr_obj,
  */
 extern int cod_get_section(struct cod_libraryobj *lib,
 				  char *pstrSect,
-				  OUT u32 *puAddr, OUT u32 *puLen);
+				  u32 *puAddr, u32 *puLen);
 
 /*
  *  ======== cod_get_sym_value ========
@@ -251,7 +251,7 @@ extern int cod_get_section(struct cod_libraryobj *lib,
  *  Ensures:
  */
 extern int cod_get_sym_value(struct cod_manager *cod_mgr_obj,
-				    char *pstrSym, OUT u32 * pul_value);
+				    char *pstrSym, u32 * pul_value);
 
 /*
  *  ======== cod_init ========
@@ -321,7 +321,7 @@ extern int cod_load_base(struct cod_manager *cod_mgr_obj,
  */
 extern int cod_open(struct cod_manager *hmgr,
 			   char *pszCoffPath,
-			   u32 flags, OUT struct cod_libraryobj **pLib);
+			   u32 flags, struct cod_libraryobj **pLib);
 
 /*
  *  ======== cod_open_base ========
@@ -364,6 +364,6 @@ extern int cod_open_base(struct cod_manager *hmgr, char *pszCoffPath,
  */
 extern int cod_read_section(struct cod_libraryobj *lib,
 				   char *pstrSect,
-				   OUT char *pstrContent, u32 content_size);
+				   char *pstrContent, u32 content_size);
 
 #endif /* COD_ */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dbdcd.h b/drivers/staging/tidspbridge/include/dspbridge/dbdcd.h
index 6d32e02..61a01a6 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dbdcd.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dbdcd.h
@@ -90,7 +90,7 @@ extern int dcd_auto_unregister(struct dcd_manager *hdcd_mgr,
  *      A DCD manager handle is created.
  */
 extern int dcd_create_manager(char *pszZlDllName,
-				     OUT struct dcd_manager **phDcdMgr);
+				     struct dcd_manager **phDcdMgr);
 
 /*
  *  ======== dcd_destroy_manager ========
@@ -130,7 +130,7 @@ extern int dcd_destroy_manager(struct dcd_manager *hdcd_mgr);
  */
 extern int dcd_enumerate_object(s32 index,
 				       enum dsp_dcdobjtype obj_type,
-				       OUT struct dsp_uuid *uuid_obj);
+				       struct dsp_uuid *uuid_obj);
 
 /*
  *  ======== dcd_exit ========
@@ -172,8 +172,8 @@ extern void dcd_exit(void);
 extern int dcd_get_dep_libs(struct dcd_manager *hdcd_mgr,
 				   struct dsp_uuid *uuid_obj,
 				   u16 numLibs,
-				   OUT struct dsp_uuid *pDepLibUuids,
-				   OUT bool *pPersistentDepLibs,
+				   struct dsp_uuid *pDepLibUuids,
+				   bool *pPersistentDepLibs,
 				   enum nldr_phase phase);
 
 /*
@@ -201,8 +201,8 @@ extern int dcd_get_dep_libs(struct dcd_manager *hdcd_mgr,
  */
 extern int dcd_get_num_dep_libs(struct dcd_manager *hdcd_mgr,
 				       struct dsp_uuid *uuid_obj,
-				       OUT u16 *pNumLibs,
-				       OUT u16 *pNumPersLibs,
+				       u16 *pNumLibs,
+				       u16 *pNumPersLibs,
 				       enum nldr_phase phase);
 
 /*
@@ -231,10 +231,10 @@ extern int dcd_get_num_dep_libs(struct dcd_manager *hdcd_mgr,
  */
 extern int dcd_get_library_name(struct dcd_manager *hdcd_mgr,
 				       struct dsp_uuid *uuid_obj,
-				       OUT char *pstrLibName,
-				       OUT u32 *pdwSize,
+				       char *pstrLibName,
+				       u32 *pdwSize,
 				       enum nldr_phase phase,
-				       OUT bool *phase_split);
+				       bool *phase_split);
 
 /*
  *  ======== dcd_get_object_def ========
@@ -264,7 +264,7 @@ extern int dcd_get_library_name(struct dcd_manager *hdcd_mgr,
 extern int dcd_get_object_def(struct dcd_manager *hdcd_mgr,
 				     struct dsp_uuid *pObjUuid,
 				     enum dsp_dcdobjtype obj_type,
-				     OUT struct dcd_genericobj *pObjDef);
+				     struct dcd_genericobj *pObjDef);
 
 /*
  *  ======== dcd_get_objects ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dev.h b/drivers/staging/tidspbridge/include/dspbridge/dev.h
index 4c0658d..664f66b 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dev.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dev.h
@@ -89,7 +89,7 @@ extern u32 dev_brd_write_fxn(void *pArb,
  *      Otherwise, does not create the device object, ensures the Bridge driver
  *      module is unloaded, and sets *phDevObject to NULL.
  */
-extern int dev_create_device(OUT struct dev_object
+extern int dev_create_device(struct dev_object
 				    **phDevObject,
 				    const char *driver_file_name,
 				    struct cfg_devnode *dev_node_obj);
@@ -124,7 +124,7 @@ extern int dev_create_device(OUT struct dev_object
  *      Otherwise, does not create the device object, ensures the Bridge driver
  *      module is unloaded, and sets *phDevObject to NULL.
  */
-extern int dev_create_iva_device(OUT struct dev_object
+extern int dev_create_iva_device(struct dev_object
 					**phDevObject,
 					const char *driver_file_name,
 					const struct cfg_hostres
@@ -208,7 +208,7 @@ extern int dev_destroy_device(struct dev_object
  *      else:           *phMgr is NULL.
  */
 extern int dev_get_chnl_mgr(struct dev_object *hdev_obj,
-				   OUT struct chnl_mgr **phMgr);
+				   struct chnl_mgr **phMgr);
 
 /*
  *  ======== dev_get_cmm_mgr ========
@@ -231,7 +231,7 @@ extern int dev_get_chnl_mgr(struct dev_object *hdev_obj,
  *      else:           *phMgr is NULL.
  */
 extern int dev_get_cmm_mgr(struct dev_object *hdev_obj,
-				  OUT struct cmm_object **phMgr);
+				  struct cmm_object **phMgr);
 
 /*
  *  ======== dev_get_dmm_mgr ========
@@ -254,7 +254,7 @@ extern int dev_get_cmm_mgr(struct dev_object *hdev_obj,
  *      else:           *phMgr is NULL.
  */
 extern int dev_get_dmm_mgr(struct dev_object *hdev_obj,
-				  OUT struct dmm_object **phMgr);
+				  struct dmm_object **phMgr);
 
 /*
  *  ======== dev_get_cod_mgr ========
@@ -275,7 +275,7 @@ extern int dev_get_dmm_mgr(struct dev_object *hdev_obj,
  *      else:           *phCodMgr is NULL.
  */
 extern int dev_get_cod_mgr(struct dev_object *hdev_obj,
-				  OUT struct cod_manager **phCodMgr);
+				  struct cod_manager **phCodMgr);
 
 /*
  *  ======== dev_get_deh_mgr ========
@@ -295,7 +295,7 @@ extern int dev_get_cod_mgr(struct dev_object *hdev_obj,
  *      else:       *phDehMgr is NULL.
  */
 extern int dev_get_deh_mgr(struct dev_object *hdev_obj,
-				  OUT struct deh_mgr **phDehMgr);
+				  struct deh_mgr **phDehMgr);
 
 /*
  *  ======== dev_get_dev_node ========
@@ -316,7 +316,7 @@ extern int dev_get_deh_mgr(struct dev_object *hdev_obj,
  *      else:           *phDevNode is NULL.
  */
 extern int dev_get_dev_node(struct dev_object *hdev_obj,
-				   OUT struct cfg_devnode **phDevNode);
+				   struct cfg_devnode **phDevNode);
 
 /*
  *  ======== dev_get_dev_type ========
@@ -380,7 +380,7 @@ extern struct dev_object *dev_get_first(void);
  *      else:           *ppIntfFxns is NULL.
  */
 extern int dev_get_intf_fxns(struct dev_object *hdev_obj,
-			    OUT struct bridge_drv_interface **ppIntfFxns);
+			    struct bridge_drv_interface **ppIntfFxns);
 
 /*
  *  ======== dev_get_io_mgr ========
@@ -401,7 +401,7 @@ extern int dev_get_intf_fxns(struct dev_object *hdev_obj,
  *      else:           *phMgr is NULL.
  */
 extern int dev_get_io_mgr(struct dev_object *hdev_obj,
-				 OUT struct io_mgr **phMgr);
+				 struct io_mgr **phMgr);
 
 /*
  *  ======== dev_get_next ========
@@ -443,7 +443,7 @@ extern struct dev_object *dev_get_next(struct dev_object
  *  Ensures:
  */
 extern void dev_get_msg_mgr(struct dev_object *hdev_obj,
-			    OUT struct msg_mgr **phMsgMgr);
+			    struct msg_mgr **phMsgMgr);
 
 /*
  *  ========= dev_get_node_manager ========
@@ -466,7 +466,7 @@ extern void dev_get_msg_mgr(struct dev_object *hdev_obj,
  */
 extern int dev_get_node_manager(struct dev_object
 				       *hdev_obj,
-				       OUT struct node_mgr **phNodeMgr);
+				       struct node_mgr **phNodeMgr);
 
 /*
  *  ======== dev_get_symbol ========
@@ -490,7 +490,7 @@ extern int dev_get_node_manager(struct dev_object
  *      0:        *pul_value contains the symbol value;
  */
 extern int dev_get_symbol(struct dev_object *hdev_obj,
-				 const char *pstrSym, OUT u32 * pul_value);
+				 const char *pstrSym, u32 * pul_value);
 
 /*
  *  ======== dev_get_bridge_context ========
@@ -511,7 +511,7 @@ extern int dev_get_symbol(struct dev_object *hdev_obj,
  *      else:           *phbridge_context is NULL;
  */
 extern int dev_get_bridge_context(struct dev_object *hdev_obj,
-				      OUT struct bridge_dev_context
+				      struct bridge_dev_context
 				      **phbridge_context);
 
 /*
@@ -585,7 +585,7 @@ extern int dev_is_locked(struct dev_object *hdev_obj);
 extern int dev_insert_proc_object(struct dev_object
 					 *hdev_obj,
 					 u32 proc_obj,
-					 OUT bool *pbAlreadyAttached);
+					 bool *pbAlreadyAttached);
 
 /*
  *  ======== dev_remove_proc_object ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/disp.h b/drivers/staging/tidspbridge/include/dspbridge/disp.h
index abadc79..5a12a88 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/disp.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/disp.h
@@ -48,7 +48,7 @@
  *      0:        IS_VALID(*phDispObject).
  *      error:          *phDispObject == NULL.
  */
-extern int disp_create(OUT struct disp_object **phDispObject,
+extern int disp_create(struct disp_object **phDispObject,
 			      struct dev_object *hdev_obj,
 			      const struct disp_attr *pDispAttrs);
 
@@ -148,7 +148,7 @@ extern int disp_node_create(struct disp_object *hDispObject,
 				   u32 ul_fxn_addr,
 				   u32 ul_create_fxn,
 				   const struct node_createargs
-				   *pargs, OUT nodeenv *pNodeEnv);
+				   *pargs, nodeenv *pNodeEnv);
 
 /*
  *  ======== disp_node_delete ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dmm.h b/drivers/staging/tidspbridge/include/dspbridge/dmm.h
index 72882b7..b8739c1 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dmm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dmm.h
@@ -39,7 +39,7 @@ struct dmm_mgrattrs {
  */
 
 extern int dmm_get_handle(void *hprocessor,
-				 OUT struct dmm_object **phDmmMgr);
+				 struct dmm_object **phDmmMgr);
 
 extern int dmm_reserve_memory(struct dmm_object *dmm_mgr,
 				     u32 size, u32 *prsv_addr);
@@ -57,7 +57,7 @@ extern int dmm_destroy(struct dmm_object *dmm_mgr);
 
 extern int dmm_delete_tables(struct dmm_object *dmm_mgr);
 
-extern int dmm_create(OUT struct dmm_object **phDmmMgr,
+extern int dmm_create(struct dmm_object **phDmmMgr,
 			     struct dev_object *hdev_obj,
 			     const struct dmm_mgrattrs *pMgrAttrs);
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/drv.h b/drivers/staging/tidspbridge/include/dspbridge/drv.h
index 753a317..1972e41 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/drv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/drv.h
@@ -394,7 +394,7 @@ extern int drv_remove_dev_object(struct drv_object *hdrv_obj,
  *      later used by the CFG module.
  */
 extern int drv_request_resources(u32 dw_context,
-					OUT u32 *pDevNodeString);
+					u32 *pDevNodeString);
 
 /*
  *  ======== drv_release_resources ========
@@ -463,7 +463,7 @@ extern void mem_ext_phys_pool_release(void);
  *      location of memory.
  */
 extern void *mem_alloc_phys_mem(u32 byte_size,
-				u32 ulAlign, OUT u32 *pPhysicalAddress);
+				u32 ulAlign, u32 *pPhysicalAddress);
 
 /*
  *  ======== mem_free_phys_mem ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspapi-ioctl.h b/drivers/staging/tidspbridge/include/dspbridge/dspapi-ioctl.h
index cc4e75b..2ad6089 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspapi-ioctl.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspapi-ioctl.h
@@ -339,7 +339,7 @@ union Trapped_Args {
 		struct cmm_object *hcmm_mgr;
 		u32 usize;
 		struct cmm_attrs *pattrs;
-		OUT void **pp_buf_va;
+		void **pp_buf_va;
 	} args_cmm_allocbuf;
 
 	struct {
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspchnl.h b/drivers/staging/tidspbridge/include/dspbridge/dspchnl.h
index 8b943cc..7c2447f 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspchnl.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspchnl.h
@@ -24,14 +24,14 @@
 #ifndef DSPCHNL_
 #define DSPCHNL_
 
-extern int bridge_chnl_create(OUT struct chnl_mgr **phChnlMgr,
+extern int bridge_chnl_create(struct chnl_mgr **phChnlMgr,
 				     struct dev_object *hdev_obj,
 				     const struct chnl_mgrattrs
 				     *pMgrAttrs);
 
 extern int bridge_chnl_destroy(struct chnl_mgr *hchnl_mgr);
 
-extern int bridge_chnl_open(OUT struct chnl_object **phChnl,
+extern int bridge_chnl_open(struct chnl_object **phChnl,
 				   struct chnl_mgr *hchnl_mgr,
 				   s8 chnl_mode,
 				   u32 uChnlId,
@@ -46,7 +46,7 @@ extern int bridge_chnl_add_io_req(struct chnl_object *chnl_obj,
 				      u32 dw_dsp_addr, u32 dw_arg);
 
 extern int bridge_chnl_get_ioc(struct chnl_object *chnl_obj,
-				   u32 dwTimeOut, OUT struct chnl_ioc *pIOC);
+				   u32 dwTimeOut, struct chnl_ioc *pIOC);
 
 extern int bridge_chnl_cancel_io(struct chnl_object *chnl_obj);
 
@@ -54,10 +54,10 @@ extern int bridge_chnl_flush_io(struct chnl_object *chnl_obj,
 				    u32 dwTimeOut);
 
 extern int bridge_chnl_get_info(struct chnl_object *chnl_obj,
-				    OUT struct chnl_info *pInfo);
+				    struct chnl_info *pInfo);
 
 extern int bridge_chnl_get_mgr_info(struct chnl_mgr *hchnl_mgr,
-					u32 uChnlID, OUT struct chnl_mgrinfo
+					u32 uChnlID, struct chnl_mgrinfo
 					*pMgrInfo);
 
 extern int bridge_chnl_idle(struct chnl_object *chnl_obj,
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
index 467ec8b..b772c5d 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
@@ -262,7 +262,7 @@ typedef int(*fxn_brd_status) (struct bridge_dev_context *hDevContext,
  *  Will not write more than ul_num_bytes bytes into pHostBuf.
  */
 typedef int(*fxn_brd_read) (struct bridge_dev_context *hDevContext,
-				   OUT u8 *pHostBuf,
+				   u8 *pHostBuf,
 				   u32 dwDSPAddr,
 				   u32 ul_num_bytes, u32 ulMemType);
 
@@ -322,7 +322,7 @@ typedef int(*fxn_brd_write) (struct bridge_dev_context *hDevContext,
  *      No channel manager exists for this board.
  *  Ensures:
  */
-typedef int(*fxn_chnl_create) (OUT struct chnl_mgr
+typedef int(*fxn_chnl_create) (struct chnl_mgr
 				      **phChnlMgr,
 				      struct dev_object
 				      * hdev_obj,
@@ -406,7 +406,7 @@ typedef void (*fxn_deh_notify) (struct deh_mgr *hdeh_mgr,
  *      0:                *phChnl is a valid channel.
  *      else:                   *phChnl is set to NULL if (phChnl != NULL);
  */
-typedef int(*fxn_chnl_open) (OUT struct chnl_object
+typedef int(*fxn_chnl_open) (struct chnl_object
 				    **phChnl,
 				    struct chnl_mgr *hchnl_mgr,
 				    s8 chnl_mode,
@@ -502,7 +502,7 @@ typedef int(*fxn_chnl_addioreq) (struct chnl_object
  */
 typedef int(*fxn_chnl_getioc) (struct chnl_object *chnl_obj,
 				      u32 dwTimeOut,
-				      OUT struct chnl_ioc *pIOC);
+				      struct chnl_ioc *pIOC);
 
 /*
  *  ======== bridge_chnl_cancel_io ========
@@ -560,7 +560,7 @@ typedef int(*fxn_chnl_flushio) (struct chnl_object *chnl_obj,
  *                      if (pInfo != NULL).
  */
 typedef int(*fxn_chnl_getinfo) (struct chnl_object *chnl_obj,
-				       OUT struct chnl_info *pChnlInfo);
+				       struct chnl_info *pChnlInfo);
 
 /*
  *  ======== bridge_chnl_get_mgr_info ========
@@ -582,7 +582,7 @@ typedef int(*fxn_chnl_getinfo) (struct chnl_object *chnl_obj,
 typedef int(*fxn_chnl_getmgrinfo) (struct chnl_mgr
 					  * hchnl_mgr,
 					  u32 uChnlID,
-					  OUT struct chnl_mgrinfo *pMgrInfo);
+					  struct chnl_mgrinfo *pMgrInfo);
 
 /*
  *  ======== bridge_chnl_idle ========
@@ -678,7 +678,7 @@ typedef int(*fxn_chnl_registernotify)
  *      function returns, they must not be stored into the device context
  *      structure.
  */
-typedef int(*fxn_dev_create) (OUT struct bridge_dev_context
+typedef int(*fxn_dev_create) (struct bridge_dev_context
 				     **phDevContext,
 				     struct dev_object
 				     * hdev_obj,
@@ -702,7 +702,7 @@ typedef int(*fxn_dev_create) (OUT struct bridge_dev_context
  *  Ensures:
  */
 typedef int(*fxn_dev_ctrl) (struct bridge_dev_context *hDevContext,
-				   u32 dw_cmd, OUT void *pargs);
+				   u32 dw_cmd, void *pargs);
 
 /*
  *  ======== bridge_dev_destroy ========
@@ -743,7 +743,7 @@ typedef int(*fxn_dev_destroy) (struct bridge_dev_context *hDevContext);
  *      phIOMgr != NULL;
  *  Ensures:
  */
-typedef int(*fxn_io_create) (OUT struct io_mgr **phIOMgr,
+typedef int(*fxn_io_create) (struct io_mgr **phIOMgr,
 				    struct dev_object *hdev_obj,
 				    const struct io_attrs *pMgrAttrs);
 
@@ -817,7 +817,7 @@ typedef int(*fxn_io_getprocload) (struct io_mgr *hio_mgr,
  *  Ensures:
  */
 typedef int(*fxn_msg_create)
- (OUT struct msg_mgr **phMsgMgr,
+ (struct msg_mgr **phMsgMgr,
   struct dev_object *hdev_obj, msg_onexit msgCallback);
 
 /*
@@ -844,7 +844,7 @@ typedef int(*fxn_msg_create)
  */
 typedef int(*fxn_msg_createqueue)
  (struct msg_mgr *hmsg_mgr,
-  OUT struct msg_queue **phMsgQueue, u32 msgq_id, u32 max_msgs, void *h);
+  struct msg_queue **phMsgQueue, u32 msgq_id, u32 max_msgs, void *h);
 
 /*
  *  ======== bridge_msg_delete ========
@@ -1047,7 +1047,7 @@ struct bridge_drv_interface {
  *  Details:
  *      Called during the Device_Init phase.
  */
-void bridge_drv_entry(OUT struct bridge_drv_interface **ppDrvInterface,
+void bridge_drv_entry(struct bridge_drv_interface **ppDrvInterface,
 		   const char *driver_file_name);
 
 #endif /* DSPDEFS_ */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdrv.h b/drivers/staging/tidspbridge/include/dspbridge/dspdrv.h
index 2dd4f8b..865f6fe 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdrv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdrv.h
@@ -57,6 +57,6 @@ extern bool dsp_deinit(u32 dwDeviceContext);
  *      Succeeded:  device context > 0
  *      Failed:     device Context = 0
  */
-extern u32 dsp_init(OUT u32 *init_status);
+extern u32 dsp_init(u32 *init_status);
 
 #endif
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspio.h b/drivers/staging/tidspbridge/include/dspbridge/dspio.h
index f382f1a..22dc49c 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspio.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspio.h
@@ -26,7 +26,7 @@
 #include <dspbridge/devdefs.h>
 #include <dspbridge/iodefs.h>
 
-extern int bridge_io_create(OUT struct io_mgr **phIOMgr,
+extern int bridge_io_create(struct io_mgr **phIOMgr,
 				   struct dev_object *hdev_obj,
 				   const struct io_attrs *pMgrAttrs);
 
@@ -36,6 +36,6 @@ extern int bridge_io_on_loaded(struct io_mgr *hio_mgr);
 
 extern int iva_io_on_loaded(struct io_mgr *hio_mgr);
 extern int bridge_io_get_proc_load(struct io_mgr *hio_mgr,
-				       OUT struct dsp_procloadstat *pProcStat);
+				       struct dsp_procloadstat *pProcStat);
 
 #endif /* DSPIO_ */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspmsg.h b/drivers/staging/tidspbridge/include/dspbridge/dspmsg.h
index 3b9ca4e..7c31bdc 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspmsg.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspmsg.h
@@ -26,12 +26,12 @@
 
 #include <dspbridge/msgdefs.h>
 
-extern int bridge_msg_create(OUT struct msg_mgr **phMsgMgr,
+extern int bridge_msg_create(struct msg_mgr **phMsgMgr,
 				    struct dev_object *hdev_obj,
 				    msg_onexit msgCallback);
 
 extern int bridge_msg_create_queue(struct msg_mgr *hmsg_mgr,
-				       OUT struct msg_queue **phMsgQueue,
+				       struct msg_queue **phMsgQueue,
 				       u32 msgq_id, u32 max_msgs, void *h);
 
 extern void bridge_msg_delete(struct msg_mgr *hmsg_mgr);
diff --git a/drivers/staging/tidspbridge/include/dspbridge/io.h b/drivers/staging/tidspbridge/include/dspbridge/io.h
index 8241547..337c299 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/io.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/io.h
@@ -49,7 +49,7 @@
  *      pMgrAttrs != NULL.
  *  Ensures:
  */
-extern int io_create(OUT struct io_mgr **phIOMgr,
+extern int io_create(struct io_mgr **phIOMgr,
 			    struct dev_object *hdev_obj,
 			    const struct io_attrs *pMgrAttrs);
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/io_sm.h b/drivers/staging/tidspbridge/include/dspbridge/io_sm.h
index 64cb274..2ae2866 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/io_sm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/io_sm.h
@@ -78,7 +78,7 @@ extern void io_cancel_chnl(struct io_mgr *hio_mgr, u32 ulChnl);
  *  Ensures:
  *      Non-preemptible (but interruptible).
  */
-extern void io_dpc(OUT unsigned long pRefData);
+extern void io_dpc(unsigned long pRefData);
 
 /*
  *  ======== io_mbox_msg ========
@@ -116,7 +116,7 @@ void io_mbox_msg(u32 msg);
  */
 extern void io_request_chnl(struct io_mgr *hio_mgr,
 			    struct chnl_object *pchnl,
-			    u8 iMode, OUT u16 *pwMbVal);
+			    u8 iMode, u16 *pwMbVal);
 
 /*
  *  ======== iosm_schedule ========
@@ -190,7 +190,7 @@ extern void io_ddma_clear_chnl_desc(struct io_mgr *hio_mgr, u32 uDDMAChnlId);
 extern void io_ddma_request_chnl(struct io_mgr *hio_mgr,
 				 struct chnl_object *pchnl,
 				 struct chnl_irp *chnl_packet_obj,
-				 OUT u16 *pwMbVal);
+				 u16 *pwMbVal);
 
 /*
  * Zero-copy IO functions
@@ -245,7 +245,7 @@ extern void io_ddzc_clear_chnl_desc(struct io_mgr *hio_mgr, u32 uChnlId);
 extern void io_ddzc_request_chnl(struct io_mgr *hio_mgr,
 				 struct chnl_object *pchnl,
 				 struct chnl_irp *chnl_packet_obj,
-				 OUT u16 *pwMbVal);
+				 u16 *pwMbVal);
 
 /*
  *  ======== io_sh_msetting ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/mgr.h b/drivers/staging/tidspbridge/include/dspbridge/mgr.h
index adfd9b5..f24a7ba 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/mgr.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/mgr.h
@@ -40,7 +40,7 @@
 
 int mgr_wait_for_bridge_events(struct dsp_notification
 				      **anotifications,
-				      u32 count, OUT u32 *pu_index,
+				      u32 count, u32 *pu_index,
 				      u32 utimeout);
 
 /*
@@ -66,7 +66,7 @@ int mgr_wait_for_bridge_events(struct dsp_notification
  *  Details:
  *      DCD Dll is loaded and MGR Object stores the handle of the DLL.
  */
-extern int mgr_create(OUT struct mgr_object **hmgr_obj,
+extern int mgr_create(struct mgr_object **hmgr_obj,
 			     struct cfg_devnode *dev_node_obj);
 
 /*
@@ -119,9 +119,9 @@ extern int mgr_destroy(struct mgr_object *hmgr_obj);
  *  Details:
  */
 extern int mgr_enum_node_info(u32 node_id,
-				     OUT struct dsp_ndbprops *pndb_props,
+				     struct dsp_ndbprops *pndb_props,
 				     u32 undb_props_size,
-				     OUT u32 *pu_num_nodes);
+				     u32 *pu_num_nodes);
 
 /*
  *  ======== mgr_enum_processor_info ========
@@ -150,10 +150,10 @@ extern int mgr_enum_node_info(u32 node_id,
  *  Details:
  */
 extern int mgr_enum_processor_info(u32 processor_id,
-					  OUT struct dsp_processorinfo
+					  struct dsp_processorinfo
 					  *processor_info,
 					  u32 processor_info_size,
-					  OUT u8 *pu_num_procs);
+					  u8 *pu_num_procs);
 /*
  *  ======== mgr_exit ========
  *  Purpose:
@@ -186,7 +186,7 @@ extern void mgr_exit(void);
  *      -EPERM and *phDCDHandle == NULL
  */
 extern int mgr_get_dcd_handle(struct mgr_object
-				     *hMGRHandle, OUT u32 *phDCDHandle);
+				     *hMGRHandle, u32 *phDCDHandle);
 
 /*
  *  ======== mgr_init ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/msg.h b/drivers/staging/tidspbridge/include/dspbridge/msg.h
index baac5f3..b849fc4 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/msg.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/msg.h
@@ -40,7 +40,7 @@
  *      msgCallback != NULL.
  *  Ensures:
  */
-extern int msg_create(OUT struct msg_mgr **phMsgMgr,
+extern int msg_create(struct msg_mgr **phMsgMgr,
 			     struct dev_object *hdev_obj,
 			     msg_onexit msgCallback);
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/nldr.h b/drivers/staging/tidspbridge/include/dspbridge/nldr.h
index d8c9688..a1b1996 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/nldr.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/nldr.h
@@ -28,10 +28,10 @@
 extern int nldr_allocate(struct nldr_object *nldr_obj,
 				void *priv_ref, const struct dcd_nodeprops
 				*node_props,
-				OUT struct nldr_nodeobject **phNldrNode,
+				struct nldr_nodeobject **phNldrNode,
 				bool *pf_phase_split);
 
-extern int nldr_create(OUT struct nldr_object **phNldr,
+extern int nldr_create(struct nldr_object **phNldr,
 			      struct dev_object *hdev_obj,
 			      const struct nldr_attrs *pattrs);
 
@@ -42,7 +42,7 @@ extern int nldr_get_fxn_addr(struct nldr_nodeobject *nldr_node_obj,
 				    char *pstrFxn, u32 * pulAddr);
 
 extern int nldr_get_rmm_manager(struct nldr_object *hNldrObject,
-				       OUT struct rmm_target_obj **phRmmMgr);
+				       struct rmm_target_obj **phRmmMgr);
 
 extern bool nldr_init(void);
 extern int nldr_load(struct nldr_nodeobject *nldr_node_obj,
diff --git a/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h b/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
index 2f9bea3..af5362e 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
@@ -131,9 +131,9 @@ typedef int(*nldr_allocatefxn) (struct nldr_object *nldr_obj,
 				       void *priv_ref,
 				       const struct dcd_nodeprops
 				       * node_props,
-				       OUT struct nldr_nodeobject
+				       struct nldr_nodeobject
 				       **phNldrNode,
-				       OUT bool *pf_phase_split);
+				       bool *pf_phase_split);
 
 /*
  *  ======== nldr_create ========
@@ -156,7 +156,7 @@ typedef int(*nldr_allocatefxn) (struct nldr_object *nldr_obj,
  *      0:        Valid *phNldr.
  *      error:          *phNldr == NULL.
  */
-typedef int(*nldr_createfxn) (OUT struct nldr_object **phNldr,
+typedef int(*nldr_createfxn) (struct nldr_object **phNldr,
 				     struct dev_object *hdev_obj,
 				     const struct nldr_attrs *pattrs);
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/node.h b/drivers/staging/tidspbridge/include/dspbridge/node.h
index 7be6dda..8ec348b 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/node.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/node.h
@@ -60,7 +60,7 @@ extern int node_allocate(struct proc_object *hprocessor,
 				const struct dsp_cbdata
 				*pargs, const struct dsp_nodeattrin
 				*attr_in,
-				OUT struct node_object **ph_node,
+				struct node_object **ph_node,
 				struct process_context *pr_ctxt);
 
 /*
@@ -87,7 +87,7 @@ extern int node_allocate(struct proc_object *hprocessor,
  */
 extern int node_alloc_msg_buf(struct node_object *hnode,
 				     u32 usize, struct dsp_bufferattr
-				     *pattr, OUT u8 **pbuffer);
+				     *pattr, u8 **pbuffer);
 
 /*
  *  ======== node_change_priority ========
@@ -231,7 +231,7 @@ extern int node_create(struct node_object *hnode);
  *      0:        Valide *phNodeMgr.
  *      error:          *phNodeMgr == NULL.
  */
-extern int node_create_mgr(OUT struct node_mgr **phNodeMgr,
+extern int node_create_mgr(struct node_mgr **phNodeMgr,
 				  struct dev_object *hdev_obj);
 
 /*
@@ -299,8 +299,8 @@ extern int node_delete_mgr(struct node_mgr *hnode_mgr);
 extern int node_enum_nodes(struct node_mgr *hnode_mgr,
 				  void **node_tab,
 				  u32 node_tab_size,
-				  OUT u32 *pu_num_nodes,
-				  OUT u32 *pu_allocated);
+				  u32 *pu_num_nodes,
+				  u32 *pu_allocated);
 
 /*
  *  ======== node_exit ========
@@ -358,7 +358,7 @@ extern int node_free_msg_buf(struct node_object *hnode,
  *      0:        *pattrs contains the node's current attributes.
  */
 extern int node_get_attr(struct node_object *hnode,
-				OUT struct dsp_nodeattr *pattr, u32 attr_size);
+				struct dsp_nodeattr *pattr, u32 attr_size);
 
 /*
  *  ======== node_get_message ========
@@ -384,7 +384,7 @@ extern int node_get_attr(struct node_object *hnode,
  *  Ensures:
  */
 extern int node_get_message(struct node_object *hnode,
-				   OUT struct dsp_msg *message, u32 utimeout);
+				   struct dsp_msg *message, u32 utimeout);
 
 /*
  *  ======== node_get_nldr_obj ========
@@ -399,7 +399,7 @@ extern int node_get_message(struct node_object *hnode,
  *  Ensures:
  */
 extern int node_get_nldr_obj(struct node_mgr *hnode_mgr,
-				    OUT struct nldr_object **phNldrObj);
+				    struct nldr_object **phNldrObj);
 
 /*
  *  ======== node_init ========
@@ -544,7 +544,7 @@ extern int node_run(struct node_object *hnode);
  *  Ensures:
  */
 extern int node_terminate(struct node_object *hnode,
-				 OUT int *pstatus);
+				 int *pstatus);
 
 /*
  *  ======== node_get_uuid_props ========
@@ -555,7 +555,7 @@ extern int node_terminate(struct node_object *hnode,
  */
 extern int node_get_uuid_props(void *hprocessor,
 				      const struct dsp_uuid *pNodeId,
-				      OUT struct dsp_ndbprops
+				      struct dsp_ndbprops
 				      *node_props);
 
 #ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
diff --git a/drivers/staging/tidspbridge/include/dspbridge/nodepriv.h b/drivers/staging/tidspbridge/include/dspbridge/nodepriv.h
index 42e1a94..c6e1c09 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/nodepriv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/nodepriv.h
@@ -102,7 +102,7 @@ struct node_createargs {
  *  Ensures:
  */
 extern int node_get_channel_id(struct node_object *hnode,
-				      u32 dir, u32 index, OUT u32 *pulId);
+				      u32 dir, u32 index, u32 *pulId);
 
 /*
  *  ======== node_get_strm_mgr ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/proc.h b/drivers/staging/tidspbridge/include/dspbridge/proc.h
index 12f2f2a..0c0a4ec 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/proc.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/proc.h
@@ -153,8 +153,8 @@ extern int proc_detach(struct process_context *pr_ctxt);
 extern int proc_enum_nodes(void *hprocessor,
 				  void **node_tab,
 				  u32 node_tab_size,
-				  OUT u32 *pu_num_nodes,
-				  OUT u32 *pu_allocated);
+				  u32 *pu_num_nodes,
+				  u32 *pu_allocated);
 
 /*
  *  ======== proc_get_resource_info ========
@@ -184,7 +184,7 @@ extern int proc_enum_nodes(void *hprocessor,
  */
 extern int proc_get_resource_info(void *hprocessor,
 					 u32 resource_type,
-					 OUT struct dsp_resourceinfo
+					 struct dsp_resourceinfo
 					 *resource_info,
 					 u32 resource_info_size);
 
@@ -256,7 +256,7 @@ extern bool proc_init(void);
  *  Ensures:
  *  Details:
  */
-extern int proc_get_state(void *hprocessor, OUT struct dsp_processorstate
+extern int proc_get_state(void *hprocessor, struct dsp_processorstate
 				 *proc_state_obj, u32 state_info_size);
 
 /*
diff --git a/drivers/staging/tidspbridge/include/dspbridge/strm.h b/drivers/staging/tidspbridge/include/dspbridge/strm.h
index 7b7a243..e1b68d6 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/strm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/strm.h
@@ -46,7 +46,7 @@
  */
 extern int strm_allocate_buffer(struct strm_object *hStrm,
 				       u32 usize,
-				       OUT u8 **ap_buffer,
+				       u8 **ap_buffer,
 				       u32 num_bufs,
 				       struct process_context *pr_ctxt);
 
@@ -90,7 +90,7 @@ extern int strm_close(struct strm_object *hStrm,
  *      0:        Valid *phStrmMgr.
  *      error:          *phStrmMgr == NULL.
  */
-extern int strm_create(OUT struct strm_mgr **phStrmMgr,
+extern int strm_create(struct strm_mgr **phStrmMgr,
 			      struct dev_object *dev_obj);
 
 /*
@@ -158,7 +158,7 @@ extern int strm_free_buffer(struct strm_object *hStrm,
  *  Ensures:
  */
 extern int strm_get_event_handle(struct strm_object *hStrm,
-					OUT void **ph_event);
+					void **ph_event);
 
 /*
  *  ======== strm_get_info ========
@@ -180,7 +180,7 @@ extern int strm_get_event_handle(struct strm_object *hStrm,
  *  Ensures:
  */
 extern int strm_get_info(struct strm_object *hStrm,
-				OUT struct stream_info *stream_info,
+				struct stream_info *stream_info,
 				u32 stream_info_size);
 
 /*
@@ -272,7 +272,7 @@ extern int strm_issue(struct strm_object *hStrm, u8 * pbuf,
  */
 extern int strm_open(struct node_object *hnode, u32 dir,
 			    u32 index, struct strm_attr *pattr,
-			    OUT struct strm_object **phStrm,
+			    struct strm_object **phStrm,
 			    struct process_context *pr_ctxt);
 
 /*
@@ -322,7 +322,7 @@ extern int strm_prepare_buffer(struct strm_object *hStrm,
  *  Ensures:
  */
 extern int strm_reclaim(struct strm_object *hStrm,
-			       OUT u8 **buf_ptr, u32 * pulBytes,
+			       u8 **buf_ptr, u32 * pulBytes,
 			       u32 *pulBufSize, u32 *pdw_arg);
 
 /*
@@ -377,7 +377,7 @@ extern int strm_register_notify(struct strm_object *hStrm,
  *      Error:          *pmask == 0.
  */
 extern int strm_select(struct strm_object **strm_tab,
-			      u32 nStrms, OUT u32 *pmask, u32 utimeout);
+			      u32 nStrms, u32 *pmask, u32 utimeout);
 
 /*
  *  ======== strm_unprepare_buffer ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/uuidutil.h b/drivers/staging/tidspbridge/include/dspbridge/uuidutil.h
index a7a64f2..db9dc1e 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/uuidutil.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/uuidutil.h
@@ -38,7 +38,7 @@
  *  Details:
  *      UUID string limit currently set at MAXUUIDLEN.
  */
-void uuid_uuid_to_string(struct dsp_uuid *uuid_obj, OUT char *pszUuid,
+void uuid_uuid_to_string(struct dsp_uuid *uuid_obj, char *pszUuid,
 			 s32 size);
 
 /*
@@ -57,6 +57,6 @@ void uuid_uuid_to_string(struct dsp_uuid *uuid_obj, OUT char *pszUuid,
  *      "12345678_1234_1234_1234_123456789abc".
  */
 extern void uuid_uuid_from_string(char *pszUuid,
-				  OUT struct dsp_uuid *uuid_obj);
+				  struct dsp_uuid *uuid_obj);
 
 #endif /* UUIDUTIL_ */
diff --git a/drivers/staging/tidspbridge/pmgr/chnl.c b/drivers/staging/tidspbridge/pmgr/chnl.c
index c9787fb..afb48a0 100644
--- a/drivers/staging/tidspbridge/pmgr/chnl.c
+++ b/drivers/staging/tidspbridge/pmgr/chnl.c
@@ -51,7 +51,7 @@ static u32 refs;
  *      Create a channel manager object, responsible for opening new channels
  *      and closing old ones for a given 'Bridge board.
  */
-int chnl_create(OUT struct chnl_mgr **phChnlMgr,
+int chnl_create(struct chnl_mgr **phChnlMgr,
 		       struct dev_object *hdev_obj,
 		       const struct chnl_mgrattrs *pMgrAttrs)
 {
diff --git a/drivers/staging/tidspbridge/pmgr/cmm.c b/drivers/staging/tidspbridge/pmgr/cmm.c
index 9f9b5c5..32e396a 100644
--- a/drivers/staging/tidspbridge/pmgr/cmm.c
+++ b/drivers/staging/tidspbridge/pmgr/cmm.c
@@ -164,7 +164,7 @@ static void un_register_gppsm_seg(struct cmm_allocator *psma);
  *      inUseList.
  */
 void *cmm_calloc_buf(struct cmm_object *hcmm_mgr, u32 usize,
-		     struct cmm_attrs *pattrs, OUT void **pp_buf_va)
+		     struct cmm_attrs *pattrs, void **pp_buf_va)
 {
 	struct cmm_object *cmm_mgr_obj = (struct cmm_object *)hcmm_mgr;
 	void *buf_pa = NULL;
@@ -240,7 +240,7 @@ void *cmm_calloc_buf(struct cmm_object *hcmm_mgr, u32 usize,
  *  Purpose:
  *      Create a communication memory manager object.
  */
-int cmm_create(OUT struct cmm_object **ph_cmm_mgr,
+int cmm_create(struct cmm_object **ph_cmm_mgr,
 		      struct dev_object *hdev_obj,
 		      const struct cmm_mgrattrs *pMgrAttrs)
 {
@@ -429,7 +429,7 @@ int cmm_free_buf(struct cmm_object *hcmm_mgr, void *buf_pa,
  *      Return the communication memory manager object for this device.
  *      This is typically called from the client process.
  */
-int cmm_get_handle(void *hprocessor, OUT struct cmm_object ** ph_cmm_mgr)
+int cmm_get_handle(void *hprocessor, struct cmm_object ** ph_cmm_mgr)
 {
 	int status = 0;
 	struct dev_object *hdev_obj;
@@ -453,7 +453,7 @@ int cmm_get_handle(void *hprocessor, OUT struct cmm_object ** ph_cmm_mgr)
  *      Return the current memory utilization information.
  */
 int cmm_get_info(struct cmm_object *hcmm_mgr,
-			OUT struct cmm_info *cmm_info_obj)
+			struct cmm_info *cmm_info_obj)
 {
 	struct cmm_object *cmm_mgr_obj = (struct cmm_object *)hcmm_mgr;
 	u32 ul_seg;
@@ -954,7 +954,7 @@ static struct cmm_allocator *get_allocator(struct cmm_object *cmm_mgr_obj,
  *  Purpose:
  *      Create an address translator object.
  */
-int cmm_xlator_create(OUT struct cmm_xlatorobject **phXlator,
+int cmm_xlator_create(struct cmm_xlatorobject **phXlator,
 			     struct cmm_object *hcmm_mgr,
 			     struct cmm_xlatorattrs *pXlatorAttrs)
 {
@@ -1075,7 +1075,7 @@ int cmm_xlator_free_buf(struct cmm_xlatorobject *xlator, void *pBufVa)
  *  Purpose:
  *      Set/Get translator info.
  */
-int cmm_xlator_info(struct cmm_xlatorobject *xlator, OUT u8 ** paddr,
+int cmm_xlator_info(struct cmm_xlatorobject *xlator, u8 ** paddr,
 			   u32 ul_size, u32 uSegId, bool set_info)
 {
 	struct cmm_xlator *xlator_obj = (struct cmm_xlator *)xlator;
diff --git a/drivers/staging/tidspbridge/pmgr/cod.c b/drivers/staging/tidspbridge/pmgr/cod.c
index 2aed7a4..0ab12f1 100644
--- a/drivers/staging/tidspbridge/pmgr/cod.c
+++ b/drivers/staging/tidspbridge/pmgr/cod.c
@@ -216,7 +216,7 @@ void cod_close(struct cod_libraryobj *lib)
  *      dynamically loaded object files.
  *
  */
-int cod_create(OUT struct cod_manager **phMgr, char *pstrDummyFile,
+int cod_create(struct cod_manager **phMgr, char *pstrDummyFile,
 		      const struct cod_attrs *attrs)
 {
 	struct cod_manager *mgr_new;
@@ -398,7 +398,7 @@ int cod_get_loader(struct cod_manager *cod_mgr_obj,
  *      given the section name.
  */
 int cod_get_section(struct cod_libraryobj *lib, char *pstrSect,
-			   OUT u32 *puAddr, OUT u32 *puLen)
+			   u32 *puAddr, u32 *puLen)
 {
 	struct cod_manager *cod_mgr_obj;
 	int status = 0;
@@ -627,7 +627,7 @@ int cod_open_base(struct cod_manager *hmgr, char *pszCoffPath,
  *      Retrieve the content of a code section given the section name.
  */
 int cod_read_section(struct cod_libraryobj *lib, char *pstrSect,
-			    OUT char *pstrContent, u32 content_size)
+			    char *pstrContent, u32 content_size)
 {
 	int status = 0;
 
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index 4e4b20a..d05d366 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -92,7 +92,7 @@ static u32 refs;		/* Module reference count */
 static int fxn_not_implemented(int arg, ...);
 static int init_cod_mgr(struct dev_object *dev_obj);
 static void store_interface_fxns(struct bridge_drv_interface *drv_fxns,
-				 OUT struct bridge_drv_interface *intf_fxns);
+				 struct bridge_drv_interface *intf_fxns);
 /*
  *  ======== dev_brd_write_fxn ========
  *  Purpose:
@@ -131,7 +131,7 @@ u32 dev_brd_write_fxn(void *pArb, u32 ulDspAddr, void *pHostBuf,
  *      Called by the operating system to load the PM Bridge Driver for a
  *      PM board (device).
  */
-int dev_create_device(OUT struct dev_object **phDevObject,
+int dev_create_device(struct dev_object **phDevObject,
 			     const char *driver_file_name,
 			     struct cfg_devnode *dev_node_obj)
 {
@@ -260,7 +260,7 @@ int dev_create_device(OUT struct dev_object **phDevObject,
 	}
 leave:
 	/*  If all went well, return a handle to the dev object;
-	 *  else, cleanup and return NULL in the OUT parameter. */
+	 *  else, cleanup and return NULL in the parameter. */
 	if (DSP_SUCCEEDED(status)) {
 		*phDevObject = dev_obj;
 	} else {
@@ -420,7 +420,7 @@ int dev_destroy_device(struct dev_object *hdev_obj)
  *      device.
  */
 int dev_get_chnl_mgr(struct dev_object *hdev_obj,
-			    OUT struct chnl_mgr **phMgr)
+			    struct chnl_mgr **phMgr)
 {
 	int status = 0;
 	struct dev_object *dev_obj = hdev_obj;
@@ -447,7 +447,7 @@ int dev_get_chnl_mgr(struct dev_object *hdev_obj,
  *      device.
  */
 int dev_get_cmm_mgr(struct dev_object *hdev_obj,
-			   OUT struct cmm_object **phMgr)
+			   struct cmm_object **phMgr)
 {
 	int status = 0;
 	struct dev_object *dev_obj = hdev_obj;
@@ -474,7 +474,7 @@ int dev_get_cmm_mgr(struct dev_object *hdev_obj,
  *      device.
  */
 int dev_get_dmm_mgr(struct dev_object *hdev_obj,
-			   OUT struct dmm_object **phMgr)
+			   struct dmm_object **phMgr)
 {
 	int status = 0;
 	struct dev_object *dev_obj = hdev_obj;
@@ -500,7 +500,7 @@ int dev_get_dmm_mgr(struct dev_object *hdev_obj,
  *      Retrieve the COD manager create for this device.
  */
 int dev_get_cod_mgr(struct dev_object *hdev_obj,
-			   OUT struct cod_manager **phCodMgr)
+			   struct cod_manager **phCodMgr)
 {
 	int status = 0;
 	struct dev_object *dev_obj = hdev_obj;
@@ -524,7 +524,7 @@ int dev_get_cod_mgr(struct dev_object *hdev_obj,
  *  ========= dev_get_deh_mgr ========
  */
 int dev_get_deh_mgr(struct dev_object *hdev_obj,
-			   OUT struct deh_mgr **phDehMgr)
+			   struct deh_mgr **phDehMgr)
 {
 	int status = 0;
 
@@ -546,7 +546,7 @@ int dev_get_deh_mgr(struct dev_object *hdev_obj,
  *      Retrieve the platform specific device ID for this device.
  */
 int dev_get_dev_node(struct dev_object *hdev_obj,
-			    OUT struct cfg_devnode **phDevNode)
+			    struct cfg_devnode **phDevNode)
 {
 	int status = 0;
 	struct dev_object *dev_obj = hdev_obj;
@@ -588,7 +588,7 @@ struct dev_object *dev_get_first(void)
  *      ppIntfFxns != NULL.
  */
 int dev_get_intf_fxns(struct dev_object *hdev_obj,
-			     OUT struct bridge_drv_interface **ppIntfFxns)
+			     struct bridge_drv_interface **ppIntfFxns)
 {
 	int status = 0;
 	struct dev_object *dev_obj = hdev_obj;
@@ -612,7 +612,7 @@ int dev_get_intf_fxns(struct dev_object *hdev_obj,
  *  ========= dev_get_io_mgr ========
  */
 int dev_get_io_mgr(struct dev_object *hdev_obj,
-			  OUT struct io_mgr **phIOMgr)
+			  struct io_mgr **phIOMgr)
 {
 	int status = 0;
 
@@ -652,7 +652,7 @@ struct dev_object *dev_get_next(struct dev_object *hdev_obj)
 /*
  *  ========= dev_get_msg_mgr ========
  */
-void dev_get_msg_mgr(struct dev_object *hdev_obj, OUT struct msg_mgr **phMsgMgr)
+void dev_get_msg_mgr(struct dev_object *hdev_obj, struct msg_mgr **phMsgMgr)
 {
 	DBC_REQUIRE(refs > 0);
 	DBC_REQUIRE(phMsgMgr != NULL);
@@ -667,7 +667,7 @@ void dev_get_msg_mgr(struct dev_object *hdev_obj, OUT struct msg_mgr **phMsgMgr)
  *      Retrieve the Node Manager Handle
  */
 int dev_get_node_manager(struct dev_object *hdev_obj,
-				OUT struct node_mgr **phNodeMgr)
+				struct node_mgr **phNodeMgr)
 {
 	int status = 0;
 	struct dev_object *dev_obj = hdev_obj;
@@ -691,7 +691,7 @@ int dev_get_node_manager(struct dev_object *hdev_obj,
  *  ======== dev_get_symbol ========
  */
 int dev_get_symbol(struct dev_object *hdev_obj,
-			  const char *pstrSym, OUT u32 * pul_value)
+			  const char *pstrSym, u32 * pul_value)
 {
 	int status = 0;
 	struct cod_manager *cod_mgr;
@@ -718,7 +718,7 @@ int dev_get_symbol(struct dev_object *hdev_obj,
  *      bridge_dev_create fxn.
  */
 int dev_get_bridge_context(struct dev_object *hdev_obj,
-			       OUT struct bridge_dev_context **phbridge_context)
+			       struct bridge_dev_context **phbridge_context)
 {
 	int status = 0;
 	struct dev_object *dev_obj = hdev_obj;
@@ -974,7 +974,7 @@ static int init_cod_mgr(struct dev_object *dev_obj)
  *      0 and List is not Empty.
  */
 int dev_insert_proc_object(struct dev_object *hdev_obj,
-				  u32 proc_obj, OUT bool *pbAlreadyAttached)
+				  u32 proc_obj, bool *pbAlreadyAttached)
 {
 	int status = 0;
 	struct dev_object *dev_obj = (struct dev_object *)hdev_obj;
@@ -1069,7 +1069,7 @@ int dev_get_dev_type(struct dev_object *hdevObject, u8 *dev_type)
  *      All function pointers in the dev object's fxn interface are not NULL.
  */
 static void store_interface_fxns(struct bridge_drv_interface *drv_fxns,
-				 OUT struct bridge_drv_interface *intf_fxns)
+				 struct bridge_drv_interface *intf_fxns)
 {
 	u32 bridge_version;
 
diff --git a/drivers/staging/tidspbridge/pmgr/dmm.c b/drivers/staging/tidspbridge/pmgr/dmm.c
index 633e77d..9599753 100644
--- a/drivers/staging/tidspbridge/pmgr/dmm.c
+++ b/drivers/staging/tidspbridge/pmgr/dmm.c
@@ -117,7 +117,7 @@ int dmm_create_tables(struct dmm_object *dmm_mgr, u32 addr, u32 size)
  *  Purpose:
  *      Create a dynamic memory manager object.
  */
-int dmm_create(OUT struct dmm_object **phDmmMgr,
+int dmm_create(struct dmm_object **phDmmMgr,
 		      struct dev_object *hdev_obj,
 		      const struct dmm_mgrattrs *pMgrAttrs)
 {
@@ -197,7 +197,7 @@ void dmm_exit(void)
  *      Return the dynamic memory manager object for this device.
  *      This is typically called from the client process.
  */
-int dmm_get_handle(void *hprocessor, OUT struct dmm_object **phDmmMgr)
+int dmm_get_handle(void *hprocessor, struct dmm_object **phDmmMgr)
 {
 	int status = 0;
 	struct dev_object *hdev_obj;
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 2d43031..bfaf88a 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -1127,7 +1127,7 @@ u32 nodewrap_alloc_msg_buf(union Trapped_Args *args, void *pr_ctxt)
 			pattr = &attr;
 
 	}
-	/* OUT argument */
+	/* argument */
 	CP_FM_USR(&pbuffer, args->args_node_allocmsgbuf.pbuffer, status, 1);
 	if (DSP_SUCCEEDED(status)) {
 		status = node_alloc_msg_buf(args->args_node_allocmsgbuf.hnode,
diff --git a/drivers/staging/tidspbridge/pmgr/io.c b/drivers/staging/tidspbridge/pmgr/io.c
index e8f006a..b47786f 100644
--- a/drivers/staging/tidspbridge/pmgr/io.c
+++ b/drivers/staging/tidspbridge/pmgr/io.c
@@ -46,7 +46,7 @@ static u32 refs;
  *      Create an IO manager object, responsible for managing IO between
  *      CHNL and msg_ctrl
  */
-int io_create(OUT struct io_mgr **phIOMgr, struct dev_object *hdev_obj,
+int io_create(struct io_mgr **phIOMgr, struct dev_object *hdev_obj,
 		     const struct io_attrs *pMgrAttrs)
 {
 	struct bridge_drv_interface *intf_fxns;
diff --git a/drivers/staging/tidspbridge/pmgr/msg.c b/drivers/staging/tidspbridge/pmgr/msg.c
index 7dec2ab..3e2937c 100644
--- a/drivers/staging/tidspbridge/pmgr/msg.c
+++ b/drivers/staging/tidspbridge/pmgr/msg.c
@@ -45,7 +45,7 @@ static u32 refs;		/* module reference count */
  *      Create an object to manage message queues. Only one of these objects
  *      can exist per device object.
  */
-int msg_create(OUT struct msg_mgr **phMsgMgr,
+int msg_create(struct msg_mgr **phMsgMgr,
 		      struct dev_object *hdev_obj, msg_onexit msgCallback)
 {
 	struct bridge_drv_interface *intf_fxns;
diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index 81b91b8..026a6f6 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -69,10 +69,10 @@ static void compress_buf(char *psz_buf, u32 ul_buf_size, s32 char_size);
 static char dsp_char2_gpp_char(char *pWord, s32 dsp_char_size);
 static int get_dep_lib_info(struct dcd_manager *hdcd_mgr,
 				   struct dsp_uuid *uuid_obj,
-				   OUT u16 *pNumLibs,
-				   OUT u16 *pNumPersLibs,
-				   OUT struct dsp_uuid *pDepLibUuids,
-				   OUT bool *pPersistentDepLibs,
+				   u16 *pNumLibs,
+				   u16 *pNumPersLibs,
+				   struct dsp_uuid *pDepLibUuids,
+				   bool *pPersistentDepLibs,
 				   enum nldr_phase phase);
 
 /*
@@ -125,7 +125,7 @@ int dcd_auto_unregister(struct dcd_manager *hdcd_mgr,
  *      Creates DCD manager.
  */
 int dcd_create_manager(char *pszZlDllName,
-			      OUT struct dcd_manager **phDcdMgr)
+			      struct dcd_manager **phDcdMgr)
 {
 	struct cod_manager *cod_mgr;	/* COD manager handle */
 	struct dcd_manager *dcd_mgr_obj = NULL;	/* DCD Manager pointer */
@@ -194,7 +194,7 @@ int dcd_destroy_manager(struct dcd_manager *hdcd_mgr)
  *      Enumerates objects in the DCD.
  */
 int dcd_enumerate_object(s32 index, enum dsp_dcdobjtype obj_type,
-				OUT struct dsp_uuid *uuid_obj)
+				struct dsp_uuid *uuid_obj)
 {
 	int status = 0;
 	char sz_reg_key[DCD_MAXPATHLENGTH];
@@ -327,8 +327,8 @@ void dcd_exit(void)
  */
 int dcd_get_dep_libs(struct dcd_manager *hdcd_mgr,
 			    struct dsp_uuid *uuid_obj,
-			    u16 numLibs, OUT struct dsp_uuid *pDepLibUuids,
-			    OUT bool *pPersistentDepLibs,
+			    u16 numLibs, struct dsp_uuid *pDepLibUuids,
+			    bool *pPersistentDepLibs,
 			    enum nldr_phase phase)
 {
 	int status = 0;
@@ -351,7 +351,7 @@ int dcd_get_dep_libs(struct dcd_manager *hdcd_mgr,
  */
 int dcd_get_num_dep_libs(struct dcd_manager *hdcd_mgr,
 				struct dsp_uuid *uuid_obj,
-				OUT u16 *pNumLibs, OUT u16 *pNumPersLibs,
+				u16 *pNumLibs, u16 *pNumPersLibs,
 				enum nldr_phase phase)
 {
 	int status = 0;
@@ -377,7 +377,7 @@ int dcd_get_num_dep_libs(struct dcd_manager *hdcd_mgr,
 int dcd_get_object_def(struct dcd_manager *hdcd_mgr,
 			      struct dsp_uuid *pObjUuid,
 			      enum dsp_dcdobjtype obj_type,
-			      OUT struct dcd_genericobj *pObjDef)
+			      struct dcd_genericobj *pObjDef)
 {
 	struct dcd_manager *dcd_mgr_obj = hdcd_mgr;	/* ptr to DCD mgr */
 	struct cod_libraryobj *lib = NULL;
@@ -644,8 +644,8 @@ func_end:
  */
 int dcd_get_library_name(struct dcd_manager *hdcd_mgr,
 				struct dsp_uuid *uuid_obj,
-				OUT char *pstrLibName, OUT u32 * pdwSize,
-				enum nldr_phase phase, OUT bool *phase_split)
+				char *pstrLibName, u32 * pdwSize,
+				enum nldr_phase phase, bool *phase_split)
 {
 	char sz_reg_key[DCD_MAXPATHLENGTH];
 	char sz_uuid[MAXUUIDLEN];
@@ -1391,10 +1391,10 @@ static char dsp_char2_gpp_char(char *pWord, s32 dsp_char_size)
  */
 static int get_dep_lib_info(struct dcd_manager *hdcd_mgr,
 				   struct dsp_uuid *uuid_obj,
-				   OUT u16 *pNumLibs,
-				   OUT u16 *pNumPersLibs,
-				   OUT struct dsp_uuid *pDepLibUuids,
-				   OUT bool *pPersistentDepLibs,
+				   u16 *pNumLibs,
+				   u16 *pNumPersLibs,
+				   struct dsp_uuid *pDepLibUuids,
+				   bool *pPersistentDepLibs,
 				   enum nldr_phase phase)
 {
 	struct dcd_manager *dcd_mgr_obj = hdcd_mgr;
diff --git a/drivers/staging/tidspbridge/rmgr/disp.c b/drivers/staging/tidspbridge/rmgr/disp.c
index cb50077..bbd0d06 100644
--- a/drivers/staging/tidspbridge/rmgr/disp.c
+++ b/drivers/staging/tidspbridge/rmgr/disp.c
@@ -81,13 +81,13 @@ static int fill_stream_def(rms_word *pdw_buf, u32 *ptotal, u32 offset,
 				  struct node_strmdef strm_def, u32 max,
 				  u32 chars_in_rms_word);
 static int send_message(struct disp_object *disp_obj, u32 dwTimeout,
-			       u32 ul_bytes, OUT u32 *pdw_arg);
+			       u32 ul_bytes, u32 *pdw_arg);
 
 /*
  *  ======== disp_create ========
  *  Create a NODE Dispatcher object.
  */
-int disp_create(OUT struct disp_object **phDispObject,
+int disp_create(struct disp_object **phDispObject,
 		       struct dev_object *hdev_obj,
 		       const struct disp_attr *pDispAttrs)
 {
@@ -252,7 +252,7 @@ int disp_node_create(struct disp_object *disp_obj,
 			    struct node_object *hnode, u32 ulRMSFxn,
 			    u32 ul_create_fxn,
 			    const struct node_createargs *pargs,
-			    OUT nodeenv *pNodeEnv)
+			    nodeenv *pNodeEnv)
 {
 	struct node_msgargs node_msg_args;
 	struct node_taskargs task_arg_obj;
diff --git a/drivers/staging/tidspbridge/rmgr/drv.c b/drivers/staging/tidspbridge/rmgr/drv.c
index 112ac87..2777c43 100644
--- a/drivers/staging/tidspbridge/rmgr/drv.c
+++ b/drivers/staging/tidspbridge/rmgr/drv.c
@@ -421,7 +421,7 @@ int drv_proc_update_strm_res(u32 num_bufs, void *hstrm_res)
  *  Purpose:
  *      DRV Object gets created only once during Driver Loading.
  */
-int drv_create(OUT struct drv_object **phDRVObject)
+int drv_create(struct drv_object **phDRVObject)
 {
 	int status = 0;
 	struct drv_object *pdrv_object = NULL;
@@ -968,7 +968,7 @@ void mem_ext_phys_pool_release(void)
  *     Allocate physically contiguous, uncached memory from external memory pool
  */
 
-static void *mem_ext_phys_mem_alloc(u32 bytes, u32 align, OUT u32 * pPhysAddr)
+static void *mem_ext_phys_mem_alloc(u32 bytes, u32 align, u32 * pPhysAddr)
 {
 	u32 new_alloc_ptr;
 	u32 offset;
@@ -1011,7 +1011,7 @@ static void *mem_ext_phys_mem_alloc(u32 bytes, u32 align, OUT u32 * pPhysAddr)
  *  Purpose:
  *      Allocate physically contiguous, uncached memory
  */
-void *mem_alloc_phys_mem(u32 byte_size, u32 ulAlign, OUT u32 * pPhysicalAddress)
+void *mem_alloc_phys_mem(u32 byte_size, u32 ulAlign, u32 * pPhysicalAddress)
 {
 	void *va_mem = NULL;
 	dma_addr_t pa_mem;
diff --git a/drivers/staging/tidspbridge/rmgr/dspdrv.c b/drivers/staging/tidspbridge/rmgr/dspdrv.c
index 2fddbbb..5658cbc 100644
--- a/drivers/staging/tidspbridge/rmgr/dspdrv.c
+++ b/drivers/staging/tidspbridge/rmgr/dspdrv.c
@@ -44,7 +44,7 @@
  *  ======== dsp_init ========
  *  	Allocates bridge resources. Loads a base image onto DSP, if specified.
  */
-u32 dsp_init(OUT u32 *init_status)
+u32 dsp_init(u32 *init_status)
 {
 	char dev_node[MAXREGPATHLENGTH] = "TIOMAP1510";
 	int status = -EPERM;
diff --git a/drivers/staging/tidspbridge/rmgr/mgr.c b/drivers/staging/tidspbridge/rmgr/mgr.c
index a7bc93b..1f8b929 100644
--- a/drivers/staging/tidspbridge/rmgr/mgr.c
+++ b/drivers/staging/tidspbridge/rmgr/mgr.c
@@ -53,7 +53,7 @@ static u32 refs;
  *  Purpose:
  *      MGR Object gets created only once during driver Loading.
  */
-int mgr_create(OUT struct mgr_object **phMgrObject,
+int mgr_create(struct mgr_object **phMgrObject,
 		      struct cfg_devnode *dev_node_obj)
 {
 	int status = 0;
@@ -114,8 +114,8 @@ int mgr_destroy(struct mgr_object *hmgr_obj)
  *      Enumerate and get configuration information about nodes configured
  *      in the node database.
  */
-int mgr_enum_node_info(u32 node_id, OUT struct dsp_ndbprops *pndb_props,
-			      u32 undb_props_size, OUT u32 *pu_num_nodes)
+int mgr_enum_node_info(u32 node_id, struct dsp_ndbprops *pndb_props,
+			      u32 undb_props_size, u32 *pu_num_nodes)
 {
 	int status = 0;
 	struct dsp_uuid node_uuid, temp_uuid;
@@ -178,9 +178,9 @@ func_cont:
  *      DSP processors.
  */
 int mgr_enum_processor_info(u32 processor_id,
-				   OUT struct dsp_processorinfo *
+				   struct dsp_processorinfo *
 				   processor_info, u32 processor_info_size,
-				   OUT u8 *pu_num_procs)
+				   u8 *pu_num_procs)
 {
 	int status = 0;
 	int status1 = 0;
@@ -305,7 +305,7 @@ void mgr_exit(void)
  *      Retrieves the MGR handle. Accessor Function.
  */
 int mgr_get_dcd_handle(struct mgr_object *hMGRHandle,
-			      OUT u32 *phDCDHandle)
+			      u32 *phDCDHandle)
 {
 	int status = -EPERM;
 	struct mgr_object *pmgr_obj = (struct mgr_object *)hMGRHandle;
@@ -355,7 +355,7 @@ bool mgr_init(void)
  *      Block on any Bridge event(s)
  */
 int mgr_wait_for_bridge_events(struct dsp_notification **anotifications,
-				      u32 count, OUT u32 *pu_index,
+				      u32 count, u32 *pu_index,
 				      u32 utimeout)
 {
 	int status;
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index aaaab67..8667216 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -325,7 +325,7 @@ static u32 find_gcf(u32 a, u32 b);
  */
 int nldr_allocate(struct nldr_object *nldr_obj, void *priv_ref,
 			 const struct dcd_nodeprops *node_props,
-			 OUT struct nldr_nodeobject **phNldrNode,
+			 struct nldr_nodeobject **phNldrNode,
 			 bool *pf_phase_split)
 {
 	struct nldr_nodeobject *nldr_node_obj = NULL;
@@ -424,7 +424,7 @@ int nldr_allocate(struct nldr_object *nldr_obj, void *priv_ref,
 /*
  *  ======== nldr_create ========
  */
-int nldr_create(OUT struct nldr_object **phNldr,
+int nldr_create(struct nldr_object **phNldr,
 		       struct dev_object *hdev_obj,
 		       const struct nldr_attrs *pattrs)
 {
@@ -775,7 +775,7 @@ int nldr_get_fxn_addr(struct nldr_nodeobject *nldr_node_obj,
  *  Given a NLDR object, retrieve RMM Manager Handle
  */
 int nldr_get_rmm_manager(struct nldr_object *hNldrObject,
-				OUT struct rmm_target_obj **phRmmMgr)
+				struct rmm_target_obj **phRmmMgr)
 {
 	int status = 0;
 	struct nldr_object *nldr_obj = hNldrObject;
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 1f975c6..6d24baf 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -294,7 +294,7 @@ int node_allocate(struct proc_object *hprocessor,
 			 const struct dsp_uuid *pNodeId,
 			 const struct dsp_cbdata *pargs,
 			 const struct dsp_nodeattrin *attr_in,
-			 OUT struct node_object **ph_node,
+			 struct node_object **ph_node,
 			 struct process_context *pr_ctxt)
 {
 	struct node_mgr *hnode_mgr;
@@ -685,8 +685,8 @@ func_end:
  *      Allocates buffer for zero copy messaging.
  */
 DBAPI node_alloc_msg_buf(struct node_object *hnode, u32 usize,
-			 OUT struct dsp_bufferattr *pattr,
-			 OUT u8 **pbuffer)
+			 struct dsp_bufferattr *pattr,
+			 u8 **pbuffer)
 {
 	struct node_object *pnode = (struct node_object *)hnode;
 	int status = 0;
@@ -1300,7 +1300,7 @@ func_end:
  *  Purpose:
  *      Create a NODE Manager object.
  */
-int node_create_mgr(OUT struct node_mgr **phNodeMgr,
+int node_create_mgr(struct node_mgr **phNodeMgr,
 			   struct dev_object *hdev_obj)
 {
 	u32 i;
@@ -1613,8 +1613,8 @@ int node_delete_mgr(struct node_mgr *hnode_mgr)
  *      Enumerate currently allocated nodes.
  */
 int node_enum_nodes(struct node_mgr *hnode_mgr, void **node_tab,
-			   u32 node_tab_size, OUT u32 *pu_num_nodes,
-			   OUT u32 *pu_allocated)
+			   u32 node_tab_size, u32 *pu_num_nodes,
+			   u32 *pu_allocated)
 {
 	struct node_object *hnode;
 	u32 i;
@@ -1716,7 +1716,7 @@ func_end:
  *      structure.
  */
 int node_get_attr(struct node_object *hnode,
-			 OUT struct dsp_nodeattr *pattr, u32 attr_size)
+			 struct dsp_nodeattr *pattr, u32 attr_size)
 {
 	struct node_mgr *hnode_mgr;
 	int status = 0;
@@ -1760,7 +1760,7 @@ int node_get_attr(struct node_object *hnode,
  *      host and a node.
  */
 int node_get_channel_id(struct node_object *hnode, u32 dir, u32 index,
-			       OUT u32 *pulId)
+			       u32 *pulId)
 {
 	enum node_type node_type;
 	int status = -EINVAL;
@@ -1802,7 +1802,7 @@ int node_get_channel_id(struct node_object *hnode, u32 dir, u32 index,
  *      Retrieve a message from a node on the DSP.
  */
 int node_get_message(struct node_object *hnode,
-			    OUT struct dsp_msg *pmsg, u32 utimeout)
+			    struct dsp_msg *pmsg, u32 utimeout)
 {
 	struct node_mgr *hnode_mgr;
 	enum node_type node_type;
@@ -2365,7 +2365,7 @@ func_end:
  *      Signal a node running on the DSP that it should exit its execute phase
  *      function.
  */
-int node_terminate(struct node_object *hnode, OUT int *pstatus)
+int node_terminate(struct node_object *hnode, int *pstatus)
 {
 	struct node_object *pnode = (struct node_object *)hnode;
 	struct node_mgr *hnode_mgr = NULL;
@@ -3005,7 +3005,7 @@ static int get_proc_props(struct node_mgr *hnode_mgr,
  */
 int node_get_uuid_props(void *hprocessor,
 			       const struct dsp_uuid *pNodeId,
-			       OUT struct dsp_ndbprops *node_props)
+			       struct dsp_ndbprops *node_props)
 {
 	struct node_mgr *hnode_mgr = NULL;
 	struct dev_object *hdev_obj;
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index 1f450fe..14de79a 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -582,8 +582,8 @@ int proc_detach(struct process_context *pr_ctxt)
  *      on a DSP processor.
  */
 int proc_enum_nodes(void *hprocessor, void **node_tab,
-			   u32 node_tab_size, OUT u32 *pu_num_nodes,
-			   OUT u32 *pu_allocated)
+			   u32 node_tab_size, u32 *pu_num_nodes,
+			   u32 *pu_allocated)
 {
 	int status = -EPERM;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
@@ -849,7 +849,7 @@ int proc_invalidate_memory(void *hprocessor, void *pmpu_addr, u32 size)
  *      Enumerate the resources currently available on a processor.
  */
 int proc_get_resource_info(void *hprocessor, u32 resource_type,
-				  OUT struct dsp_resourceinfo *resource_info,
+				  struct dsp_resourceinfo *resource_info,
 				  u32 resource_info_size)
 {
 	int status = -EPERM;
@@ -964,7 +964,7 @@ int proc_get_dev_object(void *hprocessor,
  *      Report the state of the specified DSP processor.
  */
 int proc_get_state(void *hprocessor,
-			  OUT struct dsp_processorstate *proc_state_obj,
+			  struct dsp_processorstate *proc_state_obj,
 			  u32 state_info_size)
 {
 	int status = 0;
diff --git a/drivers/staging/tidspbridge/rmgr/strm.c b/drivers/staging/tidspbridge/rmgr/strm.c
index 46149da..6dfb6fe 100644
--- a/drivers/staging/tidspbridge/rmgr/strm.c
+++ b/drivers/staging/tidspbridge/rmgr/strm.c
@@ -98,7 +98,7 @@ static void delete_strm_mgr(struct strm_mgr *strm_mgr_obj);
  *      Allocates buffers for a stream.
  */
 int strm_allocate_buffer(struct strm_object *hStrm, u32 usize,
-				OUT u8 **ap_buffer, u32 num_bufs,
+				u8 **ap_buffer, u32 num_bufs,
 				struct process_context *pr_ctxt)
 {
 	int status = 0;
@@ -200,7 +200,7 @@ func_end:
  *  Purpose:
  *      Create a STRM manager object.
  */
-int strm_create(OUT struct strm_mgr **phStrmMgr,
+int strm_create(struct strm_mgr **phStrmMgr,
 		       struct dev_object *dev_obj)
 {
 	struct strm_mgr *strm_mgr_obj;
@@ -308,7 +308,7 @@ int strm_free_buffer(struct strm_object *hStrm, u8 ** ap_buffer,
  *      Retrieves information about a stream.
  */
 int strm_get_info(struct strm_object *hStrm,
-			 OUT struct stream_info *stream_info,
+			 struct stream_info *stream_info,
 			 u32 stream_info_size)
 {
 	struct bridge_drv_interface *intf_fxns;
@@ -465,7 +465,7 @@ int strm_issue(struct strm_object *hStrm, u8 *pbuf, u32 ul_bytes,
  */
 int strm_open(struct node_object *hnode, u32 dir, u32 index,
 		     struct strm_attr *pattr,
-		     OUT struct strm_object **phStrm,
+		     struct strm_object **phStrm,
 		     struct process_context *pr_ctxt)
 {
 	struct strm_mgr *strm_mgr_obj;
@@ -615,7 +615,7 @@ func_cont:
  *  Purpose:
  *      Relcaims a buffer from a stream.
  */
-int strm_reclaim(struct strm_object *hStrm, OUT u8 ** buf_ptr,
+int strm_reclaim(struct strm_object *hStrm, u8 ** buf_ptr,
 			u32 *pulBytes, u32 *pulBufSize, u32 *pdw_arg)
 {
 	struct bridge_drv_interface *intf_fxns;
@@ -739,7 +739,7 @@ int strm_register_notify(struct strm_object *hStrm, u32 event_mask,
  *      Selects a ready stream.
  */
 int strm_select(struct strm_object **strm_tab, u32 nStrms,
-		       OUT u32 *pmask, u32 utimeout)
+		       u32 *pmask, u32 utimeout)
 {
 	u32 index;
 	struct chnl_info chnl_info_obj;
diff --git a/drivers/staging/tidspbridge/services/cfg.c b/drivers/staging/tidspbridge/services/cfg.c
index 699792c..95a2087 100644
--- a/drivers/staging/tidspbridge/services/cfg.c
+++ b/drivers/staging/tidspbridge/services/cfg.c
@@ -51,7 +51,7 @@ void cfg_exit(void)
  *      Retreive the autostart mask, if any, for this board.
  */
 int cfg_get_auto_start(struct cfg_devnode *dev_node_obj,
-			      OUT u32 *pdwAutoStart)
+			      u32 *pdwAutoStart)
 {
 	int status = 0;
 	u32 dw_buf_size;
@@ -77,7 +77,7 @@ int cfg_get_auto_start(struct cfg_devnode *dev_node_obj,
  *      Retrieve the Device Object handle for a given devnode.
  */
 int cfg_get_dev_object(struct cfg_devnode *dev_node_obj,
-			      OUT u32 *pdwValue)
+			      u32 *pdwValue)
 {
 	int status = 0;
 	u32 dw_buf_size;
@@ -113,7 +113,7 @@ int cfg_get_dev_object(struct cfg_devnode *dev_node_obj,
  *      Retreive the default executable, if any, for this board.
  */
 int cfg_get_exec_file(struct cfg_devnode *dev_node_obj, u32 ul_buf_size,
-			     OUT char *pstrExecFile)
+			     char *pstrExecFile)
 {
 	int status = 0;
 	struct drv_data *drv_datap = dev_get_drvdata(bridge);
@@ -143,7 +143,7 @@ int cfg_get_exec_file(struct cfg_devnode *dev_node_obj, u32 ul_buf_size,
  *  Purpose:
  *      Retrieve the Object handle from the Registry
  */
-int cfg_get_object(OUT u32 *pdwValue, u8 dw_type)
+int cfg_get_object(u32 *pdwValue, u8 dw_type)
 {
 	int status = -EINVAL;
 	struct drv_data *drv_datap = dev_get_drvdata(bridge);
-- 
1.6.3.3

