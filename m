Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab2LCGbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 01:31:52 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53632 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab2LCGbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 01:31:50 -0500
From: Hyeonjun Lim <hjoon0510@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Doc: Update the naming of profiling based on sysfs
Date: Mon,  3 Dec 2012 15:31:31 +0900
Message-Id: <1354516291-15589-1-git-send-email-hjoon0510@gmail.com>
X-Mailer: git-send-email 1.7.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We setup and run 'profiling' feature under Linux system.
The readprofile(1) command uses the /proc/profile information
to display ascii data on standard output.
sort -nr | head -5

/proc/profile correctly. The ./kernel/ksysfs.c defines 'profiling'
w/o 'profile' like "KERNEL_ATTR_RW(profiling)".
We need to synchronize the content between ksys.c source and kernel doc. 

Signed-off-by: Hyeonjun Lim <hjoon0510@gmail.com>
---
 Documentation/ABI/testing/sysfs-profiling |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-profiling b/Documentation/ABI/testing/sysfs-profiling
index b02d8b8..8a8e466 100644
--- a/Documentation/ABI/testing/sysfs-profiling
+++ b/Documentation/ABI/testing/sysfs-profiling
@@ -1,13 +1,13 @@
-What:		/sys/kernel/profile
+What:		/sys/kernel/profiling
 Date:		September 2008
 Contact:	Dave Hansen <dave@linux.vnet.ibm.com>
 Description:
-		/sys/kernel/profile is the runtime equivalent
+		/sys/kernel/profiling is the runtime equivalent
 		of the boot-time profile= option.
 
 		You can get the same effect running:
 
-			echo 2 > /sys/kernel/profile
+			echo 2 > /sys/kernel/profiling
 
 		as you would by issuing profile=2 on the boot
 		command line.
-- 
1.7.8.1

