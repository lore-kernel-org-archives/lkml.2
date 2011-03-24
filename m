Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab1CXXs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:48:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63351 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309Ab1CXXsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ukl2fSa2wCJ0b8EMgiqEby67dFFwSBl8pAxKdpZqfgouItyvWW+HNFZOpOrLVFUDhB
         brbySL7g3wqT3ugTWam5r21PTLIiUoXqGUrmZjcfWswbGIsLwQP9slXAfJtA92Kwg4Yt
         tmw6qNFN8kNKooXQ0mfpPMoEvWGTFA5UmwyNs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH V3 14/21]drivers:staging Remove extra semi-colon.
Date: Thu, 24 Mar 2011 16:48:39 -0700
Message-Id: <1301010519-3392-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra semi-colon from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/iio/addac/adt7316-i2c.c |    2 +-
 drivers/staging/iio/dds/ad9832.c        |    2 +-
 drivers/staging/iio/dds/ad9834.c        |    2 +-
 drivers/staging/rt2860/rtmp.h           |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

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

