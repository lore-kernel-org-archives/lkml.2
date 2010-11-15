Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab0KODFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:05:34 -0500
Received: from mail.perches.com ([173.55.12.10]:1148 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627Ab0KODFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:33 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/44] drivers/media/video: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:28 -0800
Message-Id: <d7cec5e05200050ee2c7f624eef8c571193b4d92.1289789604.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/cx88/cx88-blackbird.c  |    2 +-
 drivers/media/video/davinci/vpfe_capture.c |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index 417d1d5..14b2546 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -1065,7 +1065,7 @@ static int mpeg_open(struct file *file)
 		err = drv->request_acquire(drv);
 		if(err != 0) {
 			dprintk(1,"%s: Unable to acquire hardware, %d\n", __func__, err);
-			mutex_unlock(&dev->core->lock);;
+			mutex_unlock(&dev->core->lock);
 			return err;
 		}
 	}
diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index d8e38cc..14f3d54 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -1276,7 +1276,7 @@ static int vpfe_videobuf_prepare(struct videobuf_queue *vq,
 		vb->size = vpfe_dev->fmt.fmt.pix.sizeimage;
 		vb->field = field;
 
-		ret = videobuf_iolock(vq, vb, NULL);;
+		ret = videobuf_iolock(vq, vb, NULL);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 5485923..7aee7f0 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2408,7 +2408,7 @@ void em28xx_register_i2c_ir(struct em28xx *dev)
 		dev->init_data.get_key = em28xx_get_key_em_haup;
 		dev->init_data.name = "i2c IR (EM2840 Hauppauge)";
 	case EM2820_BOARD_LEADTEK_WINFAST_USBII_DELUXE:
-		dev->init_data.ir_codes = RC_MAP_WINFAST_USBII_DELUXE;;
+		dev->init_data.ir_codes = RC_MAP_WINFAST_USBII_DELUXE;
 		dev->init_data.get_key = em28xx_get_key_winfast_usbii_deluxe;
 		dev->init_data.name = "i2c IR (EM2820 Winfast TV USBII Deluxe)";
 		break;
-- 
1.7.3.1.g432b3.dirty

