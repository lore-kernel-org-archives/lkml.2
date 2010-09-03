Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab0ICAvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 20:51:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:59033 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab0ICAvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 20:51:40 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, linux-alpha@vger.kernel.org
Subject: [PATCH -mm 2/8] alpha: enable ARCH_DMA_ADDR_T_64BIT
Date: Fri,  3 Sep 2010 09:49:10 +0900
Message-Id: <1283474956-14710-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
References: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 03 Sep 2010 09:51:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index b9647bb..953e31e 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -54,6 +54,9 @@ config ZONE_DMA
 	bool
 	default y
 
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool y
+
 config NEED_DMA_MAP_STATE
        def_bool y
 
-- 
1.7.1

