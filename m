Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab0LOC2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 21:28:40 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48798 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab0LOC2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 21:28:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=uGn+9otwlNg9IeypZL52XPIVu5o/5dArjf0zpVgcsGCkNUvZZZ3JufsUyIYeJmLpst
         sLgfYIUC6AUXDrGJrIKH68LdhG6elXIA4x5RqAhofJDnCKkTrJrtFSa9qm9vAgbv9UZT
         ZsmWv1Pu+7kGre/OI+sW46UioW/Im46Me6nsA=
From: Trevor Woerner <twoerner@gmail.com>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Trevor Woerner <twoerner@gmail.com>
Subject: [PATCH cgroups] Remove deprecated subsystem from examples.
Date: Tue, 14 Dec 2010 21:28:08 -0500
Message-Id: <1292380088-2604-1-git-send-email-twoerner@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trevor Woerner <twoerner@gmail.com>

The 'ns' cgroup is considered deprecated. Change the cgroup subsystem
used in the examples of the cgroup documentation from 'ns' to 'blkio'.

Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Trevor Woerner <twoerner@gmail.com>
---
 Documentation/cgroups/cgroups.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 190018b..44b8b7a 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -355,13 +355,13 @@ subsystems, type:
 
 To change the set of subsystems bound to a mounted hierarchy, just
 remount with different options:
-# mount -o remount,cpuset,ns hier1 /dev/cgroup
+# mount -o remount,cpuset,blkio hier1 /dev/cgroup
 
-Now memory is removed from the hierarchy and ns is added.
+Now memory is removed from the hierarchy and blkio is added.
 
-Note this will add ns to the hierarchy but won't remove memory or
+Note this will add blkio to the hierarchy but won't remove memory or
 cpuset, because the new options are appended to the old ones:
-# mount -o remount,ns /dev/cgroup
+# mount -o remount,blkio /dev/cgroup
 
 To Specify a hierarchy's release_agent:
 # mount -t cgroup -o cpuset,release_agent="/sbin/cpuset_release_agent" \
-- 
1.7.1

