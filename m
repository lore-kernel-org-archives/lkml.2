Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0DIRtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 13:49:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36478 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903Ab0DIRti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 13:49:38 -0400
Date: Fri, 9 Apr 2010 19:40:41 +0200
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
Message-ID: <20100409174041.GA10780@a1.tnic>
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
References: <alpine.LFD.2.00.1004071929090.3586@i5.linux-foundation.org>
 <20100408054707.GA9299@a1.tnic>
 <alpine.LFD.2.00.1004080706500.3586@i5.linux-foundation.org>
 <20100408210035.GA25834@a1.tnic>
 <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org>
 <20100408234721.GB25834@a1.tnic>
 <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org>
 <20100409013012.GA8153@liondog.tnic>
 <20100409092111.GA998@a1.tnic>
 <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, Apr 09, 2010 at 09:35:15AM -0700

> Can you try with _just_ my patch?

Yep, yours along with the SLUB debugging piece just survived one
hibernation cycle without a problem. Also, no SIGBUS-killed processes,
all seems fine. Will continue stressing it though...

Let me know what you want me to do next.

-- 
Regards/Gruss,
Boris.
