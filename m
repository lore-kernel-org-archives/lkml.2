Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab2LDB1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 20:27:32 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:52505 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2LDB1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:27:31 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Steve Underwood <steveu@coppice.org>, David Rowe <david@rowetel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jesper Juhl <jj@chaosbits.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] staging: echo: remove unused variable
Date: Tue,  4 Dec 2012 01:21:44 +0000
Message-Id: <1354584111-1513-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable j isn't used in the loop

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/staging/echo/echo.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
index ca87ce9..14dfd91 100644
--- a/drivers/staging/echo/echo.c
+++ b/drivers/staging/echo/echo.c
@@ -119,7 +119,6 @@
 static inline void lms_adapt_bg(struct oslec_state *ec, int clean, int shift)
 {
 	int i;
-	int j;
 	int offset1;
 	int offset2;
 	int factor;
@@ -142,7 +141,7 @@ static inline void lms_adapt_bg(struct oslec_state *ec, int clean, int shift)
 
 	/* asm("st:"); */
 	n = ec->taps;
-	for (i = 0, j = offset2; i < n; i++, j++) {
+	for (i = 0; i < n; i++) {
 		exp = *phist++ * factor;
 		ec->fir_taps16[1][i] += (int16_t) ((exp + (1 << 14)) >> 15);
 	}
-- 
1.7.4.5

