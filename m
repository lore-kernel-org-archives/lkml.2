Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab0GHRao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 13:30:44 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:33848 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab0GHRan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 13:30:43 -0400
Message-ID: <4C360B42.8070909@kernel.dk>
Date: Thu, 08 Jul 2010 19:30:42 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, xiaosuo@gmail.com,
       tim.gardner@canonical.com, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 0/3] splice fixes
References: <E1OTYfk-0008GY-PJ@pomaz-ex.szeredi.hu>	<4C29D5B9.9040401@kernel.dk>	<E1OTZYn-0008Qk-El@pomaz-ex.szeredi.hu>	<4C29E1A0.7070601@kernel.dk>	<20100707133851.7c805c2d.akpm@linux-foundation.org>	<4C35D466.8060007@kernel.dk>	<4C35D4CE.6020401@kernel.dk> <20100708102544.2e4697f8.akpm@linux-foundation.org>
In-Reply-To: <20100708102544.2e4697f8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/10 19.25, Andrew Morton wrote:
> On Thu, 08 Jul 2010 15:38:22 +0200 Jens Axboe <axboe@kernel.dk> wrote:
> 
>>>> However this:
>>>>
>>>> commit 4f9078afb4e083e033aafbbfabe729cb3832aa42
>>>> Author: Changli Gao <xiaosuo@gmail.com>
>>>> Date:   Tue Jun 29 13:09:18 2010 +0200
>>>>
>>>>     splice: direct_splice_actor() should not use pos in sd
>>>>
>>>> went into mainline without a cc:stable tag.
>>>
>>> I will send an email to stable@.
>>
>> BTW, it's not in mainline yet. I know I forgot to mark it as stable,
>> but I can't tell them to include it before it's in mainline.
> 
> You could redo the changelog then.  But stable@kernel.org is cc'ed on
> these emails and they're splendid chaps ;)

But then the Linus monster ends up shouting at me, so I'll rather
take a little stable abuse :-)

What I've done in the past is just send stable@ a list of commits
once they are upstream. Less work for them. Best is remembering
the stable CC in the commit, but...

-- 
Jens Axboe

