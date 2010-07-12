Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab0GLCtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:49:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755533Ab0GLCtc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:49:32 -0400
MIME-Version: 1.0
In-Reply-To: <201007121149.58129.rusty@rustcorp.com.au>
References: <4C3A06E3.50402@kernel.org>
	<AANLkTik8EHarsrnAisuj9SKbeXddlA6Dz-KzDOPsmBxh@mail.gmail.com>
	<201007121149.58129.rusty@rustcorp.com.au>
Date: Sun, 11 Jul 2010 19:49:22 -0700
Message-ID: <AANLkTimMzNV4hw8N6uqRS-HRLg95LbDyQXsM3Hc-mjhg@mail.gmail.com>
Subject: Re: [RFC PATCH] x86-64: software IRQ masking and handling
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 11, 2010 at 7:19 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> PS.  When did we start top-commenting and quoting the whole patch?

Sorry, my bad. I've been using the gmail web interface for a while now
(that's how I tracked my email on my cellphone while I was on
vacation, which helped a lot when I got back). I like many of the
features, but the email posting takes some getting used to. Partly
because gmail seems to actively encourage some bad behavior (like top
posting and obviously not having working tabs), but mostly because I'm
just a klutz.

(The big upside of the gmail web interface being that searching works
across folders. So I think I'll stick with it despite the downsides.
And I'll try to be less klutzy)

                      Linus
