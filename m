Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901Ab0KRXoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:44:15 -0500
Received: from solo.fdn.fr ([80.67.169.19]:54999 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab0KRXoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:44:13 -0500
Date: Fri, 19 Nov 2010 00:43:39 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101118234339.GA6024@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
	linux-kernel@vger.kernel.org,
	Lennart Poettering <mzxreary@0pointer.de>,
	Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@elte.hu>,
	Balbir Singh <balbir@linux.vnet.ibm.com>
References: <1289916171.5169.117.camel@maggy.simson.net> <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com> <20101116211431.GA15211@tango.0pointer.de> <201011182333.48281.hpj@urpla.net> <20101118231218.GX6024@const.famille.thibault.fr> <1290123351.18039.49.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290123351.18039.49.camel@maggy.simson.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith, le Thu 18 Nov 2010 16:35:51 -0700, a écrit :
> On Fri, 2010-11-19 at 00:12 +0100, Samuel Thibault wrote:
> > Hans-Peter Jansen, le Thu 18 Nov 2010 23:33:46 +0100, a écrit :
> > > As already mentioned countless times (and some of it was even renamed 
> > > for this very fact): the grouping by tty is just a starter. There are 
> > > plenty of other possibilities to group the scheduling. The hard part is 
> > > to find the right grouping concepts, that are making sense in the 
> > > usability department _and_ are easy enough to be picked up from our 
> > > favorite system and desktop environments. That's where the generic 
> > > cgroup concept seems to be lacking ATM..
> > 
> > Actually, cgroups should probably be completely hierarchical: sessions
> > contain process groups, which contain processes, which contain threads.
> > You could also gather sessions with the same uid.
> 
> Hierarchical is ~tempting, but adds overhead for not much gain.

What overhead? The implementation of cgroups is actually already
hierarchical.

Samuel
