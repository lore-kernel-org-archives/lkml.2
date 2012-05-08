Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab2EHLSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:18:09 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38552 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2EHLSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:18:08 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] MAINTAINERS: switch drm/i915 to Daniel Vetter
Date: Tue,  8 May 2012 13:19:12 +0200
Message-Id: <1336475952-8286-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... given that I essentially run the show already, let's make this
official.

Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b0f1073..cf01233 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2376,10 +2376,10 @@ F:	drivers/gpu/drm/
 F:	include/drm/
 
 INTEL DRM DRIVERS (excluding Poulsbo, Moorestown and derivative chipsets)
-M:	Keith Packard <keithp@keithp.com>
+M:	Daniel Vetter <daniel.vetter@ffwll.ch>
 L:	intel-gfx@lists.freedesktop.org (subscribers-only)
 L:	dri-devel@lists.freedesktop.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux.git
+T:	git git://people.freedesktop.org/~danvet/drm-intel
 S:	Supported
 F:	drivers/gpu/drm/i915
 F:	include/drm/i915*
-- 
1.7.10

