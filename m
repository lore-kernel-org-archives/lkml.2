Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1KWLwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:52:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51381 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab1KWLwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:52:32 -0500
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Wed, 23 Nov 2011 12:52:10 +0100
Message-ID: <CAH9NwWfe3ahy6OAN=5au84b9pmGbbMvnRKoRUC95kNAZOFORjA@mail.gmail.com>
Subject: [PATCH] lxfb: add support for LQ057V3DG01 panel
To: linux-fbdev@vger.kernel.org
Cc: linux-geode@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 47df48b6fe482a108a0889bf2fdecfbde4aea8ee Mon Sep 17 00:00:00 2001
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Wed, 23 Nov 2011 12:44:14 +0100
Subject: [PATCH] lxfb: add support for LQ057V3DG01 panel

The LQ057V3DG01 panel needs some different timing
values so that the picture is centered.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---
 drivers/video/geode/lxfb_core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/video/geode/lxfb_core.c b/drivers/video/geode/lxfb_core.c
index 416851c..7b75bae 100644
--- a/drivers/video/geode/lxfb_core.c
+++ b/drivers/video/geode/lxfb_core.c
@@ -40,6 +40,10 @@ static struct fb_videomode geode_modedb[] __devinitdata = {
 	{ NULL, 60, 640, 480, 39682, 48, 8, 25, 2, 88, 2,
 	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
 	  FB_VMODE_NONINTERLACED, 0 },
+	/* 640x480-60 adapted for LQ057V3DG01 panel */
+	{ "LQ057V3DG01", 60, 640, 480, 39682, 48, 16, 34, 10, 88, 2,
+	  FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
+	  FB_VMODE_NONINTERLACED, 0 },
 	/* 640x400-70 */
 	{ NULL, 70, 640, 400, 39770, 40, 8, 28, 5, 96, 2,
 	  FB_SYNC_HOR_HIGH_ACT,
-- 
1.7.5.4
