Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab2FTHpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:45:44 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:49022 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2FTHpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:45:43 -0400
Message-ID: <4FE17F9E.3090009@atmel.com>
Date: Wed, 20 Jun 2012 09:45:34 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] at91: platform data for atmel-mci (for 3.5)
References: <4FBE4FE7.3010005@atmel.com> <4FC722B7.10409@atmel.com> <CAOesGMhq8uzei+Dn8=1iYrTiAOtuByjm58j9zgFyORVG5VZuNQ@mail.gmail.com> <4FCCD8D9.2070005@atmel.com> <4FD8C476.3080904@atmel.com> <CAOesGMi+2-xEv5+s0xEX7UzoC500q87zrXV4bHynQyzXE8Virw@mail.gmail.com>
In-Reply-To: <CAOesGMi+2-xEv5+s0xEX7UzoC500q87zrXV4bHynQyzXE8Virw@mail.gmail.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 03:49 PM, Olof Johansson :
> Hi,
> 
> On Wed, Jun 13, 2012 at 9:48 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
>> On 06/04/2012 05:48 PM, Nicolas Ferre :
>>> On 05/31/2012 11:04 PM, Olof Johansson :
>>>> Hi Nicolas,
>>>>
>>>> On Thu, May 31, 2012 at 12:50 AM, Nicolas Ferre <nicolas.ferre@atmel.com
>>>> <mailto:nicolas.ferre@atmel.com>> wrote:
>>>>
>>>>     On 05/24/2012 05:12 PM, Nicolas Ferre :
>>>>     > Hi Arnd, hi Olof,
>>>>
>>>>     Ping?
>>>>
>>>>     (or maybe you will have a look at this after the merge window...)
>>>>
>>>>
>>>> So, I looked at this branch yesterday but I wasn't entirely happy with
>>>> the number of ifdefs it adds.
>>>
>>> Unfortunately, this is the usual shape of any devices/boards files on
>>> AT91. This amount will be reduced when we remove the old driver and when
>>> we move newer/popular devices to Device Tree...
>>>
>>>> If the idea is to deprecate the old driver, wouldn't it make more sense
>>>> to just cut everyone over instead of having both sets of setup in the
>>>> kernel?
>>>
>>> Well, the old driver has existed since a very long time and I think that
>>> people are used to it on oldest platforms. This is why we put in place a
>>> overlapping period. This way we hope that the transition will be smoother.
>>> On the other hand, the old code will be removed in 3.7 so the
>>> overlapping period will not be so long.
>>> I hope that it will allow people to track bugs if some are remaining and
>>> switch to newer driver easily.
>>
>> Olof, Arnd,
>>
>> So, do you have made up your mind about this pull request?
> 
> Sorry for the delays in handling this, I should have been quicker at replying.
> 
> That said, the driver is staged for removal in 3.7, and this patch is
> 3.6 material at this time. But I think it makes sense to cut every
> in-tree board over completely one release before the driver is
> removed, and thus not keep the old platform data around for them.
> 
> That way the out-of-tree users still have a one-release grace period,
> but everyone with an in-tree board (and the reference platforms) will
> move over sooner. I think I would prefer that over having all these
> ifdefs in the tree, even if it's just for one release.
> 
> I could be convinced otherwise if there's a good reason though. Either
> way, 3.6 is the way to go.

Fair enough, we will prepare a patch to remove the old platform data
combined with this patch. We will integrate in an "at91-3.6-soc"
series/branch that we will submit to you soon.

Thanks, best regards,
-- 
Nicolas Ferre
