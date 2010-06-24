Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab0FXJ4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:56:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43802 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab0FXJ4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:56:16 -0400
Subject: Re: [PATCH 00/28] mm: preemptibility -v3
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1277115718.1875.490.camel@laptop>
References: <20100607110654.606530953@chello.nl>
	 <1276134311.2096.438.camel@ymzhang.sh.intel.com>
	 <1276152750.2046.2485.camel@twins>
	 <1276153198.2096.465.camel@ymzhang.sh.intel.com>
	 <1277115718.1875.490.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 11:55:31 +0200
Message-ID: <1277373331.1875.940.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 12:21 +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-10 at 14:59 +0800, Zhang, Yanmin wrote:
> 
> > > > I applied it against 2.6.35-rc2 on x86_64 machine, but kernel booting panic.
> 
> <snip panic>
> 
> > > Oi, that's no good. Happen to have your .config handy, I didn't actually
> > > see my machine do that.
> 
> > See the attachment.
> 
> That .config build and booted on my x86_64 machine, no funnies there.
> 
> I pushed a git tree out to kernel.org but somehow its refusing to show
> up on git.kernel.org..

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_preempt.git mmu_preempt
