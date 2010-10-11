Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0JKLEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 07:04:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37449 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852Ab0JKLED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 07:04:03 -0400
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pawel Moll <mail@pawelmoll.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Arnd Hannemann <arnd@arndnet.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Hemant Pedanekar <hemantp@ti.com>, Greg KH <greg@kroah.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <b7d9a97c0eda73281b49c9a7744f5569@cox.rootnode.net>
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
	 <b7d9a97c0eda73281b49c9a7744f5569@cox.rootnode.net>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 11 Oct 2010 12:03:38 +0100
Message-ID: <1286795018.19739.32.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Oct 2010 11:03:39.0048 (UTC) FILETIME=[F555CA80:01CB6933]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-11 at 12:01 +0100, Pawel Moll wrote:
> > +                 (mtype != MT_DEVICE_CACHED || mtype != MT_DEVICE_WC))
> 
> Em, am I wrong or this expression _always_ evaluates as 1? ;-)

Should be '&&'. Thanks.

-- 
Catalin

