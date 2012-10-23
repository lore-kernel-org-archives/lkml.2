Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808Ab2JWUF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:05:26 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55024 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933429Ab2JWUFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:06 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Airlie <airlied@linux.ie>,
        Dave Airlie <airlied@redhat.com>, Adam Jackson <ajax@redhat.com>
Subject: [PATCH 045/193] drivers/gpu/drm/cirrus: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:58 -0700
Message-Id: <1351022666-6960-46-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: David Airlie <airlied@linux.ie>
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

