Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1BPUNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:13:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab1BPUNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:13:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
X-Fcc: ~/Mail/linus
Cc: Mark Wielaard <mjw@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Julien Desfossez <julien.desfossez@polymtl.ca>,
        dominique.toupin@ericsson.com, ltt-dev@lists.casi.polymtl.ca,
        systemtap@sources.redhat.com, linux-kernel@vger.kernel.org,
        Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Porting "jump labels" to userspace (was: Re: [ltt-dev] LTTng-UST
	vs SystemTap userspace tracing benchmarks)
In-Reply-To: Mathieu Desnoyers's message of  Wednesday, 16 February 2011 15:00:34 -0500 <20110216200034.GA6066@Krystal>
References: <4D5AA164.1050607@polymtl.ca>
	<y0mvd0ltgba.fsf@fche.csb>
	<AANLkTi=Nsy6fXE9=Njxs9LPHuohHzf=q5kD+fK765Rht@mail.gmail.com>
	<1297853778.3224.90.camel@springer.wildebeest.org>
	<20110216185056.CAD7B1806E0@magilla.sf.frob.com>
	<20110216200034.GA6066@Krystal>
X-Windows: it could be worse, but it'll take time.
Message-Id: <20110216200449.1EB9618020E@magilla.sf.frob.com>
Date: Wed, 16 Feb 2011 12:04:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMHO there is not really so much to the in-kernel implementation that it's
worth attempting to reuse the code in userland.  Pretty much all the work
is in the details of the implementation that would naturally differ a lot
in a different context.  If you understand the mechanism and the machine
details, then implementing it well for a userland context is not a big deal
and is cleaner to do from scratch than shoe-horning kernel-centric code
into a wildly different context.


Thanks,
Roland
