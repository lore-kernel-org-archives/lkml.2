Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab0KSMwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:52:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:39882 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab0KSMwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:52:03 -0500
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Menage <menage@google.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <AANLkTikB6QXxTav=b7qNzHUv4HXnjjT9TdcEdTYHbEkw@mail.gmail.com>
References: <1289916171.5169.117.camel@maggy.simson.net>
	 <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com>
	 <20101116211431.GA15211@tango.0pointer.de>
	 <201011182333.48281.hpj@urpla.net>
	 <20101118231218.GX6024@const.famille.thibault.fr>
	 <1290123351.18039.49.camel@maggy.simson.net>
	 <20101118234339.GA6024@const.famille.thibault.fr>
	 <1290167376.2109.1553.camel@laptop>
	 <AANLkTikB6QXxTav=b7qNzHUv4HXnjjT9TdcEdTYHbEkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 13:51:53 +0100
Message-ID: <1290171113.2109.1574.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 04:31 -0800, Paul Menage wrote:
> On Fri, Nov 19, 2010 at 3:49 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > It must be nice to be that ignorant ;-) Speaking for the scheduler
> > cgroup controller (that being the only one I actually know), most all
> > the load-balance operations are O(n) in the number of active cgroups,
> > and a lot of the cpu local schedule operations are O(d) where d is the
> > depth of the cgroup tree.
> 
> The same would apply to CPU autogroups, presumably?

Yep, they're not special at all... uses the same mechanism.
