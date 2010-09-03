Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0ICAwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 20:52:10 -0400
Received: from sh.osrg.net ([192.16.179.4]:59036 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab0ICAvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 20:51:41 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, linux-s390@vger.kernel.org
Subject: [PATCH -mm 6/8] s390: enable ARCH_DMA_ADDR_T_64BIT with 64BIT
Date: Fri,  3 Sep 2010 09:49:14 +0900
Message-Id: <1283474956-14710-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
References: <20100903094753S.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 03 Sep 2010 09:51:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-s390@vger.kernel.org
---
 arch/s390/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index f0777a4..ad804c5 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -60,6 +60,9 @@ config NO_IOMEM
 config NO_DMA
 	def_bool y
 
+config ARCH_DMA_ADDR_T_64BIT
+	def_bool 64BIT
+
 config GENERIC_LOCKBREAK
 	bool
 	default y
-- 
1.7.1

