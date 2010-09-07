Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750891Ab0IGEQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 00:16:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34113 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab0IGEQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 00:16:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=h0d3KeZDXO41g13qPXB0/1S6C1QYXE+dtY3Lkf0yfepdEhN2uWM8Iuw4Qq3fdCDUW+
         eKula/EBRfh5NpVRIA3M40UBReKhIJJwckBABR5eJmWclmM14bJ6a8cCbTMZ+DQwn48V
         d9XKrFSD8erwQtsnr/etNIM4mo5DjK2RaHwcc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]crypto/Kconfig update broken web addresses.
Date: Mon,  6 Sep 2010 21:16:59 -0700
Message-Id: <1283833019-26155-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a patch to update the broken web addresses, in crypto/*
that I could locate. Some are just simple typos that needed to be
fixed, and some had a change in location altogether..
let me know if any of them need to be changed and such. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 crypto/Kconfig |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1cd497d..925da03 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -365,7 +365,7 @@ config CRYPTO_RMD128
 	  RIPEMD-160 should be used.
 
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  See <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_RMD160
 	tristate "RIPEMD-160 digest algorithm"
@@ -382,7 +382,7 @@ config CRYPTO_RMD160
 	  against RIPEMD-160.
 
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  See <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_RMD256
 	tristate "RIPEMD-256 digest algorithm"
@@ -394,7 +394,7 @@ config CRYPTO_RMD256
 	  (than RIPEMD-128).
 
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  See <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_RMD320
 	tristate "RIPEMD-320 digest algorithm"
@@ -406,7 +406,7 @@ config CRYPTO_RMD320
 	  (than RIPEMD-160).
 
 	  Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
-	  See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+	  See <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
 
 config CRYPTO_SHA1
 	tristate "SHA1 digest algorithm"
@@ -461,7 +461,7 @@ config CRYPTO_WP512
 	  Whirlpool will be part of the ISO/IEC 10118-3:2003(E) standard
 
 	  See also:
-	  <http://planeta.terra.com.br/informatica/paulobarreto/WhirlpoolPage.html>
+	  <http://www.larc.usp.br/~pbarreto/WhirlpoolPage.html>
 
 config CRYPTO_GHASH_CLMUL_NI_INTEL
 	tristate "GHASH digest algorithm (CLMUL-NI accelerated)"
@@ -579,8 +579,8 @@ config CRYPTO_ANUBIS
 	  in the NESSIE competition.
 
 	  See also:
-	  <https://www.cosic.esat.kuleuven.ac.be/nessie/reports/>
-	  <http://planeta.terra.com.br/informatica/paulobarreto/AnubisPage.html>
+	  <https://www.cosic.esat.kuleuven.be/nessie/reports/>
+	  <http://www.larc.usp.br/~pbarreto/AnubisPage.html>
 
 config CRYPTO_ARC4
 	tristate "ARC4 cipher algorithm"
@@ -659,7 +659,7 @@ config CRYPTO_KHAZAD
 	  on 32-bit processors.  Khazad uses an 128 bit key size.
 
 	  See also:
-	  <http://planeta.terra.com.br/informatica/paulobarreto/KhazadPage.html>
+	  <http://www.larc.usp.br/~pbarreto/KhazadPage.html>
 
 config CRYPTO_SALSA20
 	tristate "Salsa20 stream cipher algorithm (EXPERIMENTAL)"
-- 
1.7.2.1

