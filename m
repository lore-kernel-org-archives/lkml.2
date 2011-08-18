Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab1HRQhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:37:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47493 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab1HRQhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:37:07 -0400
Date: Thu, 18 Aug 2011 18:37:02 +0200
From: Tejun Heo <tj@kernel.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] s390: fix _TIF_SINGLE_STEP definition
Message-ID: <20110818163702.GF20085@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_TIF_SINGLE_STEP is incorrectly defined as 1<<TIF_FREEZE.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/s390/include/asm/thread_info.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: work/arch/s390/include/asm/thread_info.h
===================================================================
--- work.orig/arch/s390/include/asm/thread_info.h
+++ work/arch/s390/include/asm/thread_info.h
@@ -117,7 +117,7 @@ static inline struct thread_info *curren
 #define _TIF_SIE		(1<<TIF_SIE)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_31BIT		(1<<TIF_31BIT)
-#define _TIF_SINGLE_STEP	(1<<TIF_FREEZE)
+#define _TIF_SINGLE_STEP	(1<<TIF_SINGLE_STEP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #ifdef CONFIG_64BIT
