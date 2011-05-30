Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1E3Kvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:51:45 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:50067 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908Ab1E3Kvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:51:44 -0400
Date: Mon, 30 May 2011 12:48:26 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Keith Packard <keithp@keithp.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Fw: [PATCH] drm: i915: correct return status in
 intel_hdmi_mode_valid()
Message-ID: <20110530124826.74d83b35@absol.kitzblitz>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forwarding to Keith Packard.
Sorry, initially sent to the previous maintainer instead.

Start weitergeleitete Nachricht:
Datum: Fri, 20 May 2011 18:58:53 +0200
Von: Nicolas Kaiser <nikai@nikai.net>
An: Chris Wilson <chris@chris-wilson.co.uk>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Betreff: [PATCH] drm: i915: correct return status in intel_hdmi_mode_valid()


Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
Untested: just looks to me like the intention might be
to return MODE_CLOCK_LOW here, is that correct?

 drivers/gpu/drm/i915/intel_hdmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
index f289b86..655bbd9 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -194,7 +194,7 @@ static int intel_hdmi_mode_valid(struct drm_connector *connector,
 	if (mode->clock > 165000)
 		return MODE_CLOCK_HIGH;
 	if (mode->clock < 20000)
-		return MODE_CLOCK_HIGH;
+		return MODE_CLOCK_LOW;
 
 	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
 		return MODE_NO_DBLESCAN;
-- 
1.7.5.rc3
