Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2BHVMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:12:32 -0500
Received: from mail.active-venture.com ([67.228.131.195]:61859 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab2BHVMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:12:30 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Feb 2012 16:12:29 EST
Message-ID: <20120208150548.32643cmtaxtymzok@67.228.131.195>
Date: Wed, 08 Feb 2012 15:05:48 -0600
From: guenter@roeck-us.net
To: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
Cc: guenter.roeck@ericsson.com, netdev@vger.kernel.org,
        "afleming@freescale.com" <afleming@freescale.com>,
        "macro@linux-mips.org" <macro@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: drivers/net/phy/phy.c issue
References: <CACW_hTY41xZV6d0W2Z2kRfKOfa+RSQ-A-BoZsZwNXSQmeF_6Gg@mail.gmail.com>
	<1328729420.2261.329.camel@groeck-laptop>
	<CACW_hTbLd3kbuwJy9U2ZGDi3ypD-+KsecjYhku7jwQgFPaRqhg@mail.gmail.com>
In-Reply-To: <CACW_hTbLd3kbuwJy9U2ZGDi3ypD-+KsecjYhku7jwQgFPaRqhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>:

> 2012/2/8 Guenter Roeck <guenter.roeck@ericsson.com>:
>> Copying netdev.
>>
>> On Wed, 2012-02-08 at 09:31 -0500, Frans Meulenbroeks wrote:
>>> Hi
>>>
>>> I found an issue with drivers/net/phy/phy.c
>>> As I could not identify a maintainer for this file I decided to mail
>>> it to the above addressees.
>>> Apologies upfront if it is inappropriate.
>>>
>>> The issue:
>>>
>>> My network interface was configured as 10Mbit, full duplex,   
>>> autonegotiate off.
>>> If the cable is unplugged after 10 seconds or so the interface drops
>>> to half duplex and the message:
>>> Trying 10/HALF
>>> is printed. This message comes (if I am correct from the function
>>> phy_force_reduction in drivers/net/phy/phy.c
>>>
>>> Maybe this is still ok, however if I reconnect my network cable the
>>> interface remains configured as 10 Mbit, half duplex.
>>> I had expected/assumed that it would go back to 10 Mbit, full duplex.
>>>
>>> If I try the same with a 1Gbit full duplex link with autonegotiate on,
>>> the link also drops to half duplex whenever the cable is
>>> disconnected. However reconnecting the cable then brings the interface
>>> back to full duplex again.
>>>
>>> Not sure what is wrong (if the interface should not be dropped to half
>>> or get back to full) and even less an idea how to fix it,
>>> but wanted to report it anyway, in the hope someone can shed a light
>>> on this and/or fix it.
>>>
>> What is your kernel version ? No idea if it makes a difference, but I
>> strongly suspect people will need to know.
>
> Oops, sorry for the incomplete info.
> This was detected in 2.6.38, but the current git head of phy.c differs
> only on a few places that (at least according to my judgement) are not
> related.
> Apologies, but I cannot test on a git head kernel.
>
> And wrt the question of Andy in the subsequent reply.
>
> Hw is a Freescale MPC8313. This is a Gianfar. Is that the info you wanted?
>
This is the MAC. Andy was asking for the PHY chip.

Guenter

> BTW what is the desired behaviour? Should I drop to half duplex? Or
> should I get back to full if I reconnect.
>
> Best regards, Frans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>

