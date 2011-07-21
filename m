Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1GUMcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:32:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:46108 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1GUMbz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:31:55 -0400
Subject: Re: [PATCH 4/6] trace: Add tracepoints to reschedule interrupt
 handler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Sharp <dhsharp@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
In-Reply-To: <CAJL_ektnxUZaRJmx14H9psJ8MFBZ8iD5ET14WgT8CoJdMvH40w@mail.gmail.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
	 <1310679495-29104-5-git-send-email-vnagarnaik@google.com>
	 <20110714220233.GC26786@somewhere.redhat.com>
	 <1310719682.2586.289.camel@twins>
	 <CAJL_ektnxUZaRJmx14H9psJ8MFBZ8iD5ET14WgT8CoJdMvH40w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jul 2011 14:31:27 +0200
Message-ID: <1311251487.29152.136.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 10:50 -0700, David Sharp wrote:
> On Fri, Jul 15, 2011 at 1:48 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Fri, 2011-07-15 at 00:02 +0200, Frederic Weisbecker wrote:
> >> > This is a part of overall effort to trace all the interrupts happening
> >> > in a system to figure out what time is spent in kernel space versus user
> >> > space.
> >
> > How about you enable CONFIG_IRQ_TIME_ACCOUNTING and get all that?
> >
> 
> It's not just about how long, it's when, and what other events the
> interrupts are interacting with.

But that's not what the Changelog said, how am I supposed to smell that?

As to the patch in particular, I hate it, why do you need separate
tracepoints for the resched ipi and wtf is up with that ignore argument.
