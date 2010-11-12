Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab0KLQ1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:27:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:54299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab0KLQ1j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:27:39 -0500
Subject: Re: [RFC][PATCH 12/22] sched: add runtime reporting for -deadline
 tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
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
In-Reply-To: <1289578543.6525.535.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334202.8661.153.camel@Palantir>  <1289504223.2084.174.camel@laptop>
	 <1289578543.6525.535.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 17:27:31 +0100
Message-ID: <1289579251.2084.316.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 17:15 +0100, Raistlin wrote:
> > but reading this patch makes me
> > wonder why tsk->se.sum_exec_runtime isn't good enough?
> >
> Might be, but what you usually want is something reporting you total
> runtime from when you became a -deadline task, which may not be the case
> of sum_exec_runtime, is it? 

Correct, it wouldn't be. However since I expect a user to be mostly
interested in deltas between two readings, in which case it really
doesn't matter, does it?
