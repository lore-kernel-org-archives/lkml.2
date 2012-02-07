Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab2BGVFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 16:05:21 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42448 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab2BGVFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 16:05:19 -0500
Message-ID: <1328648765.29061.3.camel@blackout-netbook>
Subject: Re: [PATCH] [trivial] Correcting some style issues in
 drivers/crypto/geode-aes.c
From: Tristan Pourcelot <tristan.pourcelot@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: davem@davemloft.net, linux-geode@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 07 Feb 2012 22:06:05 +0100
In-Reply-To: <20120205041424.GB8219@gondor.apana.org.au>
References: <1328190031.6508.1.camel@blackout-netbook>
	 <20120205041424.GB8219@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 05 février 2012 à 15:14 +1100, Herbert Xu a écrit :
> On Thu, Feb 02, 2012 at 02:40:31PM +0100, Tristan Pourcelot wrote:
> > >From d50e5530201aa02a5232ca9f2458a7fdd18de374 Mon Sep 17 00:00:00 2001
> > From: Tristan Pourcelot <tristan.pourcelot@gmail.com>
> > Date: Thu, 2 Feb 2012 14:01:03 +0100
> > Subject: [PATCH] Correcting some style errors in
> >  drivers/crypto/geode-aes.c 
> > Signed-off-by: Tristan Pourcelot <tristan.pourcelot@gmail.com>
> 
> Sorry, your patch doesn't apply against cryptodev:
Sorry, I messed up my patch.
Here is a correct version that should apply correctly.
> 
> $ git apply ~/p
> 2 out of 3 hunks FAILED -- saving rejects to file drivers/crypto/geode-aes.c.rej
> $
> 
> Please check and resend.
> 
> Thanks,

Thanks,

>From 27c351b5ccc20c088e613826fc80710dec3c0fb2 Mon Sep 17 00:00:00 2001
From: Tristan Pourcelot <tristan.pourcelot@gmail.com>
Date: Tue, 7 Feb 2012 20:24:03 +0100
Subject: [PATCH] Correcting some style issues in drivers/geode-aes.c
 Signed-off-by: Tristan Pourcelot <tristan.pourcelot@gmail.com>

---
 drivers/crypto/geode-aes.c |   66
++++++++++++++++++++++----------------------
 1 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 219d09c..8a494b0 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -278,23 +278,23 @@ static void fallback_exit_cip(struct crypto_tfm
*tfm)
 }
 
 static struct crypto_alg geode_alg = {
-	.cra_name			=	"aes",
+	.cra_name		=	"aes",
 	.cra_driver_name	=	"geode-aes",
 	.cra_priority		=	300,
 	.cra_alignmask		=	15,
-	.cra_flags			=	CRYPTO_ALG_TYPE_CIPHER |
-							CRYPTO_ALG_NEED_FALLBACK,
-	.cra_init			=	fallback_init_cip,
-	.cra_exit			=	fallback_exit_cip,
+	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER |
+						CRYPTO_ALG_NEED_FALLBACK,
+	.cra_init		=	fallback_init_cip,
+	.cra_exit		=	fallback_exit_cip,
 	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct geode_aes_op),
-	.cra_module			=	THIS_MODULE,
-	.cra_list			=	LIST_HEAD_INIT(geode_alg.cra_list),
-	.cra_u				=	{
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(geode_alg.cra_list),
+	.cra_u			=	{
 		.cipher	=	{
 			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
 			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
-			.cia_setkey			=	geode_setkey_cip,
+			.cia_setkey		=	geode_setkey_cip,
 			.cia_encrypt		=	geode_encrypt,
 			.cia_decrypt		=	geode_decrypt
 		}
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
+			.encrypt	=	geode_cbc_encrypt,
+			.decrypt	=	geode_cbc_decrypt,
+			.ivsize		=	AES_IV_LENGTH,
 		}
 	}
 };
@@ -475,26 +475,26 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
 }
 
 static struct crypto_alg geode_ecb_alg = {
-	.cra_name			=	"ecb(aes)",
+	.cra_name		=	"ecb(aes)",
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
1.7.0.4



