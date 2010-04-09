Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0DIDPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 23:15:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52518 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab0DIDPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 23:15:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 9 Apr 2010 12:11:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       stable@kernel.org
Subject: [PATCH] fix cgroup procs documentation
Message-Id: <20100409121143.9610dc8f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33's Documentation has the same wrong information. So, I CC'ed to stable.
If people believe this information, they'll usr cgroup.procs file and will
see cgroup doesn'w work as expected.
The patch itself is against -mm.

==
Writing to cgroup.procs is not supported now.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 Documentation/cgroups/cgroups.txt |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: mmotm-temp/Documentation/cgroups/cgroups.txt
===================================================================
--- mmotm-temp.orig/Documentation/cgroups/cgroups.txt
+++ mmotm-temp/Documentation/cgroups/cgroups.txt
@@ -235,8 +235,7 @@ containing the following files describin
  - cgroup.procs: list of tgids in the cgroup.  This list is not
    guaranteed to be sorted or free of duplicate tgids, and userspace
    should sort/uniquify the list if this property is required.
-   Writing a tgid into this file moves all threads with that tgid into
-   this cgroup.
+   This is a read-only file, now.
  - notify_on_release flag: run the release agent on exit?
  - release_agent: the path to use for release notifications (this file
    exists in the top cgroup only)

