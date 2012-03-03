Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab2CCON7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 09:13:59 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37632 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab2CCON6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 09:13:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alex.mihai.c@gmail.com designates 10.213.12.211 as permitted sender) smtp.mail=alex.mihai.c@gmail.com; dkim=pass header.i=alex.mihai.c@gmail.com
From: Copot Alexandru <alex.mihai.c@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Copot Alexandru <alex.mihai.c@gmail.com>
Subject: [PATCH] mm: fix spelling error
Date: Sat,  3 Mar 2012 16:13:16 +0200
Message-Id: <1330783996-7955-1-git-send-email-alex.mihai.c@gmail.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Copot Alexandru <alex.mihai.c@gmail.com>
---
 mm/vmscan.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c52b235..8a7c989 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2250,13 +2250,13 @@ static bool shrink_zones(int priority, struct zonelist *zonelist,
 				continue;	/* Let kswapd poll it */
 			if (COMPACTION_BUILD) {
 				/*
-				 * If we already have plenty of memory free for
-				 * compaction in this zone, don't free any more.
-				 * Even though compaction is invoked for any
-				 * non-zero order, only frequent costly order
-				 * reclamation is disruptive enough to become a
-				 * noticable problem, like transparent huge page
-				 * allocations.
+				 * If we already have plenty of memory free
+				 * for compaction in this zone, don't free any
+				 * more.  Even though compaction is invoked
+				 * for any non-zero order, only frequent
+				 * costly order reclamation is disruptive
+				 * enough to become a noticeable problem, like
+				 * transparent huge page allocations.
 				 */
 				if (compaction_ready(zone, sc)) {
 					aborted_reclaim = true;
-- 
1.7.6.3

