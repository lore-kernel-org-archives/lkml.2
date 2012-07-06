Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2GFKBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:01:48 -0400
Received: from mx2.parallels.com ([64.131.90.16]:40923 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2GFKBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:01:46 -0400
Message-ID: <4FF6B6E8.7080306@parallels.com>
Date: Fri, 6 Jul 2012 13:59:04 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>, Jonathan Corbet <corbet@lwn.net>,
        <ksummit-2012-discuss@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the question!
References: <alpine.LFD.2.02.1206152313310.3086@ionos> <20120615233413.GB8894@kroah.com> <alpine.LFD.2.02.1206161103320.3086@ionos> <20120616072906.7469ec24@tpl.lwn.net> <20120620195121.GA1719@fieldses.org> <4FF6B32A.7070006@parallels.com> <20120706095450.GB7728@somewhere.redhat.com>
In-Reply-To: <20120706095450.GB7728@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Resurrecting this one.
>>
>> So something just came across my mind: When I first read this thread, my
>> inner reaction was: "People will find ways to bypass and ill-optimize
>> their workflow for whatever measure we come up with".
>>
>> That's is pure human nature. Whenever we set up a metric, that becomes a
>> goal and a bunch of people - not all - will deviate from their expected
>> workflow to maximize that number. This happens with paper count in the
>> scientific community, for the Higgs Boson's sake! Why wouldn't it happen
>> with *any* metric we set for ourselves?
>>
>> So per-se, the fact that we have a lot of people trying to find out what
>> our metrics are, and look good in the face of it, is just a testament to
>> the success of Linux - but we know that already.
>>
>> The summary here, is that I don't think patch count *per se* is a bad
>> metric. Maybe we should just tweak the way we measure a bit to steer
>> people towards doing more useful work, and that would aid our review.
>>
>> The same way we have checkpatch, we can have something automated that
>> will attempt to rule out some trivial patches in the counting process.
>> We can scan a patch, and easily determine if each part of it is:
>>
>> * pure whitespace
>> * pure Documentation change
>> * comment fix
>>
>> And if a patch is 100 % comprised by those, we simply don't count it.
>> People that just want to increase their numbers - they will always
>> exist, will tend to stop doing that. Simply because doing it will not
>> help them at all.
> 
> OTOH, documentation changes or comment fixes, and even sometimes pure whitespace
> fixes, can be very valuable contributions. This can be a useful and ungrateful
> work and that deserve credit.
> 
> We just can't find an automated and right way to evaluate a contribution.
> 

I am not saying or implying that they are not. I am merely pointing out
that metrics are good and healthy for us, but all of them will have
their perks, and a group of people will optimize for that.

I doubt that we'll stop having Documentation patches, for instances, if
we stop counting them. People who understand the value of it, will still
do it. They will just stop doing it for the sake of doing it, and even
worse, divided in a thousand patches what could easily be sent in just one.

Furthermore, I believe to be undeniable that even though those
contributions are indeed, valuable, they are not by any means as
valuable as the "real work", as Thomas describes.
