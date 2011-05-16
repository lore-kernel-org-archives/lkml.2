Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab1EPNkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:40:41 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58875 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab1EPNki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:40:38 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Frank Arnold <farnold@amd64.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/3] Documentation, ABI: Update L3 cache index disable text
Date: Mon, 16 May 2011 15:39:48 +0200
Message-Id: <1305553188-21061-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1305553188-21061-1-git-send-email-bp@amd64.org>
References: <1305553188-21061-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Change contact person to AMD kernel mailing list, update text and
external references, drop "Users:" tag.

Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |   34 ++++++++++----------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 7564e88..e7be75b 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -183,21 +183,21 @@ Description:	Discover and change clock speed of CPUs
 		to learn how to control the knobs.
 
 
-What:      /sys/devices/system/cpu/cpu*/cache/index*/cache_disable_X
-Date:      August 2008
+What:		/sys/devices/system/cpu/cpu*/cache/index3/cache_disable_{0,1}
+Date:		August 2008
 KernelVersion:	2.6.27
-Contact:	mark.langsdorf@amd.com
-Description:	These files exist in every cpu's cache index directories.
-		There are currently 2 cache_disable_# files in each
-		directory.  Reading from these files on a supported
-		processor will return that cache disable index value
-		for that processor and node.  Writing to one of these
-		files will cause the specificed cache index to be disabled.
-
-		Currently, only AMD Family 10h Processors support cache index
-		disable, and only for their L3 caches.  See the BIOS and
-		Kernel Developer's Guide at
-		http://support.amd.com/us/Embedded_TechDocs/31116-Public-GH-BKDG_3-28_5-28-09.pdf	
-		for formatting information and other details on the
-		cache index disable.
-Users:    joachim.deguara@amd.com
+Contact:	discuss@x86-64.org
+Description:	Disable L3 cache indices
+
+		These files exist in every CPU's cache/index3 directory. Each
+		cache_disable_{0,1} file corresponds to one disable slot which
+		can be used to disable a cache index. Reading from these files
+		on a processor with this functionality will return the currently
+		disabled index for that node. There is one L3 structure per
+		node, or per internal node on MCM machines. Writing a valid
+		index to one of these files will cause the specificed cache
+		index to be disabled.
+
+		All AMD processors with L3 caches provide this functionality.
+		For details, see BKDGs at
+		http://developer.amd.com/documentation/guides/Pages/default.aspx
-- 
1.7.4.rc2

