Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1GOIsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 04:48:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:35147 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab1GOIsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 04:48:15 -0400
Subject: Re: [PATCH 4/6] trace: Add tracepoints to reschedule interrupt
 handler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <20110714220233.GC26786@somewhere.redhat.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
	 <1310679495-29104-5-git-send-email-vnagarnaik@google.com>
	 <20110714220233.GC26786@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Jul 2011 10:48:02 +0200
Message-ID: <1310719682.2586.289.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 00:02 +0200, Frederic Weisbecker wrote:
> > This is a part of overall effort to trace all the interrupts happening
> > in a system to figure out what time is spent in kernel space versus user
> > space. 

How about you enable CONFIG_IRQ_TIME_ACCOUNTING and get all that?
