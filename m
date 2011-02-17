Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab1BQN65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 08:58:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44079 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab1BQN6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 08:58:52 -0500
Date: Thu, 17 Feb 2011 14:58:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Roland McGrath <roland@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Julien Desfossez <julien.desfossez@polymtl.ca>,
        dominique.toupin@ericsson.com, ltt-dev@lists.casi.polymtl.ca,
        systemtap@sources.redhat.com, linux-kernel@vger.kernel.org,
        Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        andi@firstfloor.org, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au
Subject: Re: Porting "jump labels" to userspace
Message-ID: <20110217135816.GC7018@elte.hu>
References: <y0mvd0ltgba.fsf@fche.csb>
 <AANLkTi=Nsy6fXE9=Njxs9LPHuohHzf=q5kD+fK765Rht@mail.gmail.com>
 <1297853778.3224.90.camel@springer.wildebeest.org>
 <20110216185056.CAD7B1806E0@magilla.sf.frob.com>
 <20110216200034.GA6066@Krystal>
 <20110216200449.1EB9618020E@magilla.sf.frob.com>
 <4D5C30D8.8070107@caviumnetworks.com>
 <20110216203953.GB2015@Krystal>
 <alpine.LFD.2.00.1102162143430.2701@localhost6.localdomain6>
 <1297892529.5226.543.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297892529.5226.543.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2011-02-16 at 21:45 +0100, Thomas Gleixner wrote:
> 
> > We talk about 500 lines of code, where half of it is modules specific
> > and the whole thing is full of kernelims. IMNSHO, that's faster
> > reimplemented from scratch than writing all the mails and get the
> > authors to sign off on the license change.
> 
> That and I'm not going to consent with an LGPL license, I'm an avid
> GPLv2 fan as various people already know ;-)

Ditto for me.

Thanks,

	Ingo
