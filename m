Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab0ILJHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 05:07:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:40510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0ILJHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 05:07:47 -0400
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <AANLkTimmkmeyFg6wSw4Ej=gqLAHgcB5puRxvAa_14eZp@mail.gmail.com>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <AANLkTin0LOuTOcJPiZcZGeZMdqsy2dohyrREw2GGhddJ@mail.gmail.com>
	 <1284237380.2251.56.camel@laptop> <1284237950.2251.59.camel@laptop>
	 <AANLkTimmkmeyFg6wSw4Ej=gqLAHgcB5puRxvAa_14eZp@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 12 Sep 2010 11:07:37 +0200
Message-ID: <1284282457.2251.82.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 13:52 -0700, Linus Torvalds wrote:
> So to me it looks like you're just being negative, without actually
> looking at the patch and giving it some fair thought. That's what I'm
> objecting to. 

I hope my reply just now cleared that up.
