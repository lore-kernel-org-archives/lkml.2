Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab0C1TgW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 15:36:22 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36896 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab0C1TgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 15:36:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=j/+b/zGOvfe++lQ1pxUY7+7U3FqNFAYVIp7G2hrI04w8W/NwmSq+URpCn358ZPnoi8
         /iWKo50d/gtC6aWvQD8PwImtVyV6uP8/r/VKa5Iu7mfpMFsLq6vrf8PqTDDBnPPJIvoz
         V8623i5oEDs0Ak5X1H8pBT/h9aSUvL3lv42UM=
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 1/2] Staging: line6: rewrote inline comments in control.h This is a patch to control.h that presents certain inline comments in a neater way, and which eliminates the 80 character error found by the checkpatch.pl tool. Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
Date: Sun, 28 Mar 2010 21:36:09 +0200
Message-Id: <1269804969-7138-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/line6/control.h |  166 +++++++++++++++++++++++++++++----------
 1 files changed, 123 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/line6/control.h b/drivers/staging/line6/control.h
index 2f19665..47e18ab 100644
--- a/drivers/staging/line6/control.h
+++ b/drivers/staging/line6/control.h
@@ -22,24 +22,44 @@
 enum {
 	POD_tweak                          =   1,
 	POD_wah_position                   =   4,
-	POD_compression_gain               =   5,  /* device: LINE6_BITS_PODXTALL */
+
+	/* device: LINE6_BITS_PODXTALL */
+	POD_compression_gain               =   5,
+
 	POD_vol_pedal_position             =   7,
 	POD_compression_threshold          =   9,
 	POD_pan                            =  10,
 	POD_amp_model_setup                =  11,
-	POD_amp_model                      =  12,  /* firmware: 2.0 */
+	POD_amp_model                      =  12, /* firmware: 2.0 */
 	POD_drive                          =  13,
 	POD_bass                           =  14,
-	POD_mid                            =  15,  /* device: LINE6_BITS_PODXTALL */
-	POD_lowmid                         =  15,  /* device: LINE6_BITS_BASSPODXTALL */
-	POD_treble                         =  16,  /* device: LINE6_BITS_PODXTALL */
-	POD_highmid                        =  16,  /* device: LINE6_BITS_BASSPODXTALL */
+
+	/* device: LINE6_BITS_PODXTALL */
+	POD_mid                            =  15,
+
+	 /* device: LINE6_BITS_BASSPODXTALL */
+	POD_lowmid                         =  15,
+
+	/* device: LINE6_BITS_PODXTALL */
+	POD_treble                         =  16,
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_highmid                        =  16,
+
 	POD_chan_vol                       =  17,
-	POD_reverb_mix                     =  18,  /* device: LINE6_BITS_PODXTALL */
+
+	/* device: LINE6_BITS_PODXTALL */
+	POD_reverb_mix                     =  18,
+
 	POD_effect_setup                   =  19,
 	POD_band_1_frequency               =  20,  /* firmware: 2.0 */
-	POD_presence                       =  21,  /* device: LINE6_BITS_PODXTALL */
-	POD_treble__bass                   =  21,  /* device: LINE6_BITS_BASSPODXTALL */
+
+	/* device: LINE6_BITS_PODXTALL */
+	POD_presence                       =  21,
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_treble__bass                   =  21,
+
 	POD_noise_gate_enable              =  22,
 	POD_gate_threshold                 =  23,
 	POD_gate_decay_time                =  24,
@@ -50,78 +70,137 @@ enum {
 	POD_mod_param_1                    =  29,
 	POD_delay_param_1                  =  30,
 	POD_delay_param_1_note_value       =  31,
-	POD_band_2_frequency__bass         =  32,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_band_2_frequency__bass         =  32,  /* firmware: 2.0 */
+
 	POD_delay_param_2                  =  33,
 	POD_delay_volume_mix               =  34,
 	POD_delay_param_3                  =  35,
-	POD_reverb_enable                  =  36,  /* device: LINE6_BITS_PODXTALL */
-	POD_reverb_type                    =  37,  /* device: LINE6_BITS_PODXTALL */
-	POD_reverb_decay                   =  38,  /* device: LINE6_BITS_PODXTALL */
-	POD_reverb_tone                    =  39,  /* device: LINE6_BITS_PODXTALL */
-	POD_reverb_pre_delay               =  40,  /* device: LINE6_BITS_PODXTALL */
-	POD_reverb_pre_post                =  41,  /* device: LINE6_BITS_PODXTALL */
-	POD_band_2_frequency               =  42,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
-	POD_band_3_frequency__bass         =  42,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_PODXTALL */
+	POD_reverb_enable                  =  36,
+	POD_reverb_type                    =  37,
+	POD_reverb_decay                   =  38,
+	POD_reverb_tone                    =  39,
+	POD_reverb_pre_delay               =  40,
+	POD_reverb_pre_post                =  41,
+	POD_band_2_frequency               =  42,
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_band_3_frequency__bass         =  42,  /* firmware: 2.0 */
+
 	POD_wah_enable                     =  43,
-	POD_modulation_lo_cut              =  44,  /* device: LINE6_BITS_BASSPODXTALL */
-	POD_delay_reverb_lo_cut            =  45,  /* device: LINE6_BITS_BASSPODXTALL */
-	POD_volume_pedal_minimum           =  46,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
-	POD_eq_pre_post                    =  46,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_modulation_lo_cut              =  44,
+	POD_delay_reverb_lo_cut            =  45,
+
+	/* device: LINE6_BITS_PODXTALL */
+	POD_volume_pedal_minimum           =  46,  /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_eq_pre_post                    =  46,  /* firmware: 2.0 */
+
 	POD_volume_pre_post                =  47,
-	POD_di_model                       =  48,  /* device: LINE6_BITS_BASSPODXTALL */
-	POD_di_delay                       =  49,  /* device: LINE6_BITS_BASSPODXTALL */
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_di_model                       =  48,
+	POD_di_delay                       =  49,
+
 	POD_mod_enable                     =  50,
 	POD_mod_param_1_note_value         =  51,
 	POD_mod_param_2                    =  52,
 	POD_mod_param_3                    =  53,
 	POD_mod_param_4                    =  54,
-	POD_mod_param_5                    =  55,  /* device: LINE6_BITS_BASSPODXTALL */
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_mod_param_5                    =  55,
+
 	POD_mod_volume_mix                 =  56,
 	POD_mod_pre_post                   =  57,
 	POD_modulation_model               =  58,
-	POD_band_3_frequency               =  60,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
-	POD_band_4_frequency__bass         =  60,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_PODXTALL */
+	POD_band_3_frequency               =  60,  /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_band_4_frequency__bass         =  60,  /* firmware: 2.0 */
+
 	POD_mod_param_1_double_precision   =  61,
 	POD_delay_param_1_double_precision =  62,
 	POD_eq_enable                      =  63,  /* firmware: 2.0 */
 	POD_tap                            =  64,
 	POD_volume_tweak_pedal_assign      =  65,
-	POD_band_5_frequency               =  68,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_band_5_frequency               =  68,  /* firmware: 2.0 */
+
 	POD_tuner                          =  69,
 	POD_mic_selection                  =  70,
 	POD_cabinet_model                  =  71,
 	POD_stomp_model                    =  75,
 	POD_roomlevel                      =  76,
-	POD_band_4_frequency               =  77,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
-	POD_band_6_frequency               =  77,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_PODXTALL */
+	POD_band_4_frequency               =  77,  /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_band_6_frequency               =  77,  /* firmware: 2.0 */
+
 	POD_stomp_param_1_note_value       =  78,
 	POD_stomp_param_2                  =  79,
 	POD_stomp_param_3                  =  80,
 	POD_stomp_param_4                  =  81,
 	POD_stomp_param_5                  =  82,
 	POD_stomp_param_6                  =  83,
-	POD_amp_switch_select              =  84,  /* device: LINE6_BITS_LIVE */
+
+	/* device: LINE6_BITS_LIVE */
+	POD_amp_switch_select              =  84,
+
 	POD_delay_param_4                  =  85,
 	POD_delay_param_5                  =  86,
 	POD_delay_pre_post                 =  87,
-	POD_delay_model                    =  88,  /* device: LINE6_BITS_PODXTALL */
-	POD_delay_verb_model               =  88,  /* device: LINE6_BITS_BASSPODXTALL */
+
+	/* device: LINE6_BITS_PODXTALL */
+	POD_delay_model                    =  88,
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_delay_verb_model               =  88,
+
 	POD_tempo_msb                      =  89,
 	POD_tempo_lsb                      =  90,
 	POD_wah_model                      =  91,  /* firmware: 3.0 */
 	POD_bypass_volume                  = 105,  /* firmware: 2.14 */
-	POD_fx_loop_on_off                 = 107,  /* device: LINE6_BITS_PRO */
+
+	/* device: LINE6_BITS_PRO */
+	POD_fx_loop_on_off                 = 107,
+
 	POD_tweak_param_select             = 108,
 	POD_amp1_engage                    = 111,
 	POD_band_1_gain                    = 114,  /* firmware: 2.0 */
-	POD_band_2_gain__bass              = 115,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-	POD_band_2_gain                    = 116,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
-	POD_band_3_gain__bass              = 116,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-	POD_band_3_gain                    = 117,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
-	POD_band_4_gain__bass              = 117,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-	POD_band_5_gain__bass              = 118,  /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
-	POD_band_4_gain                    = 119,  /* device: LINE6_BITS_PODXTALL */     /* firmware: 2.0 */
-	POD_band_6_gain__bass              = 119   /* device: LINE6_BITS_BASSPODXTALL */ /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_band_2_gain__bass              = 115,  /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_PODXTALL */
+	POD_band_2_gain                    = 116,  /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_band_3_gain__bass              = 116,  /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_PODXTALL */
+	POD_band_3_gain                    = 117,  /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_band_4_gain__bass              = 117,  /* firmware: 2.0 */
+	POD_band_5_gain__bass              = 118,  /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_PODXTALL */
+	POD_band_4_gain                    = 119,  /* firmware: 2.0 */
+
+	/* device: LINE6_BITS_BASSPODXTALL */
+	POD_band_6_gain__bass              = 119   /* firmware: 2.0 */
 };
 
 /**
@@ -139,7 +218,8 @@ enum {
 	VARIAX_pickup2_position            =  23,  /* type: 24 bit float */
 	VARIAX_pickup2_angle               =  26,  /* type: 24 bit float */
 	VARIAX_pickup2_level               =  29,  /* type: 24 bit float */
-	VARIAX_pickup_phase                =  32,  /* 0: in phase, 1: out of phase */
+	VARIAX_pickup_phase                =  32,  /* 0: in phase,
+						      1: out of phase */
 	VARIAX_capacitance                 =  33,  /* type: 24 bit float */
 	VARIAX_tone_resistance             =  36,  /* type: 24 bit float */
 	VARIAX_volume_resistance           =  39,  /* type: 24 bit float */
-- 
1.6.3.3

