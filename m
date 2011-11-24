Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1KXAkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 19:40:13 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53721 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab1KXAkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 19:40:10 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Nov 2011 09:38:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        Daisuke Nishimura <nishmura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>
Subject: [PATCH] update memory cgroup maintainer
Message-Id: <20111124093857.c350d90f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4bd0eecce89671dc379c17d66e010ce97d4bcba5 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 24 Nov 2011 09:41:31 +0900
Subject: [PATCH] update memory cgroup maintainer.

More players joined to memory cgroup developments and Johannes'
great work changed internal design of memory cgroup dramatically.
And he will do more works. Michal Hokko did many bug fixes and
know memory cgroup very well. Daisuke Nishimura helped us very
much but he seems busy now. Thanks to his works.


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 MAINTAINERS |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3523ab0..6d2a8db 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4311,8 +4311,9 @@ F:	include/linux/mm.h
 F:	mm/
 
 MEMORY RESOURCE CONTROLLER
+M:	Johannes Weiner <hannes@cmpxchg.org>
+M:	Michal Hocko <mhocko@suse.cz>
 M:	Balbir Singh <bsingharora@gmail.com>
-M:	Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
 M:	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
-- 
1.7.4.1


