Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab0KSNB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:01:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:44484 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab0KSNBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:01:25 -0500
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20101119125548.GC24411@Krystal>
References: <1289916171.5169.117.camel@maggy.simson.net>
	 <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
	 <20101116211431.GA15211@tango.0pointer.de>
	 <201011182333.48281.hpj@urpla.net>
	 <20101118231218.GX6024@const.famille.thibault.fr>
	 <1290123351.18039.49.camel@maggy.simson.net>
	 <20101118234339.GA6024@const.famille.thibault.fr>
	 <1290167376.2109.1553.camel@laptop> <1290169178.2109.1573.camel@laptop>
	 <20101119125548.GC24411@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 14:00:48 +0100
Message-ID: <1290171648.2109.1580.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 07:55 -0500, Mathieu Desnoyers wrote:
> 
> > In general though, I think you can say that: cgroups ass overhead.
> 
> I really think you meant "add" here ? (Hey! The keys were next to each other!)
> ;)

Uhm, quite!

> > Simply because you add constraints, this means you need to 1) account
> > more, 2) enforce constraints. Both have definite non-zero cost in both
> > data and time.
> 
> Yep, this looks like one of these perpetual throughput vs latency trade-offs.
> 
Trade-off sure, throughput vs latency only in a specific use-case, its
more a feature vs cost thing, just like all them trace people want lower
cost tracing but want more features at the same time..


