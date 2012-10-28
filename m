Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2J1Xsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:48:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41823 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756337Ab2J1X1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:05 -0400
Message-Id: <20121028231609.281019399@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:17:20 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maxim Kachur <mcdebugger@duganet.ru>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 104/105] ALSA: emu10k1: add chip details for E-mu 1010 PCIe card
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Kachur <mcdebugger@duganet.ru>

commit 10f571d09106c3eb85951896522c9650596eff2e upstream.

Add chip details for E-mu 1010 PCIe card. It has the same
chip as found in E-mu 1010b but it uses different PCI id.

Signed-off-by: Maxim Kachur <mcdebugger@duganet.ru>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


