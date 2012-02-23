Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2BWTCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:02:24 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41881 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2BWTCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:02:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bobbypowers@gmail.com designates 10.229.136.146 as permitted sender) smtp.mail=bobbypowers@gmail.com; dkim=pass header.i=bobbypowers@gmail.com
From: Bobby Powers <bobbypowers@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, davem@davemloft.net, airlied@linux.ie,
        Bobby Powers <bobbypowers@gmail.com>
Subject: [PATCH] linux headers: include linux/types.h where appropriate
Date: Thu, 23 Feb 2012 14:02:11 -0500
Message-Id: <1330023731-14043-1-git-send-email-bobbypowers@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This silences the related header check warnings.

Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
---
 include/drm/drm_mode.h          |    2 ++
 include/drm/i915_drm.h          |    2 ++
 include/drm/mga_drm.h           |    2 ++
 include/drm/radeon_drm.h        |    2 ++
 include/drm/via_drm.h           |    2 ++
 include/linux/mmc/ioctl.h       |    3 +++
 include/scsi/scsi_netlink.h     |    2 +-
 include/sound/compress_params.h |    2 ++
 8 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
index 2a2acda..4a0aae3 100644
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -27,6 +27,8 @@
 #ifndef _DRM_MODE_H
 #define _DRM_MODE_H
 
+#include <linux/types.h>
+
 #define DRM_DISPLAY_INFO_LEN	32
 #define DRM_CONNECTOR_NAME_LEN	32
 #define DRM_DISPLAY_MODE_LEN	32
diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
index 924f6a4..74b0d6c 100644
--- a/include/drm/i915_drm.h
+++ b/include/drm/i915_drm.h
@@ -29,6 +29,8 @@
 
 #include "drm.h"
 
+#include <linux/types.h>
+
 /* Please note that modifications to all structs defined here are
  * subject to backwards-compatibility constraints.
  */
diff --git a/include/drm/mga_drm.h b/include/drm/mga_drm.h
index fca8170..6d4f427 100644
--- a/include/drm/mga_drm.h
+++ b/include/drm/mga_drm.h
@@ -37,6 +37,8 @@
 
 #include "drm.h"
 
+#include <linux/types.h>
+
 /* WARNING: If you change any of these defines, make sure to change the
  * defines in the Xserver file (mga_sarea.h)
  */
diff --git a/include/drm/radeon_drm.h b/include/drm/radeon_drm.h
index b55da40..fdfedd2 100644
--- a/include/drm/radeon_drm.h
+++ b/include/drm/radeon_drm.h
@@ -35,6 +35,8 @@
 
 #include "drm.h"
 
+#include <linux/types.h>
+
 /* WARNING: If you change any of these defines, make sure to change the
  * defines in the X server file (radeon_sarea.h)
  */
diff --git a/include/drm/via_drm.h b/include/drm/via_drm.h
index 79b3b6e..c6d0992 100644
--- a/include/drm/via_drm.h
+++ b/include/drm/via_drm.h
@@ -26,6 +26,8 @@
 
 #include "drm.h"
 
+#include <linux/types.h>
+
 /* WARNING: These defines must be the same as what the Xserver uses.
  * if you change them, you must change the defines in the Xserver.
  */
diff --git a/include/linux/mmc/ioctl.h b/include/linux/mmc/ioctl.h
index 8fa5bc5..1f5e689 100644
--- a/include/linux/mmc/ioctl.h
+++ b/include/linux/mmc/ioctl.h
@@ -1,5 +1,8 @@
 #ifndef LINUX_MMC_IOCTL_H
 #define LINUX_MMC_IOCTL_H
+
+#include <linux/types.h>
+
 struct mmc_ioc_cmd {
 	/* Implies direction of data.  true = write, false = read */
 	int write_flag;
diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.h
index 58ce8fe..5cb20cc 100644
--- a/include/scsi/scsi_netlink.h
+++ b/include/scsi/scsi_netlink.h
@@ -23,7 +23,7 @@
 #define SCSI_NETLINK_H
 
 #include <linux/netlink.h>
-
+#include <linux/types.h>
 
 /*
  * This file intended to be included by both kernel and user space
diff --git a/include/sound/compress_params.h b/include/sound/compress_params.h
index d97d69f..da4a456 100644
--- a/include/sound/compress_params.h
+++ b/include/sound/compress_params.h
@@ -51,6 +51,8 @@
 #ifndef __SND_COMPRESS_PARAMS_H
 #define __SND_COMPRESS_PARAMS_H
 
+#include <linux/types.h>
+
 /* AUDIO CODECS SUPPORTED */
 #define MAX_NUM_CODECS 32
 #define MAX_NUM_CODEC_DESCRIPTORS 32
-- 
1.7.7.6

