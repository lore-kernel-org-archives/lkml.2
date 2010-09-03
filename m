Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab0ICAwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 20:52:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:59045 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756374Ab0ICAvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 20:51:46 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, cmetcalf@tilera.com
Subject: [PATCH -mm 7/8] tile: enable ARCH_DMA_ADDR_T_64BIT
Date: Fri,  3 Sep 2010 09:49:15 +0900
Message-Id: <1283474956-14710-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
References: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 03 Sep 2010 09:51:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: cmetcalf@tilera.com
---
 arch/tile/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 1eb308c..aeca73f 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -58,6 +58,9 @@ config ARCH_SUPPORTS_OPTIMIZED_INLINING
 config ARCH_PHYS_ADDR_T_64BIT
 	def_bool y
 
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool y
+
 config LOCKDEP_SUPPORT
 	def_bool y
 
-- 
1.7.1

