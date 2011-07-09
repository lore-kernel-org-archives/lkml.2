Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1GIIL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 04:11:59 -0400
Received: from gw.minian.org ([83.96.227.91]:58791 "EHLO lab.minian.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752468Ab1GIIL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 04:11:58 -0400
From: Edwin van Vliet <edwin@cheatah.nl>
To: anton@tuxera.com
Cc: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Edwin van Vliet <edwin@cheatah.nl>
Subject: [PATCH] fs/ntfs/logfile: Fix comment
Date: Sat,  9 Jul 2011 10:08:57 +0200
Message-Id: <1310198937-1223-1-git-send-email-edwin@cheatah.nl>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed double comment line

Signed-off-by: Edwin van Vliet <edwin@cheatah.nl>
---
 fs/ntfs/logfile.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ntfs/logfile.c b/fs/ntfs/logfile.c
index c71de29..d2e053b 100644
--- a/fs/ntfs/logfile.c
+++ b/fs/ntfs/logfile.c
@@ -506,7 +506,6 @@ bool ntfs_check_logfile(struct inode *log_vi, RESTART_PAGE_HEADER **rp)
 	/*
 	 * Truncate size to a multiple of the page cache size or the default
 	 * log page size if the page cache size is between the default log page
-	 * log page size if the page cache size is between the default log page
 	 * size and twice that.
 	 */
 	if (PAGE_CACHE_SIZE >= DefaultLogPageSize && PAGE_CACHE_SIZE <=
-- 
1.7.5.4

