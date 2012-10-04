Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2JDKYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:24:17 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:38074 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab2JDKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:24:14 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org
Subject: [PATCH 1/3] vmevent: Remove unused code
Date: Thu,  4 Oct 2012 03:21:16 -0700
Message-Id: <1349346078-24874-1-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <20121004102013.GA23284@lizard>
References: <20121004102013.GA23284@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct vmevent_watch_event and a few definitions are not used anywhere, so
let's remove them.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 mm/vmevent.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/mm/vmevent.c b/mm/vmevent.c
index a7f1042..39ef786 100644
--- a/mm/vmevent.c
+++ b/mm/vmevent.c
@@ -11,16 +11,6 @@
 #include <linux/swap.h>
 #undef nr_swap_pages /* This is defined to a constant for SWAP=n case */
 
-#define VMEVENT_MAX_FREE_THRESHOD	100
-
-#define VMEVENT_MAX_EATTR_ATTRS	64
-
-struct vmevent_watch_event {
-	u64				nr_avail_pages;
-	u64				nr_free_pages;
-	u64				nr_swap_pages;
-};
-
 struct vmevent_watch {
 	struct vmevent_config		config;
 
-- 
1.7.12.1

