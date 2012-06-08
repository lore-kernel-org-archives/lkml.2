Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab2FHF1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:27:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43152 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760000Ab2FHFHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:15 -0400
Message-Id: <20120608041842.369347620@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joel Sass <jsass@disklessworkstations.com>,
        Adam Jackson <ajax@redhat.com>, Keith Packard <keithp@keithp.com>
Subject: [ 11/82] drm/i915: Add Clientron E830 to the ignore LVDS list
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Sass <jsass@disklessworkstations.com>

commit 44306ab302687b519a31aa498b954c1e26f95a6b upstream.

Signed-off-by: Joel Sass <jsass@disklessworkstations.com>
Reviewed-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index e441911..798f6e1 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -708,6 +708,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 		},
 	},
 	{
+                .callback = intel_no_lvds_dmi_callback,
+                .ident = "Clientron E830",
+                .matches = {
+                        DMI_MATCH(DMI_SYS_VENDOR, "Clientron"),
+                        DMI_MATCH(DMI_PRODUCT_NAME, "E830"),
+                },
+        },
+        {
 		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Asus EeeBox PC EB1007",
 		.matches = {


