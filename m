Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab1FQI7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:59:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:56142 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757651Ab1FQI5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:57:18 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 04/10] ia64: change xlate_dev_mem_ptr's argument to phys_addr_t
Date: Fri, 17 Jun 2011 10:45:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc2-0.0.5.bd76874-default; KDE/4.6.0; i686; ; )
References: <201106171038.25988.ptesarik@suse.cz>
In-Reply-To: <201106171038.25988.ptesarik@suse.cz>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171045.38996.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No further changes are needed on ia64, because phys_addr_t is always
64-bit here, hence the same size as an unsigned long.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
---
 arch/ia64/include/asm/uaccess.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/uaccess.h b/arch/ia64/include/asm/uaccess.h
index 449c8c0..930717e 100644
--- a/arch/ia64/include/asm/uaccess.h
+++ b/arch/ia64/include/asm/uaccess.h
@@ -366,7 +366,7 @@ ia64_done_with_exception (struct pt_regs *regs)
 
 #define ARCH_HAS_TRANSLATE_MEM_PTR	1
 static __inline__ char *
-xlate_dev_mem_ptr (unsigned long p)
+xlate_dev_mem_ptr (phys_addr_t p)
 {
 	struct page *page;
 	char * ptr;
-- 
1.7.3.4
