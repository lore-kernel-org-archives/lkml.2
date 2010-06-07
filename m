Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab0FGPCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 11:02:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:35186 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0FGPCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 11:02:14 -0400
Subject: Re: [PATCH 00/28] mm: preemptibility -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100607135753.GA16657@merkur.ravnborg.org>
References: <20100607110654.606530953@chello.nl>
	 <20100607135753.GA16657@merkur.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 17:02:11 +0200
Message-ID: <1275922931.1645.570.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 15:57 +0200, Sam Ravnborg wrote:
> > 
> > There are no known architectures left unconverted, although some arch code
> > never did see a compiler (superh and um come to mind).
> 
> um is easy.
> On your x86 box you just do "make ARCH=um"

Right, seems to build.

