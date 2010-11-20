Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab0KTWRD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 17:17:03 -0500
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]:52276 "EHLO
	shogun.pilppa.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754883Ab0KTWRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 17:17:02 -0500
Date: Sun, 21 Nov 2010 00:16:46 +0200 (EET)
From: Mika Laitio <lamikr@pilppa.org>
To: Lennart Poettering <mzxreary@0pointer.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
In-Reply-To: <20101116205043.GG27235@tango.0pointer.de>
Message-ID: <alpine.LMD.2.00.1011210004090.2350@shogun.pilppa.org>
References: <20101116015648.GA11534@redhat.com> <1289916171.5169.117.camel@maggy.simson.net> <1289916683.2109.625.camel@laptop> <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com> <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com> <20101116181603.GC19327@tango.0pointer.de> <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com> <AANLkTikjQKmo0j5xbvPiS=eriAUUZPMGKkcxt8w_z8XB@mail.gmail.com>
 <AANLkTikKdjH-ZM0eXTQMvzJjYkpyfKZR2OK06tNtCGFs@mail.gmail.com> <20101116205043.GG27235@tango.0pointer.de>
User-Agent: Alpine 2.00 (LMD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > What complexity? Have you looked at the patch? It has no complexity anywhere.
> > 
> > It's a _lot_ less complex than having system daemons you don't
> > control. We have not had good results with that approach in the past.
> > System daemons tend to cause nasty problems, and debugging them is a
> > nightmare.
> 
> Well, userspace doesn't bite.

To me, this starts sounding like a legendary "userspace suspend" versus 
"kernel suspend" support fights many years ago... Since that, I have 
_sometimes_but_rarely_ been luckily enought to get my laptops 
recovered from the suspend states successfully...

And as the kernel patches allows disabling the schedyles feature either via kernel 
build parameters, boot parameters or at runtime _if_you_ really want, I do 
not understand why do you complaint if there will be much better defaults 
in the kernel immediately once you just build and boot the new kernel.
(I really do not plan to start converting init-rd boot scripts from 
all of my computers systemd way of doing things in near future...)

Mika
