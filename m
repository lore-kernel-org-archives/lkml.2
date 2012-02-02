Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2BBNjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:39:52 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55296 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2BBNjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:39:51 -0500
Message-ID: <1328190031.6508.1.camel@blackout-netbook>
Subject: [PATCH] Correcting some style issues
From: Tristan Pourcelot <tristan.pourcelot@gmail.com>
To: davem@davemloft.net, herbert@gondor.hengli.com.au,
        linux-geode@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Date: Thu, 02 Feb 2012 14:40:31 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d50e5530201aa02a5232ca9f2458a7fdd18de374 Mon Sep 17 00:00:00 2001
From: Tristan Pourcelot <tristan.pourcelot@gmail.com>
Date: Thu, 2 Feb 2012 14:01:03 +0100
Subject: [PATCH] Correcting some style errors in
 drivers/crypto/geode-aes.c 
Signed-off-by: Tristan Pourcelot <tristan.pourcelot@gmail.com>

---
 drivers/crypto/geode-aes.c |   72
++++++++++++++++++++++----------------------
 1 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 2addf1a..e325929 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -282,21 +282,21 @@ static struct crypto_alg geode_alg = {
 	.cra_driver_name	=	"geode-aes",
 	.cra_priority		=	300,
 	.cra_alignmask		=	15,
-	.cra_flags			=	CRYPTO_ALG_TYPE_CIPHER |
-							CRYPTO_ALG_NEED_FALLBACK,
-	.cra_init			=	fallback_init_cip,
-	.cra_exit			=	fallback_exit_cip,
+	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER |
+		CRYPTO_ALG_NEED_FALLBACK,
+	.cra_init		=	fallback_init_cip,
+	.cra_exit		=	fallback_exit_cip,
 	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct geode_aes_op),
-	.cra_module			=	THIS_MODULE,
-	.cra_list			=	LIST_HEAD_INIT(geode_alg.cra_list),
-	.cra_u				=	{
-		.cipher	=	{
-			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
-			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
-			.cia_setkey			=	geode_setkey_cip,
-			.cia_encrypt		=	geode_encrypt,
-			.cia_decrypt		=	geode_decrypt
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(geode_alg.cra_list),
+	.cra_u			=	{
+	.cipher	=	{
+		.cia_min_keysize	=	AES_MIN_KEY_SIZE,
+		.cia_max_keysize	=	AES_MAX_KEY_SIZE,
+		.cia_setkey		=	geode_setkey_cip,
+		.cia_encrypt		=	geode_encrypt,
+		.cia_decrypt		=	geode_decrypt
 		}
 	}
 };
@@ -392,24 +392,24 @@ static struct crypto_alg geode_cbc_alg = {
 	.cra_name		=	"cbc(aes)",
 	.cra_driver_name	=	"cbc-aes-geode",
 	.cra_priority		=	400,
-	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER |
-							CRYPTO_ALG_NEED_FALLBACK,
-	.cra_init			=	fallback_init_blk,
-	.cra_exit			=	fallback_exit_blk,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
+						CRYPTO_ALG_NEED_FALLBACK,
+	.cra_init		=	fallback_init_blk,
+	.cra_exit		=	fallback_exit_blk,
 	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct geode_aes_op),
 	.cra_alignmask		=	15,
-	.cra_type			=	&crypto_blkcipher_type,
-	.cra_module			=	THIS_MODULE,
-	.cra_list			=	LIST_HEAD_INIT(geode_cbc_alg.cra_list),
-	.cra_u				=	{
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(geode_cbc_alg.cra_list),
+	.cra_u			=	{
 		.blkcipher	=	{
 			.min_keysize	=	AES_MIN_KEY_SIZE,
 			.max_keysize	=	AES_MAX_KEY_SIZE,
-			.setkey			=	geode_setkey_blk,
-			.encrypt		=	geode_cbc_encrypt,
-			.decrypt		=	geode_cbc_decrypt,
-			.ivsize			=	AES_IV_LENGTH,
+			.setkey		=	geode_setkey_blk,
+			.encryp		=	geode_cbc_encrypt,
+			.decryp		=	geode_cbc_decrypt,
+			.ivsize		=	AES_IV_LENGTH,
 		}
 	}
 };
@@ -478,23 +478,23 @@ static struct crypto_alg geode_ecb_alg = {
 	.cra_name		=	"ecb(aes)",
 	.cra_driver_name	=	"ecb-aes-geode",
 	.cra_priority		=	400,
-	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER |
-							CRYPTO_ALG_NEED_FALLBACK,
-	.cra_init			=	fallback_init_blk,
-	.cra_exit			=	fallback_exit_blk,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
+						CRYPTO_ALG_NEED_FALLBACK,
+	.cra_init		=	fallback_init_blk,
+	.cra_exit		=	fallback_exit_blk,
 	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct geode_aes_op),
 	.cra_alignmask		=	15,
-	.cra_type			=	&crypto_blkcipher_type,
-	.cra_module			=	THIS_MODULE,
-	.cra_list			=	LIST_HEAD_INIT(geode_ecb_alg.cra_list),
-	.cra_u				=	{
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(geode_ecb_alg.cra_list),
+	.cra_u			=	{
 		.blkcipher	=	{
 			.min_keysize	=	AES_MIN_KEY_SIZE,
 			.max_keysize	=	AES_MAX_KEY_SIZE,
-			.setkey			=	geode_setkey_blk,
-			.encrypt		=	geode_ecb_encrypt,
-			.decrypt		=	geode_ecb_decrypt,
+			.setkey		=	geode_setkey_blk,
+			.encrypt	=	geode_ecb_encrypt,
+			.decrypt	=	geode_ecb_decrypt,
 		}
 	}
 };
-- 
1.7.9



