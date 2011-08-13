Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1HMA1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:27:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65438 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1HMA0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:26:41 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/4]drivers:staging Fix typo "shud"
Date: Fri, 12 Aug 2011 17:26:13 -0700
Message-Id: <1313195174-4464-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313195174-4464-1-git-send-email-justinmattock@gmail.com>
References: <1313195174-4464-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below fixes a typo shud.

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
+             * After wmi_shutown all WMI events will be dropped.
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

