Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab2HMOpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:45:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33420 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2HMOpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:45:45 -0400
Message-ID: <1344869129.31459.33.camel@twins>
Subject: Re: RFC: mutex: hung tasks on SMP platforms with
 asm-generic/mutex-xchg.h
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Will Deacon <will.deacon@arm.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 13 Aug 2012 16:45:29 +0200
In-Reply-To: <20120813141156.GC20537@mudshark.cambridge.arm.com>
References: <20120807115647.GA12828@mudshark.cambridge.arm.com>
	 <alpine.LFD.2.02.1208090029460.5231@xanadu.home>
	 <20120809144953.GC18486@mudshark.cambridge.arm.com>
	 <alpine.LFD.2.02.1208091201380.5231@xanadu.home>
	 <alpine.LFD.2.02.1208091243080.5231@xanadu.home>
	 <1344845704.31459.11.camel@twins>
	 <alpine.LFD.2.02.1208130931530.5231@xanadu.home>
	 <1344866717.31459.32.camel@twins>
	 <20120813141156.GC20537@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-13 at 15:11 +0100, Will Deacon wrote:
> 
> > Will you carry this through the ARM tree or do you want me/Ingo to take
> > it?
> 
> Please can you guys take it? The move to mutex-dec can go through the ARM
> tree but it's probably best if you take the core change. 

OK, done. Thanks!
