Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab0FDKmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:42:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55727 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab0FDKm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:42:29 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>,
       Brian Swetland <swetland@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: suspend blockers & Android integration
From: Andi Kleen <andi@firstfloor.org>
References: <20100603193045.GA7188@elte.hu> <20100603231153.GA11302@elte.hu>
	<20100603232302.GA16184@elte.hu>
	<alpine.LFD.2.00.1006031630300.8175@i5.linux-foundation.org>
	<20100603234634.GA21831@elte.hu>
	<alpine.LFD.2.00.1006031856420.8175@i5.linux-foundation.org>
	<alpine.LFD.2.00.1006031917500.8175@i5.linux-foundation.org>
	<20100603204521.09808a7f@infradead.org>
	<alpine.LFD.2.00.1006032141060.8175@i5.linux-foundation.org>
Date: Fri, 04 Jun 2010 12:42:26 +0200
In-Reply-To: <alpine.LFD.2.00.1006032141060.8175@i5.linux-foundation.org> (Linus Torvalds's message of "Thu\, 3 Jun 2010 21\:46\:01 -0700 \(PDT\)")
Message-ID: <8739x3xenh.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, 3 Jun 2010, Arjan van de Ven wrote:
>> 
>> And because there's then no power saving (but a performance cost), it's
>> actually a negative for battery life/total energy.
>
> Including the UP optimizations we do (ie lock prefix removal)? It's 

Those only help the kernel and most workloads do not do enough kernel
execution for it to really matter, but spend most of their
time in user space.

Even if as kernel programmers we often have a different view, in most
cases most cycles are in user space :)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
