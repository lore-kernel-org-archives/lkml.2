Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab0IOLi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:38:58 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:37707 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751813Ab0IOLi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:38:56 -0400
X-Quarantine-ID: <uDpzjaPSPUWB>
X-Amavis-Alert: BAD HEADER, Improper folded header field made up entirely of
	whitespace (char 09 hex): Face: ...MWASAkVVViQjzP\n jycPrvgA\n\t\n
	R1goSzOnkp14Y[...]
Subject: Re: [PATCH] radeon: Expose backlight class device for legacy LVDS
 encoder
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <1284364471.6653.137.camel@thor.local>
References: <1283963539-4039-1-git-send-email-mjg@redhat.com>
	 <1283963539-4039-3-git-send-email-mjg@redhat.com>
	 <1284364471.6653.137.camel@thor.local>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA	
 R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 15 Sep 2010 13:38:48 +0200
Message-ID: <1284550728.8555.66.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 09:54 +0200, Michel Dänzer wrote: 
> On Mit, 2010-09-08 at 12:32 -0400, Matthew Garrett wrote: 
> > From: Michel Dänzer <michel@daenzer.net>
> > 
> > Allows e.g. power management daemons to control the backlight level. Inspired
> > by the corresponding code in radeonfb.
> > 
> > (Updated to add backlight type and make the connector the parent device - mjg)
> > 
> > Signed-off-by: Michel Dänzer <daenzer@vmware.com>
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> Thanks for picking this up, Matthew.
> 
> Unfortunately, it fails to build here:
> 
>   CC [M]  drivers/gpu/drm/radeon/radeon_legacy_encoders.o
> drivers/gpu/drm/radeon/radeon_legacy_encoders.c: In function ‘radeon_legacy_backlight_init’:
> drivers/gpu/drm/radeon/radeon_legacy_encoders.c:358: error: implicit declaration of function ‘pmac_has_backlight_type’
> drivers/gpu/drm/radeon/radeon_legacy_encoders.c:403: error: implicit declaration of function ‘machine_is_compatible’
> make[1]: *** [drivers/gpu/drm/radeon/radeon_legacy_encoders.o] Error 1
> make: *** [_module_drivers/gpu/drm/radeon] Error 2

Also, radeon_get_connector_for_encoder() only works when a mode is set,
connector->kdev is only initialized after drm_sysfs_connector_add(), and
I deliberately chose the backlight device name ending in "bl" because
that's what pbbuttonsd looks for (though of course that could be fixed
there).

The updated patch below fixes these issues, successfully using this
right now.


>From 59ce4a62cefdef665db5ec7527860c9314a6931d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>
Date: Mon, 23 Aug 2010 08:46:31 +0200
Subject: drm/radeon/kms: Expose backlight class device for legacy LVDS encoder.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Allows e.g. power management daemons to control the backlight level. Inspired
by the corresponding code in radeonfb.

(Updated to add backlight type and make the connector the parent device - mjg)

Signed-off-by: Michel Dänzer <daenzer@vmware.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/gpu/drm/radeon/Kconfig                  |    1 +
 drivers/gpu/drm/radeon/radeon_connectors.c      |   15 ++
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |  257 ++++++++++++++++++++++-
 drivers/gpu/drm/radeon/radeon_mode.h            |   10 +
 4 files changed, 277 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/Kconfig b/drivers/gpu/drm/radeon/Kconfig
index 1c02d23..9746fee 100644
--- a/drivers/gpu/drm/radeon/Kconfig
+++ b/drivers/gpu/drm/radeon/Kconfig
@@ -1,6 +1,7 @@
 config DRM_RADEON_KMS
 	bool "Enable modesetting on radeon by default - NEW DRIVER"
 	depends on DRM_RADEON
