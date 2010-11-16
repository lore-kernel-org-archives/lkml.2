Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab0KPUPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:15:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:53557 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab0KPUPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:15:21 -0500
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20101116200546.GB27235@tango.0pointer.de>
References: <1289820766.16406.45.camel@maggy.simson.net>
	 <1289821590.16406.47.camel@maggy.simson.net>
	 <20101115125716.GA22422@redhat.com>
	 <1289856350.14719.135.camel@maggy.simson.net>
	 <20101116015648.GA11534@redhat.com>
	 <1289916171.5169.117.camel@maggy.simson.net>
	 <1289916683.2109.625.camel@laptop>
	 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
	 <20101116170312.GA19327@tango.0pointer.de>
	 <1289930934.2109.644.camel@laptop>
	 <20101116200546.GB27235@tango.0pointer.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Nov 2010 21:15:30 +0100
Message-ID: <1289938530.2109.667.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 21:05 +0100, Lennart Poettering wrote:
> > Using a group per tty makes sense for us console jockeys..
> 
> Well, then maybe you shouldn't claim this was relevant for anybody but
> yourself. Because it is irrelevant for most users if it is bound to the TTY.

I never made such a claim, in fact my kernels will have this =n.

> > Anyway, nobody uses systemd yet and afaik not all distro's even plan on
> > using it (I know I'm not waiting to learn yet another init variant).
> 
> Well, the way it looks right now we have convinced all big distros.

Crap, means I get to blame you for more than non working sound. I get
really fed up having to re-discover how to fix broken init scripts on
every upgrade :/
