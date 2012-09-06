Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab2IFJJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 05:09:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35913 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab2IFJJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 05:09:55 -0400
MIME-Version: 1.0
Date: Thu, 6 Sep 2012 17:09:53 +0800
Message-ID: <CAFNq8R56EXJx3X7C1AAe4xr7AaNGkFNJ2SoOELFF483q1uRk8A@mail.gmail.com>
Subject: [PATCH 1/2] mm: Fixup obsolete PG_buddy flag in error_states[]
From: Li Haifeng <omycle@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PG_buddy, an abandoned flag, indicates page(s) is/are free
and in buddy allocator. So in the comment, "pages in
buddy system" instead of "PG_buddy pages".

Signed-off-by: Haifeng Li <omycle@gmail.com>
---
 mm/memory-failure.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ab1e714..2873498 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -762,7 +762,8 @@ static struct page_state {
        { reserved,     reserved,       "reserved kernel",      me_kernel },
        /*
         * free pages are specially detected outside this table:
-        * PG_buddy pages only make a small fraction of all free pages.
+        * pages in buddy system only make a small fraction of all
+        * free pages.
         */

        /*
--
1.7.5.4
