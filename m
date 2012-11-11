Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab2KKMZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:25:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60902 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab2KKMZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:25:13 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 8/8] staging: line6: wrap comment to 80 chars in variax.c
Date: Sun, 11 Nov 2012 13:24:46 +0100
Message-Id: <1352636686-31170-9-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
References: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/variax.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index f97416b..1b85ecc 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -160,7 +160,9 @@ static void variax_startup5(unsigned long data)
 	/* current model dump: */
 	line6_dump_request_async(&variax->dumpreq, &variax->line6, 0,
 				 VARIAX_DUMP_PASS1);
-	/* passes 2 and 3 are performed implicitly before entering variax_startup6 */
+	/* passes 2 and 3 are performed implicitly before entering
+	 * variax_startup6.
+	 */
 }
 
 static void variax_startup6(struct usb_line6_variax *variax)
-- 
1.7.12.1

