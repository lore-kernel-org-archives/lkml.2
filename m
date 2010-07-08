Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab0GHNiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:38:25 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59405 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189Ab0GHNiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:38:24 -0400
Message-ID: <4C35D4CE.6020401@kernel.dk>
Date: Thu, 08 Jul 2010 15:38:22 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, xiaosuo@gmail.com,
       tim.gardner@canonical.com, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 0/3] splice fixes
References: <E1OTYfk-0008GY-PJ@pomaz-ex.szeredi.hu>	<4C29D5B9.9040401@kernel.dk>	<E1OTZYn-0008Qk-El@pomaz-ex.szeredi.hu>	<4C29E1A0.7070601@kernel.dk> <20100707133851.7c805c2d.akpm@linux-foundation.org> <4C35D466.8060007@kernel.dk>
In-Reply-To: <4C35D466.8060007@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-08 15:36, Jens Axboe wrote:
> On 2010-07-07 22:38, Andrew Morton wrote:
>> On Tue, 29 Jun 2010 14:05:52 +0200
>> Jens Axboe <axboe@kernel.dk> wrote:
>>
>>> On 2010-06-29 14:05, Miklos Szeredi wrote:
>>>> On Tue, 29 Jun 2010, Jens Axboe wrote:
>>>>> On 2010-06-29 13:08, Miklos Szeredi wrote:
>>>>>> These patches fix bugs that affect real-world users of splice(2) and
>>>>>> sendfile(2) interfaces.
>>>>>>
>>>>>> Not sure if some or all of them are appropriate for 2.6.35 and/or
>>>>>> -stable?
>>>>>
>>>>> I think that 1-2 should go into 2.6.35 directly, and 3 for .36 with
>>>>> a stable backport as well. Agree?
>>>>
>>>> Yes, sounds good.
>>>
>>> Good, that is what I queued up. I haven't pushed out the updated
>>> for-linus yet, since I asked Linus to pull it this morning.
>>>
>>
>> According to Tim's report on lkml
>> (http://lkml.org/lkml/2010/6/25/280),
>> cc56f7de7f00d188c7c4da1e9861581853b9e92f caused a regression. 
>> cc56f7de7f00d188c7c4da1e9861581853b9e92f is present in 2.6.33 and in
>> 2.6.34 hence the fix should be backported into -stable.
>>
>> According to http://bugs.launchpad.net/bugs/588861, the patch "splice:
>> direct_splice_actor() should not use pos in sd" fixes the regression.
>>
>> However this:
>>
>> commit 4f9078afb4e083e033aafbbfabe729cb3832aa42
>> Author: Changli Gao <xiaosuo@gmail.com>
>> Date:   Tue Jun 29 13:09:18 2010 +0200
>>
>>     splice: direct_splice_actor() should not use pos in sd
>>
>> went into mainline without a cc:stable tag.
> 
> I will send an email to stable@.

BTW, it's not in mainline yet. I know I forgot to mark it as stable,
but I can't tell them to include it before it's in mainline.


-- 
Jens Axboe


-- 
Jens Axboe

