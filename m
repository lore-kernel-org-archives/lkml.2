Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1LVKR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 05:17:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51254 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab1LVKRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 05:17:54 -0500
Date: Thu, 22 Dec 2011 11:15:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 6/7] printk: Poke printk extra hard
Message-ID: <20111222101556.GA12976@elte.hu>
References: <20111221105739.798864333@chello.nl>
 <20111221111143.620776435@chello.nl>
 <CA+55aFw_rQbOho8WojeiD3YZtzud99CAXZCzqoKNF1HRGXgnZA@mail.gmail.com>
 <20111222070212.GA9593@elte.hu>
 <1324543413.24803.7.camel@twins>
 <20111222090352.GA11831@elte.hu>
 <1324545242.24803.11.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324545242.24803.11.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2011-12-22 at 10:03 +0100, Ingo Molnar wrote:
> 
> > Could be made part of the locking self-tests - that way it 
> > does not add an extra config option! ;-)
> 
> Fair chance it will blow up and disable lockdep for pretty 
> much every console implementation out there, except 8250serial 
> when used in conjunction with all patches in this thread.

If it blows up without being fixed then it's not a good idea.

> Maybe not the normal vga console, but I haven't tried on a 
> machine that has a monitor attached yet (they're usually not 
> on remote power switches and I'm too lazy to reach over and 
> press reset).

The VGA console does not require a monitor attached.

Thanks,

	Ingo
