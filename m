Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab0JKWxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:53:46 -0400
Received: from relais.videotron.ca ([24.201.245.36]:64767 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab0JKWxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:53:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 11 Oct 2010 18:53:43 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
In-reply-to: <1286800232.19739.96.camel@e102109-lin.cambridge.arm.com>
Message-id: <alpine.LFD.2.00.1010111842130.2764@xanadu.home>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
 <20101007192245.GC26435@n2100.arm.linux.org.uk>
 <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
 <20101008175308.GA10975@n2100.arm.linux.org.uk>
 <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com>
 <20101008230451.GB10975@n2100.arm.linux.org.uk>
 <20101008232539.GA28697@kroah.com>
 <20101008234448.GD10975@n2100.arm.linux.org.uk>
 <20101009000046.GA30616@kroah.com>
 <20101009002546.GB14675@n2100.arm.linux.org.uk>
 <alpine.LFD.2.00.1010082210150.3107@xanadu.home>
 <1286791544.19739.31.camel@e102109-lin.cambridge.arm.com>
 <AANLkTinMuKDpbL9ka61QhUFJfze_HWWHxjUbAqbz2_vi@mail.gmail.com>
 <1286796187.19739.52.camel@e102109-lin.cambridge.arm.com>
 <AANLkTinHZ-w6=0RvVp39MnvpRC7RW1CYNSbzi2f1OvaQ@mail.gmail.com>
 <1286800232.19739.96.camel@e102109-lin.cambridge.arm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010, Catalin Marinas wrote:

> It may be just theoretical but architecture licensees implement the
> hardware according to the ARM ARM. If it says "unpredictable", they
> don't need to care much about this scenario as it is not allowed in
> software and the hardware can be further optimised (well, I think
> "unpredictable" doesn't allow hardware deadlocking or security
> implications, so the memory corruption cannot be that random, possibly
> just restricted to that memory range). It is probably ok on current
> hardware but I cannot guarantee, you would have to check on a
> case-by-case basis (CPU implementation).

I've seen real designs where "security implications" was interpreted 
rather liberally by the hardware people, and not exactly in the same way 
as software people do.


Nicolas
