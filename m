Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934339Ab1CZBos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:44:48 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47132 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934271Ab1CZBom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:44:42 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19/k/VFh9Z/76LcKrMYUhS/QrRaU0gsZsAVua13IM
	AEvwEKgPFShbuP
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 21/27] staging/tidspbridge: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:44:05 +0100
Message-Id: <1301103851-16352-21-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
References: <1301103851-16352-15-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some a very common spelling mistake in
drivers/staging/tidspbridge.

WRONG -> RIGHT
occured     -> occurred

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/tidspbridge/hw/hw_mmu.c            |    6 +++---
 .../staging/tidspbridge/include/dspbridge/clk.h    |    6 +++---
 .../staging/tidspbridge/include/dspbridge/cmm.h    |    2 +-
 .../staging/tidspbridge/include/dspbridge/cod.h    |    2 +-
 .../staging/tidspbridge/include/dspbridge/dev.h    |    2 +-
 .../tidspbridge/include/dspbridge/dspdefs.h        |   14 +++++++-------
 .../staging/tidspbridge/include/dspbridge/mgr.h    |    2 +-
 .../staging/tidspbridge/include/dspbridge/node.h   |    2 +-
 .../staging/tidspbridge/include/dspbridge/proc.h   |    6 +++---
 .../staging/tidspbridge/include/dspbridge/pwr.h    |    8 ++++----
 10 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/tidspbridge/hw/hw_mmu.c b/drivers/staging/tidspbridge/hw/hw_mmu.c
