Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab0F2HtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:49:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab0F2HtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:49:12 -0400
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
In-Reply-To: <1277797219.2096.884.camel@ymzhang.sh.intel.com>
References: <20100607110654.606530953@chello.nl>
	 <1276134311.2096.438.camel@ymzhang.sh.intel.com>
	 <1276152750.2046.2485.camel@twins>
	 <1276153198.2096.465.camel@ymzhang.sh.intel.com>
	 <1277115718.1875.490.camel@laptop>  <1277373331.1875.940.camel@laptop>
	 <1277797219.2096.884.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 29 Jun 2010 09:48:33 +0200
Message-ID: <1277797713.1868.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 15:40 +0800, Zhang, Yanmin wrote:
> On Thu, 2010-06-24 at 11:55 +0200, Peter Zijlstra wrote:

> > git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-mmu_preempt.git mmu_preempt

> We tested the tree on many machines with many benchmarks. Comparing with pure kernel 2.6.35-rc3,
> there is no clear performance regression/improvement. We didn't run into panic again.

Most awesome, thanks!
