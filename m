Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0KKT6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:58:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58795 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756607Ab0KKT6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:58:18 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18zsZ86l7IzUXTL1FB6wX25Fa7YCGKjc5JliTeD/Y
	evIOFN1ULThKkS
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101111193810.GB1564@arch.trippelsdorf.de>
References: <1287648715.9021.20.camel@marge.simson.net>
	 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
	 <20101021162924.GA3225@redhat.com>
	 <1288076838.11930.1.camel@marge.simson.net>
	 <1288078144.7478.9.camel@marge.simson.net>
	 <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
	 <1289489200.11397.21.camel@maggy.simson.net>
	 <20101111191556.GA1564@arch.trippelsdorf.de>
	 <1289504111.21413.2.camel@maggy.simson.net>
	 <20101111193810.GB1564@arch.trippelsdorf.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 12:58:06 -0700
Message-ID: <1289505486.21413.17.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 20:38 +0100, Markus Trippelsdorf wrote:
> On 2010.11.11 at 12:35 -0700, Mike Galbraith wrote:

> > When you say with/without, does that mean enabled/disabled, or
> > patched/virgin and/or cgroups/nocgroups?
> 
> Patched/virgin and nocgroups

Figures.  As you can see, group scheduling is not wonderful for extreme
switchers.  Fortunately, most apps do a bit of work in between.

	-Mike

