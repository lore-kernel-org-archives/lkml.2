Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab1CCBRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:17:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42006 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab1CCBRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:17:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:organization:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sV2Gl+c5qyfhbf0uQVEBAeEFTdntmsZy2VWwJxqKHM2O+KAhmOF+bMa/ZDgHt5Nc5e
         8zd7Ea6//SSXn5ge+p5PG80/G9EABrX8HOCl5BX+yT4ZPh5Swga6mLllx/vm6FyqRnyD
         bAzgqbjTYVxxpsAj/tKZyOzxJ2FJmEN1l9sgU=
Subject: [PATCH 1/2] [TRIVIAL] Update cpuset info & webiste via cgroup.
From: GeunSik Lim <leemgs1@gmail.com>
Reply-To: leemgs1@gmail.com
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Private
Date: Thu, 03 Mar 2011 10:16:54 +0900
Message-Id: <1299115014.10998.18.camel@centos55>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>From ed826530c41dad5abd567423877672c838fa4d73 Mon Sep 17 00:00:00 2001
From: Geunsik Lim <leemgs1@gmail.com>
Date: Thu, 3 Mar 2011 09:48:27 +0900
Subject: [PATCH 1/2] Update cpuset info & webiste via cgroup.

cpuset related websited is changed.
and, update list of cpuset using cgroup(controller group).

Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 Documentation/cgroups/cpusets.txt |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
index 5d0d569..98a3082 100644
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -693,7 +693,7 @@ There are ways to query or modify cpusets:
  - via the C library libcgroup.
    (http://sourceforge.net/projects/libcg/)
  - via the python application cset.
-   (http://developer.novell.com/wiki/index.php/Cpuset)
+   (http://code.google.com/p/cpuset/)
 
 The sched_setaffinity calls can also be done at the shell prompt using
 SGI's runon or Robert Love's taskset.  The mbind and set_mempolicy
@@ -725,13 +725,14 @@ Now you want to do something with this cpuset.
 
 In this directory you can find several files:
 # ls
-cpuset.cpu_exclusive       cpuset.memory_spread_slab
-cpuset.cpus                cpuset.mems
-cpuset.mem_exclusive       cpuset.sched_load_balance
-cpuset.mem_hardwall        cpuset.sched_relax_domain_level
-cpuset.memory_migrate      notify_on_release
-cpuset.memory_pressure     tasks
-cpuset.memory_spread_page
+cgroup.clone_children  cpuset.memory_pressure
+cgroup.event_control   cpuset.memory_spread_page
+cgroup.procs           cpuset.memory_spread_slab
+cpuset.cpu_exclusive   cpuset.mems
+cpuset.cpus            cpuset.sched_load_balance
+cpuset.mem_exclusive   cpuset.sched_relax_domain_level
+cpuset.mem_hardwall    notify_on_release
+cpuset.memory_migrate  tasks
 
 Reading them will give you information about the state of this cpuset:
 the CPUs and Memory Nodes it can use, the processes that are using
-- 
1.6.2.5

 

-----------------------------------------------
To unsubscribe from this list: send the line "unsubscribe linux-***" 
in the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

GeunSik Lim ( Samsung Electronics )
e-Mail  :1) geunsik.lim@samsung.com
         2) leemgs@gmail.com , leemgs1@gmail.com
HomePage: http://blog.naver.com/invain/
-----------------------------------------------

