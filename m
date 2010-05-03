Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab0ECQn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 12:43:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933161Ab0ECQnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 12:43:55 -0400
Date: Mon, 3 May 2010 09:41:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 1/2] mm: Take all anon_vma locks in anon_vma_lock
In-Reply-To: <20100503121847.7997d280@annuminas.surriel.com>
Message-ID: <alpine.LFD.2.00.1005030940490.5478@i5.linux-foundation.org>
References: <20100503121743.653e5ecc@annuminas.surriel.com> <20100503121847.7997d280@annuminas.surriel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 May 2010, Rik van Riel wrote:
> 
> Both the page migration code and the transparent hugepage patches expect
> 100% reliable rmap lookups and use page_lock_anon_vma(page) to prevent
> races with mmap, munmap, expand_stack, etc.

Pretty much same comments as for the other one. Why are we pandering to 
the case that is/should be unusual?

		Linus
