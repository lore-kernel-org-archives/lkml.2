Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab0KTTrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 14:47:41 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:59654 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755183Ab0KTTrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 14:47:40 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19lMscvAQNl/ipuwJwH7/fKRsA1p2H+Wa4uOL4hnn
	BsQJC40RYAhXja
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: balbir@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101120090955.GB12043@balbir.in.ibm.com>
References: <AANLkTimwSktAQ5PkXNGY2EQz71DFmKY3Bt2fbZYasD0G@mail.gmail.com>
	 <AANLkTi=fT-DCP40_U24zft-3owseW24px=Zq=LnEJ_FF@mail.gmail.com>
	 <1289783580.495.58.camel@maggy.simson.net>
	 <1289811438.2109.474.camel@laptop>
	 <1289820766.16406.45.camel@maggy.simson.net>
	 <1289821590.16406.47.camel@maggy.simson.net>
	 <20101115125716.GA22422@redhat.com>
	 <1289856350.14719.135.camel@maggy.simson.net>
	 <20101116015648.GA11534@redhat.com>
	 <1289916171.5169.117.camel@maggy.simson.net>
	 <20101120090955.GB12043@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Nov 2010 12:47:19 -0700
Message-ID: <1290282439.28711.19.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-20 at 14:39 +0530, Balbir Singh wrote:

> I see the arguments you make, but it sounds easily fixable, we need to
> provide a simple template and a guide. I suspect the question that
> eventually comes to mind is - what is the overhead of maintaining
> or guaranteeing that behaviour and will the user still need to
> configure things in user space to get the full benefit? 

That systemd gizmo sounds like it'll eventually take care of new
installations, though a tad costlier (for which you likely get more
tweakability).

	-Mike

