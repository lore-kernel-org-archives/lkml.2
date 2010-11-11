Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0KKTW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:22:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:54924 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0KKTWZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:22:25 -0500
Subject: Re: [RFC][PATCH 10/22] sched: add a syscall to wait for the next
 instance
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
In-Reply-To: <1288334104.8661.151.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334104.8661.151.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 20:21:57 +0100
Message-ID: <1289503317.2084.158.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:35 +0200, Raistlin wrote:
> 
> Introduce sched_wait_interval() syscall (and scheduling class
> interface call). In general, this aims at providing each scheduling
> class with a mean of making one of its own task sleep for some time
> according to some specific rule of the scheduling class itself.
> 
Did we have an actual use case for this? I seem to remember that the
last time we seemed to thing job wakeups are due to external events, in
which case we don't need this.

I think we should try without this patch first and only consider this
once we merged the base functionality and have a solid use-case for
this.
