Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab0DJAMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 20:12:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377Ab0DJAMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 20:12:32 -0400
Message-ID: <4BBFC220.6060702@redhat.com>
Date: Fri, 09 Apr 2010 20:11:12 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Borislav Petkov <bp@alien8.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
References: <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org> <20100408234721.GB25834@a1.tnic> <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org> <20100409013012.GA8153@liondog.tnic> <20100409092111.GA998@a1.tnic> <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org> <20100409174041.GA10780@a1.tnic> <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org> <20100409191425.GB10780@a1.tnic> <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org> <20100409204328.GG28964@cmpxchg.org> <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org> <4BBFBC07.3010509@redhat.com> <alpine.LFD.2.00.1004091657090.3558@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004091657090.3558@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 08:03 PM, Linus Torvalds wrote:

> This is why I suggest that we limit the "re-use an existing vma for a new
> case" to the singleton case, which means that now you _never_ have
> differences at all. There's no spreading on splitting. Merging is trivial.

That looks like it should work.

> Now, admittedly, I'm really hopped up on cough medication, so the feeling
> of this solving all the problems in the universe may not be entirely
> accurate. But it feels so _right_.
>
> I hope if feels right when I'm off my meds too.

I am not on any cough meds, and your patch looks right.
OTOH, maybe I should be on some kind of cold meds, because
I haven't been feeling right all week...
