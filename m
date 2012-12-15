Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab2LOEfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 23:35:24 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:53099 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab2LOEfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 23:35:10 -0500
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH 3/3] arch/tile: set CORE_DUMP_USE_REGSET on tilegx
Date: Fri, 14 Dec 2012 23:34:51 -0500
Message-Id: <1355546091-32537-3-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1355546091-32537-1-git-send-email-simon.marchi@polymtl.ca>
References: <1355546091-32537-1-git-send-email-simon.marchi@polymtl.ca>
X-Poly-FromMTA: ([132.207.72.18]) at Sat, 15 Dec 2012 04:34:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the previous patch which adds support for user_regset, tilegx
can now use this feature.

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
 arch/tile/include/asm/elf.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
index f8ccf08..7a793c7 100644
--- a/arch/tile/include/asm/elf.h
+++ b/arch/tile/include/asm/elf.h
@@ -169,4 +169,8 @@ do { \
 
 #endif /* CONFIG_COMPAT */
 
+#ifdef __tilegx__
+#define CORE_DUMP_USE_REGSET
+#endif /* __tilegx__ */
+
 #endif /* _ASM_TILE_ELF_H */
-- 
1.7.1

