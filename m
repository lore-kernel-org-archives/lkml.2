Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab1EXNeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:34:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64740 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab1EXNeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:34:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=EbNlcuetUvrgmiEe+prbFo34qO0bvUYJ8Mf+Re3yqyCBBicX6dqeG3reX5DHOc42oF
         itwl3SNK9gOGmCAZRsTTKHPpIvXVheburoIbGaDRNMCYzJBWWS/X3EG+fO263Do0QqiR
         1in06nSN6Tg/QhViJVVkC6PXDPmbDqUJGSis4=
Date: Tue, 24 May 2011 15:34:14 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: [PATCH] set_migratetype_isolate: remove unused variable.
Message-ID: <20110524133414.GA11674@nb-core2.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
---
 mm/page_alloc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9d5498e..bcbdaf1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5508,10 +5508,8 @@ int set_migratetype_isolate(struct page *page)
 	struct memory_isolate_notify arg;
 	int notifier_ret;
 	int ret = -EBUSY;
-	int zone_idx;
 
 	zone = page_zone(page);
-	zone_idx = zone_idx(zone);
 
 	spin_lock_irqsave(&zone->lock, flags);
 
-- 
1.7.5.1
