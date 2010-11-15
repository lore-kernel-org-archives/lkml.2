Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab0KOTnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:43:25 -0500
Received: from mail3.unitn.it ([193.205.206.70]:43484 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758012Ab0KOTnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:43:24 -0500
Message-ID: <4CE18C7E.2060202@unitn.it>
Date: Mon, 15 Nov 2010 20:39:42 +0100
From: Luca Abeni <luca.abeni@unitn.it>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "James H. Anderson" <anderson@cs.unc.edu>
CC: Raistlin <raistlin@linux.it>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
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
        Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>,
        Bjoern Brandenburg <bbb@email.unc.edu>
Subject: Re: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline tasks
References: <1289588215.6525.697.camel@Palantir> <80992760-24F2-42AE-AF2D-15727F6A1C81@email.unc.edu> <4CE17DD2.3060807@cs.unc.edu>
In-Reply-To: <4CE17DD2.3060807@cs.unc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/11/10 19:37, James H. Anderson wrote:
[...]
> If you're talking about our most recent "stochastic" paper, it is about
> supporting
> soft real-time task systems on a multiprocessor where resource
> reservations are
> used. The main result of the paper is that if you provision the
> reservation for a
> task slightly higher than it's average-case execution time
[...]
BTW, I think we are aligned on this.

I was a little bit surprised when Peter mentioned allocating a runtime 
equal to the average execution time (because of the meta-stability 
considerations that Tommaso also mentioned), but I fully agree that if 
the allocated runtime is higher than the average execution time then the 
queue is stable and it's possible to find a bound for the expected 
tardiness (or even its probability distribution... This is similar to my 
"probabilistic deadlines").


			Luca
