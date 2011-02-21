Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab1BUELy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:11:54 -0500
Received: from xenotime.net ([184.105.210.51]:44552 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932228Ab1BUELw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:11:52 -0500
Date: Sun, 20 Feb 2011 20:08:35 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Cc: Xiao Jiang <jgq516@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 5/5] Docbook: correction of drm_device to drm_driver
Message-ID: <12982613152740@xenotime.net>
In-Reply-To: <1298261315935@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Jiang <jgq516@gmail.com>

A few wrong usages of drm_device, which should be drm_driver.

Signed-off-by: Xiao Jiang <jgq516@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 Documentation/DocBook/drm.tmpl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- lnx-2638-rc3.orig/Documentation/DocBook/drm.tmpl
+++ lnx-2638-rc3/Documentation/DocBook/drm.tmpl
@@ -73,8 +73,8 @@
       services.
     </para>
     <para>
-      The core of every DRM driver is struct drm_device.  Drivers
-      will typically statically initialize a drm_device structure,
+      The core of every DRM driver is struct drm_driver.  Drivers
+      will typically statically initialize a drm_driver structure,
       then pass it to drm_init() at load time.
     </para>
 
@@ -84,7 +84,7 @@
     <title>Driver initialization</title>
     <para>
       Before calling the DRM initialization routines, the driver must
-      first create and fill out a struct drm_device structure.
+      first create and fill out a struct drm_driver structure.
     </para>
     <programlisting>
       static struct drm_driver driver = {


-- 