index 014f5d5..c214df9 100644
--- a/drivers/staging/tidspbridge/hw/hw_mmu.c
+++ b/drivers/staging/tidspbridge/hw/hw_mmu.c
@@ -59,7 +59,7 @@ enum hw_mmu_page_size_t {
  * RETURNS:
  *
  *       Type		: hw_status
- *       Description     : 0		 -- No errors occured
+ *       Description     : 0		 -- No errors occurred
  *			 RET_BAD_NULL_PARAM     -- A Pointer
  *						Paramater was set to NULL
  *
@@ -102,7 +102,7 @@ static hw_status mmu_flush_entry(const void __iomem *base_address);
  * RETURNS:
  *
  *       Type	    	: hw_status
- *       Description     : 0		 -- No errors occured
+ *       Description     : 0		 -- No errors occurred
  *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
  *						   was set to NULL
  *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter out
@@ -147,7 +147,7 @@ static hw_status mmu_set_cam_entry(const void __iomem *base_address,
  * RETURNS:
  *
  *       Type	    	: hw_status
- *       Description     : 0		 -- No errors occured
+ *       Description     : 0		 -- No errors occurred
  *			 RET_BAD_NULL_PARAM     -- A Pointer Paramater
  *							was set to NULL
  *			 RET_PARAM_OUT_OF_RANGE -- Input Parameter
diff --git a/drivers/staging/tidspbridge/include/dspbridge/clk.h b/drivers/staging/tidspbridge/include/dspbridge/clk.h
index b239503..685341c 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/clk.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/clk.h
@@ -55,7 +55,7 @@ extern void dsp_clk_exit(void);
  *      Initializes private state of CLK module.
  *  Parameters:
  *  Returns:
- *      TRUE if initialized; FALSE if error occured.
+ *      TRUE if initialized; FALSE if error occurred.
  *  Requires:
  *  Ensures:
  *      CLK initialized.
@@ -71,7 +71,7 @@ void dsp_gpt_wait_overflow(short int clk_id, unsigned int load);
  *  Parameters:
  *  Returns:
  *      0:	Success.
- *	-EPERM:	Error occured while enabling the clock.
+ *	-EPERM:	Error occurred while enabling the clock.
  *  Requires:
  *  Ensures:
  */
@@ -86,7 +86,7 @@ u32 dsp_clock_enable_all(u32 dsp_per_clocks);
  *  Parameters:
  *  Returns:
  *      0:        Success.
- *      -EPERM:      Error occured while disabling the clock.
+ *      -EPERM:      Error occurred while disabling the clock.
  *  Requires:
  *  Ensures:
  */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cmm.h b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
index 27a21b5..aff2205 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cmm.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cmm.h
@@ -190,7 +190,7 @@ extern int cmm_get_info(struct cmm_object *hcmm_mgr,
  *      Initializes private state of CMM module.
  *  Parameters:
  *  Returns:
- *      TRUE if initialized; FALSE if error occured.
+ *      TRUE if initialized; FALSE if error occurred.
  *  Requires:
  *  Ensures:
  *      CMM initialized.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cod.h b/drivers/staging/tidspbridge/include/dspbridge/cod.h
index 53bd4bb..cb684c1 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cod.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cod.h
@@ -249,7 +249,7 @@ extern int cod_get_sym_value(struct cod_manager *cod_mgr_obj,
  *  Parameters:
  *      None.
  *  Returns:
- *      TRUE if initialized; FALSE if error occured.
+ *      TRUE if initialized; FALSE if error occurred.
  *  Requires:
  *  Ensures:
  *      A requirement for each of the other public COD functions.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dev.h b/drivers/staging/tidspbridge/include/dspbridge/dev.h
index f41e478..f92b4be 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dev.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dev.h
@@ -497,7 +497,7 @@ extern void dev_exit(void);
  *      Initialize DEV's private state, keeping a reference count on each call.
  *  Parameters:
  *  Returns:
- *      TRUE if initialized; FALSE if error occured.
+ *      TRUE if initialized; FALSE if error occurred.
  *  Requires:
  *  Ensures:
  *      TRUE: A requirement for the other public DEV functions.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
index c2ba26c..ed32bf3 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
@@ -52,7 +52,7 @@ struct bridge_dev_context;
  *      dev_ctxt:    Handle to Bridge driver defined device context.
  *  Returns:
  *      0:        Success.
- *      -ETIMEDOUT:  Timeout occured waiting for a response from hardware.
+ *      -ETIMEDOUT:  Timeout occurred waiting for a response from hardware.
  *      -EPERM:      Other, unspecified error.
  *  Requires:
  *      dev_ctxt != NULL
@@ -91,7 +91,7 @@ typedef int(*fxn_brd_setstate) (struct bridge_dev_context
  *      dsp_addr:       DSP address at which to start execution.
  *  Returns:
  *      0:        Success.
- *      -ETIMEDOUT:  Timeout occured waiting for a response from hardware.
+ *      -ETIMEDOUT:  Timeout occurred waiting for a response from hardware.
  *      -EPERM:      Other, unspecified error.
  *  Requires:
  *      dev_ctxt != NULL
@@ -142,7 +142,7 @@ typedef int(*fxn_brd_memcopy) (struct bridge_dev_context
  *      mem_type:       Memory space on DSP to which to transfer.
  *  Returns:
  *      0:        Success.
- *      -ETIMEDOUT:  Timeout occured waiting for a response from hardware.
+ *      -ETIMEDOUT:  Timeout occurred waiting for a response from hardware.
  *      -EPERM:      Other, unspecified error.
  *  Requires:
  *      dev_ctxt != NULL;
@@ -205,7 +205,7 @@ typedef int(*fxn_brd_memunmap) (struct bridge_dev_context
  *      dev_ctxt:    Handle to Bridge driver defined device context.
  *  Returns:
  *      0:        Success.
- *      -ETIMEDOUT:  Timeout occured waiting for a response from hardware.
+ *      -ETIMEDOUT:  Timeout occurred waiting for a response from hardware.
  *      -EPERM:      Other, unspecified error.
  *  Requires:
  *      dev_ctxt != NULL
@@ -248,7 +248,7 @@ typedef int(*fxn_brd_status) (struct bridge_dev_context *dev_ctxt,
  *      mem_type:       Memory space on DSP from which to transfer.
  *  Returns:
  *      0:        Success.
- *      -ETIMEDOUT:  Timeout occured waiting for a response from hardware.
+ *      -ETIMEDOUT:  Timeout occurred waiting for a response from hardware.
  *      -EPERM:      Other, unspecified error.
  *  Requires:
  *      dev_ctxt != NULL;
@@ -274,7 +274,7 @@ typedef int(*fxn_brd_read) (struct bridge_dev_context *dev_ctxt,
  *      mem_type:       Memory space on DSP to which to transfer.
  *  Returns:
  *      0:        Success.
- *      -ETIMEDOUT:  Timeout occured waiting for a response from hardware.
+ *      -ETIMEDOUT:  Timeout occurred waiting for a response from hardware.
  *      -EPERM:      Other, unspecified error.
  *  Requires:
  *      dev_ctxt != NULL;
@@ -601,7 +601,7 @@ typedef int(*fxn_chnl_getmgrinfo) (struct chnl_mgr
  *  Returns:
  *      0:            Success;
  *      -EFAULT:        Invalid chnl_obj.
- *      -ETIMEDOUT: Timeout occured before channel could be idled.
+ *      -ETIMEDOUT: Timeout occurred before channel could be idled.
  *  Requires:
  *  Ensures:
  */
diff --git a/drivers/staging/tidspbridge/include/dspbridge/mgr.h b/drivers/staging/tidspbridge/include/dspbridge/mgr.h
index e506c4d..6d5b009 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/mgr.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/mgr.h
@@ -195,7 +195,7 @@ extern int mgr_get_dcd_handle(struct mgr_object
  *      call. Initializes the DCD.
  *  Parameters:
  *  Returns:
- *      TRUE if initialized; FALSE if error occured.
+ *      TRUE if initialized; FALSE if error occurred.
  *  Requires:
  *  Ensures:
  *      TRUE: A requirement for the other public MGR functions.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/node.h b/drivers/staging/tidspbridge/include/dspbridge/node.h
index 53da0ef..16371d8 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/node.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/node.h
@@ -44,7 +44,7 @@
  *      -ESPIPE:        iAlg functions not found for a DAIS node.
  *      -EDOM:         attr_in != NULL and attr_in->prio out of
  *                          range.
- *      -EPERM:          A failure occured, unable to allocate node.
+ *      -EPERM:          A failure occurred, unable to allocate node.
  *      -EBADR:    Proccessor is not in the running state.
  *  Requires:
  *      node_init(void) called.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/proc.h b/drivers/staging/tidspbridge/include/dspbridge/proc.h
index 5e09fd1..f00dffd 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/proc.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/proc.h
@@ -89,7 +89,7 @@ extern int proc_auto_start(struct cfg_devnode *dev_node_obj,
  *  Returns:
  *      0     :       SUCCESS
  *      -EFAULT :       Invalid processor handle.
- *      -ETIME:       A Timeout Occured before the Control information
+ *      -ETIME:       A Timeout Occurred before the Control information
  *			  could be sent.
  *      -EPERM   :       General Failure.
  *  Requires:
@@ -169,7 +169,7 @@ extern int proc_enum_nodes(void *hprocessor,
  *      0     :       Success.
  *      -EFAULT :       Invalid processor handle.
  *      -EBADR:    The processor is not in the PROC_RUNNING state.
- *      -ETIME:       A timeout occured before the DSP responded to the
+ *      -ETIME:       A timeout occurred before the DSP responded to the
  *			  querry.
  *      -EPERM   :       Unable to get Resource Information
  *  Requires:
@@ -229,7 +229,7 @@ extern int proc_get_dev_object(void *hprocessor,
  *      call.
  *  Parameters:
  *  Returns:
- *      TRUE if initialized; FALSE if error occured.
+ *      TRUE if initialized; FALSE if error occurred.
  *  Requires:
  *  Ensures:
  *      TRUE: A requirement for the other public PROC functions.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/pwr.h b/drivers/staging/tidspbridge/include/dspbridge/pwr.h
index 5e3ab21..0fb0664 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/pwr.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/pwr.h
@@ -46,7 +46,7 @@
  *      0:            Success.
  *      0: Success, but the DSP was already asleep.
  *      -EINVAL:    The specified sleep_code is not supported.
- *      -ETIME:       A timeout occured while waiting for DSP sleep
+ *      -ETIME:       A timeout occurred while waiting for DSP sleep
  *                          confirmation.
  *      -EPERM:          General failure, unable to send sleep command to
  *                          the DSP.
@@ -67,7 +67,7 @@ extern int pwr_sleep_dsp(const u32 sleep_code, const u32 timeout);
  *  Returns:
  *      0:            Success.
  *      0:  Success, but the DSP was already awake.
- *      -ETIME:       A timeout occured while waiting for wake
+ *      -ETIME:       A timeout occurred while waiting for wake
  *                          confirmation.
  *      -EPERM:          General failure, unable to send wake command to
  *                          the DSP.
@@ -85,7 +85,7 @@ extern int pwr_wake_dsp(const u32 timeout);
  *  Returns:
  *      0:            Success.
  *      0:  Success, but the DSP was already awake.
- *      -ETIME:       A timeout occured while waiting for wake
+ *      -ETIME:       A timeout occurred while waiting for wake
  *                          confirmation.
  *      -EPERM:          General failure, unable to send wake command to
  *                          the DSP.
@@ -103,7 +103,7 @@ extern int pwr_pm_pre_scale(u16 voltage_domain, u32 level);
  *  Returns:
  *      0:            Success.
  *      0:  Success, but the DSP was already awake.
- *      -ETIME:       A timeout occured while waiting for wake
+ *      -ETIME:       A timeout occurred while waiting for wake
  *                          confirmation.
  *      -EPERM:          General failure, unable to send wake command to
  *                          the DSP.
-- 
1.7.3.4

