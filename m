Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab0CRWGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:06:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2563 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab0CRWGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:06:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=muSIKZ1wGrj2KrFKVgEdzoz9plR/rAwepIsw4uR9hZo2SsBsSrYwSJZlgJ8aByF7B
	Ud/wgk2LOT7t7gnyej0HQ==
From: Greg Thelen <gthelen@google.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH] memcg: fix typo in memcg documentation
Date: Thu, 18 Mar 2010 15:04:39 -0700
Message-Id: <1268949879-29478-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated memory.txt to be more consistent: s/swapiness/swappiness/

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 Documentation/cgroups/memory.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index f8bc802..3a6aecd 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -340,7 +340,7 @@ Note:
 5.3 swappiness
   Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
 
-  Following cgroups' swapiness can't be changed.
+  Following cgroups' swappiness can't be changed.
   - root cgroup (uses /proc/sys/vm/swappiness).
   - a cgroup which uses hierarchy and it has child cgroup.
   - a cgroup which uses hierarchy and not the root of hierarchy.
-- 
1.7.0.1

