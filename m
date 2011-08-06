Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab1HFS2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 14:28:52 -0400
Received: from smtp.ioda.net ([87.98.140.96]:48509 "EHLO smtp.ioda.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab1HFS2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 14:28:50 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Aug 2011 14:28:50 EDT
Message-ID: <4E3D858C.5050804@ioda-net.ch>
Date: Sat, 06 Aug 2011 20:18:52 +0200
From: Bruno Friedmann <bruno@ioda-net.ch>
Organization: Ioda-Net =?UTF-8?B?U8Ogcmw=?=
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110729 Thunderbird/6.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Mel Gorman <mgorman@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] x86: Add reboot quirk for Dell Precision M4600
References: <20110727125651.GH3010@suse.de> <20110806065635.GE13220@elte.hu> <24c471f7-80f5-4102-a12b-d6245c8d0921@email.android.com> <alpine.LFD.2.02.1108061120150.3197@x980>
In-Reply-To: <alpine.LFD.2.02.1108061120150.3197@x980>
X-Enigmail-Version: 1.3a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2011 05:31 PM, Len Brown wrote:
> On Sat, 6 Aug 2011, H. Peter Anvin wrote:
> 
>> Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> * Mel Gorman <mgorman@suse.de> wrote:
>>>
>>>> ACPI reboot does not work for Dell Precision M4600. Detect this
>>>> machine via DMI and force the use of the PCI reboot method.
>>>>     
>>>> Reported-and-tested-by: Bruno Friedmann <bruno@ioda-net.ch>
>>>> Signed-off-by: Mel Gorman <mgorman@suse.de>
>>>> ---
>>>>  arch/x86/kernel/reboot.c |    9 +++++++++
>>>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>>
>>> Weird - ACPI is the default Windows method of reboot - how come it 
>>> does not work on that box? Does Windows work around this specific 
>>> machine (unlikely), or is our ACPI boot sequence not 100% compatible 
>>> with the Windows method (more likely IMO)?
>>
>> It seems almost all the affected machines are Dell, too... very odd, no?
> 
> Dell website says that the M4600 is current,
> and ships with Windows 7.  It is a "mobile workstation",
> so it is more likely to have a windows "feature" driver,
> say, than Dell's servers.

And this computer can be buyed with RedHat 6.0 by phone call.
If you check the support website download and drivers you will some drivers for Redhat
(mainly the new version of alsa)
http://dell.to/r1IKhp

> 
> Matthew,
> Did you do your reboot comopatibility test using Win7,
> or something older?
> 
> BTW, it would be nice if ACPI incompatibilities and workarounds
> somehow got stuck in the ACPI code rather than the arch code.
> Unfortunately this kind sets a working reboot method instead
> of disabling a non-working one -- so what it overrides has
> changed when the default changed.
> 
> thanks,
> -Len Brown, Intel Open Source Technolgy Center
> 

In any case, if you want anymore testing, and dumps of something, just drop me an email
and the howto get it formatted as you want it.

Actually I'm in the desktop summit with the computer until 9th August night.

I don't know if we can find an owner of the M6600 (the 17") version to get feedback about that hardware which share
a lot with the M4600.

Also Dell can upgrade their Bios.

The only error or significant warning I saw in boot.msg is
<3>[   36.851649] sdhci-pci 0000:0b:00.1: Invalid iomem size. You may experience problems.




-- 

Bruno Friedmann
Ioda-Net Sàrl www.ioda-net.ch

openSUSE Member & Ambassador
GPG KEY : D5C9B751C4653227
irc: tigerfoot
