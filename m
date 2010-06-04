Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab0FDEv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:51:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750867Ab0FDEv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:51:58 -0400
Date: Thu, 3 Jun 2010 21:46:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, tytso@mit.edu,
       Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
       Arve Hj?nnev?g <arve@android.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: suspend blockers & Android integration
In-Reply-To: <20100603204521.09808a7f@infradead.org>
Message-ID: <alpine.LFD.2.00.1006032141060.8175@i5.linux-foundation.org>
References: <20100603193045.GA7188@elte.hu> <20100603231153.GA11302@elte.hu> <20100603232302.GA16184@elte.hu> <alpine.LFD.2.00.1006031630300.8175@i5.linux-foundation.org> <20100603234634.GA21831@elte.hu> <alpine.LFD.2.00.1006031856420.8175@i5.linux-foundation.org>
 <alpine.LFD.2.00.1006031917500.8175@i5.linux-foundation.org> <20100603204521.09808a7f@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Arjan van de Ven wrote:
> 
> And because there's then no power saving (but a performance cost), it's
> actually a negative for battery life/total energy.

Including the UP optimizations we do (ie lock prefix removal)? It's 
possible that I'm just biased by benchmarks, and it's true that Intel has 
been getting lots better, but the locking costs are very noticeable 
performance-wise on some benchmarks.

And several CPU's have been held back from going into deepest sleep states 
by stupid firmware and/or platform bugs.

But hey, if it's not going to help, and people have tried it, I guess I'll 
have to believe it.

		Linus

