Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab0JKKPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 06:15:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43448 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab0JKKPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 06:15:40 -0400
Date: Mon, 11 Oct 2010 11:15:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101011101504.GC27153@n2100.arm.linux.org.uk>
References: <20101008230451.GB10975@n2100.arm.linux.org.uk> <20101008232539.GA28697@kroah.com> <20101008234448.GD10975@n2100.arm.linux.org.uk> <AANLkTinhwORqdWU43yr1AXJGZm2zPKGG+Q9twruNs2aH@mail.gmail.com> <20101009092127.GB20975@n2100.arm.linux.org.uk> <AANLkTimQJLmDZPHtVJLCv9ZQgx_Yjh9=MOwOxMSAz4QX@mail.gmail.com> <20101011083508.GW29673@pengutronix.de> <20101011090212.GA27153@n2100.arm.linux.org.uk> <20101011092424.GX29673@pengutronix.de> <AANLkTikYRfK-KHYxPL5y4z7kbb0YVn2y0CiYiMvWDsB-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikYRfK-KHYxPL5y4z7kbb0YVn2y0CiYiMvWDsB-@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 01:08:29PM +0300, Felipe Contreras wrote:
> So, coming back to the arguments. I think Russell should have tried
> this and provided an example of what to do, and how. I think it should
> be clear by now that there's not much known affected drivers can do
> right now.

Those people who have stupid platforms that require major chunks of
memory should have been paying attention and evaluated the patch six
months ago.

They partly did that, and asked some questions about how to solve it.
They got answers, and then nothing happened.  And it's somehow my
problem that they did nothing?

*They* should have done more to help instead of ignoring the issue,
then we'd know where things were _before_ the patch was originally
merged.

Not my problem.
