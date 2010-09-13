Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab0IMTtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:49:10 -0400
Received: from mail.perches.com ([173.55.12.10]:1920 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428Ab0IMTsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:43 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "David S. Miller" <davem@davemloft.net>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 23/25] net/sunrpc: Use static const char arrays
Date: Mon, 13 Sep 2010 12:48:01 -0700
Message-Id: <c87c4e9337ce9af6a3b17baee29ec0dda5a4d392.1284406639.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/sunrpc/auth_gss/gss_krb5_mech.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index 0326446..8a4d083 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -422,7 +422,7 @@ static int
 context_derive_keys_rc4(struct krb5_ctx *ctx)
 {
 	struct crypto_hash *hmac;
-	char sigkeyconstant[] = "signaturekey";
+	static const char sigkeyconstant[] = "signaturekey";
 	int slen = strlen(sigkeyconstant) + 1;	/* include null terminator */
 	struct hash_desc desc;
 	struct scatterlist sg[1];
-- 
1.7.3.rc1

