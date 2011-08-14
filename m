Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab1HNBhc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 21:37:32 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33740 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1HNBhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 21:37:31 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH V2 3/4]drivers:staging Fix typo "shud"
Date: Sat, 13 Aug 2011 18:37:03 -0700
Message-Id: <1313285824-1892-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

This is a resend from the original, since I made a mistake with the original
patch. The below patch fixes a typo.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    2 +-
 .../staging/intel_sst/intel_sst_app_interface.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 32ee39a..b93e1b4 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1934,7 +1934,7 @@ ar6000_stop_endpoint(struct net_device *dev, bool keepprofile, bool getdbglogs)
             ar->arWmiEnabled = false;
             ar->arWmi = NULL;
             /* 
-             * After wmi_shudown all WMI events will be dropped.
+             * After wmi_shutdown all WMI events will be dropped.
              * We need to cleanup the buffers allocated in AP mode
              * and give disconnect notification to stack, which usually
              * happens in the disconnect_event. 
diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
index 93b41a2..e3efe63 100644
--- a/drivers/staging/intel_sst/intel_sst_app_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
@@ -1288,7 +1288,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 
 		pr_debug("SNDRV_SST_DRIVER_INFO received\n");
 		info.version = SST_VERSION_NUM;
-		/* hard coding, shud get sumhow later */
+		/* hard coding, should go somewhere later. */
 		info.active_pcm_streams = sst_drv_ctx->stream_cnt -
 						sst_drv_ctx->encoded_cnt;
 		info.active_enc_streams = sst_drv_ctx->encoded_cnt;
-- 
1.7.6

