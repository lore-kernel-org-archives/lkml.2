Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521Ab2DKO4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:56:48 -0400
Received: from mailrelay01.solcon.nl ([212.45.32.107]:40653 "EHLO
	mailrelay01.solcon.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760162Ab2DKO4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:56:46 -0400
X-Greylist: delayed 1323 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2012 10:56:46 EDT
Message-ID: <4F85967D.4090902@solcon.nl>
Date: Wed, 11 Apr 2012 16:34:37 +0200
From: Albert Pool <albertpool@solcon.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: tiwai@suse.de, perex@perex.cz
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix for Asus A6Vm sound
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been told that model=z71v is necessary for Asus A6Vm (1043:1173) sound to work.

Signed-off-by: Albert Pool<albertpool@solcon.nl>

---

  sound/pci/hda/alc880_quirks.c |    2 +-

  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/alc880_quirks.c b/sound/pci/hda/alc880_quirks.c

index 501501e..1b0358a 100644

--- a/sound/pci/hda/alc880_quirks.c

+++ b/sound/pci/hda/alc880_quirks.c

@@ -1375,7 +1375,7 @@ static const struct snd_pci_quirk alc880_cfg_tbl[] = {

      SND_PCI_QUIRK(0x1043, 0x10c3, "ASUS Wxx", ALC880_ASUS_DIG),

      SND_PCI_QUIRK(0x1043, 0x1113, "ASUS", ALC880_ASUS_DIG),

      SND_PCI_QUIRK(0x1043, 0x1123, "ASUS", ALC880_ASUS_DIG),

-    SND_PCI_QUIRK(0x1043, 0x1173, "ASUS", ALC880_ASUS_DIG),

+    SND_PCI_QUIRK(0x1043, 0x1173, "ASUS A6V", ALC880_Z71V),

      SND_PCI_QUIRK(0x1043, 0x1964, "ASUS Z71V", ALC880_Z71V),

      /* SND_PCI_QUIRK(0x1043, 0x1964, "ASUS", ALC880_ASUS_DIG), */

      SND_PCI_QUIRK(0x1043, 0x1973, "ASUS", ALC880_ASUS_DIG),

-- 

1.7.5.4

