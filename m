Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1ITMK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:10:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47020 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1ITMK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:10:57 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=3kNrfhY1ZosA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=_J7hAj0WIu3IhZS4OrsA:9 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [RFC][PATCH 0/5] Introduce checks for preemptable code for
 this_cpu_read/write()
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>, Tejun Heo <htejun@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.02.1109200933310.2723@ionos>
References: <20110919212040.745370781@goodmis.org>
	 <m2ehzcdkf2.fsf@firstfloor.org>
	 <1316488378.29966.35.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1109200933310.2723@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 20 Sep 2011 08:10:52 -0400
Message-ID: <1316520652.29966.39.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 10:32 +0200, Thomas Gleixner wrote:

> > and not have every spinlock disable preemption.
> 
> That doesn't work, you're prone to deadlocks then. I guess you meant
> not disable migration on RT, right?

Oops, yeah I meant migrate disable.

-- Steve


