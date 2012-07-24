Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2GXBNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:13:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49218 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab2GXBKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:10:10 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <nico@linaro.org>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, Cyril Chemparathy <cyril@ti.com>,
        Vitaly Andrianov <vitalya@ti.com>
Subject: [RFC 07/23] ARM: LPAE: use phys_addr_t for membank size
Date: Mon, 23 Jul 2012 21:09:09 -0400
Message-ID: <1343092165-9470-8-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343092165-9470-1-git-send-email-cyril@ti.com>
References: <1343092165-9470-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the membank structure's size field to phys_addr_t to allow
banks larger than 4G.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
---
 arch/arm/include/asm/setup.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index 23ebc0c..a2e7581 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -195,8 +195,8 @@ static const struct tagtable __tagtable_##fn __tag = { tag, fn }
 #define NR_BANKS	CONFIG_ARM_NR_BANKS
 
 struct membank {
-	phys_addr_t start;
-	unsigned long size;
+	phys_addr_t  start;
+	phys_addr_t  size;
 	unsigned int highmem;
 };
 
-- 
1.7.9.5

