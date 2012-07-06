Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2GFKGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:06:01 -0400
Received: from mx2.parallels.com ([64.131.90.16]:35737 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab2GFKF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:05:59 -0400
Message-ID: <4FF6B7E4.3060207@parallels.com>
Date: Fri, 6 Jul 2012 14:03:16 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jonathan Corbet <corbet@lwn.net>,
        <ksummit-2012-discuss@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the question!
References: <alpine.LFD.2.02.1206152313310.3086@ionos> <20120615233413.GB8894@kroah.com> <alpine.LFD.2.02.1206161103320.3086@ionos> <20120616072906.7469ec24@tpl.lwn.net> <20120620195121.GA1719@fieldses.org> <4FF6B32A.7070006@parallels.com> <20120706095450.GB7728@somewhere.redhat.com> <4FF6B72E.8020403@linux.vnet.ibm.com>
In-Reply-To: <4FF6B72E.8020403@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 02:00 PM, Srivatsa S. Bhat wrote:
> On 07/06/2012 03:24 PM, Frederic Weisbecker wrote:
>> On Fri, Jul 06, 2012 at 01:43:06PM +0400, Glauber Costa wrote:
>>> On 06/20/2012 11:51 PM, J. Bruce Fields wrote:
>>>> On Sat, Jun 16, 2012 at 07:29:06AM -0600, Jonathan Corbet wrote:
>>>>> On Sat, 16 Jun 2012 12:50:05 +0200 (CEST)
>>>>> Thomas Gleixner <tglx@linutronix.de> wrote:
>>>>>
>>>>>> A good start would be if you could convert your kernel statistics into
>>>>>> accounting the consolidation effects of contributions instead of
>>>>>> fostering the idiocy that corporates have started to measure themself
>>>>>> and the performance of their employees (I'm not kidding, it's the sad
>>>>>> reality) with line and commit count statistics.
>>>>>
>>>>> I would dearly love to come up with a way to measure "real work" in
>>>>> some fashion; I've just not, yet, figured out how to do that.  I do
>>>>> fear that the simple numbers we're able to generate end up creating the
>>>>> wrong kinds of incentives.
>>>>
>>>> I can't see any alternative to explaining what somebody did and why it
>>>> was important.
>>>>
>>>> To that end, the best resource for understanding the value of somebody's
>>>> work is the lwn.net kernel page--if their work has been discussed there.
>>>>
>>>> So, all you need to do is to hire a dozen more of you, and we're
>>>> covered!
>>>>
>>>> --b.
>>>>
>>>>>
>>>>> Any thoughts on how to measure "consolidation effects"?  I toss out
>>>>> numbers on code removal sometimes, but that turns out to not be a whole
>>>>> lot more useful than anything else on its own.
>>>>>
>>>>> Thanks,
>>>>>
>>>
>>> Resurrecting this one.
>>>
>>> So something just came across my mind: When I first read this thread, my
>>> inner reaction was: "People will find ways to bypass and ill-optimize
>>> their workflow for whatever measure we come up with".
>>>
>>> That's is pure human nature. Whenever we set up a metric, that becomes a
>>> goal and a bunch of people - not all - will deviate from their expected
>>> workflow to maximize that number. This happens with paper count in the
>>> scientific community, for the Higgs Boson's sake! Why wouldn't it happen
>>> with *any* metric we set for ourselves?
>>>
>>> So per-se, the fact that we have a lot of people trying to find out what
>>> our metrics are, and look good in the face of it, is just a testament to
>>> the success of Linux - but we know that already.
>>>
>>> The summary here, is that I don't think patch count *per se* is a bad
>>> metric. Maybe we should just tweak the way we measure a bit to steer
>>> people towards doing more useful work, and that would aid our review.
>>>
>>> The same way we have checkpatch, we can have something automated that
>>> will attempt to rule out some trivial patches in the counting process.
>>> We can scan a patch, and easily determine if each part of it is:
>>>
>>> * pure whitespace
>>> * pure Documentation change
>>> * comment fix
>>>
>>> And if a patch is 100 % comprised by those, we simply don't count it.
>>> People that just want to increase their numbers - they will always
>>> exist, will tend to stop doing that. Simply because doing it will not
>>> help them at all.
>>
>> OTOH, documentation changes or comment fixes, and even sometimes pure whitespace
>> fixes, can be very valuable contributions. This can be a useful and ungrateful
>> work and that deserve credit.
>>
> 
> Very true!
> 

Said another way: "valuable" here, is mostly semantics. People who go to
non-technical conferences and speak about Linux do a valuable
contribution. People who creates business around Linux do a valuable
contribution. We don't have to come up with an statistic that measure
"valuable contributions". We just need to have something that serves as
an index some people can use. People optimizing for that add noise to
the metric - probably true for patchcount or any other, and filtering
this noise is useful, even if *some* useful information is lost.

And in this particular context of this metric, I believe this kind of
contribution to be just noise.


