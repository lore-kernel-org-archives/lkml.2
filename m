Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936782Ab2C3XFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:05:49 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934798Ab2C3VFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:04 -0400
Message-Id: <201203302104.q2UL4s2P006255@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 27 Mar 2012 14:04:57 -0400
Subject: [PATCH] arch/tile: fix typo in <arch/spr_def.h>
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:04:54.0429 (UTC) FILETIME=[C15A14D0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We aren't yet using this definition in the kernel, but fix it up
before someone goes looking for it.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/arch/spr_def.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/tile/include/arch/spr_def.h b/arch/tile/include/arch/spr_def.h
index f548efe..d6ba449 100644
--- a/arch/tile/include/arch/spr_def.h
+++ b/arch/tile/include/arch/spr_def.h
@@ -60,8 +60,8 @@
 	_concat4(SPR_IPI_EVENT_, CONFIG_KERNEL_PL,,)
 #define SPR_IPI_EVENT_RESET_K \
 	_concat4(SPR_IPI_EVENT_RESET_, CONFIG_KERNEL_PL,,)
-#define SPR_IPI_MASK_SET_K \
-	_concat4(SPR_IPI_MASK_SET_, CONFIG_KERNEL_PL,,)
+#define SPR_IPI_EVENT_SET_K \
+	_concat4(SPR_IPI_EVENT_SET_, CONFIG_KERNEL_PL,,)
 #define INT_IPI_K \
 	_concat4(INT_IPI_, CONFIG_KERNEL_PL,,)
 
-- 
1.6.5.2

