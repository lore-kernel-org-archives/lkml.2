Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab2BJFtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:49:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2BJFs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:48:59 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: [PATCH 60/60] feature-removal-schedule.txt: schedule the deprecated form of kmap_atomic() for removal
Date: Fri, 10 Feb 2012 13:40:21 +0800
Message-Id: <1328852421-19678-61-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cong Wang <amwang@redhat.com>
---
 Documentation/feature-removal-schedule.txt |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index a0ffac0..7465332 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -524,3 +524,11 @@ Files:	arch/arm/mach-at91/at91cap9.c
 Why:	The code is not actively maintained and platforms are now hard to find.
 Who:	Nicolas Ferre <nicolas.ferre@atmel.com>
 	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
+
+----------------------------
+
+What:	kmap_atomic(page, km_type)
+When:	3.5
+Why:	The old kmap_atomic() with two arguments is deprecated, we only
+	keep it for backward compatibility for few cycles and then drop it.
+Who:	Cong Wang <amwang@redhat.com>
-- 
1.7.7.6

