Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0DIKi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 06:38:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58230 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633Ab0DIKix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 06:38:53 -0400
Date: Fri, 9 Apr 2010 11:21:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
Message-ID: <20100409092111.GA998@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
	hannes@cmpxchg.org
References: <alpine.LFD.2.00.1004071625490.3586@i5.linux-foundation.org>
 <20100408101925.FB9F.A69D9226@jp.fujitsu.com>
 <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org>
 <20100408054707.GA9299@a1.tnic>
 <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org>
 <20100408210035.GA25834@a1.tnic>
 <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org>
 <20100408234721.GB25834@a1.tnic>
 <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org>
 <20100409013012.GA8153@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100409013012.GA8153@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>
Date: Fri, Apr 09, 2010 at 03:30:12AM +0200

> > Maybe with all the patches flying around, you had a reject or something, 
> > and you lost that one anon_vma_prepare()?
> > 
> > Or maybe I screwed up somewhere and sent you the wrong patch. Here it is 
> > again, just in case.
> 
> Doesn't look like it - here's the diff between yours and what I have
> applied here (yep, only minor fuzz but no code differences) Also, I've
> added my version at the end:

So I went and reapplied the three patches (3rd is the object_err export
for SLUB debugging) on a new branch of today's git - same results, the
same processes crap up in the WARN(!vma->anon_vma) check so it should be
something else we're missing.

More code staring later...

-- 
Regards/Gruss,
Boris.
