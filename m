Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0EZTDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:03:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab0EZTC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:02:59 -0400
Message-ID: <4BFD7003.9040006@redhat.com>
Date: Wed, 26 May 2010 15:01:23 -0400
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
References: <20100512133815.0d048a86@annuminas.surriel.com> <20100512134029.36c286c4@annuminas.surriel.com> <20100512210216.GP24989@csn.ul.ie> <4BEB18BB.5010803@redhat.com> <20100513095439.GA27949@csn.ul.ie> <20100513103356.25665186@annuminas.surriel.com> <20100513140919.0a037845.akpm@linux-foundation.org> <4BFC9CCF.6000809@redhat.com> <20100526112403.635be0ed@annuminas.surriel.com> <20100526112505.1bddf24d@annuminas.surriel.com> <alpine.LFD.2.00.1005261021560.3689@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005261021560.3689@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 01:25 PM, Linus Torvalds wrote:
>
>
> On Wed, 26 May 2010, Rik van Riel wrote:
>>
>> Subject: rename anon_vma_lock to vma_lock_anon_vma
>>
>> Rename anon_vma_lock to vma_lock_anon_vma.  This matches the
>> naming style used in page_lock_anon_vma and will come in really
>> handy further down in this patch series.
>>
>> Signed-off-by: Rik van Riel<riel@redhat.com>
>
> This v2 series seems to be missing all the ack's etc from the previous
> series. At least Mel and Hiroyuki-san had acked several of the patches.
>
> What's the point of making a v2 if it doesn't actually take the input from
> v1 into account?

It did take all the input into account (I made all the
suggested improvements, enhanced comments where people
had questions, etc).

I just forgot to add all the Acked-by's :(

If you want I can send you and Andrew a duplicate of
what I sent this morning, with the only difference
being added Acked-by's.

-- 
All rights reversed
