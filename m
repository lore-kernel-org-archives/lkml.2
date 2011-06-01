Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1FBSkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:40:37 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:56737 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab1FBSkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:40:36 -0400
Message-Id: <201106021834.p52IYxA7032489@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 1 Jun 2011 16:06:04 -0400
Subject: [PATCH] tile: enable CONFIG_BUGVERBOSE
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 02 Jun 2011 18:34:59.0872 (UTC) FILETIME=[C76D1A00:01CC2153]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial config change to enable backtraces on panic.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 28afa4c..dd373c8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -697,7 +697,7 @@ config DEBUG_BUGVERBOSE
 	bool "Verbose BUG() reporting (adds 70K)" if DEBUG_KERNEL && EXPERT
 	depends on BUG
 	depends on ARM || AVR32 || M32R || M68K || SPARC32 || SPARC64 || \
-		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300
+		   FRV || SUPERH || GENERIC_BUG || BLACKFIN || MN10300 || TILE
 	default y
 	help
 	  Say Y here to make BUG() panics output the file name and line number
-- 
1.6.5.2

