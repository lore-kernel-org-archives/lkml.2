Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab0G0C6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 22:58:48 -0400
Received: from adelie.canonical.com ([91.189.90.139]:50281 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab0G0C6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 22:58:40 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 13/13] AppArmor: update Maintainer and Documentation/kernel-parameters.txt
Date: Mon, 26 Jul 2010 19:57:48 -0700
Message-Id: <1280199468-19680-14-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280199468-19680-1-git-send-email-john.johansen@canonical.com>
References: <1280199468-19680-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 Documentation/kernel-parameters.txt |   12 ++++++++++--
 MAINTAINERS                         |    8 ++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4ddb58d..b61f89f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -93,6 +93,7 @@ parameter is applicable:
 			Documentation/scsi/.
 	SECURITY Different security models are enabled.
 	SELINUX SELinux support is enabled.
+	APPARMOR AppArmor support is enabled.
 	SERIAL	Serial support is enabled.
 	SH	SuperH architecture is enabled.
 	SMP	The kernel is an SMP kernel.
@@ -254,8 +255,8 @@ and is between 256 and 4096 characters. It is defined in the file
 			control method, with respect to putting devices into
 			low power states, to be enforced (the ACPI 2.0 ordering
 			of _PTS is used by default).
-			s4_nonvs prevents the kernel from saving/restoring the
-			ACPI NVS memory during hibernation.
+			nonvs prevents the kernel from saving/restoring the
+			ACPI NVS memory during suspend/hibernation and resume.
 			sci_force_enable causes the kernel to set SCI_EN directly
 			on resume from S1/S3 (which is against the ACPI spec,
 			but some broken systems don't work without it).
@@ -2312,6 +2313,13 @@ and is between 256 and 4096 characters. It is defined in the file
 			If enabled at boot time, /selinux/disable can be used
 			later to disable prior to initial policy load.
 
+	apparmor=	[APPARMOR] Disable or enable AppArmor at boot time
+			Format: { "0" | "1" }
+			See security/apparmor/Kconfig help text
+			0 -- disable.
+			1 -- enable.
+			Default value is set via kernel config option.
+
 	serialnumber	[BUGS=X86-32]
 
 	shapers=	[NET]
diff --git a/MAINTAINERS b/MAINTAINERS
index db3d0f5..b4e8b7d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5061,6 +5061,14 @@ S:	Supported
 F:	include/linux/selinux*
 F:	security/selinux/
 
+APPARMOR SECURITY MODULE
+M:	John Johansen <john.johansen@canonical.com>
+L:	apparmor@lists.ubuntu.com (subscribers-only, general discussion)
+W:	apparmor.wiki.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev.git
+S:	Supported
+F:	security/apparmor/
+
 SENSABLE PHANTOM
 M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
-- 
1.7.1

