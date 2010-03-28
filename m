Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0C1R3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 13:29:12 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:45262 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab0C1R3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 13:29:11 -0400
From: Gilles Espinasse <g.esp@free.fr>
To: jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       Gilles Espinasse <g.esp@free.fr>
Subject: [PATCH] Fix requr typo on crypto/Kconfig
Date: Sun, 28 Mar 2010 19:28:25 +0200
Message-Id: <1269797305-4689-1-git-send-email-g.esp@free.fr>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <?>
References: <?>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gilles Espinasse <g.esp@free.fr>
---
 crypto/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 403857a..9d9434f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -28,7 +28,7 @@ config CRYPTO_FIPS
 	  This options enables the fips boot option which is
 	  required if you want to system to operate in a FIPS 200
 	  certification.  You should say no unless you know what
-	  this is. Note that CRYPTO_ANSI_CPRNG is requred if this
+	  this is. Note that CRYPTO_ANSI_CPRNG is required if this
 	  option is selected
 
 config CRYPTO_ALGAPI
-- 
1.6.4.4

