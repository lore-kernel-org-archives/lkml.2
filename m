Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab1JDQvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:51:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab1JDQoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:44:15 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Mark Salter <msalter@redhat.com>
Subject: [PATCH v4 04/24] add missing __iomem to generic iounmap declaration
Date: Tue,  4 Oct 2011 12:43:41 -0400
Message-Id: <1317746641-26725-5-git-send-email-msalter@redhat.com>
In-Reply-To: <1317746641-26725-1-git-send-email-msalter@redhat.com>
References: <1317746641-26725-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/io.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 9120887..c2cf2ed 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -327,7 +327,7 @@ static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 #define ioremap_wc ioremap_nocache
 #endif
 
-static inline void iounmap(void *addr)
+static inline void iounmap(void __iomem *addr)
 {
 }
 #endif /* CONFIG_MMU */
-- 
1.7.6.2

