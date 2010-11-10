Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab0KJWni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:43:38 -0500
Received: from xenotime.net ([72.52.115.56]:37654 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757362Ab0KJWnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:43:35 -0500
Date: Wed, 10 Nov 2010 11:53:50 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] MAINTAINERS: update documentation entries
Message-ID: <1289418830734@xenotime.net>
In-Reply-To: <1289418830794@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add explicit filename supported (scripts/kernel-doc) and add my
documentation quilt tree location to the MAINTAINERS file.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.37-rc1-git8.orig/MAINTAINERS
+++ linux-2.6.37-rc1-git8/MAINTAINERS
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

