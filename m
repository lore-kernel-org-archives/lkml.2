Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab1CGSZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 13:25:23 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2633 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab1CGSZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:25:21 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
To: "Francis Moreau" <francis.moro@gmail.com>
cc: "Brett Rudley" <brudley@broadcom.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: brcm80211: the system freezes if booted with laptop wifi
 switch to OFF
References: <AANLkTinhThfS587rkX4y1UbJLQzQKEWGfrFArUVGD3Ew@mail.gmail.com>
 <op.vryqz6qt3ri7v4@arend-laptop>
 <AANLkTinbrbkUO-ycAsX4cLEoM6avPeiYEZZ-zKtavfqq@mail.gmail.com>
 <op.vry7kwq83ri7v4@arend-laptop>
 <AANLkTinWOFPUqmv6PbQMy6xnsAptGKUjoAHoxB65LCy9@mail.gmail.com>
Date: Mon, 7 Mar 2011 19:25:07 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vrzj35j33ri7v4@arend-laptop>
In-Reply-To: <AANLkTinWOFPUqmv6PbQMy6xnsAptGKUjoAHoxB65LCy9@mail.gmail.com>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 616BFC1926W9638425-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Mar 2011 18:29:47 +0100, Francis Moreau  
<francis.moro@gmail.com> wrote:

> On Mon, Mar 7, 2011 at 2:54 PM, Arend van Spriel <arend@broadcom.com>  
> wrote:
>>
>> I don't know what the origin is of your kernel so please provide some
>> details on that.
>
> What kind of information do you need ?
>
> As you probably noticed the kernel I'm running is 2.6.38-rc6.
>

Yup. However, that is not unique by itself. Did you get it from a git  
repository like linux-next maintained by Stephen Rothwell or linux-2.6  
maintained by Linus Torvalds, or did you download a kernel snapshot from  
ftp.kernel.org.

>
> Revelant part of lscpi:
>
> 12:00.0 Network controller: Broadcom Corporation Device 4727 (rev 01)
> 	Subsystem: Dell Device 0010
> 	Flags: bus master, fast devsel, latency 0, IRQ 17
> 	Memory at fbb00000 (64-bit, non-prefetchable) [size=16K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: brcm80211
> 	Kernel modules: brcm80211
>

Always useful to know what hardware you are using. Thanks.

>
>> The patch itself can be found in the linuxdriver email
>> archive:
>>
>> http://driverdev.linuxdriverproject.org/pipermail/devel/2011-January/011381.html
>>
>
> Do you want me to give it a try ?
>

I don't think it will apply cleanly, but sure go ahead.

>
>> Not sure whether it applies to whatever you have. I just tried your  
>> scenario
>> with my driver and hardware and no freezes during boot.
>
> My scenario is:
>
>    - set the switch to OFF
>    - insmod the module
>    - bring up/configure the interface

That's a bit different, but could you elaborate on the last step. Are you  
using iw, wpa_supplicant, etc. or relying on NetworkManager.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

