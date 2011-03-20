Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab1CTVvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 17:51:33 -0400
Received: from ist.d-labs.de ([213.239.218.44]:51921 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab1CTVvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 17:51:32 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, crope@iki.fi,
        tvboxspy@gmail.com, Florian Mickler <florian@mickler.org>
Subject: [PATCH 4/5] [media] lmedm04: correct indentation
Date: Sun, 20 Mar 2011 22:50:51 +0100
Message-Id: <1300657852-29318-5-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300657852-29318-1-git-send-email-florian@mickler.org>
References: <1300657852-29318-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should not change anything except whitespace.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/media/dvb/dvb-usb/lmedm04.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index 9eea418..0a3e88f 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -626,15 +626,15 @@ static int lme2510_download_firmware(struct usb_device *dev,
 				data[0] = i | 0x80;
 				dlen = (u8)(end - j)-1;
 			}
-		data[1] = dlen;
-		memcpy(&data[2], fw_data, dlen+1);
-		wlen = (u8) dlen + 4;
-		data[wlen-1] = check_sum(fw_data, dlen+1);
-		deb_info(1, "Data S=%02x:E=%02x CS= %02x", data[3],
+			data[1] = dlen;
+			memcpy(&data[2], fw_data, dlen+1);
+			wlen = (u8) dlen + 4;
+			data[wlen-1] = check_sum(fw_data, dlen+1);
+			deb_info(1, "Data S=%02x:E=%02x CS= %02x", data[3],
 				data[dlen+2], data[dlen+3]);
-		ret |= lme2510_bulk_write(dev, data,  wlen, 1);
-		ret |= lme2510_bulk_read(dev, data, len_in , 1);
-		ret |= (data[0] == 0x88) ? 0 : -1;
+			ret |= lme2510_bulk_write(dev, data,  wlen, 1);
+			ret |= lme2510_bulk_read(dev, data, len_in , 1);
+			ret |= (data[0] == 0x88) ? 0 : -1;
 		}
 	}
 
-- 
1.7.4.1

