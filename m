Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab1JNM2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:28:21 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:57851 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1JNM2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:28:20 -0400
Subject: [PATCH 03/21] sparc: drop unused Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:27:37 +0200
Message-ID: <1318595257.6132.59.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/sparc/Kconfig |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 1a6f20d..f92602e 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -560,12 +560,7 @@ config SUN_OPENPROMFS
 	  Only choose N if you know in advance that you will not need to modify
 	  OpenPROM settings on the running system.
 
-# Makefile helpers
-config SPARC32_PCI
-	bool
-	default y
-	depends on SPARC32 && PCI
-
+# Makefile helper
 config SPARC64_PCI
 	bool
 	default y
-- 
1.7.4.4




