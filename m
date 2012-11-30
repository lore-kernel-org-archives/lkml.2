Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993211Ab2K3TEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:04:24 -0500
Received: from mail.kernel.org ([198.145.19.201]:59970 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993127Ab2K3TDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:03:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Duncan Roe <duncan_roe@acslink.net.au>, Takashi Iwai <tiwai@suse.de>
Subject: [ 35/54] ALSA: hda - Fix missing beep on ASUS X43U notebook
Date: Fri, 30 Nov 2012 10:56:06 -0800
Message-Id: <20121130185211.476588645@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duncan Roe <duncan_roe@acslink.net.au>

commit 7110005e8d5c3cd418fc4b64f9f124f004422a9a upstream.

Signed-off-by: Duncan Roe <duncan_roe@acslink.net.au>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4280,6 +4280,7 @@ static void alc_auto_init_std(struct hda
 	((spec)->beep_amp = HDA_COMPOSE_AMP_VAL(nid, 3, idx, dir))
 
 static const struct snd_pci_quirk beep_white_list[] = {
+	SND_PCI_QUIRK(0x1043, 0x103c, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x829f, "ASUS", 1),
 	SND_PCI_QUIRK(0x1043, 0x83ce, "EeePC", 1),
 	SND_PCI_QUIRK(0x1043, 0x831a, "EeePC", 1),


