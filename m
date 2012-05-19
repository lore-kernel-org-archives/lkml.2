Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635Ab2ESTXj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 15:23:39 -0400
Received: from nm24.bullet.mail.sp2.yahoo.com ([98.139.91.94]:45688 "HELO
	nm24.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752452Ab2ESTXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 15:23:38 -0400
X-Yahoo-Newman-Id: 765755.5391.bm@smtp220.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7vK3pSUVM1keLUNnJEaFXo9.AUKllsTntPlf.tmErV567Vp
 s_Kh7KSTVXVv.o4m2.SDueM1WyHvD3FM1XfXe4tQVHDdyGq9x27_0KnWVPbA
 fxRL2gYyrhLsk1S9XwSv_a0.TDQSIcq989RtaM3rEuCKz5xePBH9qREW1AwW
 R.P__41Cd0rl5GHHK9MZjVqvXTtDubs9Jiwg8.E24WnCMkzFUd.4XPWpX3lQ
 E.1iQr8drMei8GL_Ns6zcTrkociIlpA9vea0zF8j9PH5c6zmlqPwxHlvXJ7V
 AfdgK7.7D7FPCcEe.0u3y8cDf.zjiLxkc5EkQLbRDgTkZyW_ejnuwg0B_CEZ
 9eJIDJ52zpT2IhbbpPR8kk_Yj9DAERyiwych3_dZ_n2qZhBQTk1X_eS2r9Y.
 1M4Z7avDOv0duPVCMMM8HJnO2u0cP8dO0o1tvMcZtqOTQZu1l39t3UI60Ejf
 _4K9vCcxeNIyj4BkSJgSUL.gakwn.4HFLnRjSRTdEdi6hZiXAriceVevuXsm
 5t.ra6N1mS3Z5nWz1kgUnixMRhA--
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahiliation@yahoo.co.in
Subject: [PATCH]usb:early:fixed coding style issue related to : operator
Date: Sun, 20 May 2012 00:56:58 +0530
Message-Id: <1337455618-4334-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a space issue relating to ":" operator found
by checkpatch.pl tool in drivers/usb/early/ehci-dbgp.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 drivers/usb/early/ehci-dbgp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/early/ehci-dbgp.c b/drivers/usb/early/ehci-dbgp.c
index 1fc8f12..ee0ebac 100644
--- a/drivers/usb/early/ehci-dbgp.c
+++ b/drivers/usb/early/ehci-dbgp.c
@@ -334,7 +334,7 @@ static int dbgp_control_msg(unsigned devnum, int requesttype,
 	int ret;
 
 	read = (requesttype & USB_DIR_IN) != 0;
-	if (size > (read ? DBGP_MAX_PACKET:0))
+	if (size > (read ? DBGP_MAX_PACKET : 0))
 		return -1;
 
 	/* Compute the control message */
-- 
1.7.10

