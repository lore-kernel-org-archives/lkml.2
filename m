Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab0JXNHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 09:07:48 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:40567 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932503Ab0JXNHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 09:07:47 -0400
Date: Sun, 24 Oct 2010 15:05:56 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/crypto: dubious error check
Message-ID: <20101024150556.22f49c6a@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like a copy-and-paste problem to me.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/crypto/n2_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 88ee015..7614126 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1832,7 +1832,7 @@ static int __devinit get_irq_props(struct mdesc_handle *mdesc, u64 node,
 		return -ENODEV;
 
 	ino = mdesc_get_property(mdesc, node, "ino", &ino_len);
-	if (!intr)
+	if (!ino)
 		return -ENODEV;
 
 	if (intr_len != ino_len)
-- 
1.7.2.2
