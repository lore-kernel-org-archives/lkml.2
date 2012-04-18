Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab2DREdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:33:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51545 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2DREdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:33:41 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        David Airlie <airlied@linux.ie>, <dri-devel@lists.freedesktop.org>
Subject: [PATCH 02/12] drivers: gpu: drm: gma500: mdfld_dsi_output.h: Remove not unneeded include of version.h
Date: Wed, 18 Apr 2012 01:30:02 -0300
Message-Id: <1334723412-5034-3-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
References: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The output of "make versioncheck" points a incorrect include of
version.h in the drivers/gpu/drm/gma500/mdfld_dsi_output.h:

drivers/gpu/drm/gma500/mdfld_dsi_output.h: 32 linux/version.h not needed.

If we take a look in the file, we can agree to remove it.

Cc: David Airlie <airlied@linux.ie>
Cc: <dri-devel@lists.freedesktop.org>
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/gpu/drm/gma500/mdfld_dsi_output.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/gma500/mdfld_dsi_output.h b/drivers/gpu/drm/gma500/mdfld_dsi_output.h
index 21071ce..36eb074 100644
--- a/drivers/gpu/drm/gma500/mdfld_dsi_output.h
+++ b/drivers/gpu/drm/gma500/mdfld_dsi_output.h
@@ -29,7 +29,6 @@
 #define __MDFLD_DSI_OUTPUT_H__
 
 #include <linux/backlight.h>
-#include <linux/version.h>
 #include <drm/drmP.h>
 #include <drm/drm.h>
 #include <drm/drm_crtc.h>
-- 
1.7.7.6

