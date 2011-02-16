Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab1BPCAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:00:11 -0500
Received: from kroah.org ([198.145.64.141]:49184 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758522Ab1BPBvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:51:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:02 2011
Message-Id: <20110216014702.454095958@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Knut Petersen <knut_petersen@t-online.de>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [082/115] drm/i915/lvds: Add AOpen i915GMm-HFS to the list of false-positive LVDS
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Knut Petersen <knut_petersen@t-online.de>

commit 22ab70d3262ddb6e69b3c246a34e2967ba5eb1e8 upstream.

Signed-off-by: Knut Petersen <knut_petersen@t-online.de>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -884,6 +884,14 @@ static const struct dmi_system_id intel_
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
+		.ident = "AOpen i915GMm-HFS",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
+			DMI_MATCH(DMI_BOARD_NAME, "i915GMm-HFS"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Aopen i945GTt-VFA",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "AO00001JW"),


