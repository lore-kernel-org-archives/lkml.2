Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab1IVUDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:03:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48739 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1IVUDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:03:31 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Axel Lin <axel.lin@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] ARM: Don't include mach-nuc93x/Kconfig
Date: Thu, 22 Sep 2011 14:03:22 -0600
Message-Id: <1316721802-10852-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6adc1e7ff19d9befdbb7781b26fff42bb0bc21e2 "ARM: mach-nuc93x: delete"
removed support for this sub-architecture, thus deleting that file. So,
don't include it. grep indicates no more references to this machine.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/Kconfig |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 89bd520..472a7f8 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -969,8 +969,6 @@ source "arch/arm/mach-netx/Kconfig"
 source "arch/arm/mach-nomadik/Kconfig"
 source "arch/arm/plat-nomadik/Kconfig"
 
-source "arch/arm/mach-nuc93x/Kconfig"
-
 source "arch/arm/plat-omap/Kconfig"
 
 source "arch/arm/mach-omap1/Kconfig"
-- 
1.7.0.4

