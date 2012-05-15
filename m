Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966572Ab2EOT3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:29:06 -0400
Received: from nm20.bullet.mail.sp2.yahoo.com ([98.139.91.90]:34083 "HELO
	nm20.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966525Ab2EOT3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:29:04 -0400
X-Yahoo-Newman-Id: 267412.10870.bm@smtp216.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KSCiXGQVM1kpWycndoJax52S96vgw6VXKHzSLox8vO8v4au
 lbKs7v0Ys.Dn5r9f8pGxD8VGVida2SQOdS4DNyfhvZgg3vUBRB4daCLWIG2H
 xhvJ2x6RVkyc4e6zcBLJXEhEJ8a8tAxy8ao2tndXtqAn67OEC3ZSoaKVEu0d
 54GuQZlJHZNYjePEdeRf9DzVCggxqMtLw.fRUW9j5ttLhEkyQ_W1cwKEeL2F
 dyFKd5TvqZeUhUYu_4Y0OJZhsVKgtRd.THuVHLGxlOVWyhxzHu58MccR8is2
 tzi5HBv4ga5Wd2ag7JEmFpvmCX2cNTN47qu0_zn.VvjaKhP0NJVvU3eUwvp.
 rIwYNfO8gaZaeVuiyIB86nL6R1BS2i0vjYi4L.UvzAP7VDjghnuKW1aKocIQ
 Jd9fidbntEOyYT9lc3clc87GD4uBw3IBF5NRdf3rkwAa0TYcqqdyWEcgyn1V
 L88zkXhN8ENkZRrJVZuzvfqAc4cc1qj4Pe1btx2BJN1kYuGvBivKFonFAhA-
 -
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: mdharm-usb@one-eyed-alien.net, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: [PATCH 1/3] drivers:Fixed C99 comment issue.
Date: Wed, 16 May 2012 01:02:15 +0530
Message-Id: <1337110335-9783-1-git-send-email-ahiliation@yahoo.co.in>
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

