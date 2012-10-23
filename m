Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965601Ab2JWVH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:07:26 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53064 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933591Ab2JWUFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:07 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 034/193] crypto: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:47 -0700
Message-Id: <1351022666-6960-35-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/Kconfig |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 6563366..b4913b5 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -134,8 +134,8 @@ config CRYPTO_NULL
 	  These are 'Null' algorithms, used by IPsec, which do nothing.
 
 config CRYPTO_PCRYPT
-	tristate "Parallel crypto engine (EXPERIMENTAL)"
-	depends on SMP && EXPERIMENTAL
+	tristate "Parallel crypto engine"
+	depends on SMP
 	select PADATA
 	select CRYPTO_MANAGER
 	select CRYPTO_AEAD
@@ -292,7 +292,6 @@ config CRYPTO_HMAC
 
 config CRYPTO_XCBC
 	tristate "XCBC support"
-	depends on EXPERIMENTAL
 	select CRYPTO_HASH
 	select CRYPTO_MANAGER
 	help
@@ -303,7 +302,6 @@ config CRYPTO_XCBC
 
 config CRYPTO_VMAC
 	tristate "VMAC support"
-	depends on EXPERIMENTAL
 	select CRYPTO_HASH
 	select CRYPTO_MANAGER
 	help
@@ -890,8 +888,7 @@ config CRYPTO_KHAZAD
 	  <http://www.larc.usp.br/~pbarreto/KhazadPage.html>
 
 config CRYPTO_SALSA20
-	tristate "Salsa20 stream cipher algorithm (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Salsa20 stream cipher algorithm"
 	select CRYPTO_BLKCIPHER
 	help
 	  Salsa20 stream cipher algorithm.
@@ -903,9 +900,8 @@ config CRYPTO_SALSA20
 	  Bernstein <djb@cr.yp.to>. See <http://cr.yp.to/snuffle.html>
 
 config CRYPTO_SALSA20_586
-	tristate "Salsa20 stream cipher algorithm (i586) (EXPERIMENTAL)"
+	tristate "Salsa20 stream cipher algorithm (i586)"
 	depends on (X86 || UML_X86) && !64BIT
-	depends on EXPERIMENTAL
 	select CRYPTO_BLKCIPHER
 	help
 	  Salsa20 stream cipher algorithm.
@@ -917,9 +913,8 @@ config CRYPTO_SALSA20_586
 	  Bernstein <djb@cr.yp.to>. See <http://cr.yp.to/snuffle.html>
 
 config CRYPTO_SALSA20_X86_64
-	tristate "Salsa20 stream cipher algorithm (x86_64) (EXPERIMENTAL)"
+	tristate "Salsa20 stream cipher algorithm (x86_64)"
 	depends on (X86 || UML_X86) && 64BIT
-	depends on EXPERIMENTAL
 	select CRYPTO_BLKCIPHER
 	help
 	  Salsa20 stream cipher algorithm.
-- 
1.7.9.5

