Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab0HQHRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:17:43 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52302 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0HQHRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:17:41 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimTiaTMXL2xd1m-UJd8hR7kntiKE2Z=7o+GMoME@mail.gmail.com>
References: <20100817060051.20467.10072.stgit@angua> <4C6A28F6.4090701@monstr.eu>
 <AANLkTimTiaTMXL2xd1m-UJd8hR7kntiKE2Z=7o+GMoME@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 17 Aug 2010 01:17:21 -0600
X-Google-Sender-Auth: UJHfs4AthQ07w7fADDIppMecsnc
Message-ID: <AANLkTikn7Q7OvHBtFj0+b+FYOey8_Z5BJbCmucK0uqJd@mail.gmail.com>
Subject: Re: [RFC PATCH] of/microblaze: fix includes so that asm/prom.h
 doesn't need linux/of*.h
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 1:12 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Tue, Aug 17, 2010 at 12:15 AM, Michal Simek <monstr@monstr.eu> wrote:
>> Grant Likely wrote:
>>>
>>> asm/prom.h has some nasty include ordering issues because a number of
>>> files assume that linux/of_* is included by prom.h.  This patch fixes
>>> the Microblaze occurrences.
>>>
>>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>>> ---
>>>
>>> Hi Michal,
>>>
>>> And here is my patch that fixes all the include issues so the remaining
>>> lines
>>> can be removed from prom.h.  I'll add this one to my test-devicetree
>>> branch
>>> along with similar patches to fix powerpc and sparc, and probably merge it
>>> in 2.6.37.
>>
>> That's bad because I don't want to keep pci broken till 2.6.37 especially in
>> case that I know that is broken.
>>
>> If this is the right fix for my issue and you want to merge it in 2.6.37
>> then I prefer to use my patch which simple add one header to prom.h and then
>> this patch fix it in general in 2.6.37.
>>
>> What do you think?
>
> heh, I think we're talking across purposes.  I sent 2 patches.
>
> The first patch fixes your immediate issue, and I'll ask Linus to
> merge it tomorrow.
> The second patch (this patch) allows the rest of the linux/of*.h
> includes to be removed from prom.h, but I will not merge that one into
> 2.6.36 because it is riskier and it isn't a regression fix.

...and here's the link to the first patch in case it somehow missed your inbox:

http://lkml.org/lkml/2010/8/17/46

g.
