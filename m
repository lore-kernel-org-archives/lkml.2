Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2FJKuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 06:50:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64361 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab2FJKuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 06:50:05 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v3 02/10] mm: frontswap: trivial coding convention issues
Date: Sun, 10 Jun 2012 12:51:00 +0200
Message-Id: <1339325468-30614-3-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com>
References: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/frontswap.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index 557e8af4..7ec53d5 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -148,8 +148,9 @@ int __frontswap_store(struct page *page)
 		frontswap_clear(sis, offset);
 		atomic_dec(&sis->frontswap_pages);
 		inc_frontswap_failed_stores();
-	} else
+	} else {
 		inc_frontswap_failed_stores();
+	}
 	if (frontswap_writethrough_enabled)
 		/* report failure so swap also writes to swap device */
 		ret = -1;
@@ -250,9 +251,9 @@ void frontswap_shrink(unsigned long target_pages)
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

