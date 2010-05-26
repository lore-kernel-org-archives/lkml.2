Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab0EZT3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:29:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281Ab0EZT27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:28:59 -0400
Date: Wed, 26 May 2010 12:25:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH 1/5] rename anon_vma_lock to vma_lock_anon_vma
In-Reply-To: <4BFD7003.9040006@redhat.com>
Message-ID: <alpine.LFD.2.00.1005261223050.3689@i5.linux-foundation.org>
References: <20100512133815.0d048a86@annuminas.surriel.com> <20100512134029.36c286c4@annuminas.surriel.com> <20100512210216.GP24989@csn.ul.ie> <4BEB18BB.5010803@redhat.com> <20100513095439.GA27949@csn.ul.ie> <20100513103356.25665186@annuminas.surriel.com>
 <20100513140919.0a037845.akpm@linux-foundation.org> <4BFC9CCF.6000809@redhat.com> <20100526112403.635be0ed@annuminas.surriel.com> <20100526112505.1bddf24d@annuminas.surriel.com> <alpine.LFD.2.00.1005261021560.3689@i5.linux-foundation.org>
 <4BFD7003.9040006@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 May 2010, Rik van Riel wrote:
> 
> If you want I can send you and Andrew a duplicate of
> what I sent this morning, with the only difference
> being added Acked-by's.

I assume this will come through Andrew, so it depends on whether he is so 
resigned to manually adding acks from following threads or not.

Personally, I think it's one of the responsibilities of the person pushing 
the patch to do. Having the acked-by and reviewed-by trail should be one 
of the things that makes it _way_ easier for upstream to decide whether a 
patch should go in - especially if the people in question are active 
maintainers.

		Linus
