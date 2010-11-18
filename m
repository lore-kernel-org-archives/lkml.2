Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312Ab0KRUdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:33:15 -0500
Received: from xenotime.net ([72.52.115.56]:42682 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758087Ab0KRUdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:33:12 -0500
Date: Thu, 18 Nov 2010 12:27:34 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: [PATCH 7/7] MAINTAINERS: update documentation entries
Message-ID: <12901120541282@xenotime.net>
In-Reply-To: <12901120542939@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update kernel-doc and Documentation maintainers info.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.37-rc2-git4.orig/MAINTAINERS
+++ linux-2.6.37-rc2-git4/MAINTAINERS
@@ -2008,6 +2008,7 @@ F:	drivers/hwmon/dme1737.c
 DOCBOOK FOR DOCUMENTATION
 M:	Randy Dunlap <rdunlap@xenotime.net>
 S:	Maintained
+F:	scripts/kernel-doc
 
 DOCKING STATION DRIVER
 M:	Shaohua Li <shaohua.li@intel.com>
@@ -2018,6 +2019,7 @@ F:	drivers/acpi/dock.c
 DOCUMENTATION
 M:	Randy Dunlap <rdunlap@xenotime.net>
 L:	linux-doc@vger.kernel.org
+T:	quilt oss.oracle.com/~rdunlap/kernel-doc-patches/current/
 S:	Maintained
 F:	Documentation/
 


-- 

