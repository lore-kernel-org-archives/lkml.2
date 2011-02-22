Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab1BVW2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:28:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:2718 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973Ab1BVW2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:28:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,208,1297065600"; 
   d="scan'208";a="890223783"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linuxtronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Update high resolution timers doc to include supported archs
Date: Tue, 22 Feb 2011 14:28:05 -0800
Message-Id: <1298413685-4271-1-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the original document was authored, MIPS and PowerPC (with the possible
exception of some ancient hardware) have been fully migrated to high resolution
timers.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Thomas Gleixner <tglx@linuxtronix.de>
CC: Ingo Molnar <mingo@elte.hu>
---
 Documentation/timers/highres.txt |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/timers/highres.txt b/Documentation/timers/highres.txt
index 2133223..44e36bf 100644
--- a/Documentation/timers/highres.txt
+++ b/Documentation/timers/highres.txt
@@ -239,9 +239,8 @@ systems, where the time slice is controlled by the scheduler, variable
 frequency profiling, and a complete removal of jiffies in the future.
 
 
-Aside the current initial submission of i386 support, the patchset has been
-extended to x86_64 and ARM already. Initial (work in progress) support is also
-available for MIPS and PowerPC.
+Following the initial i386 submission, support has been extended to x86_64, ARM,
+PowerPC, and MIPS.
 
 	  Thomas, Ingo
 
-- 
1.7.1

