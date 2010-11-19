Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab0KSMjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:39:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:37098 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751911Ab0KSMjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:39:19 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19MgihvY39M6satU4w9v0pBonqQPG84GgyM5opqNb
	aASY4u4KzaH4kY
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <1290167376.2109.1553.camel@laptop>
References: <1289916171.5169.117.camel@maggy.simson.net>
	 <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
	 <20101116211431.GA15211@tango.0pointer.de>
	 <201011182333.48281.hpj@urpla.net>
	 <20101118231218.GX6024@const.famille.thibault.fr>
	 <1290123351.18039.49.camel@maggy.simson.net>
	 <20101118234339.GA6024@const.famille.thibault.fr>
	 <1290167376.2109.1553.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 05:38:56 -0700
Message-ID: <1290170336.3840.40.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 12:49 +0100, Peter Zijlstra wrote:

> You add a lot of pointer chasing to all the scheduler fast paths and
> there is quite significant data size bloat for even compiling with the
> controller enabled, let alone actually using the stuff.

The pointer chasing hurts, but fast path + global spinlock is what
slapped the hierarchical outta me :)

	-Mike

