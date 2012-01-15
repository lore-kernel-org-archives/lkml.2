Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2AOUM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 15:12:26 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23717 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2AOUMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 15:12:25 -0500
Date: Sun, 15 Jan 2012 21:12:23 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: dm-devel@redhat.com
cc: Mikulas Patocka <mpatocka@redhat.com>, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH] There's no need to include linux/version.h in
 drivers/md/dm-bufio.c
Message-ID: <alpine.LNX.2.00.1201152110290.13389@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As 'make versioncheck' points out, drivers/md/dm-bufio.c has no need
to include linux/version.h, so this patch removes the unneeded
include.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/md/dm-bufio.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 0a6806f..b6e58c7 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -12,7 +12,6 @@
 #include <linux/dm-io.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include <linux/version.h>
 #include <linux/shrinker.h>
 #include <linux/module.h>
 
-- 
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

