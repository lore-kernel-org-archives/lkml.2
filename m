Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab2JNPTQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:19:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39383 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab2JNPTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:19:12 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 4/4] Drivers: Staging: CSR: Removed whitespace before quoting newline
Date: Mon, 15 Oct 2012 00:16:53 +0900
Message-Id: <1350227813-30880-4-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350227813-30880-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350227813-30880-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the unnecessary whitespace before \n on the printing statement.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/data_tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/csr/data_tx.c b/drivers/staging/csr/data_tx.c
index 160a6c5..f3c1cc3 100644
--- a/drivers/staging/csr/data_tx.c
+++ b/drivers/staging/csr/data_tx.c
@@ -40,7 +40,7 @@ int uf_verify_m4(unifi_priv_t *priv, const unsigned char *packet,
 		((p[4 + 5 + 8 + 32 + 16 + 8 + 8 + 16 + 0] == 0) &&
 		/* key data length (2 octets) 0 for 4/4 only */
 		p[4 + 5 + 8 + 32 + 16 + 8 + 8 + 16 + 1] == 0)) {
-		unifi_trace(priv, UDBG1, "uf_verify_m4: M4 detected \n");
+		unifi_trace(priv, UDBG1, "uf_verify_m4: M4 detected\n");
 		return 0;
 	} else {
 		return 1;
-- 
1.7.9.5

