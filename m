Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab2KEX3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:29:32 -0500
Received: from smtp.outflux.net ([198.145.64.163]:54541 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab2KEXFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:21 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Dave Airlie <airlied@redhat.com>,
        Alan Cox <alan@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 048/104] drivers/gpu/drm/gma500: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:05 -0800
Message-Id: <1352156701-4038-49-git-send-email-keescook@chromium.org>
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
CC: Alan Cox <alan@linux.intel.com>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/gpu/drm/gma500/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/Kconfig b/drivers/gpu/drm/gma500/Kconfig
index 42e665c..1188f0f 100644
--- a/drivers/gpu/drm/gma500/Kconfig
+++ b/drivers/gpu/drm/gma500/Kconfig
@@ -1,6 +1,6 @@
 config DRM_GMA500
 	tristate "Intel GMA5/600 KMS Framebuffer"
-	depends on DRM && PCI && X86 && EXPERIMENTAL
+	depends on DRM && PCI && X86
 	select FB_CFB_COPYAREA
         select FB_CFB_FILLRECT
         select FB_CFB_IMAGEBLIT
-- 
1.7.9.5

