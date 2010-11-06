Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab0KFSuh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:50:37 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34057 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab0KFSug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:50:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=idNWbigvx24qQtuMxgM+1aXXps86CynIeFk0VgjjS5VWrZvejEXBTLznbvVctodDY5
         byBeL00ttDP2snhQvFPFDX/H2uFXC7JLRwprANBy34jdyImtWqLvxgrz290yMIo8EtNR
         LsIWaN1rj6Fbbm8eE9IwRU6LOF5gvR5guWLOo=
From: Tracey Dent <tdent48227@gmail.com>
To: herbert@gondor.hengli.com.au
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] Crypto: Makefile: Makefile clean up
Date: Sat,  6 Nov 2010 14:50:48 -0400
Message-Id: <1289069448-1861-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed Makefile to use <modules>-y instead of <modules>-objs.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 crypto/Makefile |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 423b7de..40a9e43 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -3,32 +3,32 @@
 #
 
 obj-$(CONFIG_CRYPTO) += crypto.o
-crypto-objs := api.o cipher.o compress.o
+crypto-y := api.o cipher.o compress.o
 
 obj-$(CONFIG_CRYPTO_WORKQUEUE) += crypto_wq.o
 
 obj-$(CONFIG_CRYPTO_FIPS) += fips.o
 
 crypto_algapi-$(CONFIG_PROC_FS) += proc.o
-crypto_algapi-objs := algapi.o scatterwalk.o $(crypto_algapi-y)
+crypto_algapi-y := algapi.o scatterwalk.o $(crypto_algapi-y)
 obj-$(CONFIG_CRYPTO_ALGAPI2) += crypto_algapi.o
 
 obj-$(CONFIG_CRYPTO_AEAD2) += aead.o
 
-crypto_blkcipher-objs := ablkcipher.o
-crypto_blkcipher-objs += blkcipher.o
+crypto_blkcipher-y := ablkcipher.o
+crypto_blkcipher-y += blkcipher.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER2) += crypto_blkcipher.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER2) += chainiv.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER2) += eseqiv.o
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 
-crypto_hash-objs += ahash.o
-crypto_hash-objs += shash.o
+crypto_hash-y += ahash.o
+crypto_hash-y += shash.o
 obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 
 obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
 
-cryptomgr-objs := algboss.o testmgr.o
+cryptomgr-y := algboss.o testmgr.o
 
 obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
-- 
1.7.3.2.146.gca209

