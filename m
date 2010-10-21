Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0JUIkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:40:05 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45092 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754261Ab0JUIkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:40:03 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX191O68KdNR1oz1tDxOVGhHI7JorvZUAfrS1+TzYKT
	xkVFQ7P1NP5gLy
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
In-Reply-To: <20101021083101.GE8775@elte.hu>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
	 <1287511983.7417.45.camel@marge.simson.net>
	 <1287514410.7368.10.camel@marge.simson.net>
	 <20101020025652.GB26822@elte.hu>
	 <1287648715.9021.20.camel@marge.simson.net> <20101021083101.GE8775@elte.hu>
Content-Type: text/plain
Date: Thu, 21 Oct 2010 10:39:58 +0200
Message-Id: <1287650399.9021.33.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 10:31 +0200, Ingo Molnar wrote:

> Btw., how does Xorg fare with this? Can we remove sleeper fairness for example and 
> simplify other bits of the CFS logic as a side-effect?

Works a treat for me.  As I write this in evolution, I have amarok
playing with a visualization and a make -j100 running.  Song switch is
instant, visualization is nice and smooth despite unaccelerated Xorg.

We can't whack fair sleepers though, not without inventing a new
preemption model to take it's place.

	-Mike

