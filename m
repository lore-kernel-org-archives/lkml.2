Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab2LQWfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:35:20 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:58276 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab2LQWfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:35:16 -0500
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH v2 3/3] arch/tile: set CORE_DUMP_USE_REGSET on tile
Date: Mon, 17 Dec 2012 17:35:06 -0500
Message-Id: <1355783706-11507-3-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1355783706-11507-1-git-send-email-simon.marchi@polymtl.ca>
References: <1355783706-11507-1-git-send-email-simon.marchi@polymtl.ca>
X-Poly-FromMTA: ([132.207.72.18]) at Mon, 17 Dec 2012 22:35:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the previous patch which adds support for user_regset, tile
can now use this feature.

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
 arch/tile/include/asm/elf.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
index f8ccf08..2b43fa0 100644
--- a/arch/tile/include/asm/elf.h
+++ b/arch/tile/include/asm/elf.h
@@ -169,4 +169,6 @@ do { \
 
 #endif /* CONFIG_COMPAT */
 
+#define CORE_DUMP_USE_REGSET
+
 #endif /* _ASM_TILE_ELF_H */
-- 
1.7.1

