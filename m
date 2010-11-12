Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab0KLQw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:52:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59534 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab0KLQw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:52:56 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=1jCsSUyidw0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7ytc701yKkiR2wrT3MkA:9 a=5HPxFokIPmSJRKZoOxMA:7 a=rWek5GX00_56KNikuy6Kfbjppj8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <1289580222.2084.318.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333622.8661.141.camel@Palantir>
	 <1289579924.12418.404.camel@gandalf.stny.rr.com>
	 <1289580222.2084.318.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Nov 2010 11:52:52 -0500
Message-ID: <1289580772.12418.405.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 17:43 +0100, Peter Zijlstra wrote:
> On Fri, 2010-11-12 at 11:38 -0500, Steven Rostedt wrote:
> > A while ago I implemented an EDF scheduler for a client (before working
> > with Red Hat), and one thing they asked about was having a "soft group",
> > which was basically: This group is guaranteed X runtime in Y period, but
> > if the system is idle, let the group run, even if it has exhausted its X
> > runtime.
> > 
> > Is this supported? 
> 
> No, some of the bits in 18/22 come near, but I'd prefer not to add such
> things until we've got a convincing use-case.

I'm fine with that, but I would like to know if the ABI would be able to
add such an extension in the future if we find a convincing use-case.

-- Steve


