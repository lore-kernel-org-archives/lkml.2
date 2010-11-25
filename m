Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab0KYT0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 14:26:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:53453 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab0KYT0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 14:26:53 -0500
Message-ID: <4CEEB86F.8070105@infradead.org>
Date: Thu, 25 Nov 2010 17:26:39 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Marek <mmarek@suse.cz>,
        randy.dunlap@oracle.com, catalin.marinas@arm.com,
        linux-kbuild@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com
Subject: Re: [PATCH] Revert "kconfig: Temporarily disable dependency warnings"
References: <20101011145930.11fe570c.randy.dunlap@oracle.com>	<1286889586-13483-1-git-send-email-mmarek@suse.cz>	<20101029113731.5c7c54b9.sfr@canb.auug.org.au>	<20101122114801.2eee4c4d.sfr@canb.auug.org.au>	<AANLkTikwxBZUupGNA-gsrxWYpyCKK7wiVZu82WaUST-K@mail.gmail.com>	<20101122135715.121b5eb7.sfr@canb.auug.org.au> <AANLkTi=io3tsuL8Hd2a0y8PyBYYAzb-gkJo1GfmpcF+L@mail.gmail.com>
In-Reply-To: <AANLkTi=io3tsuL8Hd2a0y8PyBYYAzb-gkJo1GfmpcF+L@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-11-2010 15:16, Arnaud Lacombe escreveu:
> Hi,
> 
> On Sun, Nov 21, 2010 at 9:57 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi,
>>
>> On Sun, 21 Nov 2010 20:58:54 -0500 Arnaud Lacombe <lacombar@gmail.com> wrote:
>>>
>>> There is 2 patches which fixes that by adding to the kconfig language
>>> a "visible" property to menus, 1 revert of "another" solution (which
>>> works but does not scale) and 2 patch which makes usage of the new
>>> property. Ack-ed and complemented by Mauro, but still waiting
>>> review/blessing by Michal.
>>>
>>> The core change is available here: https://patchwork.kernel.org/patch/306412/
>>>
>>> Alternatively, if you don't care about the menu structure, Randy
>>> proposed a one-liner.
>>
>> OK, good to know it is being worked on.  Thanks.
>>
> FYI, I withdrawn the patches and ask for them not to be merged[0], as
> there is a clear lack of interest to see this issue resolved.
> 
> Mauro, may I ask you to remove my patches from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-next.git
> kconfig_fixes
> 
> please ?

I prefer to have them there, while the issue remains at .37/-next builds.

It is a pain to see all those warnings polluting my console, every time 
I recompile things, and I can't simply do a grep to discard MEDIA 
warnings/errors (as someone proposed), as this may prevent me to get real
errors at media builds.

The better is to give more time to Marek/Sam to review your patch
series and ack or, if they don't agree, to send an alternative patchset
to fix the issues or to revert the changeset that started to produce 
those troubles.

Cheers,
Mauro
