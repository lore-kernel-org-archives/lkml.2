Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab2A2M5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 07:57:40 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:35594
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752134Ab2A2M5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 07:57:38 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com,
        linux-media@vger.kernel.org
Subject: [PATCH] [trivial] media: Fix typo in mixer_drv.c and hdmi_drv.c
Date: Sun, 29 Jan 2012 21:50:53 +0900
Message-Id: <1327841453-1674-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct typo "sucessful" to "successful" in
drivers/media/video/s5p-tv/mixer_drv.c
drivers/media/video/s5p-tv/hdmi_drv.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/media/video/s5p-tv/hdmi_drv.c  |    4 ++--
 drivers/media/video/s5p-tv/mixer_drv.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
index 8b41a04..3e0dd09 100644
--- a/drivers/media/video/s5p-tv/hdmi_drv.c
+++ b/drivers/media/video/s5p-tv/hdmi_drv.c
@@ -962,7 +962,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 	/* storing subdev for call that have only access to struct device */
 	dev_set_drvdata(dev, sd);
 
-	dev_info(dev, "probe sucessful\n");
+	dev_info(dev, "probe successful\n");
 
 	return 0;
 
@@ -1000,7 +1000,7 @@ static int __devexit hdmi_remove(struct platform_device *pdev)
 	iounmap(hdmi_dev->regs);
 	hdmi_resources_cleanup(hdmi_dev);
 	kfree(hdmi_dev);
-	dev_info(dev, "remove sucessful\n");
+	dev_info(dev, "remove successful\n");
 
 	return 0;
 }
diff --git a/drivers/media/video/s5p-tv/mixer_drv.c b/drivers/media/video/s5p-tv/mixer_drv.c
index 0064309..a2c0c25 100644
--- a/drivers/media/video/s5p-tv/mixer_drv.c
+++ b/drivers/media/video/s5p-tv/mixer_drv.c
@@ -444,7 +444,7 @@ static int __devexit mxr_remove(struct platform_device *pdev)
 
 	kfree(mdev);
 
-	dev_info(dev, "remove sucessful\n");
+	dev_info(dev, "remove successful\n");
 	return 0;
 }
 
-- 
1.7.6.5

