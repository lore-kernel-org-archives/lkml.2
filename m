Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789Ab1C3Vy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:54:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:17364 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933373Ab1C3VHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447427"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: knut_petersen@t-online.de, chris@chris-wilson.co.uk, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [84/275] drm/i915/lvds: Add AOpen i915GMm-HFS to the list of false-positive LVDS
Message-Id: <20110330210522.23E713E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Knut Petersen <knut_petersen@t-online.de>

commit 22ab70d3262ddb6e69b3c246a34e2967ba5eb1e8 upstream.

Signed-off-by: Knut Petersen <knut_petersen@t-online.de>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.35.y/drivers/gpu/drm/i915/intel_lvds.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/i915/intel_lvds.c	2011-03-29 22:51:36.591786877 -0700
+++ linux-2.6.35.y/drivers/gpu/drm/i915/intel_lvds.c	2011-03-29 23:02:59.891302951 -0700
@@ -811,6 +811,14 @@
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
