Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721Ab2JWUFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:05:15 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58477 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933671Ab2JWUFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:05:06 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, David Airlie <airlied@linux.ie>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 044/193] drivers/gpu/drm/ast: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:01:57 -0700
Message-Id: <1351022666-6960-45-git-send-email-keescook@chromium.org>
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

