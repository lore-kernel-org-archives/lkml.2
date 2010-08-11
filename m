Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0HKShT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:37:19 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:55269 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab0HKShR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:37:17 -0400
Date: Wed, 11 Aug 2010 11:37:17 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Alexander Shishkin <virtuoso@slind.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto/Kconfig: fix typo
Message-ID: <20100811183717.GF20015@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

algolithm -> algorithm

Signed-off-by: Andy Isaacson <adi@hexapodia.org>
---
 crypto/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.7.1

