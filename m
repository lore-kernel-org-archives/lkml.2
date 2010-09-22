Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0IVQ5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:57:21 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54942 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0IVQ5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Oz45X9k3Ej0NlKzc4CYOQlvafoz8Phy+107J0MjgRJGlxc6LQZgxBX7T/MUOsbUY6h
         fJdDJ/dVE6Px/jt7blFsiYTb5b3J4gXrsXi9JoY4RoXvynU814Nv5An8LiSQ3d3Himby
         r0c3XBH+3sEy6TWBMqxFHjZ8dPMqUUdB4N/Es=
MIME-Version: 1.0
Date: Wed, 22 Sep 2010 17:57:19 +0100
Message-ID: <AANLkTinv8x495Ga+xKa3RvowjAF02_uL9CH8=-+xDN9X@mail.gmail.com>
Subject: [2.6.36-rc5] radeon fixes...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix string interpreted as trigraph and typo.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Reviewed-by: Alex Deucher <alexdeucher@gmail.com>

diff --git a/drivers/gpu/drm/radeon/atombios.h
b/drivers/gpu/drm/radeon/atombios.h
index 1bc72c3..fe359a2 100644
--- a/drivers/gpu/drm/radeon/atombios.h
+++ b/drivers/gpu/drm/radeon/atombios.h
@@ -4999,7 +4999,7 @@ typedef struct _SW_I2C_IO_DATA_PARAMETERS
 #define SW_I2C_CNTL_WRITE1BIT 6

 //==============================VESA definition
Portion===============================
-#define VESA_OEM_PRODUCT_REV			            '01.00'
+#define VESA_OEM_PRODUCT_REV			            "01.00"
 #define VESA_MODE_ATTRIBUTE_MODE_SUPPORT	     0xBB	//refer to VBE
spec p.32, no TTY support
 #define VESA_MODE_WIN_ATTRIBUTE						     7
 #define VESA_WIN_SIZE											     64
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index bfdfa3e..e3b47a5 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2727,7 +2727,7 @@ int r600_ib_test(struct radeon_device *rdev)
 	if (i < rdev->usec_timeout) {
 		DRM_INFO("ib test succeeded in %u usecs\n", i);
 	} else {
-		DRM_ERROR("radeon: ib test failed (sracth(0x%04X)=0x%08X)\n",
+		DRM_ERROR("radeon: ib test failed (scratch(0x%04X)=0x%08X)\n",
 			  scratch, tmp);
 		r = -EINVAL;
 	}
-- 
Daniel J Blueman
