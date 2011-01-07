Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1AGKL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:11:56 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:36500 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab1AGKLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:11:53 -0500
Message-ID: <4D26E565.6000708@snapgear.com>
Date: Fri, 7 Jan 2011 20:05:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Andreas Schwab <schwab@linux-m68k.org>,
        Thorsten Glaser <tg@mirbsd.de>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>
Subject: Re: Signal patchset
References: <AANLkTi=9B-8KN0oiXoiU+KqPt6B8Vs=d7yu9cui-7e1r@mail.gmail.com>	<20101215101027.GA31097@ZenIV.linux.org.uk>	<4D0A12EA.6040605@snapgear.com> <AANLkTi=iddsbRr+N5iLuGBizbFFQ2JN9sgBFC_Q3uA2K@mail.gmail.com>
In-Reply-To: <AANLkTi=iddsbRr+N5iLuGBizbFFQ2JN9sgBFC_Q3uA2K@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jan 2011 10:05:43.0035 (UTC) FILETIME=[71D24CB0:01CBAE52]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Geert,

On 07/01/11 06:42, Geert Uytterhoeven wrote:
> On Thu, Dec 16, 2010 at 14:23, Greg Ungerer<gerg@snapgear.com>  wrote:
>> On 15/12/10 20:10, Al Viro wrote:
>>> On Sun, Dec 05, 2010 at 12:15:10PM +0100, Geert Uytterhoeven wrote:
>>>
>>>> Unless someone objects, I'm inclined to apply Al's patchset, as it
>>>> improves the
>>>> situation anyway.
>>>>
>>>> OK?
>>>
>>> FWIW, there's an m68knommu counterpart (ACKed by gerg a while ago).  The
>>> entire bunch is on ftp.linux.org.uk/pub/people/viro/m68k-signals - both m68k
>>> and m68knommu sets.  I don't know how you guys would prefer it done, since
>
> Thx, good the know the nommu part is there, as I don't seem to have it
> in my mailbox.
>
>>> there's a trivial dependency between m68k and m68knommu parts of series -
>>> the former has
>>> +#ifndef __uClinux__
>>> +#define __ARCH_WANT_SYS_RT_SIGSUSPEND
>>> +#endif
>>> in unistd.h and the latter does
>>> -#ifndef __uClinux__
>>>   #define __ARCH_WANT_SYS_RT_SIGSUSPEND
>>> -#endif
>>> Both parts switch to generic sys_rt_sigsuspend(), for mmu and nommu resp.,
>>> so they need __ARCH_WANT_SYS_RT_SIGSUSPEND defined as soon as conversion
>>> is done.  Other than that they are independent.
>>
>> I can make sure to send to Linus after Geert. Unless Geert you
>> want to take and send both the m68k and m68knommu changes?
>
> I can take the m68knommu changes with your ack, too.
> I'll try to take a look at it tomorrow...

Acked-by: Greg Ungerer <gerg@uclinux.org>

:-)

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
