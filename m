Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861Ab3AIVJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:09:41 -0500
Received: from mail.kernel.org ([198.145.19.201]:42980 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933713Ab3AIUjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andy Gross <andy.gross@ti.com>
Subject: [ 074/123] staging: drm/omap: Fix include error during make
Date: Wed,  9 Jan 2013 12:35:13 -0800
Message-Id: <20130109201508.105753385@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Gross <andy.gross@ti.com>

commit b9ed9f0ecf1b5675c64d069e9b53effe276b6f01 upstream.

Fixed include error for drm_mode.h

Signed-off-by: Andy Gross <andy.gross@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/omapdrm/omap_crtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/omapdrm/omap_crtc.c
+++ b/drivers/staging/omapdrm/omap_crtc.c
@@ -19,7 +19,7 @@
 
 #include "omap_drv.h"
 
-#include "drm_mode.h"
+#include <drm/drm_mode.h>
 #include "drm_crtc.h"
 #include "drm_crtc_helper.h"
 


