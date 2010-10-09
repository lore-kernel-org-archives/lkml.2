Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab0JIQPi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 12:15:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:36210 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab0JIQPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 12:15:37 -0400
Subject: Re: + softirq-cleanup-preempt-check.patch added to -mm tree
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
In-Reply-To: <4CAB92E9.7060509@suse.cz>
References: <201010051905.o95J5BrS013873@imap1.linux-foundation.org>
	 <20101005193833.GA16493@elte.hu>  <4CAB92E9.7060509@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 09 Oct 2010 18:15:27 +0200
Message-ID: <1286640927.1891.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-05 at 23:04 +0200, Jiri Slaby wrote:
> >> +static inline void softirq_preempt_check(struct softirq_action *h,
> >> +            int prev_count)
> > 
> > unnecessary linebreak.
> 
> How unnecessary is this linebreak:
> $ wc -c
> static inline void softirq_preempt_check(struct softirq_action *h, int
> prev_count)
> 83
> 
> People, including me, still work with 80-col terminals. What I can
> tolerate are undivided strings, because it sucks if one cannot grep for
> anything from the log 

I actually work on ~350 character wide terminals, but then, I vert-split
it 4-ways so I end up with ~85 chars per column.. :-)

But I agree the line should be split, I however much prefer the form:

static inline
void softirq_preempt_check(struct softirq_action *h, int prev_count)


