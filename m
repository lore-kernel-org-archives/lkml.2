Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1AFAbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:31:42 -0500
Received: from kroah.org ([198.145.64.141]:36075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab1AFAbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:40 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:09 2011
Message-Id: <20110106002309.150359580@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [132/152] drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 448f53a1ede54eb854d036abf54573281412d650 upstream.

Fixes the lack of output on the LVDS panel of the Lenovo U160.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=31596
Reported-and-tested-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_bios.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -276,7 +276,7 @@ parse_general_features(struct drm_i915_p
 					general->ssc_freq ? 66 : 48;
 			else if (IS_IRONLAKE(dev_priv->dev) || IS_GEN6(dev))
 				dev_priv->lvds_ssc_freq =
-					general->ssc_freq ? 100 : 120;
+					general->ssc_freq ? 120 : 100;
 			else
 				dev_priv->lvds_ssc_freq =
 					general->ssc_freq ? 100 : 96;


