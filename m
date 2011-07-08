Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab1GHFZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:25:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63286 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab1GHFZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:25:38 -0400
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Paul Menage <menage@google.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] Documentation:cgroups:fix a  command error in cpuacct.txt
Date: Fri, 8 Jul 2011 13:24:36 +0800
Message-Id: <1310102676-23154-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-08 13:24:57,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-08 13:24:57,
	Serialize complete at 2011-07-08 13:24:57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Must echo a task id to the cgroups' tasks file, but not to a directory.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 Documentation/cgroups/cpuacct.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/cpuacct.txt b/Documentation/cgroups/cpuacct.txt
index 9ad85df..9d73cc0 100644
--- a/Documentation/cgroups/cpuacct.txt
+++ b/Documentation/cgroups/cpuacct.txt
@@ -23,7 +23,7 @@ New accounting groups can be created under the parent group /sys/fs/cgroup.
 
 # cd /sys/fs/cgroup
 # mkdir g1
-# echo $$ > g1
+# echo $$ > g1/tasks
 
 The above steps create a new group g1 and move the current shell
 process (bash) into it. CPU time consumed by this bash and its children
-- 
1.7.6

