Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934846Ab2C3VFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:05:14 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934752Ab2C3VEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:04:55 -0400
Message-Id: <201203302104.q2UL4rg5006253@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 27 Mar 2012 13:53:30 -0400
Subject: [PATCH] arch/tile/Kconfig: rename tile_defconfig to tilepro_defconfig
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:04:53.0866 (UTC) FILETIME=[C1042CA0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We switched to using "tilepro" for the 32-bit stuff a while ago,
but missed this one usage.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 30413c1..30393aa 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -69,6 +69,9 @@ config ARCH_PHYS_ADDR_T_64BIT
 config ARCH_DMA_ADDR_T_64BIT
 	def_bool y
 
+config NEED_DMA_MAP_STATE
+	def_bool y
+
 config LOCKDEP_SUPPORT
 	def_bool y
 
@@ -118,7 +121,7 @@ config 64BIT
 
 config ARCH_DEFCONFIG
 	string
-	default "arch/tile/configs/tile_defconfig" if !TILEGX
+	default "arch/tile/configs/tilepro_defconfig" if !TILEGX
 	default "arch/tile/configs/tilegx_defconfig" if TILEGX
 
 source "init/Kconfig"
-- 
1.6.5.2

