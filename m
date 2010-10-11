Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0JKLID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 07:08:03 -0400
Received: from cox.rootnode.net ([89.248.165.14]:57791 "EHLO cox.rootnode.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab0JKLHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 07:07:50 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Oct 2010 07:07:50 EDT
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 11 Oct 2010 12:01:50 +0100
From: Pawel Moll <mail@pawelmoll.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Arnd Hannemann <arnd@arndnet.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Hemant Pedanekar <hemantp@ti.com>, Greg KH <greg@kroah.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
In-Reply-To: <1286791544.19739.31.camel@e102109-lin.cambridge.arm.com>
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
Message-ID: <b7d9a97c0eda73281b49c9a7744f5569@cox.rootnode.net>
User-Agent: Roundcube Webmail/0.4
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.7 (cox.rootnode.net [0.0.0.0]); Mon, 11 Oct 2010 13:01:50 +0200 (CEST)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Oct 11 13:01:50 2010
X-DSPAM-Confidence: 0.9901
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4cb2ee9e262111804284693
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> +		    (mtype != MT_DEVICE_CACHED || mtype != MT_DEVICE_WC))

Em, am I wrong or this expression _always_ evaluates as 1? ;-)

Cheers!

Paweł

