Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab2FFKyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:54:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55007 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2FFKyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:54:20 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: konrad.wilk@oracle.com, dan.magenheimer@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH 02/11] mm: frontswap: trivial coding convention issues
Date: Wed,  6 Jun 2012 12:55:06 +0200
Message-Id: <1338980115-2394-2-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
References: <1338980115-2394-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/frontswap.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index 07c0eee..844d6a6 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -127,8 +127,9 @@ int __frontswap_put_page(struct page *page)
 		frontswap_clear(sis, offset);
 		atomic_dec(&sis->frontswap_pages);
 		frontswap_failed_puts++;
-	} else
+	} else {
 		frontswap_failed_puts++;
+	}
 	if (frontswap_writethrough_enabled)
 		/* report failure so swap also writes to swap device */
 		ret = -1;
@@ -229,9 +230,9 @@ void frontswap_shrink(unsigned long target_pages)
 	for (type = swap_list.head; type >= 0; type = si->next) {
 		si = swap_info[type];
 		si_frontswap_pages = atomic_read(&si->frontswap_pages);
-		if (total_pages_to_unuse < si_frontswap_pages)
+		if (total_pages_to_unuse < si_frontswap_pages) {
 			pages = pages_to_unuse = total_pages_to_unuse;
-		else {
+		} else {
 			pages = si_frontswap_pages;
 			pages_to_unuse = 0; /* unuse all */
 		}
-- 
1.7.8.6

