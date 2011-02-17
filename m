Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab1BQC7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 21:59:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50227 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1BQC7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:59:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=waF6rUYUL+78/qjmADFfmyjWBvAb4bAEOxEfjbw1dVOcuSg4z+G5KCyHYk93undT7T
         jvjE+wW/cENQWAu7E7+/T8fh7JgfoNZgNogKIWcsxYV7xi2mhd4Kq/rVmPauQhdRAI+R
         BpWhV4QUqJjbqMZUgqgR1+4IhdJbg6GE4T5Ws=
From: Klaas Neirinck <klaas.neirinck@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Klaas Neirinck <klaas.neirinck@gmail.com>
Subject: [PATCH 03/10] Staging: tidspbridge: fixed unnecessary whitespaces before quoted newlines
Date: Thu, 17 Feb 2011 03:58:47 +0100
Message-Id: <1297911534-31534-3-git-send-email-klaas.neirinck@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297911534-31534-2-git-send-email-klaas.neirinck@gmail.com>
References: <1297911534-31534-1-git-send-email-klaas.neirinck@gmail.com>
 <1297911534-31534-2-git-send-email-klaas.neirinck@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Klaas Neirinck <klaas.neirinck@gmail.com>

diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 69ecd73..0e21b72 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -456,7 +456,7 @@ int bridge_io_on_loaded(struct io_mgr *hio_mgr)
 
 		dev_dbg(bridge, "%s: ul_gpp_pa %x, ul_gpp_va %x, ul_dsp_va %x, "
 			"shm0_end %x, ul_dyn_ext_base %x, ul_ext_end %x, "
-			"ul_seg_size %x ul_seg1_size %x \n", __func__,
+			"ul_seg_size %x ul_seg1_size %x\n", __func__,
 			ul_gpp_pa, ul_gpp_va, ul_dsp_va, shm0_end,
 			ul_dyn_ext_base, ul_ext_end, ul_seg_size, ul_seg1_size);
 
@@ -1240,7 +1240,7 @@ static void input_msg(struct io_mgr *pio_mgr, struct msg_mgr *hmsg_mgr)
 		msg_queue_obj =
 		    (struct msg_queue *)lst_first(hmsg_mgr->queue_list);
 		dev_dbg(bridge,	"input msg: dw_cmd=0x%x dw_arg1=0x%x "
-			"dw_arg2=0x%x msgq_id=0x%x \n", msg.msg.dw_cmd,
+			"dw_arg2=0x%x msgq_id=0x%x\n", msg.msg.dw_cmd,
 			msg.msg.dw_arg1, msg.msg.dw_arg2, msg.msgq_id);
 		/*
 		 * Interrupt may occur before shared memory and message
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index a3f69f6..eef149b 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -547,7 +547,7 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 		if ((unsigned int *)ul_dsp_clk_addr != NULL) {
 			/* Get the clock rate */
 			ul_dsp_clk_rate = dsp_clk_get_iva2_rate();
-			dev_dbg(bridge, "%s: DSP clock rate (KHZ): 0x%x \n",
+			dev_dbg(bridge, "%s: DSP clock rate (KHZ): 0x%x\n",
 				__func__, ul_dsp_clk_rate);
 			(void)bridge_brd_write(dev_context,
 					       (u8 *) &ul_dsp_clk_rate,
diff --git a/drivers/staging/tidspbridge/pmgr/dmm.c b/drivers/staging/tidspbridge/pmgr/dmm.c
index 8685233..b89864d 100644
--- a/drivers/staging/tidspbridge/pmgr/dmm.c
+++ b/drivers/staging/tidspbridge/pmgr/dmm.c
@@ -523,9 +523,9 @@ u32 dmm_mem_map_dump(struct dmm_object *dmm_mgr)
 	spin_unlock(&dmm_mgr->dmm_lock);
 	printk(KERN_INFO "Total DSP VA FREE memory = %d Mbytes\n",
 	       freemem / (1024 * 1024));
-	printk(KERN_INFO "Total DSP VA USED memory= %d Mbytes \n",
+	printk(KERN_INFO "Total DSP VA USED memory= %d Mbytes\n",
 	       (((table_size * PG_SIZE4K) - freemem)) / (1024 * 1024));
-	printk(KERN_INFO "DSP VA - Biggest FREE block = %d Mbytes \n\n",
+	printk(KERN_INFO "DSP VA - Biggest FREE block = %d Mbytes\n\n",
 	       (bigsize * PG_SIZE4K / (1024 * 1024)));
 
 	return 0;
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 1562f3c..ff8a074 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -418,7 +418,7 @@ int node_allocate(struct proc_object *hprocessor,
 
 	/* check for page aligned Heap size */
 	if (((attr_in->heap_size) & (PG_SIZE4K - 1))) {
-		pr_err("%s: node heap size not aligned to 4K, size = 0x%x \n",
+		pr_err("%s: node heap size not aligned to 4K, size = 0x%x\n",
 		       __func__, attr_in->heap_size);
 		status = -EINVAL;
 	} else {
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index b47d7aa..0552ac1 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -1652,7 +1652,7 @@ int proc_stop(void *hprocessor)
 		status = node_enum_nodes(hnode_mgr, &hnode, node_tab_size,
 					 &num_nodes, &nodes_allocated);
 		if ((status == -EINVAL) || (nodes_allocated > 0)) {
-			pr_err("%s: Can't stop device, active nodes = %d \n",
+			pr_err("%s: Can't stop device, active nodes = %d\n",
 			       __func__, nodes_allocated);
 			return -EBADR;
 		}
-- 
1.7.1

