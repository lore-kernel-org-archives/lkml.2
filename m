Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966595Ab2EOTea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:34:30 -0400
Received: from nm10-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.198]:46833 "HELO
	nm10-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965425Ab2EOTe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:34:29 -0400
X-Yahoo-Newman-Id: 587814.69756.bm@smtp214.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: O13lxvgVM1mVzVZhq7_ZcNtQ3Db2S6j6ijl9DyGMcew3Zgu
 1DdQIUCnVROn5xBdhmRA8B7RUJtLQ2FNlH4tbSFH4v9wc7Kn1ohU285ye8s8
 _8h79unMZlv8JTJJfr41rKNSo_o8qZeHztw95KgQRnfsMmoBFPYzzxMZGVqu
 2G5FJ0cw4bz6DsicKsltmCwoCCVRUy9IrmBa3zxnRcsADchDZBlYKAdJc4dL
 ZcMH_uQ1Fj0deE3eemJ5_Vwvs.aMe3EBlAE7Jy.t3FwNnx6DhtQfz5NhnIXv
 BIWYuqFgNLW1sEL0b4hGOHwCuU40shTqRao9UFezRPglYaMouuWzH6d37B6h
 gDvpkIGJDr11uLxcxCDmUmUlD5Pkhhxx_wahSpkF8pgWgMWOyUNBED1MZoxc
 E4jhldKL0U2l6Ksnja2Ekkce67nSiDGWxkyLeke5cNDSXDXfoAJmYo4TFk8E
 irP5aVVsGdtltZzvLLE0lfx12Rit._tipOty.1gRdjVTU1ghfoPV1vr52QA-
 -
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: mdharm-usb@one-eyed-alien.net, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: [PATCH 3/3] drivers:Fixed keyword related space issues.
Date: Wed, 16 May 2012 01:06:42 +0530
Message-Id: <1337110602-9879-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed keyword related space issues found by
checkpatch.pl tool in drivers/usb/storage/usb.c
Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 drivers/usb/storage/usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 16d49da..e23c30a 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -265,7 +265,7 @@ void fill_inquiry_response(struct us_data *us, unsigned char *data,
 		return;
 
 	memset(data+8, ' ', 28);
-	if(data[0]&0x20) { /* USB device currently not connected. Return
+	if (data[0]&0x20) { /* USB device currently not connected. Return
 			      peripheral qualifier 001b ("...however, the
 			      physical device is not currently connected
 			      to this logical unit") and leave vendor and
@@ -298,7 +298,7 @@ static int usb_stor_control_thread(void * __us)
 	struct us_data *us = (struct us_data *)__us;
 	struct Scsi_Host *host = us_to_host(us);
 
-	for(;;) {
+	for (;;) {
 		US_DEBUGP("*** thread sleeping.\n");
 		if (wait_for_completion_interruptible(&us->cmnd_ready))
 			break;
-- 
1.7.10

