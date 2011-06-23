Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030Ab1FWWI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:08:28 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23874 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759815Ab1FWWI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:08:26 -0400
Date: Thu, 23 Jun 2011 23:59:32 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, linux-karma-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
        Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 04/37] Remove unneeded version.h includes from fs/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106232358330.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h were not needed in fs/ (fs/btrfs/ctree.h and
fs/omfs/file.c).
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/btrfs/ctree.h |    1 -
 fs/omfs/file.c   |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3006287..f30ac05 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -19,7 +19,6 @@
 #ifndef __BTRFS_CTREE__
 #define __BTRFS_CTREE__
 
-#include <linux/version.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/fs.h>
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index d738a7e..2c6d952 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -4,7 +4,6 @@
  * Released under GPL v2.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

