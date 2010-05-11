Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0EKFx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 01:53:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53156 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab0EKFx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 01:53:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EtpME+Mc+mav6rmqR/lpv2+GpakpIwQ+bWqItYDtEc2zSVCSEzg0YxSagAp5Bwu7kM
         4Fikkgy8/8dobiU45HOJzs+k13agJZDgPdD3yBBZReawkVifyVdVEURCI6jKkQ/M+t2w
         cbSVvkU9s9aSTbeTF/7pgEPAbLAXRcHfJb6e8=
MIME-Version: 1.0
In-Reply-To: <4BE896FC.2050407@tuxonice.net>
References: <20100510223322.347254355@kvm.kroah.org>
	 <4BE896FC.2050407@tuxonice.net>
Date: Tue, 11 May 2010 07:53:25 +0200
Message-ID: <AANLkTinUQ-ra-0lknwTAPIp996NU40o0LKjsq1sXc6Va@mail.gmail.com>
Subject: Re: [057/117] ALSA: hda: Use STAC_DELL_M6_BOTH quirk for Dell Studio 
	1558
From: Daniel Chen <seven.steps@gmail.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel T Chen <crimsun@ubuntu.com>, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/10 08:32, Greg KH wrote:
>> 2.6.33-stable review patch.  If anyone has any objections, please let us
>> know.
...
>> commit 5c1bccf645d4ab65e4c7502acb42e8b9afdb5bdc upstream.
>>
>> BugLink: https://launchpad.net/bugs/568600
>>
>> The OR has verified that the dell-m6 model quirk is necessary for audio
>> to be audible by default on the Dell Studio XPS 1645.
...
>>  sound/pci/hda/patch_sigmatel.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> --- a/sound/pci/hda/patch_sigmatel.c
>> +++ b/sound/pci/hda/patch_sigmatel.c
>> @@ -1604,6 +1604,8 @@ static struct snd_pci_quirk stac92hd73xx
>>                                "Dell Studio 1557", STAC_DELL_M6_DMIC),
>>        SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02fe,
>>                                "Dell Studio XPS 1645", STAC_DELL_M6_BOTH),
>> +       SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0413,
>> +                               "Dell Studio 1558", STAC_DELL_M6_BOTH),
>>        {} /* terminator */
>>  };


On Tue, May 11, 2010 at 1:30 AM, Nigel Cunningham <nigel@tuxonice.net> wrote:
> Just that the commit comment doesn't match the code here.

Oops, simply brown paper bag copy-n'-paste error. I'm happy to respin
for clarification if necessary.

Best,
-Dan
