Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab0EZThT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:37:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541Ab0EZThS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:37:18 -0400
Message-ID: <4BFD7818.8080402@redhat.com>
Date: Wed, 26 May 2010 15:35:52 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH 1/5] rename anon_vma_lock to vma_lock_anon_vma
References: <20100512133815.0d048a86@annuminas.surriel.com> <20100512134029.36c286c4@annuminas.surriel.com> <20100512210216.GP24989@csn.ul.ie> <4BEB18BB.5010803@redhat.com> <20100513095439.GA27949@csn.ul.ie> <20100513103356.25665186@annuminas.surriel.com> <20100513140919.0a037845.akpm@linux-foundation.org> <4BFC9CCF.6000809@redhat.com> <20100526112403.635be0ed@annuminas.surriel.com> <20100526112505.1bddf24d@annuminas.surriel.com> <alpine.LFD.2.00.1005261021560.3689@i5.linux-foundation.org> <4BFD7003.9040006@redhat.com> <alpine.LFD.2.00.1005261223050.3689@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005261223050.3689@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 03:25 PM, Linus Torvalds wrote:
>
>
> On Wed, 26 May 2010, Rik van Riel wrote:
>>
>> If you want I can send you and Andrew a duplicate of
>> what I sent this morning, with the only difference
>> being added Acked-by's.
>
> I assume this will come through Andrew, so it depends on whether he is so
> resigned to manually adding acks from following threads or not.
>
> Personally, I think it's one of the responsibilities of the person pushing
> the patch to do. Having the acked-by and reviewed-by trail should be one
> of the things that makes it _way_ easier for upstream to decide whether a
> patch should go in - especially if the people in question are active
> maintainers.

I'll do a repost, gathering up the acks I have so far.

I just saw that patches 4 and 5 have no acks yet.

I've fixed up the comments to make the code clearer and
made the "find the root anon_vma" thing a little simpler
in anon_vma_fork.

Hopefully those patches will get acks now :)

-- 
All rights reversed
