Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab1KDSWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 14:22:52 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:60978 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751603Ab1KDSWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 14:22:51 -0400
Message-ID: <4EB42D4D.9050104@xenotime.net>
Date: Fri, 04 Nov 2011 11:22:05 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>
Subject: [PATCH 1/8] Documentation: update cgroups notes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

- ns cgroup has been removed.
- it's true moving a task to another cgroup can fail.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <paul@paulmenage.org>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/cgroups/cgroups.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx1104.orig/Documentation/cgroups/cgroups.txt
+++ lnx1104/Documentation/cgroups/cgroups.txt
@@ -454,8 +454,8 @@ mounted hierarchy, to remove a task from
 move it into a new cgroup (possibly the root cgroup) by writing to the
 new cgroup's tasks file.
 
-Note: If the ns cgroup is active, moving a process to another cgroup can
-fail.
+Note: Due to some restrictions enforced by some cgroup subsystems, moving
+a process to another cgroup can fail.
 
 2.3 Mounting hierarchies by name
 --------------------------------
