Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2HCRBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:01:31 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36981 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2HCRBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:01:30 -0400
Date: Fri, 3 Aug 2012 19:01:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core kernel fixes
Message-ID: <20120803170124.GA2773@gmail.com>
References: <20120803163145.GA1549@gmail.com>
 <501C0273.2060603@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501C0273.2060603@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Darren Hart <dvhart@linux.intel.com> wrote:

> On 08/03/2012 09:31 AM, Ingo Molnar wrote:
> > Linus,
> > 
> > Please pull the latest core-urgent-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus
> > 
> >    HEAD: 6f7b0a2a5c0fb03be7c25bd1745baa50582348ef futex: Forbid uaddr == uaddr2 in futex_wait_requeue_pi()
> > 
> > Various futex fixes for bugs Darren Hart found via his 
> > testsuite.
> > 
> 
> Minor correction. I fixed two bugs reported by Dave Jones 
> (found with his trinity test) and Dan Carpenter through static 
> analysis. The other I found while debugging the first two. 
> Credit where credit is due.

Hm, from the wording of the changelogs I thought you were 
running those tests. Please put such bug reporting info into the 
changelog and/or add a Reported-by tag next time around - 
testers are our most valuable contributors.

Thanks,

	Ingo
