Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab1KDJQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 05:16:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56516 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751830Ab1KDJQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 05:16:38 -0400
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        yinghan@google.com, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] memcg: doc the pagefault count
Date: Fri, 4 Nov 2011 17:15:21 +0800
Message-Id: <1320398121-17336-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.8.rc0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-04 17:16:39,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-04 17:16:40,
	Serialize complete at 2011-11-04 17:16:40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pagefault count has added to memcg stats since commit 456f998e,
but forgot to doc it.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 Documentation/cgroups/memory.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index cc0ebc5..081f4f44 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -389,6 +389,13 @@ mapped_file	- # of bytes of mapped file (includes tmpfs/shmem)
 pgpgin		- # of pages paged in (equivalent to # of charging events).
 pgpgout		- # of pages paged out (equivalent to # of uncharging events).
 swap		- # of bytes of swap usage
+
+pgfault		- # of page-faults
+pgmajfault	- # of major page-faults
+		These two are different from "pgpgin"/"pgpgout" stat which
+		count number of pages charged/discharged to the cgroup and
+		have no meaning of reading/writing page to disk.
+
 inactive_anon	- # of bytes of anonymous memory and swap cache memory on
 		LRU list.
 active_anon	- # of bytes of anonymous and swap cache memory on active
-- 
1.7.8.rc0

