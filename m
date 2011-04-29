Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab1D2OhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:37:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab1D2OhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:37:12 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Update KCONFIG entry
Date: Fri, 29 Apr 2011 16:37:02 +0200
Message-Id: <1304087822-22853-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel hasn't been active for several years. Add myself as kconfig
maintainer, but change the mode to "Odd Fixes" to not set expectations
too high. Also, remove the patchwork link, since it is not used for
kbuild/kconfig.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 CREDITS     |    4 ++++
 MAINTAINERS |    5 ++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/CREDITS b/CREDITS
index 1d39a6d..d6585ab 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3913,6 +3913,10 @@ S: Flandernstrasse 101
 S: D-73732 Esslingen
 S: Germany
 
+N: Roman Zippel
+E: zippel@linux-m68k.org
+D: AFFS and HFS filesystems, m68k maintainer, new kernel configuration in 2.5
+
 N: Leonard N. Zubkoff
 W: http://www.dandelion.com/Linux/
 D: BusLogic SCSI driver
diff --git a/MAINTAINERS b/MAINTAINERS
index 6b4b9cd..0398ba5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3577,10 +3577,9 @@ F:	Documentation/hwmon/k8temp
 F:	drivers/hwmon/k8temp.c
 
 KCONFIG
-M:	Roman Zippel <zippel@linux-m68k.org>
+M:	Michal Marek <mmarek@suse.cz>
 L:	linux-kbuild@vger.kernel.org
-Q:	http://patchwork.kernel.org/project/linux-kbuild/list/
-S:	Maintained
+S:	Odd Fixes
 F:	Documentation/kbuild/kconfig-language.txt
 F:	scripts/kconfig/
 
-- 
1.7.4.1

