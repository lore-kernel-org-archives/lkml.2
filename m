Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761234Ab2FEAUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 20:20:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43149 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752429Ab2FEAUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 20:20:11 -0400
Message-ID: <1338855610.20167.2.camel@joe2Laptop>
Subject: [PATCH] MAINTAINERS: whitespace only
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 17:20:10 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove trailing spaces at EOL.
Always use a tab after the type :

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 55f0fda..a3c9b62 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1077,7 +1077,7 @@ F:	drivers/media/video/s5p-fimc/
 ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC) SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 M:	Kamil Debski <k.debski@samsung.com>
-M:     Jeongtae Park <jtp.park@samsung.com>
+M:	Jeongtae Park <jtp.park@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
@@ -1743,10 +1743,10 @@ F:	include/linux/can/platform/
 CAPABILITIES
 M:	Serge Hallyn <serge.hallyn@canonical.com>
 L:	linux-security-module@vger.kernel.org
-S:	Supported	
+S:	Supported
 F:	include/linux/capability.h
 F:	security/capability.c
-F:	security/commoncap.c 
+F:	security/commoncap.c
 F:	kernel/capability.c
 
 CELL BROADBAND ENGINE ARCHITECTURE
@@ -2146,11 +2146,11 @@ S:	Orphan
 F:	drivers/net/wan/pc300*
 
 CYTTSP TOUCHSCREEN DRIVER
-M:      Javier Martinez Canillas <javier@dowhile0.org>
-L:      linux-input@vger.kernel.org
-S:      Maintained
-F:      drivers/input/touchscreen/cyttsp*
-F:      include/linux/input/cyttsp.h
+M:	Javier Martinez Canillas <javier@dowhile0.org>
+L:	linux-input@vger.kernel.org
+S:	Maintained
+F:	drivers/input/touchscreen/cyttsp*
+F:	include/linux/input/cyttsp.h
 
 DAMA SLAVE for AX.25
 M:	Joerg Reuter <jreuter@yaina.de>
@@ -5169,7 +5169,7 @@ S:	Maintained
 F:	drivers/firmware/pcdp.*
 
 PCI ERROR RECOVERY
-M:     Linas Vepstas <linasvepstas@gmail.com>
+M:	Linas Vepstas <linasvepstas@gmail.com>
 L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	Documentation/PCI/pci-error-recovery.txt


