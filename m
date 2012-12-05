Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab2LEQOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:14:55 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56729 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab2LEQJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:40 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 29/44] metag: Basic documentation
Date: Wed, 5 Dec 2012 16:08:47 +0000
Message-ID: <1354723742-6195-30-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic metag documentation.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 Documentation/00-INDEX              |    2 ++
 Documentation/kernel-parameters.txt |    4 ++++
 Documentation/metag/00-INDEX        |    2 ++
 3 files changed, 8 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/metag/00-INDEX

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index ceb1ff7..d06f731 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -228,6 +228,8 @@ memory-hotplug.txt
 	- Hotpluggable memory support, how to use and current status.
 memory.txt
 	- info on typical Linux memory problems.
+metag/
+	- directory with info about Linux on Meta architecture.
 mips/
 	- directory with info about Linux on MIPS architecture.
 mmc/
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9776f06..20c93ba 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -958,6 +958,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			       If specified, z/VM IUCV HVC accepts connections
 			       from listed z/VM user IDs only.
 
+	hwthread_map=	[METAG] Comma-separated list of Linux cpu id to
+			        hardware thread id mappings.
+				Format: <cpu>:<hwthread>
+
 	keep_bootcon	[KNL]
 			Do not unregister boot console at start. This is only
 			useful for debugging when something happens in the window
diff --git a/Documentation/metag/00-INDEX b/Documentation/metag/00-INDEX
new file mode 100644
index 0000000..808f5d4
--- /dev/null
+++ b/Documentation/metag/00-INDEX
@@ -0,0 +1,2 @@
+00-INDEX
+	- this file
-- 
1.7.7.6


