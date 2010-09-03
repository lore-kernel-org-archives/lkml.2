Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab0ICAwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 20:52:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:59043 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab0ICAvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 20:51:46 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, linux-mips@linux-mips.org
Subject: [PATCH -mm 4/8] mips: enable ARCH_DMA_ADDR_T_64BIT with (HIGHMEM && 64BIT_PHYS_ADDR) || 64BIT
Date: Fri,  3 Sep 2010 09:49:12 +0900
Message-Id: <1283474956-14710-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
References: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 03 Sep 2010 09:51:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-mips@linux-mips.org
---
 arch/mips/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 3ad59dd..3e9db47 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -830,6 +830,9 @@ config GPIO_TXX9
 config CFE
 	bool
 
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool (HIGHMEM && 64BIT_PHYS_ADDR) || 64BIT
+
 config DMA_COHERENT
 	bool
 
-- 
1.7.1

