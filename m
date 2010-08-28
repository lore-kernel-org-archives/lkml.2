Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab0H1PK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:10:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60352 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab0H1PKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:10:54 -0400
Subject: Re: [PATCH 00/20] mm: Preemptibility -v4
From: Peter Zijlstra <peterz@infradead.org>
To: piotr@hosowicz.com
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@suse.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <4C7923B4.6030208@example.com>
References: <20100828141637.421594670@chello.nl>
	 <4C7923B4.6030208@example.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 28 Aug 2010 17:10:25 +0200
Message-ID: <1283008225.1975.3598.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-28 at 16:56 +0200, Piotr Hosowicz wrote:
> On 28.08.2010 16:16, Peter Zijlstra wrote:
> 
> > Full series (including the Sparc64 gup_fast bits) also available in -git
> > form from (against Linus' tree as of about an hour ago):
> 
> How come? I tried this:
> 
> aapi205:/usr/src/linus/tmp# git pull
> Already up-to-date.
> 
> ... and don't see an update. Maybe I don't do something right. If there 
> is newer code I should receive it, am I correct? I use this link:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

That's Linus' tree, the patches aren't in there quite yet, try:

  git remote add mmu_preempt git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_preempt.git
  git remote update
  git checkout mmu_preempt/mmu_preempt

or
  
  git checkout -b mmu_preempt origin/master
  git pull git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_preempt.git mmu_preempt


