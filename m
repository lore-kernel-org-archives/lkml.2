Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0IQDv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 23:51:26 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43319 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab0IQDvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 23:51:25 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Eric Anholt <eric@anholt.net>
Subject: [PATCH 2/2] drm/i915: Support for another B43 device id
Date: Fri, 17 Sep 2010 11:51:20 +0800
Message-Id: <1284695480-6354-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284695424-6294-1-git-send-email-ike.pan@canonical.com>
References: <1284695424-6294-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We find there is another device id set for B43 chipset. After adding the device
id 4E90/4E92 beside 4E40/4E42, the machine works fine with the same
modification in xserver-xorg-video-intel.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/gpu/drm/i915/i915_drv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 216deb5..a9876ac 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -170,6 +170,7 @@ static const struct pci_device_id pciidlist[] = {		/* aka */
 	INTEL_VGA_DEVICE(0x2e22, &intel_g45_info),		/* G45_G */
 	INTEL_VGA_DEVICE(0x2e32, &intel_g45_info),		/* G41_G */
 	INTEL_VGA_DEVICE(0x2e42, &intel_g45_info),		/* B43_G */
+	INTEL_VGA_DEVICE(0x2e92, &intel_g45_info),		/* B43_G */
 	INTEL_VGA_DEVICE(0xa001, &intel_pineview_info),
 	INTEL_VGA_DEVICE(0xa011, &intel_pineview_info),
 	INTEL_VGA_DEVICE(0x0042, &intel_ironlake_d_info),
-- 
1.7.1

