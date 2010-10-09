Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab0JIL4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 07:56:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38937 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab0JIL4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 07:56:01 -0400
Date: Sat, 9 Oct 2010 07:55:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101009115551.GA19947@infradead.org>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
 <20101009092127.GB20975@n2100.arm.linux.org.uk>
 <AANLkTimtdV8THgnQL1RxaqLzCUwO27AZSMPi=UtgpML7@mail.gmail.com>
 <201010091311.26335.arnd@arndb.de>
 <AANLkTikdxSQD+9UY70PtCPMgnrovx-dWjrrPJ0AZyG4X@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikdxSQD+9UY70PtCPMgnrovx-dWjrrPJ0AZyG4X@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 09:43:50PM +1000, Dave Airlie wrote:
> I'm guessing some closed source graphics drivers for ARM do all kinds
> of wrong crap, and Nokia use them a lot, and nobody wants to tell the
> closed vendors to change their drivers because it costs money.

In which case Russell's message to tell them to sodd off is exactly the
right thing to do.  I've never figured out why Felipe cars so much, but
if he's one of the users of utterly buggy binary drivers that would
explain his weird actions here.

