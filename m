Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab0DJRPA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 13:15:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47114 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab0DJRO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 13:14:59 -0400
Date: Sat, 10 Apr 2010 19:07:04 +0200
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
Message-ID: <20100410170704.GA28952@a1.tnic>
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
References: <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
 <20100409204328.GG28964@cmpxchg.org>
 <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
 <20100410003110.GI28964@cmpxchg.org>
 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>
 <20100410072714.GA9246@liondog.tnic>
 <20100410112639.GA24708@a1.tnic>
 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
 <20100410163828.GA25579@a1.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100410163828.GA25579@a1.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>
Date: Sat, Apr 10, 2010 at 06:38:28PM +0200

> Im going to run the stress test on 2.6.33.2 to verify whether this is
> actually software-related. Just in case.

Just did a bunch of hibernation runs - 2.6.33.2 feels rock solid - no
issues whatsoever. So in the face of such results a hw failure is kinda
unprobable... Hmm...

-- 
Regards/Gruss,
Boris.
