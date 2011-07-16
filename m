Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1GPIpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 04:45:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36864 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab1GPIp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 04:45:29 -0400
Date: Sat, 16 Jul 2011 16:45:13 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: greg@kroah.com
Cc: rdunlap@xenotime.net, linux-kernel@vger.kernel.org, harryxiyou@gmail.com,
        kongjianjun@gmail.com, joe@perches.com, akpm@linux-fondation.org
Subject: [PATCH]Fix a comment mistake
Message-ID: <20110716084511.GB4941@gmail.com>
Mail-Followup-To: greg@kroah.com, rdunlap@xenotime.net,
	linux-kernel@vger.kernel.org, harryxiyou@gmail.com,
	kongjianjun@gmail.com, joe@perches.com, akpm@linux-fondation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harry Wei <harryxiyou@gmail.com>

The file is fs/debugfs/inode.c but the comment says it is file.c.
This patch can fix this little mistake.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 fs/debugfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index e7a7a2f..f3a257d 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -1,5 +1,5 @@
 /*
- *  file.c - part of debugfs, a tiny little debug file system
+ *  inode.c - part of debugfs, a tiny little debug file system
  *
  *  Copyright (C) 2004 Greg Kroah-Hartman <greg@kroah.com>
  *  Copyright (C) 2004 IBM Inc.
-- 
1.7.0.4

