Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab1IPGTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 02:19:00 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:64847 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab1IPGS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 02:18:58 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Joe Perches <joe@perches.com>,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH 36/44] Staging: cx25821: Change indent with spaces to tabs 32
Date: Fri, 16 Sep 2011 14:15:09 +0800
Message-Id: <1316153717-7272-37-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change indent with spaces to tabs.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-video.c |  113 +++++++++++++++----------------
 1 files changed, 56 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index 2383feb..aa57b40 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -1867,69 +1867,68 @@ static long video_ioctl_set(struct file *file, unsigned int cmd,
 			cx25821_set_pixel_format(dev, selected_channel,
 						pix_format);
 
-	       break;
-
-       case ENABLE_CIF_RESOLUTION:
-	       selected_channel = data_from_user->decoder_select;
-	       cif_enable = data_from_user->cif_resolution_enable;
-	       cif_width = data_from_user->cif_width;
-
-	       if (cif_enable) {
-		       if (dev->tvnorm & V4L2_STD_PAL_BG
-			   || dev->tvnorm & V4L2_STD_PAL_DK)
-			       width = 352;
-		       else
-			       width = (cif_width == 320
-					|| cif_width == 352) ? cif_width : 320;
-	       }
-
-	       if (!(selected_channel <= 7 && selected_channel >= 0)) {
-		       selected_channel -= 4;
-		       selected_channel = selected_channel % 8;
-	       }
-
-	       if (selected_channel <= 7 && selected_channel >= 0) {
-		       dev->channels[selected_channel].
-			       use_cif_resolution = cif_enable;
-		       dev->channels[selected_channel].cif_width = width;
-	       } else {
-		       for (i = 0; i < VID_CHANNEL_NUM; i++) {
-			       dev->channels[i].use_cif_resolution =
-				       cif_enable;
-			       dev->channels[i].cif_width = width;
-		       }
-	       }
-
-	       medusa_set_resolution(dev, width, selected_channel);
-	       break;
-       case REG_READ:
-	       data_from_user->reg_data = cx_read(data_from_user->reg_address);
-	       break;
-       case REG_WRITE:
-	       cx_write(data_from_user->reg_address, data_from_user->reg_data);
-	       break;
-       case MEDUSA_READ:
-	       value =
-		   cx25821_i2c_read(&dev->i2c_bus[0],
-				    (u16) data_from_user->reg_address,
-				    &data_from_user->reg_data);
-	       break;
-       case MEDUSA_WRITE:
-	       cx25821_i2c_write(&dev->i2c_bus[0],
-				 (u16) data_from_user->reg_address,
-				 data_from_user->reg_data);
-	       break;
-       }
+		break;
+
+	case ENABLE_CIF_RESOLUTION:
+		selected_channel = data_from_user->decoder_select;
+		cif_enable = data_from_user->cif_resolution_enable;
+		cif_width = data_from_user->cif_width;
+
+		if (cif_enable) {
+			if (dev->tvnorm & V4L2_STD_PAL_BG
+			    || dev->tvnorm & V4L2_STD_PAL_DK)
+				width = 352;
+			else
+				width = (cif_width == 320 || cif_width == 352) ?
+							cif_width : 320;
+		}
+
+		if (!(selected_channel <= 7 && selected_channel >= 0)) {
+			selected_channel -= 4;
+			selected_channel = selected_channel % 8;
+		}
+
+		if (selected_channel <= 7 && selected_channel >= 0) {
+			dev->channels[selected_channel].
+				use_cif_resolution = cif_enable;
+			dev->channels[selected_channel].cif_width = width;
+		} else {
+			for (i = 0; i < VID_CHANNEL_NUM; i++) {
+				dev->channels[i].use_cif_resolution =
+					cif_enable;
+				dev->channels[i].cif_width = width;
+			}
+		}
 
-       return 0;
+		medusa_set_resolution(dev, width, selected_channel);
+		break;
+	case REG_READ:
+		data_from_user->reg_data = cx_read(data_from_user->reg_address);
+		break;
+	case REG_WRITE:
+		cx_write(data_from_user->reg_address, data_from_user->reg_data);
+		break;
+	case MEDUSA_READ:
+		value = cx25821_i2c_read(&dev->i2c_bus[0],
+					 (u16) data_from_user->reg_address,
+					 &data_from_user->reg_data);
+		break;
+	case MEDUSA_WRITE:
+		cx25821_i2c_write(&dev->i2c_bus[0],
+				  (u16) data_from_user->reg_address,
+				  data_from_user->reg_data);
+		break;
+	}
+
+	return 0;
 }
 
 static long cx25821_video_ioctl(struct file *file,
-			       unsigned int cmd, unsigned long arg)
+				unsigned int cmd, unsigned long arg)
 {
-       int  ret = 0;
+	int  ret = 0;
 
-       struct cx25821_fh  *fh  = file->private_data;
+	struct cx25821_fh  *fh  = file->private_data;
 
        /* check to see if it's the video upstream */
        if (fh->channel_id == SRAM_CH09) {
-- 
1.7.0.4

