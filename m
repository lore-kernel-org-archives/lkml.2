Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760410Ab2EPTF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:05:27 -0400
Received: from nm24.bullet.mail.bf1.yahoo.com ([98.139.212.183]:38125 "HELO
	nm24.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760169Ab2EPTF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:05:26 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2012 15:05:25 EDT
X-Yahoo-Newman-Id: 919662.66384.bm@smtp105.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: uhehhbwVM1nN4n0T3IzNHi0SQyJOAGQJQnhPiaM03ZISK4Z
 P5WlbNRJWcxyFqOYRw25nr6lI5AUrcms5.EmiRmwtW1yfvRDuryl2C01L29L
 0jVKweIRXmWDu1LNSON5q0sWx3ZE.ZQmOjEmD9XiZlo2xGXhxBv7Sb6Kig8s
 jfhl7py0Jga5EoM9l2qJS_P0TLpIbmGU3ixJOUJeU06NHNH5t6uYCRh.jQ2N
 uAHTkZyXOKPBW7WUzhTHuK8xSOXXh_BVzr3zGOYEvW2Dx.bZSRWeG.uxbyaX
 kceGQEaWMwDyfoXO.z.ydS60_FLodfTmKrWCAw62Yko0zSlzWCS5cHERngU9
 Oh9hkevRkUzXMqSpiH5y.7dItRCD6CVIw4o7U9F5SOmwSwGAaG3ZsRi9qocL
 5dzGETKc0Faku.3gYENf3b8LZjGEXRkdNqew_yv0sKL2OE6u7EqNrd6jXVer
 ODNiwJJDO3x5d4FpOeUDNG7XzkijBxe2wfS6BcEFF5prhAbzkh7QMVHk.975
 gqk8l
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: mdharm-usb@one-eyed-alien.net, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: [PATCH 1/3]USB: storage :fixed C99 comment issue.
Date: Thu, 17 May 2012 00:33:07 +0530
Message-Id: <1337194987-3730-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed C99 comment issue in drivers/usb/storage/usb.c
found using checkpatch.pl tool.

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 drivers/usb/storage/usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 2653e73..7ad1a8b 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -261,7 +261,7 @@ EXPORT_SYMBOL_GPL(usb_stor_post_reset);
 void fill_inquiry_response(struct us_data *us, unsigned char *data,
 		unsigned int data_len)
 {
-	if (data_len<36) // You lose.
+	if (data_len<36) /* You lose. */
 		return;
 
 	memset(data+8, ' ', 28);
-- 
1.7.10

