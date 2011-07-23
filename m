Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1GWRjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 13:39:51 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:41176 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753090Ab1GWRjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 13:39:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PJP+D8WmphShjN6SRyCvHMipStQiLF8V8wgAAVnwEJIwoHxjTdblk8YKKWXfDzqpT0badAA8nEF/01AvsP0MDMhIQzy46WyB+tY7V1GI2IXHPEITGGGKVxfhKC9ihEDc;
Date: Sat, 23 Jul 2011 10:38:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH 2/3] Documentation: fix ambigous text for root cpuset
Message-Id: <20110723103817.4550b140.rdunlap@xenotime.net>
In-Reply-To: <20110723103701.635db37d.rdunlap@xenotime.net>
References: <20110723103701.635db37d.rdunlap@xenotime.net>
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

Only the root cpuset has cpuset.memory_pressure_enabled flag,
but not the only one.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Paul Menage <menage@google.com>
---
 Documentation/cgroups/cpusets.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-300.orig/Documentation/cgroups/cpusets.txt
+++ lnx-300/Documentation/cgroups/cpusets.txt
@@ -180,7 +180,7 @@ files describing that cpuset:
  - cpuset.sched_load_balance flag: if set, load balance within CPUs on that cpuset
  - cpuset.sched_relax_domain_level: the searching range when migrating tasks
 
-In addition, the root cpuset only has the following file:
+In addition, only the root cpuset has the following file:
  - cpuset.memory_pressure_enabled flag: compute memory_pressure?
 
 New cpusets are created using the mkdir system call or shell
