Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab1CXUVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:21:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62425 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183Ab1CXUVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:21:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C1VTxlccj/tFQCkN7l0o1mJFNfxlawtXcKteR5SzDFnvTKR4EKpjnXa72bzDZMJ9/W
         3pUlhtTIYGNmTU7384+WQIdho1phgsn3voDSyjj6eg3sKy57FtuV7knUcgi9+JPHqpLW
         pqcVzbfPYjHdEkVmvDcWobDTCwSK+yn9VPSCk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2 14/21]drivers:staging Remove extra semi-colon.
Date: Thu, 24 Mar 2011 13:18:33 -0700
Message-Id: <1300997920-31573-14-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
References: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra semi-colon from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/gma500/psb_buffer.c     |    4 ++--
 drivers/staging/gma500/psb_fb.c         |    2 +-
 drivers/staging/iio/addac/adt7316-i2c.c |    2 +-
 drivers/staging/iio/dds/ad9832.c        |    2 +-
 drivers/staging/iio/dds/ad9834.c        |    2 +-
 drivers/staging/rt2860/rtmp.h           |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gma500/psb_buffer.c b/drivers/staging/gma500/psb_buffer.c
index 3077f6a..4f60850 100644
--- a/drivers/staging/gma500/psb_buffer.c
+++ b/drivers/staging/gma500/psb_buffer.c
@@ -384,12 +384,12 @@ static int psb_ttm_io_mem_reserve(struct ttm_bo_device *bdev,
 		break;
 	case TTM_PL_CI:
 		mem->bus.offset = mm_node->start << PAGE_SHIFT;
-		mem->bus.base = dev_priv->ci_region_start;;
+		mem->bus.base = dev_priv->ci_region_start;
 		mem->bus.is_iomem = true;
 		break;
 	case TTM_PL_RAR:
 		mem->bus.offset = mm_node->start << PAGE_SHIFT;
-		mem->bus.base = dev_priv->rar_region_start;;
+		mem->bus.base = dev_priv->rar_region_start;
 		mem->bus.is_iomem = true;
 		break;
 	default:
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index f67f53b..6c2b06e 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -194,7 +194,7 @@ static int psbfb_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct drm_device *dev = psbfb->base.dev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct psb_gtt *pg = dev_priv->pg;
-	unsigned long phys_addr = (unsigned long)pg->stolen_base;;
+	unsigned long phys_addr = (unsigned long)pg->stolen_base;
 
 	page_num = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 
diff --git a/drivers/staging/iio/addac/adt7316-i2c.c b/drivers/staging/iio/addac/adt7316-i2c.c
index 52d1ea3..1c86cf1 100644
--- a/drivers/staging/iio/addac/adt7316-i2c.c
+++ b/drivers/staging/iio/addac/adt7316-i2c.c
@@ -109,7 +109,7 @@ static int __devinit adt7316_i2c_probe(struct i2c_client *client,
 
 static int __devexit adt7316_i2c_remove(struct i2c_client *client)
 {
-	return adt7316_remove(&client->dev);;
+	return adt7316_remove(&client->dev);
 }
 
 static const struct i2c_device_id adt7316_i2c_id[] = {
diff --git a/drivers/staging/iio/dds/ad9832.c b/drivers/staging/iio/dds/ad9832.c
index 3e8491f..554441d 100644
--- a/drivers/staging/iio/dds/ad9832.c
+++ b/drivers/staging/iio/dds/ad9832.c
@@ -52,7 +52,7 @@ static int ad9832_write_frequency(struct ad9832_state *st,
 					((addr - 3) << ADD_SHIFT) |
 					((regval >> 0) & 0xFF));
 
-	return spi_sync(st->spi, &st->freq_msg);;
+	return spi_sync(st->spi, &st->freq_msg);
 }
 
 static int ad9832_write_phase(struct ad9832_state *st,
diff --git a/drivers/staging/iio/dds/ad9834.c b/drivers/staging/iio/dds/ad9834.c
index eb1a681..5086f9d 100644
--- a/drivers/staging/iio/dds/ad9834.c
+++ b/drivers/staging/iio/dds/ad9834.c
@@ -47,7 +47,7 @@ static int ad9834_write_frequency(struct ad9834_state *st,
 				       (AD9834_FREQ_BITS / 2)) &
 				       RES_MASK(AD9834_FREQ_BITS / 2)));
 
-	return spi_sync(st->spi, &st->freq_msg);;
+	return spi_sync(st->spi, &st->freq_msg);
 }
 
 static int ad9834_write_phase(struct ad9834_state *st,
diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index d16b06a..afdf0bf 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -1683,7 +1683,7 @@ struct rt_rtmp_chip_op {
 	/* MCU related callback functions */
 	int (*loadFirmware) (struct rt_rtmp_adapter *pAd);	/* int (*loadFirmware)(struct rt_rtmp_adapter *pAd); */
 	int (*eraseFirmware) (struct rt_rtmp_adapter *pAd);	/* int (*eraseFirmware)(struct rt_rtmp_adapter *pAd); */
-	int (*sendCommandToMcu) (struct rt_rtmp_adapter *pAd, u8 cmd, u8 token, u8 arg0, u8 arg1);;	/* int (*sendCommandToMcu)(struct rt_rtmp_adapter *pAd, u8 cmd, u8 token, u8 arg0, u8 arg1); */
+	int (*sendCommandToMcu) (struct rt_rtmp_adapter *pAd, u8 cmd, u8 token, u8 arg0, u8 arg1);	/* int (*sendCommandToMcu)(struct rt_rtmp_adapter *pAd, u8 cmd, u8 token, u8 arg0, u8 arg1); */
 
 	/* RF access related callback functions */
 	struct rt_reg_pair *pRFRegTable;
-- 
1.7.4.1

