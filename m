Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab2EPTBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:01:14 -0400
Received: from nm25.bullet.mail.bf1.yahoo.com ([98.139.212.184]:42840 "HELO
	nm25.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759578Ab2EPTBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:01:10 -0400
X-Yahoo-Newman-Id: 101415.92607.bm@smtp207.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: YRQgFh0VM1kfEDqZbE5IjBPRKbjzdkPiVNULmPgZ4agk1MK
 U9FnAtlCBGQsq0.IA9zNMq0Z8s1PWzQkZRJ20.o.2dV17641CXIOQYRDrBSz
 dF9kpDeTt8R8q4HvU79jSCBxiR_FGf29u6OyUi_O213cBnv2vy5bxjCkzMNo
 G99wdgDI6X1v3lSB0DVuLrGjQXG9gSfoOPo.AYUb3CPMSDvQNlMFT.97B8Mw
 p12rGIF0j0drNCJ._jgS49nF0Vx9tJKQ6tU2R.oLW7gw6k34PM.1xb5lXgtC
 fAqLm0uJqwyQC2NhpK_UYboILSCCod4gX1z.37yhX54rznUAHkwX4yhvZHtX
 iBfAw40uNL7hKf_VbWi9.I53ZMB9AX8VPLSysYw4j4t5E3MWP7_klXNEDbAV
 MbLiy6OKNbcsDIC1Q2yqF8gyCBzXUhCQ8nYEmxHKkKPHL_1bNOeq6ylGSgZ4
 EAJKfKBdUD_7Ya6zt2wUBB1hhK6eWvG28A5QQhR7FiuDBHG6NtgN0fZ77Lp5
 SCsEX.g--
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: mdharm-usb@one-eyed-alien.net, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: [PATCH 3/3]USB: storage:fixed keyword related space issues.
Date: Thu, 17 May 2012 00:34:28 +0530
Message-Id: <1337195068-3802-1-git-send-email-ahiliation@yahoo.co.in>
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

