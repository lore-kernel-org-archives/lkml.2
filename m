Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab3ACJx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:53:58 -0500
Received: from msa101.auone-net.jp ([61.117.18.161]:50025 "EHLO
	msa101.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3ACJxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:53:55 -0500
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2013 04:53:55 EST
Date: Thu, 3 Jan 2013 18:43:20 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "Documentation: ABI:
 /sys/devices/system/cpu/cpu#/node"
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <20130103094321.0719E3E403B@msa101.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit cba5dd7fa535b7684cba68e17ac8be5b0083dc3d.

Commit cba5dd7fa535b7684cba68e17ac8be5b0083dc3d duplicates
/sys/devices/system/cpu/cpu#/node entry.
Commit 657348a056eea4a27be20cf8e22c98a252597447 has already added it.

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 6943133..9c978dc 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -67,20 +67,6 @@ Description:	Discover NUMA node a CPU belongs to
 		/sys/devices/system/cpu/cpu42/node2 -> ../../node/node2
 
 
-What:		/sys/devices/system/cpu/cpu#/node
-Date:		October 2009
-Contact:	Linux memory management mailing list <linux-mm@kvack.org>
-Description:	Discover NUMA node a CPU belongs to
-
-		When CONFIG_NUMA is enabled, a symbolic link that points
-		to the corresponding NUMA node directory.
-
-		For example, the following symlink is created for cpu42
-		in NUMA node 2:
-
-		/sys/devices/system/cpu/cpu42/node2 -> ../../node/node2
-
-
 What:		/sys/devices/system/cpu/cpu#/topology/core_id
 		/sys/devices/system/cpu/cpu#/topology/core_siblings
 		/sys/devices/system/cpu/cpu#/topology/core_siblings_list
-- 
1.7.10.4

