Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0KUAT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 19:19:28 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:48287 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751608Ab0KUAT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 19:19:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/A+yVfkIDAx/1TFbiHKAzhVdz8rzkpPYY3uMCcSu
	HKoMt4VYtmyLtP
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Mika Laitio <lamikr@pilppa.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <alpine.LMD.2.00.1011210004090.2350@shogun.pilppa.org>
References: <20101116015648.GA11534@redhat.com>
	 <1289916171.5169.117.camel@maggy.simson.net>
	 <1289916683.2109.625.camel@laptop>
	 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
	 <20101116170312.GA19327@tango.0pointer.de>
	 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
	 <20101116181603.GC19327@tango.0pointer.de>
	 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
	 <AANLkTikjQKmo0j5xbvPiS=eriAUUZPMGKkcxt8w_z8XB@mail.gmail.com>
	 <AANLkTikKdjH-ZM0eXTQMvzJjYkpyfKZR2OK06tNtCGFs@mail.gmail.com>
	 <20101116205043.GG27235@tango.0pointer.de>
	 <alpine.LMD.2.00.1011210004090.2350@shogun.pilppa.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Nov 2010 17:19:05 -0700
Message-ID: <1290298745.5559.12.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 00:16 +0200, Mika Laitio wrote:
> > > What complexity? Have you looked at the patch? It has no complexity anywhere.
> > > 
> > > It's a _lot_ less complex than having system daemons you don't
> > > control. We have not had good results with that approach in the past.
> > > System daemons tend to cause nasty problems, and debugging them is a
> > > nightmare.
> > 
> > Well, userspace doesn't bite.
> 
> To me, this starts sounding like a legendary "userspace suspend" versus 
> "kernel suspend" support fights many years ago... 

Nah.  Patch accepted, rejected, obsoleted 10 minutes from now etc etc,
it'll never be a big deal.

	-Mike

