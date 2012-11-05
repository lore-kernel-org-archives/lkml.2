Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583Ab2KEXai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:30:38 -0500
Received: from smtp.outflux.net ([198.145.64.163]:54829 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab2KEXFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:21 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Dave Airlie <airlied@redhat.com>,
        Adam Jackson <ajax@redhat.com>
Subject: [PATCH 047/104] drivers/gpu/drm/cirrus: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:04 -0800
Message-Id: <1352156701-4038-48-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Dave Airlie <airlied@redhat.com>
CC: Adam Jackson <ajax@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/gpu/drm/cirrus/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/cirrus/Kconfig b/drivers/gpu/drm/cirrus/Kconfig
index fc154dd..bf67b22 100644
--- a/drivers/gpu/drm/cirrus/Kconfig
+++ b/drivers/gpu/drm/cirrus/Kconfig
@@ -1,6 +1,6 @@
 config DRM_CIRRUS_QEMU
 	tristate "Cirrus driver for QEMU emulated device"
-	depends on DRM && PCI && EXPERIMENTAL
+	depends on DRM && PCI
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
-- 
1.7.9.5

