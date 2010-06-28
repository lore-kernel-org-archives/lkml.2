Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0F1WFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 18:05:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:47128 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753269Ab0F1WFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 18:05:22 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+4Tw8ctKG4K5Fq51ynAw3yq8D9lxvFnmnMIShd/+
	Hww11mIwQktPK2
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Sascha Hauer <kernel@pengutronix.de>
Subject: Subject: [PATCH] arm: fix KConfig warning for mach-mx25
Date: Tue, 29 Jun 2010 00:05:20 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Baruch Siach <baruch@tkos.co.il>,
       "Eric =?iso-8859-1?q?B=E9nard?=" <eric@eukrea.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Russell King <rmk+kernel@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006290005.20875.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de

This patch fixes a KConfig warning:
"arch/arm/mach-mx25/Kconfig:18:warning: choice value used outside its
choice group"

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next-20100628
 arch/arm/mach-mx25/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mx25/Kconfig b/arch/arm/mach-mx25/Kconfig
index 3a6668e..2f436ed 100644
--- a/arch/arm/mach-mx25/Kconfig
+++ b/arch/arm/mach-mx25/Kconfig
@@ -15,8 +15,7 @@ choice
 	default MACH_EUKREA_MBIMXSD_BASEBOARD
 
 config MACH_EUKREA_MBIMXSD_BASEBOARD
-	prompt "Eukrea MBIMXSD development board"
-	bool
+	bool "Eukrea MBIMXSD development board"
 	help
 	  This adds board specific devices that can be found on Eukrea's
 	  MBIMXSD evaluation board.
-- 
1.7.1