+	select BACKLIGHT_CLASS_DEVICE
 	help
 	  Choose this option if you want kernel modesetting enabled by default.
 
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 31a09cd..9a9ba97 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -40,6 +40,10 @@ radeon_atombios_connected_scratch_regs(struct drm_connector *connector,
 				       struct drm_encoder *encoder,
 				       bool connected);
 
+extern void
+radeon_legacy_backlight_init(struct radeon_encoder *radeon_encoder,
+			     struct drm_connector *drm_connector);
+
 void radeon_connector_hotplug(struct drm_connector *connector)
 {
 	struct drm_device *dev = connector->dev;
@@ -1389,6 +1393,17 @@ radeon_add_legacy_connector(struct drm_device *dev,
 		connector->polled = DRM_CONNECTOR_POLL_HPD;
 	connector->display_info.subpixel_order = subpixel_order;
 	drm_sysfs_connector_add(connector);
+	if (connector_type == DRM_MODE_CONNECTOR_LVDS) {
+		struct drm_encoder *drm_encoder;
+
+		list_for_each_entry(drm_encoder, &dev->mode_config.encoder_list, head) {
+			struct radeon_encoder *radeon_encoder;
+
+			radeon_encoder = to_radeon_encoder(drm_encoder);
+			if (radeon_encoder->encoder_id == ENCODER_OBJECT_ID_INTERNAL_LVDS)
+				radeon_legacy_backlight_init(radeon_encoder, connector);
+		}
+	}
 	return;
 
 failed:
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
index 0b83970..bdca317 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -28,6 +28,10 @@
 #include "radeon_drm.h"
 #include "radeon.h"
 #include "atom.h"
+#include <linux/backlight.h>
+#ifdef CONFIG_PMAC_BACKLIGHT
+#include <asm/backlight.h>
+#endif
 
 static void radeon_legacy_encoder_disable(struct drm_encoder *encoder)
 {
@@ -39,7 +43,7 @@ static void radeon_legacy_encoder_disable(struct drm_encoder *encoder)
 	radeon_encoder->active_device = 0;
 }
 
-static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
+static void radeon_legacy_lvds_update(struct drm_encoder *encoder, int mode)
 {
 	struct drm_device *dev = encoder->dev;
 	struct radeon_device *rdev = dev->dev_private;
@@ -47,15 +51,23 @@ static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
 	uint32_t lvds_gen_cntl, lvds_pll_cntl, pixclks_cntl, disp_pwr_man;
 	int panel_pwr_delay = 2000;
 	bool is_mac = false;
+	uint8_t backlight_level;
 	DRM_DEBUG_KMS("\n");
 
+	lvds_gen_cntl = RREG32(RADEON_LVDS_GEN_CNTL);
+	backlight_level = (lvds_gen_cntl >> RADEON_LVDS_BL_MOD_LEVEL_SHIFT) & 0xff;
+
 	if (radeon_encoder->enc_priv) {
 		if (rdev->is_atom_bios) {
 			struct radeon_encoder_atom_dig *lvds = radeon_encoder->enc_priv;
 			panel_pwr_delay = lvds->panel_pwr_delay;
+			if (lvds->bl_dev)
+				backlight_level = lvds->backlight_level;
 		} else {
 			struct radeon_encoder_lvds *lvds = radeon_encoder->enc_priv;
 			panel_pwr_delay = lvds->panel_pwr_delay;
+			if (lvds->bl_dev)
+				backlight_level = lvds->backlight_level;
 		}
 	}
 
@@ -82,11 +94,13 @@ static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
 		lvds_pll_cntl &= ~RADEON_LVDS_PLL_RESET;
 		WREG32(RADEON_LVDS_PLL_CNTL, lvds_pll_cntl);
 
-		lvds_gen_cntl = RREG32(RADEON_LVDS_GEN_CNTL);
-		lvds_gen_cntl |= (RADEON_LVDS_ON | RADEON_LVDS_EN | RADEON_LVDS_DIGON | RADEON_LVDS_BLON);
+		lvds_gen_cntl &= ~(RADEON_LVDS_DISPLAY_DIS |
+				   RADEON_LVDS_BL_MOD_LEVEL_MASK);
+		lvds_gen_cntl |= (RADEON_LVDS_ON | RADEON_LVDS_EN |
+				  RADEON_LVDS_DIGON | RADEON_LVDS_BLON |
+				  (backlight_level << RADEON_LVDS_BL_MOD_LEVEL_SHIFT));
 		if (is_mac)
 			lvds_gen_cntl |= RADEON_LVDS_BL_MOD_EN;
-		lvds_gen_cntl &= ~(RADEON_LVDS_DISPLAY_DIS);
 		udelay(panel_pwr_delay * 1000);
 		WREG32(RADEON_LVDS_GEN_CNTL, lvds_gen_cntl);
 		break;
@@ -95,7 +109,6 @@ static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
 	case DRM_MODE_DPMS_OFF:
 		pixclks_cntl = RREG32_PLL(RADEON_PIXCLKS_CNTL);
 		WREG32_PLL_P(RADEON_PIXCLKS_CNTL, 0, ~RADEON_PIXCLK_LVDS_ALWAYS_ONb);
-		lvds_gen_cntl = RREG32(RADEON_LVDS_GEN_CNTL);
 		lvds_gen_cntl |= RADEON_LVDS_DISPLAY_DIS;
 		if (is_mac) {
 			lvds_gen_cntl &= ~RADEON_LVDS_BL_MOD_EN;
@@ -119,6 +132,25 @@ static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
 
 }
 
+static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct radeon_device *rdev = encoder->dev->dev_private;
+	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
+	DRM_DEBUG("\n");
+
+	if (radeon_encoder->enc_priv) {
+		if (rdev->is_atom_bios) {
+			struct radeon_encoder_atom_dig *lvds = radeon_encoder->enc_priv;
+			lvds->dpms_mode = mode;
+		} else {
+			struct radeon_encoder_lvds *lvds = radeon_encoder->enc_priv;
+			lvds->dpms_mode = mode;
+		}
+	}
+
+	radeon_legacy_lvds_update(encoder, mode);
+}
+
 static void radeon_legacy_lvds_prepare(struct drm_encoder *encoder)
 {
 	struct radeon_device *rdev = encoder->dev->dev_private;
@@ -237,9 +269,222 @@ static const struct drm_encoder_helper_funcs radeon_legacy_lvds_helper_funcs = {
 	.disable = radeon_legacy_encoder_disable,
 };
 
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+
+#define MAX_RADEON_LEVEL 0xFF
+
+struct radeon_backlight_privdata {
+	struct radeon_encoder *encoder;
+	uint8_t negative;
+};
+
+static uint8_t radeon_legacy_lvds_level(struct backlight_device *bd)
+{
+	struct radeon_backlight_privdata *pdata = bl_get_data(bd);
+	uint8_t level;
+
+	/* Convert brightness to hardware level */
+	if (bd->props.brightness < 0)
+		level = 0;
+	else if (bd->props.brightness > MAX_RADEON_LEVEL)
+		level = MAX_RADEON_LEVEL;
+	else
+		level = bd->props.brightness;
+
+	if (pdata->negative)
+		level = MAX_RADEON_LEVEL - level;
+
+	return level;
+}
+
+static int radeon_legacy_backlight_update_status(struct backlight_device *bd)
+{
+	struct radeon_backlight_privdata *pdata = bl_get_data(bd);
+	struct radeon_encoder *radeon_encoder = pdata->encoder;
+	struct drm_device *dev = radeon_encoder->base.dev;
+	struct radeon_device *rdev = dev->dev_private;
+	int dpms_mode = DRM_MODE_DPMS_ON;
+
+	if (radeon_encoder->enc_priv) {
+		if (rdev->is_atom_bios) {
+			struct radeon_encoder_atom_dig *lvds = radeon_encoder->enc_priv;
+			dpms_mode = lvds->dpms_mode;
+			lvds->backlight_level = radeon_legacy_lvds_level(bd);
+		} else {
+			struct radeon_encoder_lvds *lvds = radeon_encoder->enc_priv;
+			dpms_mode = lvds->dpms_mode;
+			lvds->backlight_level = radeon_legacy_lvds_level(bd);
+		}
+	}
+
+	if (bd->props.brightness > 0)
+		radeon_legacy_lvds_update(&radeon_encoder->base, dpms_mode);
+	else
+		radeon_legacy_lvds_update(&radeon_encoder->base, DRM_MODE_DPMS_OFF);
+
+	return 0;
+}
+
+static int radeon_legacy_backlight_get_brightness(struct backlight_device *bd)
+{
+	struct radeon_backlight_privdata *pdata = bl_get_data(bd);
+	struct radeon_encoder *radeon_encoder = pdata->encoder;
+	struct drm_device *dev = radeon_encoder->base.dev;
+	struct radeon_device *rdev = dev->dev_private;
+	uint8_t backlight_level;
+
+	backlight_level = (RREG32(RADEON_LVDS_GEN_CNTL) >>
+			   RADEON_LVDS_BL_MOD_LEVEL_SHIFT) & 0xff;
+
+	return pdata->negative ? MAX_RADEON_LEVEL - backlight_level : backlight_level;
+}
+
+static const struct backlight_ops radeon_backlight_ops = {
+	.get_brightness = radeon_legacy_backlight_get_brightness,
+	.update_status	= radeon_legacy_backlight_update_status,
+};
+
+void radeon_legacy_backlight_init(struct radeon_encoder *radeon_encoder,
+				  struct drm_connector *drm_connector)
+{
+	struct drm_device *dev = radeon_encoder->base.dev;
+	struct radeon_device *rdev = dev->dev_private;
+	struct backlight_device *bd;
+	struct backlight_properties props;
+	struct radeon_backlight_privdata *pdata;
+	uint8_t backlight_level;
+
+	if (!radeon_encoder->enc_priv)
+		return;
+
+#ifdef CONFIG_PMAC_BACKLIGHT
+	if (!pmac_has_backlight_type("ati") &&
+	    !pmac_has_backlight_type("mnca"))
+		return;
+#endif
+
+	pdata = kmalloc(sizeof(struct radeon_backlight_privdata), GFP_KERNEL);
+	if (!pdata) {
+		DRM_ERROR("Memory allocation failed\n");
+		goto error;
+	}
+
+	props.max_brightness = MAX_RADEON_LEVEL;
+	props.type = BACKLIGHT_RAW;
+	bd = backlight_device_register("radeon_bl", &drm_connector->kdev,
+				       pdata, &radeon_backlight_ops, &props);
+	if (IS_ERR(bd)) {
+		DRM_ERROR("Backlight registration failed\n");
+		goto error;
+	}
+
+	pdata->encoder = radeon_encoder;
+
+	backlight_level = (RREG32(RADEON_LVDS_GEN_CNTL) >>
+			   RADEON_LVDS_BL_MOD_LEVEL_SHIFT) & 0xff;
+
+	/* First, try to detect backlight level sense based on the assumption
+	 * that firmware set it up at full brightness
+	 */
+	if (backlight_level == 0)
+		pdata->negative = true;
+	else if (backlight_level == 0xff)
+		pdata->negative = false;
+	else {
+		/* XXX hack... maybe some day we can figure out in what direction
+		 * backlight should work on a given panel?
+		 */
+		pdata->negative = (rdev->family != CHIP_RV200 &&
+				   rdev->family != CHIP_RV250 &&
+				   rdev->family != CHIP_RV280 &&
+				   rdev->family != CHIP_RV350);
+
+#ifdef CONFIG_PMAC_BACKLIGHT
+		pdata->negative = (pdata->negative ||
+				   of_machine_is_compatible("PowerBook4,3") ||
+				   of_machine_is_compatible("PowerBook6,3") ||
+				   of_machine_is_compatible("PowerBook6,5"));
+#endif
+	}
+
+	if (rdev->is_atom_bios) {
+		struct radeon_encoder_atom_dig *lvds = radeon_encoder->enc_priv;
+		lvds->bl_dev = bd;
+	} else {
+		struct radeon_encoder_lvds *lvds = radeon_encoder->enc_priv;
+		lvds->bl_dev = bd;
+	}
+
+	bd->props.brightness = radeon_legacy_backlight_get_brightness(bd);
+	bd->props.power = FB_BLANK_UNBLANK;
+	backlight_update_status(bd);
+
+	DRM_INFO("radeon legacy LVDS backlight initialized\n");
+
+	return;
+
+error:
+	kfree(pdata);
+	return;
+}
+
+static void radeon_legacy_backlight_exit(struct radeon_encoder *radeon_encoder)
+{
+	struct drm_device *dev = radeon_encoder->base.dev;
+	struct radeon_device *rdev = dev->dev_private;
+	struct backlight_device *bd = NULL;
+
+	if (!radeon_encoder->enc_priv)
+		return;
+
+	if (rdev->is_atom_bios) {
+		struct radeon_encoder_atom_dig *lvds = radeon_encoder->enc_priv;
+		bd = lvds->bl_dev;
+		lvds->bl_dev = NULL;
+	} else {
+		struct radeon_encoder_lvds *lvds = radeon_encoder->enc_priv;
+		bd = lvds->bl_dev;
+		lvds->bl_dev = NULL;
+	}
+
+	if (bd) {
+		struct radeon_legacy_backlight_privdata *pdata;
+
+		pdata = bl_get_data(bd);
+		backlight_device_unregister(bd);
+		kfree(pdata);
+
+		DRM_INFO("radeon legacy LVDS backlight unloaded\n");
+	}
+}
+
+#else /* !CONFIG_BACKLIGHT_CLASS_DEVICE */
+
+static void radeon_legacy_backlight_init(struct radeon_encoder *encoder)
+{
+}
+
+static void radeon_legacy_backlight_exit(struct radeon_encoder *encoder)
+{
+}
+
+#endif
+
+
+static void radeon_lvds_enc_destroy(struct drm_encoder *encoder)
+{
+	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
+
+	if (radeon_encoder->enc_priv) {
+		radeon_legacy_backlight_exit(radeon_encoder);
+		kfree(radeon_encoder->enc_priv);
+	}
+	drm_encoder_cleanup(encoder);
+	kfree(radeon_encoder);
+}
 
 static const struct drm_encoder_funcs radeon_legacy_lvds_enc_funcs = {
-	.destroy = radeon_enc_destroy,
+	.destroy = radeon_lvds_enc_destroy,
 };
 
 static void radeon_legacy_primary_dac_dpms(struct drm_encoder *encoder, int mode)
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 8f93e2b..c112624 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -302,6 +302,11 @@ struct radeon_encoder_lvds {
 	uint32_t lvds_gen_cntl;
 	/* panel mode */
 	struct drm_display_mode native_mode;
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	struct backlight_device *bl_dev;
+	int      dpms_mode;
+	uint8_t  backlight_level;
+#endif
 };
 
 struct radeon_encoder_tv_dac {
@@ -353,6 +358,11 @@ struct radeon_encoder_atom_dig {
 	struct radeon_atom_ss *ss;
 	/* panel mode */
 	struct drm_display_mode native_mode;
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	struct backlight_device *bl_dev;
+	int dpms_mode;
+	uint8_t backlight_level;
+#endif
 };
 
 struct radeon_encoder_atom_dac {
-- 
1.7.1



-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
