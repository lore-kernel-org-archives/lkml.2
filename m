Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab1JaIOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 04:14:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58343 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab1JaIOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 04:14:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 Oct 2011 17:13:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        levinsasha928@gmail.com, Chris Mason <chris.mason@oracle.com>,
        JBeulich@novell.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
Message-Id: <20111031171321.097a166c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Oct 2011 11:52:22 -0700 (PDT)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> Hi Linus --
> 
> Frontswap now has FOUR users: Two already merged in-tree (zcache
> and Xen) and two still in development but in public git trees
> (RAMster and KVM).  Frontswap is part 2 of 2 of the core kernel
> changes required to support transcendent memory; part 1 was cleancache
> which you merged at 3.0 (and which now has FIVE users).
> 
> Frontswap patches have been in linux-next since June 3 (with zero
> changes since Sep 22).  First posted to lkml in June 2009, frontswap 
> is now at version 11 and has incorporated feedback from a wide range
> of kernel developers.  For a good overview, see
>    http://lwn.net/Articles/454795.
> If further rationale is needed, please see the end of this email
> for more info.
> 
> SO... Please pull:
> 
> git://oss.oracle.com/git/djm/tmem.git #tmem
> 
> since git commit b6fd41e29dea9c6753b1843a77e50433e6123bcb
> Linus Torvalds (1):
> 

Why bypass -mm tree ?

I think you planned to merge this via -mm tree and, then, posted patches
to linux-mm with CC -mm guys.

I think you posted 2011/09/16 at the last time, v10. But no further submission
to gather acks/reviews from Mel, Johannes, Andrew, Hugh etc.. and no inclusion
request to -mm or -next. _AND_, IIUC, at v10, the number of posted pathces was 6.
Why now 8 ? Just because it's simple changes ? 

I don't have heavy concerns to the codes itself but this process as bypassing -mm
or linux-next seems ugly.

Thanks,
-Kame

