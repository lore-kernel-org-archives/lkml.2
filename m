Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab2JPTOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:14:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab2JPTOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:14:01 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 06/10] ext4: ialloc: Fixed coding style issue
Date: Wed, 17 Oct 2012 00:43:01 +0530
Message-Id: <1350414785-7848-6-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed one of checkpatch.pl reported issue

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.7-rc1/fs/ext4/ialloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/linux-3.7-rc1/fs/ext4/ialloc.c b/linux-3.7-rc1/fs/ext4/ialloc.c
index fa36372..2e63f4a 100644
--- a/linux-3.7-rc1/fs/ext4/ialloc.c
+++ b/linux-3.7-rc1/fs/ext4/ialloc.c
@@ -1086,7 +1086,7 @@ unsigned long ext4_count_free_inodes(struct super_block *sb)
 }
 
 /* Called at mount-time, super-block is locked */
-unsigned long ext4_count_dirs(struct super_block * sb)
+unsigned long ext4_count_dirs(struct super_block *sb)
 {
 	unsigned long count = 0;
 	ext4_group_t i, ngroups = ext4_get_groups_count(sb);
-- 
1.7.7.3

