Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab2FHTOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 15:14:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62667 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab2FHTOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 15:14:44 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v2 02/10] mm: frontswap: trivial coding convention issues
Date: Fri,  8 Jun 2012 21:15:11 +0200
Message-Id: <1339182919-11432-3-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339182919-11432-1-git-send-email-levinsasha928@gmail.com>
References: <1339182919-11432-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/frontswap.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index 557e8af4..b619d29 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -150,6 +150,7 @@ int __frontswap_store(struct page *page)
 		inc_frontswap_failed_stores();
 	} else
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

