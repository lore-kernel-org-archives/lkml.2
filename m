Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab0KLTXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:23:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49442 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab0KLTXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:23:10 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=1jCsSUyidw0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ZnvJaOifsQVlnLHOAJ0A:9 a=UFPmwqG6N55Ich9uJpGwi3vhQNcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Raistlin <raistlin@linux.it>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289589549.6525.720.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>
	 <1289579924.12418.404.camel@gandalf.stny.rr.com>
	 <1289580222.2084.318.camel@laptop>
	 <1289580772.12418.405.camel@gandalf.stny.rr.com>
	 <1289589549.6525.720.camel@Palantir>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Nov 2010 14:23:07 -0500
Message-ID: <1289589787.12418.444.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 20:19 +0100, Raistlin wrote:
> On Fri, 2010-11-12 at 11:52 -0500, Steven Rostedt wrote:
> > > No, some of the bits in 18/22 come near, but I'd prefer not to add such
> > > things until we've got a convincing use-case.
> > 
> > I'm fine with that, but I would like to know if the ABI would be able to
> > add such an extension in the future if we find a convincing use-case.
> > 
> Scared about ABIs' stability eh? :-PP

Nah, why should I be? ;-)

> 
> BTW, in this case everything should be fine, since the very exact
> behaviour you described was triggered by a (couple of) flag(s), which
> can be added and dealt with during sched_setscheduler2() at any time.

Yep.

> 
> As Peter was saying, see patch 18 for details.

I'm slowly getting there ;-)

-- Steve


