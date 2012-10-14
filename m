Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab2JNPTj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:19:39 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:43043 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab2JNPTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:19:09 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 3/4] Drivers: Staging: CSR: Removed whitespace between function name and (
Date: Mon, 15 Oct 2012 00:16:52 +0900
Message-Id: <1350227813-30880-3-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350227813-30880-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350227813-30880-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the unnecessary whitespace between function name and the "(",
according to the coding style.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/data_tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/csr/data_tx.c b/drivers/staging/csr/data_tx.c
index 1bea7f0..160a6c5 100644
--- a/drivers/staging/csr/data_tx.c
+++ b/drivers/staging/csr/data_tx.c
@@ -15,7 +15,7 @@
 #include "csr_wifi_hip_unifi.h"
 #include "unifi_priv.h"
 
-int uf_verify_m4 (unifi_priv_t *priv, const unsigned char *packet,
+int uf_verify_m4(unifi_priv_t *priv, const unsigned char *packet,
 	unsigned int length) {
 	const unsigned char *p = packet;
 	u16 keyinfo;
-- 
1.7.9.5

