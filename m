Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab0JROmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:42:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099Ab0JROhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:37:32 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/22] GFS2: No longer experimental
Date: Mon, 18 Oct 2010 15:15:27 +0100
Message-Id: <1287411346-17855-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
References: <1287411346-17855-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the time has arrvied to remove the experimental tag
from GFS2.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
index cc96655..c465ae0 100644
--- a/fs/gfs2/Kconfig
+++ b/fs/gfs2/Kconfig
@@ -1,6 +1,6 @@
 config GFS2_FS
 	tristate "GFS2 file system support"
-	depends on EXPERIMENTAL && (64BIT || LBDAF)
+	depends on (64BIT || LBDAF)
 	select DLM if GFS2_FS_LOCKING_DLM
 	select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
 	select SYSFS if GFS2_FS_LOCKING_DLM
-- 
1.7.1.1

