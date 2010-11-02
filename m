Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab0KBUeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 16:34:09 -0400
Received: from mognix.dark-green.com ([88.116.226.179]:62003 "EHLO
	mognix.dark-green.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0KBUeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 16:34:07 -0400
Message-ID: <4CD075BC.3080402@dark-green.com>
Date: Tue, 02 Nov 2010 21:34:04 +0100
From: gimli <gimli@dark-green.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; de; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] MacBookAir3,1(3,2) alsa support
References: <2e2e589908fd826020cfede6291e6168@mognix.dark-green.com> <s5h1v73u4je.wl%tiwai@suse.de>
In-Reply-To: <s5h1v73u4je.wl%tiwai@suse.de>
Content-Type: multipart/mixed;
 boundary="------------070800090505080207060701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070800090505080207060701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Rebased to 2.6.37-rc1

Signed-off-by: Edgar (gimli) Hucek<gimli@dark-green.com>


Am 02.11.10 16:30, schrieb Takashi Iwai:
> At Tue, 02 Nov 2010 08:21:51 +0100,
> gimli wrote:
>>
>> This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the alsa
>> sound system.
>>
>> Signed-off-by: Edgar (gimli) Hucek<gimli@dark-green.com>
>
> The patch isn't applicable to the latest upstream code.
> Could you rebase your patch to 2.6.37-rc1?
>
>
> thanks,
>
> Takashi
>
>
>> [2 snd_hda_macbookair.patch<text/plain; UTF-8 (base64)>]
>> --- a/sound/pci/hda/patch_cirrus.c	2010-10-29 08:30:04.029681004 +0200
>> +++ b/sound/pci/hda/patch_cirrus.c	2010-10-29 08:34:04.509681003 +0200
>> @@ -1089,6 +1089,7 @@
>>   static struct snd_pci_quirk cs420x_cfg_tbl[] = {
>>   	SND_PCI_QUIRK(0x10de, 0xcb79, "MacBookPro 5,5", CS420X_MBP55),
>>   	SND_PCI_QUIRK(0x8086, 0x7270, "IMac 27 Inch", CS420X_IMAC27),
>> +	SND_PCI_QUIRK(0x10de, 0x0d94, "MacBookAir 3,1(2)", CS420X_MBP55),
>>   	{} /* terminator */
>>   };
>>
>


--------------070800090505080207060701
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="snd_hda_macbookair.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="snd_hda_macbookair.patch"

diff -uNr linux-2.6.37-rc1/sound/pci/hda/patch_cirrus.c linux-2.6.37-rc1-patched/sound/pci/hda/patch_cirrus.c
--- linux-2.6.37-rc1/sound/pci/hda/patch_cirrus.c	2010-11-02 21:27:10.000000000 +0100
+++ linux-2.6.37-rc1-patched/sound/pci/hda/patch_cirrus.c	2010-11-02 21:28:53.000000000 +0100
@@ -1169,6 +1169,7 @@
 	SND_PCI_QUIRK(0x10de, 0xcb79, "MacBookPro 5,5", CS420X_MBP55),
 	SND_PCI_QUIRK(0x10de, 0xcb89, "MacBookPro 7,1", CS420X_MBP55),
 	SND_PCI_QUIRK(0x8086, 0x7270, "IMac 27 Inch", CS420X_IMAC27),
+	SND_PCI_QUIRK(0x10de, 0x0d94, "MacBookAir 3,1(2)", CS420X_MBP55),
 	{} /* terminator */
 };
 

--------------070800090505080207060701--
