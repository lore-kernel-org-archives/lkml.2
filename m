Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0KSC2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 21:28:45 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:59101 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752207Ab0KSC2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 21:28:44 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+g5JoTTH2gIOF/YdluDNcZKMd/SKJhTYrNzpsP2S
	9AtexKEJ6y7i+j
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20101119012348.GM6024@const.famille.thibault.fr>
References: <20101116211431.GA15211@tango.0pointer.de>
	 <201011182333.48281.hpj@urpla.net>
	 <20101118231218.GX6024@const.famille.thibault.fr>
	 <1290123351.18039.49.camel@maggy.simson.net>
	 <20101118234339.GA6024@const.famille.thibault.fr>
	 <AANLkTimTNxLYGLgnS9TUT_YiMnmDVrqseByGGogj+A4Z@mail.gmail.com>
	 <20101119000204.GE6024@const.famille.thibault.fr>
	 <AANLkTi=n4r9STKsx76t--HbK7EiUWaaPm7tUN2nXtqxA@mail.gmail.com>
	 <20101119005942.GL6024@const.famille.thibault.fr>
	 <1290129157.18039.70.camel@maggy.simson.net>
	 <20101119012348.GM6024@const.famille.thibault.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 19:28:21 -0700
Message-ID: <1290133701.18039.105.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 02:23 +0100, Samuel Thibault wrote:
> Mike Galbraith, le Thu 18 Nov 2010 18:12:37 -0700, a écrit :
> > I think that could be done with a fork flag with the same semantics as
> > reset on fork.  Once your task launcher (ala kdeinit) is tagged, it
> > launches task groups, the children lose that ability.
> 
> Mmm, even if always creating groups can have a slight overhead, you
> should probably not prevent userspace from deciding to do so when it
> knows it's appropriate.

I think you may have misunderstood.  The flag would be a hint that
userland can set to say "I want to fork off task groups", just as
SCHED_RESET_ON_FORK asks the kernel to reset a child's sched class and
nice level on fork.

	-Mike

