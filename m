Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105Ab0KPUMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:12:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:60676 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab0KPUMY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:12:24 -0500
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20101116200356.GA27235@tango.0pointer.de>
References: <20101115125716.GA22422@redhat.com>
	 <1289856350.14719.135.camel@maggy.simson.net>
	 <20101116015648.GA11534@redhat.com>
	 <1289916171.5169.117.camel@maggy.simson.net>
	 <1289916683.2109.625.camel@laptop>
	 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
	 <20101116170312.GA19327@tango.0pointer.de>
	 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
	 <20101116181603.GC19327@tango.0pointer.de>
	 <1289931715.2109.648.camel@laptop>
	 <20101116200356.GA27235@tango.0pointer.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Nov 2010 21:12:29 +0100
Message-ID: <1289938349.2109.664.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 21:03 +0100, Lennart Poettering wrote:
> Userspace usually gets updated way more frequently in most distributions
> than the kernel is. Maybe *you* never update userspace. But well, you
> are not the examplary Linux user, are you? 

I run very recent userspace on my desktop and laptop, and I get really
tired of fixing it every upgrade. That said, I do run more recent
kernels than get shipped, in fact I never run distro kernels at all.


