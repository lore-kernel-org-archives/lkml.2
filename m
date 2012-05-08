Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab2EHFm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 01:42:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33228 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2EHFm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 01:42:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com>
References: <20120501132409.GA22894@lizard> <20120501132620.GC24226@lizard>
 <4FA35A85.4070804@kernel.org> <20120504073810.GA25175@lizard>
 <CAOJsxLH_7mMMe+2DvUxBW1i5nbUfkbfRE3iEhLQV9F_MM7=eiw@mail.gmail.com>
 <CAHGf_=qcGfuG1g15SdE0SDxiuhCyVN025pQB+sQNuNba4Q4jcA@mail.gmail.com>
 <20120507121527.GA19526@lizard> <4FA82056.2070706@gmail.com> <CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 8 May 2012 01:42:05 -0400
Message-ID: <CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com>
Subject: Re: [PATCH 3/3] vmevent: Implement special low-memory attribute
To: Pekka Enberg <penberg@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Minchan Kim <minchan@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 1:20 AM, Pekka Enberg <penberg@kernel.org> wrote:
> On Mon, May 7, 2012 at 10:19 PM, KOSAKI Motohiro
> <kosaki.motohiro@gmail.com> wrote:
>>> Even more, we may introduce two attributes:
>>>
>>> RECLAIMABLE_CACHE_PAGES and
>>> RECLAIMABLE_CACHE_PAGES_NOIO (which excludes dirty pages).
>>>
>>> This makes ABI detached from the mm internals and still keeps a
>>> defined meaning of the attributes.
>>
>> Collection of craps are also crap. If you want to improve userland
>> notification, you should join VM improvement activity. You shouldn't
>> think nobody except you haven't think userland notification feature.
>>
>> The problem is, Any current kernel vm statistics were not created for
>> such purpose and don't fit.
>>
>> Even though, some inaccurate and incorrect statistics fit _your_ usecase,
>> they definitely don't fit other. And their people think it is bug.
>
> Well, yeah, if we are to report _number of pages_, the numbers better
> be meaningful.
>
> That said, I think you are being unfair to Anton who's one of the few
> that's actually taking the time to implement this properly instead of
> settling for an out-of-tree hack.

Unfair? But only I can talk about technical comment. To be honest, I
really dislike
I need say the same explanation again and again. A lot of people don't read
past discussion. And as far as the patches take the same mistake, I must say
the same thing. It is just PITA.

I don't disagree vmevent notification itself, but I must disagree lie
notification.
And also, To make just idea statistics doesn't make sense at all. How do an
application choose the right events? If that depend on hardware configuration,
userland developers can't write proper applications.

That's the reason why I often disagree at random new features.
