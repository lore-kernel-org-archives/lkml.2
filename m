Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934221Ab2HWSss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:48:48 -0400
Received: from noserose.net ([66.220.18.76]:52589 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754506Ab2HWSso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:48:44 -0400
Message-Id: <b1a5ec55cc51cde658a01ebae183c604507a8385.1345743802.git.ecashin@coraid.com>
In-Reply-To: <cover.1345743800.git.ecashin@coraid.com>
References: <cover.1345743800.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Date: Thu, 23 Aug 2012 13:36:27 -0400
Subject: [PATCH 14/14] aoe: update documentation with new URL and VM settings reference
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old area has a new URL.  Also, now that the driver can perform
better, it is worth mentioning the VM settings that help aoe to sink
dirty pages out early, avoiding unecessary memory pressure when much
I/O is going on.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 Documentation/aoe/aoe.txt |    9 ++++++---
 MAINTAINERS               |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/aoe/aoe.txt b/Documentation/aoe/aoe.txt
index 5f5aa16..b3e4756 100644
--- a/Documentation/aoe/aoe.txt
+++ b/Documentation/aoe/aoe.txt
@@ -1,8 +1,11 @@
-The EtherDrive (R) HOWTO for users of 2.6 kernels is found at ...
+The EtherDrive (R) HOWTO for 2.6 and 3.x kernels is found at ...
 
-  http://www.coraid.com/SUPPORT/EtherDrive-HBA  
+  http://support.coraid.com/support/linux/EtherDrive-2.6-HOWTO.html
 
-  It has many tips and hints!
+It has many tips and hints!  Please see, especially, recommended
+tunings for virtual memory:
+
+  http://support.coraid.com/support/linux/EtherDrive-2.6-HOWTO-5.html#ss5.19
 
 The aoetools are userland programs that are designed to work with this
 driver.  The aoetools are on sourceforge.
diff --git a/MAINTAINERS b/MAINTAINERS
index fdc0119..917b0d8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1250,7 +1250,7 @@ F:	include/linux/i2c/at24.h
 
 ATA OVER ETHERNET (AOE) DRIVER
 M:	"Ed L. Cashin" <ecashin@coraid.com>
-W:	http://www.coraid.com/support/linux
+W:	http://support.coraid.com/support/linux
 S:	Supported
 F:	Documentation/aoe/
 F:	drivers/block/aoe/
-- 
1.7.2.5

