Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab0EFRhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:37:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759263Ab0EFRhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:37:38 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com,
       Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 02/13] ia64: removing redundant ifdef
Date: Thu,  6 May 2010 19:36:06 +0200
Message-Id: <1273167377-14270-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/ia64/include/asm/mmzone.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/include/asm/mmzone.h b/arch/ia64/include/asm/mmzone.h
index f2ca320..e0de617 100644
--- a/arch/ia64/include/asm/mmzone.h
+++ b/arch/ia64/include/asm/mmzone.h
@@ -19,16 +19,12 @@
 
 static inline int pfn_to_nid(unsigned long pfn)
 {
-#ifdef CONFIG_NUMA
 	extern int paddr_to_nid(unsigned long);
 	int nid = paddr_to_nid(pfn << PAGE_SHIFT);
 	if (nid < 0)
 		return 0;
 	else
 		return nid;
-#else
-	return 0;
-#endif
 }
 
 #ifdef CONFIG_IA64_DIG /* DIG systems are small */
-- 
1.6.6.1

