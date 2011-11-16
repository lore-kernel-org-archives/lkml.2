Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab1KPTpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:45:08 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39246 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1KPTpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:45:06 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        William Irwin <wli@holomorphy.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH] hugetlb: Provide a default HPAGE_SHIFT if !CONFIG_HUGETLB_PAGE
Date: Wed, 16 Nov 2011 11:43:31 -0800
Message-Id: <1321472611-13283-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

This is required now to get MIPS kernels to compile with
!CONFIG_HUGETLB_PAGE.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 include/linux/hugetlb.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 19644e0..746d543 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -113,6 +113,7 @@ static inline void copy_huge_page(struct page *dst, struct page *src)
 #ifndef HPAGE_MASK
 #define HPAGE_MASK	PAGE_MASK		/* Keep the compiler happy */
 #define HPAGE_SIZE	PAGE_SIZE
+#define HPAGE_SHIFT	PAGE_SHIFT
 #endif
 
 #endif /* !CONFIG_HUGETLB_PAGE */
-- 
1.7.2.3

