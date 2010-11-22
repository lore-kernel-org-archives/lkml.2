Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab0KVPD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 10:03:59 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40353 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab0KVPD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 10:03:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oL/umRxCwIyz8d0ZbtQ0+OdAjNmWpd3TFrwZ4qBbmXY1c68RSJH1iG3RZU/DkVpOVD
         nB8IhW3fGP07W4QhMRU8g1oSyxuUmi6hECZjabTzndA9x26MuFQVrrzM79/1w21NQBQq
         QapyIY4kVr2CrJCO+1C4skWlsiaoZGoxgyGQk=
MIME-Version: 1.0
In-Reply-To: <s5h8w0lsvsi.wl%tiwai@suse.de>
References: <AANLkTin2zKWLLxsRn+T+U+NpAmbQiOTM_vrg_Z-8JZd-@mail.gmail.com>
	<AANLkTinWMv0XEt1ERcNdcPiqhSfqi59jH_G2T-SBHGaN@mail.gmail.com>
	<s5h8w0lsvsi.wl%tiwai@suse.de>
Date: Mon, 22 Nov 2010 08:58:25 -0600
X-Google-Sender-Auth: 9GSgu5P77XK5Ta66_J1ftWdJjkM
Message-ID: <AANLkTi=esSJJreo-avXjM4_OafqbjV=s7Lnudzrc_30i@mail.gmail.com>
Subject: Re: [PATCH] Enable jack sense for Thinkpad Edge 11
From: Manoj Iyer <manoj.iyer@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 12:43 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 18 Nov 2010 23:20:50 -0500,
> Manoj Iyer wrote:
>>
>> Sorry my patch encoding was broken, below is the correction.
>>
>>  The following changes since commit 0c1c062266ecfeaebadadb780020a422f829284f:
>>   Manoj Iyer (1):
>>         Enable jack sense for Thinkpad Edge 11
>>
>>  are available in the git repository at:
>>
>>  git://kernel.ubuntu.com/manjo/linux-2.6.git thinpad11
>
> The fixed patch seems missing.  Could you repost?

>From 89796b0608f0c36cbd05d0426e95386766ff20b9 Mon Sep 17 00:00:00 2001
From: Manoj Iyer <manoj.iyer@canonical.com>
Date: Thu, 18 Nov 2010 21:24:42 +0000
Subject: [PATCH] Enable jack sense for Thinkpad Edge 11

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
---
 sound/pci/hda/patch_conexant.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 6361f75..b8d6554 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3108,6 +3108,7 @@ static struct snd_pci_quirk cxt5066_cfg_tbl[] = {
        SND_PCI_QUIRK(0x152d, 0x0833, "OLPC XO-1.5", CXT5066_OLPC_XO_1_5),
        SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo T400s", CXT5066_THINKPAD),
        SND_PCI_QUIRK(0x17aa, 0x21b2, "Thinkpad X100e", CXT5066_IDEAPAD),
+       SND_PCI_QUIRK(0x17aa, 0x21c8, "Thinkpad Edge 11", CXT5066_THINKPAD),
        SND_PCI_QUIRK(0x17aa, 0x21b3, "Thinkpad Edge 13 (197)",
CXT5066_IDEAPAD),
        SND_PCI_QUIRK(0x17aa, 0x21b4, "Thinkpad Edge", CXT5066_IDEAPAD),
        SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo Thinkpad", CXT5066_THINKPAD),
-- 
1.7.0.4



>
>
> thanks,
>
> Takashi
>
>>
>> On Thu, Nov 18, 2010 at 4:35 PM, Manoj Iyer <manoj.iyer@canonical.com> wrote:
>> > This patch enables audio play back from external headphones on Thinkpad Edge 11.
>> >
>> > The following changes since commit 0c1c062266ecfeaebadadb780020a422f829284f:
>> >  Manoj Iyer (1):
>> >        Enable jack sense for Thinkpad Edge 11
>> >
>> > are available in the git repository at:
>> >
>> >  git://kernel.ubuntu.com/git/manjo/linux-2.6.git thinpad11
>> >
>> > From 89796b0608f0c36cbd05d0426e95386766ff20b9 Mon Sep 17 00:00:00 2001
>> > From: Manoj Iyer <manoj.iyer@canonical.com>
>> > Date: Thu, 18 Nov 2010 21:24:42 +0000
>> > Subject: [PATCH] Enable jack sense for Thinkpad Edge 11
>> >
>> > Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
>> > ---
>> >  sound/pci/hda/patch_conexant.c |    1 +
>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
>> > index 6361f75..b8d6554 100644
>> > --- a/sound/pci/hda/patch_conexant.c
>> > +++ b/sound/pci/hda/patch_conexant.c
>> > @@ -3108,6 +3108,7 @@ static struct snd_pci_quirk cxt5066_cfg_tbl[] = {
>> >        SND_PCI_QUIRK(0x152d, 0x0833, "OLPC XO-1.5", CXT5066_OLPC_XO_1_5),
>> >        SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo T400s", CXT5066_THINKPAD),
>> >        SND_PCI_QUIRK(0x17aa, 0x21b2, "Thinkpad X100e", CXT5066_IDEAPAD),
>> > +       SND_PCI_QUIRK(0x17aa, 0x21c8, "Thinkpad Edge 11", CXT5066_THINKPAD),
>> >        SND_PCI_QUIRK(0x17aa, 0x21b3, "Thinkpad Edge 13 (197)",
>> > CXT5066_IDEAPAD),
>> >        SND_PCI_QUIRK(0x17aa, 0x21b4, "Thinkpad Edge", CXT5066_IDEAPAD),
>> >        SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo Thinkpad", CXT5066_THINKPAD),
>> > --
>> > 1.7.0.4
>> >
>> > ---
>> > Manoj Iyer
>> >
>>
>>
>>
>> --
>> --manjo
>>
>



-- 
--manjo
