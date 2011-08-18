Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab1HRTJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:09:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47527 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1HRTJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:09:00 -0400
Date: Thu, 18 Aug 2011 20:08:59 +0100
To: richard@nod.at
Subject: Subject: [PATCH 60/91] um: kill useless include of user.h
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7xb-0007sY-Pq@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


everything in USER_OBJ gets it via -include user.h

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/hostfs/hostfs_user.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/hostfs/hostfs_user.c b/fs/hostfs/hostfs_user.c
index d51a983..dd7bc38 100644
--- a/fs/hostfs/hostfs_user.c
+++ b/fs/hostfs/hostfs_user.c
@@ -16,7 +16,6 @@
 #include <sys/vfs.h>
 #include "hostfs.h"
 #include "os.h"
-#include "user.h"
 #include <utime.h>
 
 static void stat64_to_hostfs(const struct stat64 *buf, struct hostfs_stat *p)
-- 
1.7.2.5


