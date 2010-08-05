Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478Ab0HEJVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:21:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39287 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867Ab0HEJVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=DVbg5AC7cu+M3rl48SURI7JogwdYTy7lJTUhEM/3PqoDShWzFzQ8r9bPa0quCzQO37
         dk8Dh+8GGzXBibPeRYutQCK+FJH2H7HCko6TIbnzgG08qPAEFkYzez2taTo1rL5u0D9O
         2y3aKQsg7RMUbzDVwmNrdOgqv9pCX5NfYKL5k=
Date: Thu, 5 Aug 2010 11:21:42 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Trivial. Fix typo in kconfig entry.
Message-ID: <20100805112142.68d8926d@varda>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 This fixes a typo in file crypto/Kconfig.

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1cd497d..27484e4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -102,7 +102,7 @@ config CRYPTO_MANAGER2
 	select CRYPTO_PCOMP2
 
 config CRYPTO_MANAGER_TESTS
-	bool "Run algolithms' self-tests"
+	bool "Run algorithms' self-tests"
 	default y
 	depends on CRYPTO_MANAGER2
 	help
