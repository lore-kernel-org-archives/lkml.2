Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2FWKF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 06:05:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab2FWKFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 06:05:34 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: [PATCH 10/12] feature-removal-schedule.txt: remove kmap_atomic(page, km_type)
Date: Sat, 23 Jun 2012 18:04:21 +0800
Message-Id: <1340445863-16111-11-git-send-email-amwang@redhat.com>
In-Reply-To: <1340445863-16111-1-git-send-email-amwang@redhat.com>
References: <1340445863-16111-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 Documentation/feature-removal-schedule.txt |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 56000b3..2cd5202 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -523,14 +523,6 @@ Who:	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
 
 ----------------------------
 
-What:	kmap_atomic(page, km_type)
-When:	3.5
-Why:	The old kmap_atomic() with two arguments is deprecated, we only
-	keep it for backward compatibility for few cycles and then drop it.
-Who:	Cong Wang <amwang@redhat.com>
-
-----------------------------
-
 What:	get_robust_list syscall
 When:	2013
 Why:	There appear to be no production users of the get_robust_list syscall,
-- 
1.7.7.6

