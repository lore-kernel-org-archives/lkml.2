Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965410Ab2JWU4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:56:44 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44896 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933741Ab2JWUFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:18 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Airlie <airlied@linux.ie>,
        Dave Airlie <airlied@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 048/193] drivers/gpu/drm/udl: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:01 -0700
Message-Id: <1351022666-6960-49-git-send-email-keescook@chromium.org>
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
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/gpu/drm/udl/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/udl/Kconfig b/drivers/gpu/drm/udl/Kconfig
index 56e0bf3..6222af1 100644
--- a/drivers/gpu/drm/udl/Kconfig
+++ b/drivers/gpu/drm/udl/Kconfig
@@ -1,6 +1,6 @@
 config DRM_UDL
 	tristate "DisplayLink"
-	depends on DRM && EXPERIMENTAL
+	depends on DRM
 	depends on USB_ARCH_HAS_HCD
 	select DRM_USB
 	select FB_SYS_FILLRECT
-- 
1.7.9.5

