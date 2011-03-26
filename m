Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab1CZBkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:40:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33404 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932402Ab1CZBkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:40:15 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19cNLcowAVc7GXde60G5fqkzXWdkb4vvlamgPiT0W
	OTHBHIXpGdm1RN
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 11/27] staging/intel_sst: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:39:20 +0100
Message-Id: <1301103576-16109-11-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301103576-16109-8-git-send-email-peterhuewe@gmx.de>
References: <1301103576-16109-8-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some very common spelling mistakes in
drivers/staging/intel_sst.

WRONG -> RIGHT
occured     -> occurred
libary		-> library
recieve     -> receive

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 .../staging/intel_sst/intel_sst_app_interface.c    |   14 +++++++-------
 drivers/staging/intel_sst/intel_sst_dsp.c          |    2 +-
 drivers/staging/intel_sst/intel_sst_fw_ipc.h       |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
index a367991..7a6ecb7 100644
--- a/drivers/staging/intel_sst/intel_sst_app_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
@@ -871,7 +871,7 @@ int sst_send_algo_ipc(struct ipc_post **msg)
 }
 
 /**
- * intel_sst_ioctl_dsp - recieves the device ioctl's
+ * intel_sst_ioctl_dsp - receives the device ioctl's
  *
  * @cmd:Ioctl cmd
  * @arg:data
@@ -1067,7 +1067,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 			retval = -EFAULT;
 			break;
 		}
-		pr_debug("SET_VOLUME recieved for %d!\n",
+		pr_debug("SET_VOLUME received for %d!\n",
 				set_vol.stream_id);
 		if (minor == STREAM_MODULE && set_vol.stream_id == 0) {
 			pr_debug("invalid operation!\n");
@@ -1085,7 +1085,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 			retval = -EFAULT;
 			break;
 		}
-		pr_debug("IOCTL_GET_VOLUME recieved for stream = %d!\n",
+		pr_debug("IOCTL_GET_VOLUME received for stream = %d!\n",
 				get_vol.stream_id);
 		if (minor == STREAM_MODULE && get_vol.stream_id == 0) {
 			pr_debug("invalid operation!\n");
@@ -1117,7 +1117,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 			retval = -EFAULT;
 			break;
 		}
-		pr_debug("SNDRV_SST_SET_VOLUME recieved for %d!\n",
+		pr_debug("SNDRV_SST_SET_VOLUME received for %d!\n",
 			set_mute.stream_id);
 		if (minor == STREAM_MODULE && set_mute.stream_id == 0) {
 			retval = -EPERM;
@@ -1153,7 +1153,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_MMAP_CAPTURE): {
 		struct snd_sst_mmap_buffs mmap_buf;
 
-		pr_debug("SNDRV_SST_MMAP_PLAY/CAPTURE recieved!\n");
+		pr_debug("SNDRV_SST_MMAP_PLAY/CAPTURE received!\n");
 		if (minor != STREAM_MODULE) {
 			retval = -EBADRQC;
 			break;
@@ -1239,7 +1239,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_SET_TARGET_DEVICE): {
 		struct snd_sst_target_device target_device;
 
-		pr_debug("SET_TARGET_DEVICE recieved!\n");
+		pr_debug("SET_TARGET_DEVICE received!\n");
 		if (copy_from_user(&target_device, (void __user *)arg,
 				sizeof(target_device))) {
 			retval = -EFAULT;
@@ -1256,7 +1256,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_DRIVER_INFO): {
 		struct snd_sst_driver_info info;
 
-		pr_debug("SNDRV_SST_DRIVER_INFO recived\n");
+		pr_debug("SNDRV_SST_DRIVER_INFO received\n");
 		info.version = SST_VERSION_NUM;
 		/* hard coding, shud get sumhow later */
 		info.active_pcm_streams = sst_drv_ctx->stream_cnt -
diff --git a/drivers/staging/intel_sst/intel_sst_dsp.c b/drivers/staging/intel_sst/intel_sst_dsp.c
index 6e5c915..1b56e8b 100644
--- a/drivers/staging/intel_sst/intel_sst_dsp.c
+++ b/drivers/staging/intel_sst/intel_sst_dsp.c
@@ -405,7 +405,7 @@ exit:
 
 }
 
-/* This function is called when FW requests for a particular libary download
+/* This function is called when FW requests for a particular library download
 This function prepares the library to download*/
 int sst_load_library(struct snd_sst_lib_download *lib, u8 ops)
 {
diff --git a/drivers/staging/intel_sst/intel_sst_fw_ipc.h b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
index 8df313d..0f0c5bb 100644
--- a/drivers/staging/intel_sst/intel_sst_fw_ipc.h
+++ b/drivers/staging/intel_sst/intel_sst_fw_ipc.h
@@ -111,7 +111,7 @@
 #define IPC_SST_PERIOD_ELAPSED 0x97 /* period elapsed */
 #define IPC_IA_TARGET_DEV_CHNGD 0x98 /* error in processing a stream */
 
-#define IPC_SST_ERROR_EVENT 0x99 /* Buffer over run occured */
+#define IPC_SST_ERROR_EVENT 0x99 /* Buffer over run occurred */
 /* L2S messages */
 #define IPC_SC_DDR_LINK_UP 0xC0
 #define IPC_SC_DDR_LINK_DOWN 0xC1
-- 
1.7.3.4

