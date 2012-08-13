Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab2HMOM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:12:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38648 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975Ab2HMOM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:12:26 -0400
Date: Mon, 13 Aug 2012 15:11:57 +0100
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <chris.mason@fusionio.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RFC: mutex: hung tasks on SMP platforms with
 asm-generic/mutex-xchg.h
Message-ID: <20120813141156.GC20537@mudshark.cambridge.arm.com>
References: <20120807115647.GA12828@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1208090029460.5231@xanadu.home>
 <20120809144953.GC18486@mudshark.cambridge.arm.com>
 <alpine.LFD.2.02.1208091201380.5231@xanadu.home>
 <alpine.LFD.2.02.1208091243080.5231@xanadu.home>
 <1344845704.31459.11.camel@twins>
 <alpine.LFD.2.02.1208130931530.5231@xanadu.home>
 <1344866717.31459.32.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344866717.31459.32.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 03:05:17PM +0100, Peter Zijlstra wrote:
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks Peter.

> Will you carry this through the ARM tree or do you want me/Ingo to take
> it?

Please can you guys take it? The move to mutex-dec can go through the ARM
tree but it's probably best if you take the core change.

Cheers,

Will
