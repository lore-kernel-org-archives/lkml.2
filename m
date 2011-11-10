Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1KJSTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:19:09 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35236 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1KJSTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:19:02 -0500
Message-ID: <4EBC1592.2060307@garzik.org>
Date: Thu, 10 Nov 2011 13:18:58 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for Oct 11 (ata/pata_of_platform.c)
References: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au> <4E94A920.40503@xenotime.net> <4E987829.3080104@xenotime.net> <20111110135703.GA23609@elte.hu>
In-Reply-To: <20111110135703.GA23609@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 08:57 AM, Ingo Molnar wrote:
>
> * Randy Dunlap<rdunlap@xenotime.net>  wrote:
>
>> On 10/11/2011 01:37 PM, Randy Dunlap wrote:
>>> On 10/11/11 02:11, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> The linux-next tree is now available from
>>>> git://github.com/sfrothwell/linux-next.git as a temporary measure while
>>>> the kernel.org servers are unavailable.
>>>>
>>>> It may also turn up on git.kernel.org (depending on the mirroring).  The
>>>> patch set is still absent, however.
>>>>
>>>> Changes since 20111007:
>>>>
>>>> Removed tree: ide (at the maintainer's request)
>>>
>>>
>>> drivers/ata/pata_of_platform.c:55:13: error: 'NO_IRQ' undeclared (first use in this function)
>>
>>
>> [adding Author: Anton]
>>
>> Build error still present in linux-next of 20111014.
>
> This build failure regression report was ignored twice and then
> pushed upstream and is still unfixed a month after the initial
> report. Upstream now fails to build on like 25% of x86 configs.
>
> What's going on with this bug guys?


Hum, I missed it in my LKML scans, and never got a CC.

Will merge Anton's patch immediately...

	Jeff




