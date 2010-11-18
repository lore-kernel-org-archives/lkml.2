Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706Ab0KRXaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:30:03 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:50943 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754613Ab0KRXaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:30:01 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/pQSc9zSvpDWCpzSMwiBcZOfEw2h0x1NKjDLjYi1
	hD2zL17A6lbrY4
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-kernel@vger.kernel.org, Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <201011182333.48281.hpj@urpla.net>
References: <1289916171.5169.117.camel@maggy.simson.net>
	 <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
	 <20101116211431.GA15211@tango.0pointer.de>
	 <201011182333.48281.hpj@urpla.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 16:29:38 -0700
Message-ID: <1290122978.18039.46.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 23:33 +0100, Hans-Peter Jansen wrote:

> If you think, that systemd can solve this and probably other aspects of 
> responsiveness, go for it, compete with it, and _prove_ it with real 
> facts and numbers, not just hand waving.

Of course systemd can do it.  You don't even need systemd, autogroup or
whatever else if you don't mind a little scripting.  There's nothing to
prove, any numbers he generates will be identical with any numbers I
generate... it's the same scheduler whether you configure it from
userspace or kernelspace.

> As already mentioned countless times (and some of it was even renamed 
> for this very fact): the grouping by tty is just a starter. There are

Actually, I switched to setsid alone for now at least, and the only
thing in the root group is kernel threads. 

	-Mike

