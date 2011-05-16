Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab1EPVXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:23:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:37261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab1EPVXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:23:09 -0400
Date: Mon, 16 May 2011 21:22:58 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-eecaaba5b2e4ae762b4726fae2e3b22630e137ec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gregkh@suse.de, rdunlap@xenotime.net, tglx@linutronix.de,
        hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gregkh@suse.de, tglx@linutronix.de, rdunlap@xenotime.net,
        hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <1305553188-21061-4-git-send-email-bp@amd64.org>
References: <1305553188-21061-4-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] Documentation, ABI: Update L3 cache index disable text
Git-Commit-ID: eecaaba5b2e4ae762b4726fae2e3b22630e137ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 May 2011 21:22:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eecaaba5b2e4ae762b4726fae2e3b22630e137ec
Gitweb:     http://git.kernel.org/tip/eecaaba5b2e4ae762b4726fae2e3b22630e137ec
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Mon, 16 May 2011 15:39:48 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 16 May 2011 11:24:30 -0700

Documentation, ABI: Update L3 cache index disable text

Change contact person to AMD kernel mailing list, update text and
external references, drop "Users:" tag.

Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1305553188-21061-4-git-send-email-bp@amd64.org
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
