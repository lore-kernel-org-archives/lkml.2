Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab1EYOMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:12:44 -0400
Received: from daytona.panasas.com ([67.152.220.89]:29810 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744Ab1EYOMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:12:41 -0400
Message-ID: <4DDD0E5F.5080105@panasas.com>
Date: Wed, 25 May 2011 17:12:47 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110430 Remi/fc12 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Subject: Re: (Short?) merge window reminder
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>	<20110523192056.GC23629@elte.hu>	<BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com> <BANLkTinbrtzY66p+1NALP8BDfjXLx=Qp-A@mail.gmail.com>
In-Reply-To: <BANLkTinbrtzY66p+1NALP8BDfjXLx=Qp-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2011 14:12:40.0948 (UTC) FILETIME=[CEFDE340:01CC1AE5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2011 11:52 PM, Alexey Zaytsev wrote:
> On Tue, May 24, 2011 at 00:33, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Mon, May 23, 2011 at 12:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>> I really hope there's also a voice that tells you to wait until .42 before
>>> cutting 3.0.0! :-)
>>
>> So I'm toying with 3.0 (and in that case, it really would be "3.0",
>> not "3.0.0" - the stable team would get the third digit rather than
>> the fourth one.
>>
>> But no, it wouldn't be for 42. Despite THHGTTG, I think "40" is a
>> fairly nice round number.
>>
>> There's also the timing issue - since we no longer do version numbers
>> based on features, but based on time, just saying "we're about to
>> start the third decade" works as well as any other excuse.
>>
>> But we'll see.
> 
> Maybe, 2011.x, or 11.x, x increasing for every merge window started this year?
> This would better reflect the steady nature of the releases, but would
> certainly break a lot of scripts. ;)

My $0.017 on this. Clearly current process is time based. People have said.

* Keep Three digit numbers to retain script compatibility
* Make it clear from the version when it was released.
* Linus said 3 as for 3rd decade
* Nice single increment number progression
* Please make it look like a nice version number sys-admins will feel
  at home with

So if you combine all the above:

D. Y. N
D - Is the decade since birth (1991 not 1990)
Y - is the year in the decade so you have 3.1.x, 3.2.x, .. 3.10.x, 4.1.X and so on
    Nice incremental number.
N - The Linus release of this Year. So this 3rd one goes up to 4 most probably.

Linus always likes, and feels very poetic about the Christmas version release.
He hates it when once it slipped into the next year. So now he gets to increment
the second digit as a bonus.

The 2nd digit gets to start on a *one*, never zero and goes up to *10*, to symbolize
the 1991 birth. And we never have .zero quality, right?

The first Digit gets incremented on decade from 1991 so on 2011 and not 2010

So here you have it, who said we need to compromise?

Free life
Boaz
 
