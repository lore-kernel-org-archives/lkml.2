Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab2EOBKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:10:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:11505 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413Ab2EOBKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:10:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="140646363"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH] mm: make validate_mm() static
Date: Tue, 15 May 2012 09:10:47 +0800
Message-Id: <1337044247-4006-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

validate_mm() is just used in mmap.c only, thus make it static.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 mm/mmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 848ef52..3e440f3 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -335,7 +335,7 @@ static int browse_rb(struct rb_root *root)
 	return i;
 }
 
-void validate_mm(struct mm_struct *mm)
+static void validate_mm(struct mm_struct *mm)
 {
 	int bug = 0;
 	int i = 0;
-- 
1.7.7.6

