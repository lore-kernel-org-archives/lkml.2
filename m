Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab1E0Tlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:41:53 -0400
Received: from relais.videotron.ca ([24.201.245.36]:36699 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab1E0Tlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:41:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 27 May 2011 15:41:49 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Ingo Molnar <mingo@elte.hu>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()" locks
 up on ARM
In-reply-to: <20110527120629.GA32617@elte.hu>
Message-id: <alpine.LFD.2.00.1105271532060.3207@xanadu.home>
References: <1306358128.21578.107.camel@twins>
 <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
 <1306405979.1200.63.camel@twins>
 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
 <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins>
 <20110526122623.GA11875@elte.hu>
 <20110526123137.GG24876@n2100.arm.linux.org.uk>
 <20110526125007.GA27083@elte.hu>
 <BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com>
 <20110527120629.GA32617@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011, Ingo Molnar wrote:

> I'd suggest doing this once modern ARM chips get so widespread that 
> you can realistically induce a ~700 usecs irqs-off delays on old, 
> virtual-cache ARM chips. Old chips would likely use old kernels 
> anyway, right?

Those "old" ARM chips are still largely produced and fitted in new 
designs, and using latest kernels.  They are unlikely to fade away 
before a couple years.


Nicolas
