Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab0DII6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 04:58:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:54784 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab0DII6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 04:58:46 -0400
Subject: Re: [PATCH 00/13] mm: preemptibility -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20100409085050.GO5683@laptop>
References: <20100408191737.296180458@chello.nl>
	 <20100409041421.GM5683@laptop> <1270802131.20295.3270.camel@laptop>
	 <20100409085050.GO5683@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 10:58:41 +0200
Message-ID: <1270803521.20295.3274.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 18:50 +1000, Nick Piggin wrote:
> I have some microbenchmarks like this and the page fault test I
> could try.
> 
If you don't mind, please. If you send them my way I'll run them on my
machines too.

