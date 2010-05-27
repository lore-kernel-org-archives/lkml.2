Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab0E0Ax7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 20:53:59 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:38059 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab0E0Ax5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 20:53:57 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, trivial@kernel.org,
       Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] kernel/power/swap.c: fix typos in comments
Date: Wed, 26 May 2010 21:49:00 -0300
Message-Id: <1274921340-4894-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 kernel/power/swap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 66824d7..5846a02 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -114,7 +114,7 @@ sector_t alloc_swapdev_block(int swap)
 
 /**
  *	free_all_swap_pages - free swap pages allocated for saving image data.
- *	It also frees the extents used to register which swap entres had been
+ *	It also frees the extents used to register which swap entries had been
  *	allocated.
  */
 
@@ -315,7 +315,7 @@ static int write_page(void *buf, sector_t offset, struct bio **bio_chain)
 /*
  *	The swap map is a data structure used for keeping track of each page
  *	written to a swap partition.  It consists of many swap_map_page
- *	structures that contain each an array of MAP_PAGE_SIZE swap entries.
+ *	structures that contain each an array of MAP_PAGE_ENTRIES swap entries.
  *	These structures are stored on the swap and linked together with the
  *	help of the .next_swap member.
  *
-- 
1.6.6.1

