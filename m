Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab2KEXah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:30:37 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37235 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab2KEXFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:21 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Dave Airlie <airlied@redhat.com>
Subject: [PATCH 046/104] drivers/gpu/drm/ast: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:03 -0800
Message-Id: <1352156701-4038-47-git-send-email-keescook@chromium.org>
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
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/gpu/drm/ast/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ast/Kconfig b/drivers/gpu/drm/ast/Kconfig
index a277b12..da4a51e 100644
--- a/drivers/gpu/drm/ast/Kconfig
+++ b/drivers/gpu/drm/ast/Kconfig
@@ -1,6 +1,6 @@
 config DRM_AST
 	tristate "AST server chips"
-	depends on DRM && PCI && EXPERIMENTAL
+	depends on DRM && PCI
 	select DRM_TTM
 	select FB_SYS_COPYAREA
 	select FB_SYS_FILLRECT
-- 
1.7.9.5

