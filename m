Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab2JNPTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:19:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45385 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab2JNPTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:19:05 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 2/4] Drivers: Staging: CSR: Removed braces for single line if statement
Date: Mon, 15 Oct 2012 00:16:51 +0900
Message-Id: <1350227813-30880-2-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350227813-30880-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350227813-30880-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was a very minor fix that an if statement had curly braces with just
single line of code inside.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/data_tx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/csr/data_tx.c b/drivers/staging/csr/data_tx.c
index 8af0358..1bea7f0 100644
--- a/drivers/staging/csr/data_tx.c
+++ b/drivers/staging/csr/data_tx.c
@@ -20,9 +20,8 @@ int uf_verify_m4 (unifi_priv_t *priv, const unsigned char *packet,
 	const unsigned char *p = packet;
 	u16 keyinfo;
 
-	if (length < (4 + 5 + 8 + 32 + 16 + 8 + 8 + 16 + 1 + 8)) {
+	if (length < (4 + 5 + 8 + 32 + 16 + 8 + 8 + 16 + 1 + 8))
 		return 1;
-	}
 
 	p += 8;
 	keyinfo = p[5] << 8 | p[6]; /* big-endian */
-- 
1.7.9.5

