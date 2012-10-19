Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2JSCsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:48:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:51785 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581Ab2JSCsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Maxim Kachur <mcdebugger@duganet.ru>, Takashi Iwai <tiwai@suse.de>
Subject: [ 62/62] ALSA: emu10k1: add chip details for E-mu 1010 PCIe card
Date: Thu, 18 Oct 2012 19:45:30 -0700
Message-Id: <20121019024306.020002764@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Kachur <mcdebugger@duganet.ru>

commit 10f571d09106c3eb85951896522c9650596eff2e upstream.

Add chip details for E-mu 1010 PCIe card. It has the same
chip as found in E-mu 1010b but it uses different PCI id.

Signed-off-by: Maxim Kachur <mcdebugger@duganet.ru>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/emu10k1/emu10k1_main.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -1416,6 +1416,15 @@ static struct snd_emu_chip_details emu_c
 	 .ca0108_chip = 1,
 	 .spk71 = 1,
 	 .emu_model = EMU_MODEL_EMU1010B}, /* EMU 1010 new revision */
+	/* Tested by Maxim Kachur <mcdebugger@duganet.ru> 17th Oct 2012. */
+	/* This is MAEM8986, 0202 is MAEM8980 */
+	{.vendor = 0x1102, .device = 0x0008, .subsystem = 0x40071102,
+	 .driver = "Audigy2", .name = "E-mu 1010 PCIe [MAEM8986]",
+	 .id = "EMU1010",
+	 .emu10k2_chip = 1,
+	 .ca0108_chip = 1,
+	 .spk71 = 1,
+	 .emu_model = EMU_MODEL_EMU1010B}, /* EMU 1010 PCIe */
 	/* Tested by James@superbug.co.uk 8th July 2005. */
 	/* This is MAEM8810, 0202 is MAEM8820 */
 	{.vendor = 0x1102, .device = 0x0004, .subsystem = 0x40011102,


