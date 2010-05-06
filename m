Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab0EFRh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:37:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab0EFRhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:37:25 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com,
       Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 07/13] h8300: removing redundant ifdef
Date: Thu,  6 May 2010 19:36:11 +0200
Message-Id: <1273167377-14270-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/h8300/include/asm/tlb.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/arch/h8300/include/asm/tlb.h b/arch/h8300/include/asm/tlb.h
index 3dea80a..6339a02 100644
--- a/arch/h8300/include/asm/tlb.h
+++ b/arch/h8300/include/asm/tlb.h
@@ -7,17 +7,4 @@
 
 #define tlb_flush(tlb)	do { } while(0)
 
-/* 
-  include/asm-h8300/tlb.h 
-*/
-
-#ifndef __H8300_TLB_H__
-#define __H8300_TLB_H__
-
-#define tlb_flush(tlb)	do { } while(0)
-
-#include <asm-generic/tlb.h>
-
-#endif
-
 #endif
-- 
1.6.6.1

