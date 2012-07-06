Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab2GFJWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:22:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40145 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab2GFJWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:22:41 -0400
Date: Fri, 6 Jul 2012 11:22:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "vnagarnaik@google.com" <vnagarnaik@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH]trace,x86: add x86 irq vector tracepoints
Message-ID: <20120706092235.GB30564@gmail.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AA07@USINDEM103.corp.hds.com>
 <1341521053.21574.22.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341521053.21574.22.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Thomas Gleixner is the unofficial (or is it now official?) 
> maintainer of interrupts. You need his Ack for this change.

It's been official for a while:

IRQ SUBSYSTEM
M:      Thomas Gleixner <tglx@linutronix.de>
S:      Maintained
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
F:      kernel/irq/

I guess the 'F' pattern ought to be extended a bit, to include 
relevant arch/ files, such as arch/x86/kernel/irq.c.

F:      arch/*/kernel/irq.c

or so?

Thanks,

	Ingo
