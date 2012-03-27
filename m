Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934899Ab2C3XGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:06:21 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934779Ab2C3VEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:04:54 -0400
Message-Id: <201203302104.q2UL4rZh006252@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 27 Mar 2012 13:47:57 -0400
Subject: [PATCH] arch/tile/Kconfig: remove pointless "!M386" test.
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:04:53.0507 (UTC) FILETIME=[C0CD6530:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like a cut and paste bug from the x86 version.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 11270ca..30413c1 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -12,7 +12,7 @@ config TILE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
 	select SYS_HYPERVISOR
-	select ARCH_HAVE_NMI_SAFE_CMPXCHG if !M386
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
-- 
1.6.5.2

