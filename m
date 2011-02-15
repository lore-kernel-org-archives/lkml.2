Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab1BOXfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:35:36 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47349 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1BOXfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:35:34 -0500
Date: Wed, 16 Feb 2011 00:35:27 +0100
From: Tim Peters <darksecond@darksecond.nl>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: fixed a braces code style issue
Message-ID: <20110215233526.GA6726@free>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i fixed a braces code style issue on inode.c

Signed-off-by: Tim Peters <mail@darksecond.nl>
---
 fs/btrfs/inode.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fb9bd78..46125c3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -467,11 +467,10 @@ again:
 		 */
 		total_in = (total_in + PAGE_CACHE_SIZE - 1) &
 			~(PAGE_CACHE_SIZE - 1);
-		if (total_compressed >= total_in) {
+		if (total_compressed >= total_in)
 			will_compress = 0;
-		} else {
+		else
 			num_bytes = total_in;
-		}
 	}
 	if (!will_compress && pages) {
 		/*
-- 
1.7.4

