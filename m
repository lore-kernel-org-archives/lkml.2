Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1KDA6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 20:58:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38416 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1KDA6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 20:58:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Nov 2011 09:40:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        cgroups@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        bsingharora@gmail.com, nishimura@mxp.nes.nec.co.jp,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, glommer@parallels.com, tj@kernel.org,
        akpm@linux-foundation.org, oleg@redhat.com, mk@cm4all.com,
        fweisbec@gmail.com, James.Bottomley@HansenPartnership.com
Subject: [PATCH] add new cgroup list to CC notice
Message-Id: <20111104094030.cf8d5860.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed at Kernel Summit(2011), new cgroups mailing list is opened by
James. This list is for discussing general cgroup design and patches
including all subsystems and for getting more attentions to cgroups/namespaces
related issues by developpers.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ab77670..2d6b4ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1927,6 +1927,7 @@ CONTROL GROUPS (CGROUPS)
 M:	Paul Menage <paul@paulmenage.org>
 M:	Li Zefan <lizf@cn.fujitsu.com>
 L:	containers@lists.linux-foundation.org
+L:	cgroups@vger.kernel.org
 S:	Maintained
 F:	include/linux/cgroup*
 F:	kernel/cgroup*
@@ -4294,6 +4295,7 @@ MEMORY RESOURCE CONTROLLER
 M:	Balbir Singh <bsingharora@gmail.com>
 M:	Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
 M:	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
+L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/memcontrol.c
-- 
1.7.4.1


