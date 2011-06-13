Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab1FMMTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:19:43 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:41746 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab1FMMTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:19:37 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Mike Thomas <rmthomas@sciolus.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH 1/5] staging/easycap: Kill leftover build options in readme
Date: Mon, 13 Jun 2011 16:18:28 +0400
Message-Id: <0357ebaecb3c8c17cf7a8925daeed50409c11b63.1307967011.git.kirr@mns.spb.ru>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <cover.1307967011.git.kirr@mns.spb.ru>
References: <cover.1307967011.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1307967011.git.kirr@mns.spb.ru>
References: <cover.1307967011.git.kirr@mns.spb.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following options were removed from in-tree driver, but were left
in README:

- EASYCAP_IS_VIDEODEV_CLIENT was removed in cb81fa07 (staging/easycap:
  kill EASYCAP_IS_VIDEODEV_CLIENT compilation conditional);

- EASYCAP_NEEDS_V4L2_DEVICE_H/EASYCAP_NEEDS_V4L2_FOPS were removed in
  30516058 (staging/easycap: kill EASYCAP_NEEDS_V4L2_DEVICE_H and
  EASYCAP_NEEDS_V4L2_FOPS);

- EASYCAP_NEEDS_UNLOCKED_IOCTL was removed in f2b3c685 (staging/easycap:
  kill EASYCAP_NEEDS_UNLOCKED_IOCTL).

Remove them.

Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Mike Thomas <rmthomas@sciolus.org>
Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/staging/easycap/README |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/easycap/README b/drivers/staging/easycap/README
index 6b5ac0d..16b8264 100644
--- a/drivers/staging/easycap/README
+++ b/drivers/staging/easycap/README
@@ -27,28 +27,6 @@ BUILD OPTIONS AND DEPENDENCIES
 Unless EASYCAP_DEBUG is defined during compilation it will not be possible
 to select a debug level at the time of module installation.
 
-If the parameter EASYCAP_IS_VIDEODEV_CLIENT is undefined during compilation
-the built module is entirely independent of the videodev module, and when
-the EasyCAP is physically plugged into a USB port the special files
-/dev/easycap0 and /dev/easysnd1 are created as video and sound sources
-respectively.
-
-If the parameter EASYCAP_IS_VIDEODEV_CLIENT is defined during compilation
-the built easycap module is configured to register with the videodev module,
-in which case the special files created when the EasyCAP is plugged in are
-/dev/video0 and /dev/easysnd0.
-
-During in-tree builds the following should should be defined whenever the
-parameter EASYCAP_IS_VIDEODEV_CLIENT is defined:
-
-EASYCAP_NEEDS_V4L2_DEVICE_H
-EASYCAP_NEEDS_V4L2_FOPS
-EASYCAP_NEEDS_UNLOCKED_IOCTL
-
-If the build is performed out-of-tree against older kernels the parameters
-to be defined depend on the kernel version in a way which will not be
-discussed here.
-
 
 KNOWN RUNTIME ISSUES
 --------------------
-- 
1.7.6.rc1

