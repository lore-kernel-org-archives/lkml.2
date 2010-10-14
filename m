Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0JNVQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:16:34 -0400
Received: from king.tilera.com ([72.1.168.226]:52863 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab0JNVQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:16:28 -0400
Message-Id: <228de98c863487232c8226656f4b8f3e799a4a7a.1287090291.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1287090280.git.cmetcalf@tilera.com>
References: <cover.1287090280.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 14 Oct 2010 16:50:26 -0400
Subject: [PATCH 14/14] arch/tile: convert a BUG_ON to BUILD_BUG_ON
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 14 Oct 2010 21:16:25.0387 (UTC) FILETIME=[0F0527B0:01CB6BE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspired by Akinobu Mita's cleanup work.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 6444a2b..f3a50e7 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -311,7 +311,7 @@ static void __init setup_memory(void)
 #endif
 
 	/* We are using a char to hold the cpu_2_node[] mapping */
-	BUG_ON(MAX_NUMNODES > 127);
+	BUILD_BUG_ON(MAX_NUMNODES > 127);
 
 	/* Discover the ranges of memory available to us */
 	for (i = 0; ; ++i) {
-- 
1.6.5.2

