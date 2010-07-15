Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab0GOAol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:44:41 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57370 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab0GOAoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:44:34 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 13/13] AppArmor: update Maintainer and Documentation/kernel-parameters.txt
Date: Wed, 14 Jul 2010 17:43:41 -0700
Message-Id: <1279154621-25868-14-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 Documentation/kernel-parameters.txt |    8 ++++++++
 MAINTAINERS                         |    8 ++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 82d6aeb..0cceb09 100644
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
index 5884812..7a32382 100644
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
1.7.0.4

