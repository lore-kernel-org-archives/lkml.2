Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab1ASFmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 00:42:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab1ASFmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 00:42:09 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: len.brown@intel.com, WANG Cong <amwang@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net> (maintainer:DOCUMENTATION),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [Patch] kernel doc: fix some ACPI documentation
Date: Wed, 19 Jan 2011 13:41:58 +0800
Message-Id: <1295415718-16541-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Documentation/kernel-parameters.txt, apparently 0xffffffff should
be acpi.debug_layer not acpi.debug_level.

In Documentation/acpi/debug.txt, component ACPI_NUMA is missing, add it.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/Documentation/acpi/debug.txt b/Documentation/acpi/debug.txt
index 65bf47c..1af2a01 100644
--- a/Documentation/acpi/debug.txt
+++ b/Documentation/acpi/debug.txt
@@ -63,6 +63,7 @@ shows the supported mask values, currently these:
     ACPI_MEMORY_DEVICE_COMPONENT    0x08000000
     ACPI_VIDEO_COMPONENT            0x10000000
     ACPI_PROCESSOR_COMPONENT        0x20000000
+    ACPI_NUMA                       0x80000000
 
 debug_level
 -----------
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b72e071..75f2334 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -193,7 +193,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			object while interpreting AML:
 			    acpi.debug_layer=0xffffffff acpi.debug_level=0x2
 			Enable all messages related to ACPI hardware:
-			    acpi.debug_layer=0x2 acpi.debug_level=0xffffffff
+			    acpi.debug_layer=0xffffffff acpi.debug_level=0x2
 
 			Some values produce so much output that the system is
 			unusable.  The "log_buf_len" parameter may be useful
