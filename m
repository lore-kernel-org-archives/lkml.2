Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1BNJy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 04:54:57 -0500
Received: from mail.windriver.com ([147.11.1.11]:48658 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1BNJy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 04:54:56 -0500
From: jgq516@gmail.com
To: rdunlap@xenotime.net, jesse.barnes@intel.com, airlied@redhat.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] drm: fix wrong usages of drm_device in DRM Developer's Guide
Date: Mon, 14 Feb 2011 17:58:23 +0800
Message-Id: <1297677503-11175-1-git-send-email-jgq516@gmail.com>
X-Mailer: git-send-email 1.7.3
X-OriginalArrivalTime: 14 Feb 2011 09:54:42.0169 (UTC) FILETIME=[339CA690:01CBCC2D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Jiang <jgq516@gmail.com>

A few wrong usages of drm_device, which should be drm_driver.

Signed-off-by: Xiao Jiang <jgq516@gmail.com>
---
 Documentation/DocBook/drm.tmpl |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/drm.tmpl b/Documentation/DocBook/drm.tmpl
index 2861055..c279158 100644
--- a/Documentation/DocBook/drm.tmpl
+++ b/Documentation/DocBook/drm.tmpl
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
1.6.3.1

