Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab1BQC7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 21:59:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34098 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab1BQC7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:59:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ADcqbJVw5qhXnk8iSMrwNztnYMfLmqjz1K3BegO+Ssjbj1RkBCTBvyYAJ8J02xkS8P
         HrFDREbOY6g+cKuQ4RY0fNqCKJeZDlPl0dYAOu0Wb7ru9QgBA5W8MgVX+ep0nyplo3Ko
         p0CMmh5W6/YbaUOvbkeHcqFM+COjJuw26eIXg=
From: Klaas Neirinck <klaas.neirinck@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Klaas Neirinck <klaas.neirinck@gmail.com>
Subject: [PATCH 09/10] Staging: tidspbridge: fixed spaces after '*' style issues.
Date: Thu, 17 Feb 2011 03:58:53 +0100
Message-Id: <1297911534-31534-9-git-send-email-klaas.neirinck@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297911534-31534-8-git-send-email-klaas.neirinck@gmail.com>
References: <1297911534-31534-1-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-2-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-3-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-4-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-5-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-6-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-7-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-8-git-send-email-klaas.neirinck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issues.

Signed-off-by: Klaas Neirinck <klaas.neirinck@gmail.com>

diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
index 4fb095e..b20e26e 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
@@ -86,7 +86,7 @@ typedef int(*fxn_brd_monitor) (struct bridge_dev_context *dev_ctxt);
  *  Update the Board state to the specified state.
  */
 typedef int(*fxn_brd_setstate) (struct bridge_dev_context
-				       * dev_ctxt, u32 brd_state);
+				       *dev_ctxt, u32 brd_state);
 
 /*
  *  ======== bridge_brd_start ========
@@ -108,7 +108,7 @@ typedef int(*fxn_brd_setstate) (struct bridge_dev_context
  *      else:           Board state is indeterminate.
  */
 typedef int(*fxn_brd_start) (struct bridge_dev_context
-				    * dev_ctxt, u32 dsp_addr);
+				    *dev_ctxt, u32 dsp_addr);
 
 /*
  *  ======== bridge_brd_mem_copy ========
@@ -131,7 +131,7 @@ typedef int(*fxn_brd_start) (struct bridge_dev_context
  *      else:           Board state is indeterminate.
  */
 typedef int(*fxn_brd_memcopy) (struct bridge_dev_context
-				      * dev_ctxt,
+				      *dev_ctxt,
 				      u32 dsp_dest_addr,
 				      u32 dsp_src_addr,
 				      u32 ul_num_bytes, u32 mem_type);
@@ -156,7 +156,7 @@ typedef int(*fxn_brd_memcopy) (struct bridge_dev_context
  *  Ensures:
  */
 typedef int(*fxn_brd_memwrite) (struct bridge_dev_context
-				       * dev_ctxt,
+				       *dev_ctxt,
 				       u8 *host_buf,
 				       u32 dsp_addr, u32 ul_num_bytes,
 				       u32 mem_type);
@@ -179,7 +179,7 @@ typedef int(*fxn_brd_memwrite) (struct bridge_dev_context
  *  Ensures:
  */
 typedef int(*fxn_brd_memmap) (struct bridge_dev_context
-				     * dev_ctxt, u32 ul_mpu_addr,
+				     *dev_ctxt, u32 ul_mpu_addr,
 				     u32 virt_addr, u32 ul_num_bytes,
 				     u32 map_attr,
 				     struct page **mapped_pages);
@@ -200,7 +200,7 @@ typedef int(*fxn_brd_memmap) (struct bridge_dev_context
  *  Ensures:
  */
 typedef int(*fxn_brd_memunmap) (struct bridge_dev_context
-				       * dev_ctxt,
+				       *dev_ctxt,
 				       u32 virt_addr, u32 ul_num_bytes);
 
 /*
@@ -326,7 +326,7 @@ typedef int(*fxn_brd_write) (struct bridge_dev_context *dev_ctxt,
 typedef int(*fxn_chnl_create) (struct chnl_mgr
 				      **channel_mgr,
 				      struct dev_object
-				      * hdev_obj,
+				      *hdev_obj,
 				      const struct
 				      chnl_mgrattrs * mgr_attrts);
 
@@ -471,7 +471,7 @@ typedef int(*fxn_chnl_close) (struct chnl_object *chnl_obj);
  *          set to CHNL_IOCSTATEOS.
  */
 typedef int(*fxn_chnl_addioreq) (struct chnl_object
-					* chnl_obj,
+					*chnl_obj,
 					void *host_buf,
 					u32 byte_size,
 					u32 buf_size,
@@ -581,7 +581,7 @@ typedef int(*fxn_chnl_getinfo) (struct chnl_object *chnl_obj,
  *                          struct, if (mgr_info != NULL).
  */
 typedef int(*fxn_chnl_getmgrinfo) (struct chnl_mgr
-					  * hchnl_mgr,
+					  *hchnl_mgr,
 					  u32 ch_id,
 					  struct chnl_mgrinfo *mgr_info);
 
@@ -683,9 +683,9 @@ typedef int(*fxn_chnl_registernotify)
 typedef int(*fxn_dev_create) (struct bridge_dev_context
 				     **device_ctx,
 				     struct dev_object
-				     * hdev_obj,
+				     *hdev_obj,
 				     struct cfg_hostres
-				     * config_param);
+				     *config_param);
 
 /*
  *  ======== bridge_dev_ctrl ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h b/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
index c85d3da..21b2044 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
@@ -130,7 +130,7 @@ enum nldr_phase {
 typedef int(*nldr_allocatefxn) (struct nldr_object *nldr_obj,
 				       void *priv_ref,
 				       const struct dcd_nodeprops
-				       * node_props,
+				       *node_props,
 				       struct nldr_nodeobject
 				       **nldr_nodeobj,
 				       bool *pf_phase_split);
@@ -223,7 +223,7 @@ typedef void (*nldr_freefxn) (struct nldr_nodeobject *nldr_node_obj);
  *  Ensures:
  */
 typedef int(*nldr_getfxnaddrfxn) (struct nldr_nodeobject
-					 * nldr_node_obj,
+					 *nldr_node_obj,
 					 char *str_fxn, u32 * addr);
 
 /*
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index 0552ac1..760dfbc 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -1432,7 +1432,7 @@ func_end:
  */
 int proc_register_notify(void *hprocessor, u32 event_mask,
 				u32 notify_type, struct dsp_notification
-				* hnotification)
+				*hnotification)
 {
 	int status = 0;
 	struct proc_object *p_proc_object = (struct proc_object *)hprocessor;
diff --git a/drivers/staging/tidspbridge/rmgr/strm.c b/drivers/staging/tidspbridge/rmgr/strm.c
index 2e42714..f4a0531 100644
--- a/drivers/staging/tidspbridge/rmgr/strm.c
+++ b/drivers/staging/tidspbridge/rmgr/strm.c
@@ -697,7 +697,7 @@ func_end:
  */
 int strm_register_notify(struct strm_object *stream_obj, u32 event_mask,
 				u32 notify_type, struct dsp_notification
-				* hnotification)
+				*hnotification)
 {
 	struct bridge_drv_interface *intf_fxns;
 	int status = 0;
-- 
1.7.1

