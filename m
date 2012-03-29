Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936615Ab2C3Wvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:51:45 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934984Ab2C3VGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:10 -0400
Message-Id: <201203302105.q2UL57B5006304@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 16:19:45 -0400
Subject: [PATCH] arch/tile: export the page_home() function.
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:08.0085 (UTC) FILETIME=[C97DD250:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/homecache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index 1cc6ae4..499f737 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -394,6 +394,7 @@ int page_home(struct page *page)
 		return pte_to_home(*virt_to_pte(NULL, kva));
 	}
 }
+EXPORT_SYMBOL(page_home);
 
 void homecache_change_page_home(struct page *page, int order, int home)
 {
-- 
1.6.5.2

