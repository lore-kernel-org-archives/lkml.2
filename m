Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2E3McS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:32:18 -0400
Received: from nm12-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.88]:31030 "HELO
	nm12-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753314Ab2E3McR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:32:17 -0400
X-Yahoo-Newman-Id: 201234.86768.bm@smtp215.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: UTufzvkVM1nYSjcmYHRhIGIkcGpuPOFqDPij52NaOVtz9au
 IbJU2jrgfDmGVsPW5s_Sshp20_D5nbaRxLVunONeEL0P56m9ec144QPxJc.Y
 p2Sbe_lrOCPp9TNu.fro.kLf.W38TBeqfiob4Cp5YPBiEe0y0hRw3nO1e1ND
 _bnwXJlvqZ57QmPuM1vWiLMks5seS1Fu.ZMVlQv4X4GJqUNMJmrjzTWDyjvl
 QkRzHSP_FdArwuPlGebtdM05c0tmJWGnoaVymPQyrQ36T1KIyMJnC.A.m838
 ctMKeeJmTwTVLlDExW64d6tO5qF67KqHUvrQqS3qoijzS0q3X7rQtQXSQQu7
 cykC_weGmj1EjHGR5_PPyDJaGvOSZjGlm5.8xT80fsy6C0EaYt_6jT28HoDf
 ME.vS5gCYFCmh2ZttSssavoE.vCFrjAJSZmi7XUTNPvWitMq5qC0ibmzp3YN
 .Sqw6Gue4TK.wIR.WvxNXUw3LgNvJSAdITeFsgNL8
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: mdharm-usb@one-eyed-alien.net, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: [PATCH]USB:storage:fixed space issues in coding style.
Date: Wed, 30 May 2012 18:05:47 +0530
Message-Id: <1338381347-2608-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed space issues in coding style found by
checkpatch.pl tool in drivers/usb/storage/protocol.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 drivers/usb/storage/protocol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
index 82dd834..5dfb4c3 100644
--- a/drivers/usb/storage/protocol.c
+++ b/drivers/usb/storage/protocol.c
@@ -66,7 +66,7 @@ void usb_stor_pad12_command(struct scsi_cmnd *srb, struct us_data *us)
 	 * NOTE: This only works because a scsi_cmnd struct field contains
 	 * a unsigned char cmnd[16], so we know we have storage available
 	 */
-	for (; srb->cmd_len<12; srb->cmd_len++)
+	for (; srb->cmd_len < 12; srb->cmd_len++)
 		srb->cmnd[srb->cmd_len] = 0;
 
 	/* send the command to the transport layer */
@@ -76,14 +76,14 @@ void usb_stor_pad12_command(struct scsi_cmnd *srb, struct us_data *us)
 void usb_stor_ufi_command(struct scsi_cmnd *srb, struct us_data *us)
 {
 	/* fix some commands -- this is a form of mode translation
-	 * UFI devices only accept 12 byte long commands 
+	 * UFI devices only accept 12 byte long commands
 	 *
 	 * NOTE: This only works because a scsi_cmnd struct field contains
 	 * a unsigned char cmnd[16], so we know we have storage available
 	 */
 
 	/* Pad the ATAPI command with zeros */
-	for (; srb->cmd_len<12; srb->cmd_len++)
+	for (; srb->cmd_len < 12; srb->cmd_len++)
 		srb->cmnd[srb->cmd_len] = 0;
 
 	/* set command length to 12 bytes (this affects the transport layer) */
-- 
1.7.10

