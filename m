Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0DJUpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 16:45:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40027 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0DJUo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 16:44:59 -0400
Date: Sat, 10 Apr 2010 22:36:28 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
Message-ID: <20100410203628.GB32035@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Rik van Riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
References: <20100410072714.GA9246@liondog.tnic>
 <20100410112639.GA24708@a1.tnic>
 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
 <20100410163828.GA25579@a1.tnic>
 <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
 <20100410185145.GB28952@a1.tnic>
 <20100410185839.GA32035@a1.tnic>
 <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, Apr 10, 2010 at 01:12:46PM -0700

> So I'm actually pretty optimistic that this really is it.

Ok, let me verify what/in which order should be tested before I test
something wrongly. The RCU-safe fix for the TLB flush can stay for
correctness reasons, this last patch, obviosly, what happens with the
find_mergeable_anon_vma() changes to use only singleton lists for
merging? Should I keep those too?

-- 
Regards/Gruss,
Boris.
