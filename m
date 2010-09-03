Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab0ICAwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 20:52:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:59039 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab0ICAvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 20:51:41 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, x86@kernel.org
Subject: [PATCH -mm 1/8] x86: enable ARCH_DMA_ADDR_T_64BIT with X86_64 || HIGHMEM64G
Date: Fri,  3 Sep 2010 09:49:09 +0900
Message-Id: <1283474956-14710-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
References: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 03 Sep 2010 09:51:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: x86@kernel.org
---
 arch/x86/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..2924f4e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1148,6 +1148,9 @@ config X86_PAE
 config ARCH_PHYS_ADDR_T_64BIT
 	def_bool X86_64 || X86_PAE
 
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool X86_64 || HIGHMEM64G
+
 config DIRECT_GBPAGES
 	bool "Enable 1GB pages for kernel pagetables" if EMBEDDED
 	default y
-- 
1.7.1

