Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab1GWRq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 13:46:26 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:55206 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753100Ab1GWRqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 13:46:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=YneG6lfCGShE+gsTmDjQwBTvD8BkgLqs02Xuvpc1Yv2IryMg0Q5VL3iubO+93jVdaU/xR1heY5yP7UFrfaqRWch59AG29Oss4i7kkX40yBSKvERA4YDsryJpfBVd5u2A;
Date: Sat, 23 Jul 2011 10:37:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH 1/3] Documentation: fix echo command in cgroups/cpuacct.txt
Message-Id: <20110723103701.635db37d.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Must echo a task id to the cgroups' tasks file, but not to a directory.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/cgroups/cpuacct.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-300.orig/Documentation/cgroups/cpuacct.txt
+++ lnx-300/Documentation/cgroups/cpuacct.txt
@@ -23,7 +23,7 @@ New accounting groups can be created und
 
 # cd /sys/fs/cgroup
 # mkdir g1
-# echo $$ > g1
+# echo $$ > g1/tasks
 
 The above steps create a new group g1 and move the current shell
 process (bash) into it. CPU time consumed by this bash and its children
