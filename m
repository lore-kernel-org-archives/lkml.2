Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab1BWFnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:43:19 -0500
Received: from mail.perches.com ([173.55.12.10]:3856 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab1BWFmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:33 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 14/18] MAINTAINERS: Remove SHARP LH7A40X section
Date: Tue, 22 Feb 2011 21:42:07 -0800
Message-Id: <af4040c0008d55d48515c775d154de7afce69485.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 82e6923e1862428b755ec306b3dbccf926849314
("ARM: lh7a40x: remove unmaintained platform support")
removed support, remove it from MAINTAINERS.

cc: Russell King <rmk+kernel@arm.linux.org.uk>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 085774c..862e251 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5608,17 +5608,6 @@ M:	Robin Holt <holt@sgi.com>
 S:	Maintained
 F:	drivers/misc/sgi-xp/
 
-SHARP LH SUPPORT (LH7952X & LH7A40X)
-M:	Marc Singer <elf@buici.com>
-W:	http://projects.buici.com/arm
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
-F:	Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen
-F:	arch/arm/mach-lh7a40x/
-F:	drivers/tty/serial/serial_lh7a40x.c
-F:	drivers/usb/gadget/lh7a40*
-F:	drivers/usb/host/ohci-lh7a40*
-
 SHM-SIGNAL LIBRARY
 M:	Gregory Haskins <ghaskins@novell.com>
 S:	Maintained
-- 
1.7.4.rc3

