Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1BYH6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 02:58:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49849 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab1BYH6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 02:58:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=bLff2f6YOAmiFQlRJYGPYQ0e8F/sfsXO4pH1goQAC5u1WejBhilDCve+TsIuuH9SzT
         8cA0IZgFfOeWEw3fG8A7OCgNrSiqcOMDJhDOmPcxBKu2j3+waWUgzowEMO+kCJDl/sh3
         tLlJVHOetspX+tf7IyhMUPd0uL6tiFF1BcUO4=
Cc: trivial@kernel.org, perex@perex.cz, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-Id: <2621AB8F-E727-4555-8DE4-A2ECC84DC8A9@gmail.com>
From: Justin Mattock <justinmattock@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
In-Reply-To: <s5hpqqgh7o2.wl%tiwai@suse.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH 20/21]sound:pci:hda:patch_realtek.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 23:58:49 -0800
References: <1298614562-4230-1-git-send-email-justinmattock@gmail.com> <s5hpqqgh7o2.wl%tiwai@suse.de>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 24, 2011, at 11:53 PM, Takashi Iwai wrote:

> At Thu, 24 Feb 2011 22:16:02 -0800,
> Justin P. Mattock wrote:
>>
>> The patch below removes an extra "l" in the word.
>>
>> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> Thanks, applied both patches 19 and 20 to sound git tree.
>
>
> Takashi
>

alright!!

>>
>> ---
>> sound/pci/hda/patch_realtek.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/ 
>> patch_realtek.c
>> index 3328a25..c5208c9 100644
>> --- a/sound/pci/hda/patch_realtek.c
>> +++ b/sound/pci/hda/patch_realtek.c
>> @@ -4705,7 +4705,7 @@ static struct snd_pci_quirk alc880_cfg_tbl[]  
>> = {
>> 	SND_PCI_QUIRK(0x1558, 0x5401, "ASUS", ALC880_ASUS_DIG2),
>> 	SND_PCI_QUIRK(0x1565, 0x8202, "Biostar", ALC880_5ST_DIG),
>> 	SND_PCI_QUIRK(0x1584, 0x9050, "Uniwill", ALC880_UNIWILL_DIG),
>> -	SND_PCI_QUIRK(0x1584, 0x9054, "Uniwlll", ALC880_F1734),
>> +	SND_PCI_QUIRK(0x1584, 0x9054, "Uniwill", ALC880_F1734),
>> 	SND_PCI_QUIRK(0x1584, 0x9070, "Uniwill", ALC880_UNIWILL),
>> 	SND_PCI_QUIRK(0x1584, 0x9077, "Uniwill P53", ALC880_UNIWILL_P53),
>> 	SND_PCI_QUIRK(0x161f, 0x203d, "W810", ALC880_W810),
>> -- 
>> 1.7.4.1
>>


Justin P. Mattock
