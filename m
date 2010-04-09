Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab0DIU7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:59:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312Ab0DIU7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:59:11 -0400
Message-ID: <4BBF94C2.9070105@redhat.com>
Date: Fri, 09 Apr 2010 16:57:38 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
References: <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org> <20100408234721.GB25834@a1.tnic> <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org> <20100409013012.GA8153@liondog.tnic> <20100409092111.GA998@a1.tnic> <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org> <20100409174041.GA10780@a1.tnic> <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org> <20100409191425.GB10780@a1.tnic> <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org> <20100409204328.GG28964@cmpxchg.org>
In-Reply-To: <20100409204328.GG28964@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 04:43 PM, Johannes Weiner wrote:

> Okay, I think I got it working.  I first thought we would need an
> m^n loop to properly merge the anon_vma_chains, but we can actually
> be cleverer than that:

I've looked it over 5 times, can't find anything wrong
with it.  Your approach looks like it should work just
fine.

Certainly easier than the things Linus and I tried :)

> Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>
