Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab1HRCuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 22:50:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60822 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab1HRCuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 22:50:37 -0400
Message-ID: <4E4C7E16.9090905@cn.fujitsu.com>
Date: Thu, 18 Aug 2011 10:51:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: LKML <linux-kernel@vger.kernel.org>,
        container cgroup <containers@lists.linux-foundation.org>,
        linux-doc@vger.kernel.org, Paul Menage <paul@paulmenage.org>
Subject: [PATCH] cgroups: update documentation on task moving restriction
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 10:49:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 10:49:23,
	Serialize complete at 2011-08-18 10:49:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- ns cgroup has been removed.
- it's true moving a task to another cgroup can fail.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/cgroups/cgroups.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index cd67e90..9c452ef 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -454,8 +454,8 @@ mounted hierarchy, to remove a task from its current cgroup you must
 move it into a new cgroup (possibly the root cgroup) by writing to the
 new cgroup's tasks file.
 
-Note: If the ns cgroup is active, moving a process to another cgroup can
-fail.
+Note: Due to some restrictions enforced by some cgroup subsystems, moving
+a process to another cgroup can fail.
 
 2.3 Mounting hierarchies by name
 --------------------------------
-- 
1.7.3.1
