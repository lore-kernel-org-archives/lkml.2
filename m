Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab2FKT7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:59:25 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41616 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2FKT7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:59:24 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Cc: Ezequiel Garcia <elezegarcia@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Clemens Ladisch <clemens@ladisch.de>
Subject: [PATCH 1/3] maestro3: Remove unused AC97 register definitions
Date: Mon, 11 Jun 2012 16:58:49 -0300
Message-Id: <1339444731-15678-1-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 sound/pci/maestro3.c |   68 --------------------------------------------------
 1 files changed, 0 insertions(+), 68 deletions(-)

diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index deef213..adb3b4c 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -361,74 +361,6 @@ MODULE_PARM_DESC(amp_gpio, "GPIO pin number for external amp. (default = -1)");
 #define DSP2HOST_REQ_I2SRATE    0x02
 #define DSP2HOST_REQ_TIMER      0x04
 
-/* AC97 registers */
-/* XXX fix this crap up */
-/*#define AC97_RESET              0x00*/
-
-#define AC97_VOL_MUTE_B         0x8000
-#define AC97_VOL_M              0x1F
-#define AC97_LEFT_VOL_S         8
-
-#define AC97_MASTER_VOL         0x02
-#define AC97_LINE_LEVEL_VOL     0x04
-#define AC97_MASTER_MONO_VOL    0x06
-#define AC97_PC_BEEP_VOL        0x0A
-#define AC97_PC_BEEP_VOL_M      0x0F
-#define AC97_SROUND_MASTER_VOL  0x38
-#define AC97_PC_BEEP_VOL_S      1
-
-/*#define AC97_PHONE_VOL          0x0C
-#define AC97_MIC_VOL            0x0E*/
-#define AC97_MIC_20DB_ENABLE    0x40
-
-/*#define AC97_LINEIN_VOL         0x10
-#define AC97_CD_VOL             0x12
-#define AC97_VIDEO_VOL          0x14
-#define AC97_AUX_VOL            0x16*/
-#define AC97_PCM_OUT_VOL        0x18
-/*#define AC97_RECORD_SELECT      0x1A*/
-#define AC97_RECORD_MIC         0x00
-#define AC97_RECORD_CD          0x01
-#define AC97_RECORD_VIDEO       0x02
-#define AC97_RECORD_AUX         0x03
-#define AC97_RECORD_MONO_MUX    0x02
-#define AC97_RECORD_DIGITAL     0x03
-#define AC97_RECORD_LINE        0x04
-#define AC97_RECORD_STEREO      0x05
-#define AC97_RECORD_MONO        0x06
-#define AC97_RECORD_PHONE       0x07
-
-/*#define AC97_RECORD_GAIN        0x1C*/
-#define AC97_RECORD_VOL_M       0x0F
-
-/*#define AC97_GENERAL_PURPOSE    0x20*/
-#define AC97_POWER_DOWN_CTRL    0x26
-#define AC97_ADC_READY          0x0001
-#define AC97_DAC_READY          0x0002
-#define AC97_ANALOG_READY       0x0004
-#define AC97_VREF_ON            0x0008
-#define AC97_PR0                0x0100
-#define AC97_PR1                0x0200
-#define AC97_PR2                0x0400
-#define AC97_PR3                0x0800
-#define AC97_PR4                0x1000
-
-#define AC97_RESERVED1          0x28
-
-#define AC97_VENDOR_TEST        0x5A
-
-#define AC97_CLOCK_DELAY        0x5C
-#define AC97_LINEOUT_MUX_SEL    0x0001
-#define AC97_MONO_MUX_SEL       0x0002
-#define AC97_CLOCK_DELAY_SEL    0x1F
-#define AC97_DAC_CDS_SHIFT      6
-#define AC97_ADC_CDS_SHIFT      11
-
-#define AC97_MULTI_CHANNEL_SEL  0x74
-
-/*#define AC97_VENDOR_ID1         0x7C
-#define AC97_VENDOR_ID2         0x7E*/
-
 /*
  * ASSP control regs
  */
-- 
1.7.4.4

