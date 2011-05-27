Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab1E0Rzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:55:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37264 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab1E0Rzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:55:32 -0400
Date: Fri, 27 May 2011 18:55:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
	locks up on ARM
Message-ID: <20110527175500.GQ24876@n2100.arm.linux.org.uk>
References: <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com> <1306405979.1200.63.camel@twins> <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com> <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins> <20110526122623.GA11875@elte.hu> <20110526123137.GG24876@n2100.arm.linux.org.uk> <20110526125007.GA27083@elte.hu> <BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com> <20110527120629.GA32617@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527120629.GA32617@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 02:06:29PM +0200, Ingo Molnar wrote:
> I'd suggest doing this once modern ARM chips get so widespread that 
> you can realistically induce a ~700 usecs irqs-off delays on old, 
> virtual-cache ARM chips. Old chips would likely use old kernels 
> anyway, right?

Not necessarily.  I have rather a lot of legacy hardware (it outweighs
the more modern stuff) and that legacy hardware is _loads_ more useful
than the modern stuff in that it can actually do stuff like run a network
(such as running kerberos servers, httpd, mtas, etc).  Modern ARM
machines typically don't have ways to attach mass storage to them which
make them hellishly limited for such applications.

I'm planning to continue using my old machines, and continue to upgrade
their kernels, especially in order to keep up to date with security
issues.
