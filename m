Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab0DIBpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 21:45:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58350 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0DIBpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 21:45:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas of a mergeable VMA
Cc: kosaki.motohiro@jp.fujitsu.com, Borislav Petkov <bp@alien8.de>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
In-Reply-To: <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org>
References: <20100408234721.GB25834@a1.tnic> <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org>
Message-Id: <20100409104345.80DA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Apr 2010 10:45:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> On Fri, 9 Apr 2010, Borislav Petkov wrote:
> > 
> > Yep, looks good: its mmap_region()...
> 
> Can you double-check your current diffs - maybe something got corrupted.
> 
> mmap_region installs the vma with vma_link(), and the last thing 
> vma_link() does with my patch is that "anon_vma_prepare()".

I agree. and at least your patch works fine on my box. I'll continue digg.



> 
> Maybe with all the patches flying around, you had a reject or something, 
> and you lost that one anon_vma_prepare()?
> 
> Or maybe I screwed up somewhere and sent you the wrong patch. Here it is 
> again, just in case.
> 
> [ I have a horrible cold, and can hardly think straight. So who knows, 
>   maybe I'm missing something. But if you have lost one of the 
>   'anon_vma_prepare()' call sites, that would certainly explain why you 
>   get NULL anon_vma's ]
> 
> 		Linus


