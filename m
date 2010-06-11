Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229Ab0FKNAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 09:00:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55020 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab0FKNA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 09:00:29 -0400
Date: Fri, 11 Jun 2010 14:00:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: regulator: add Maxim 8998 driver
Message-ID: <20100611130022.GF12436@sirena.org.uk>
References: <1276239765-26234-1-git-send-email-m.szyprowski@samsung.com> <20100611105823.GA17546@rakim.wolfsonmicro.main> <AANLkTikbTtpMe_k97khIS1Mg5m7AaEbX0sa7URrJ2TkS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikbTtpMe_k97khIS1Mg5m7AaEbX0sa7URrJ2TkS@mail.gmail.com>
X-Cookie: Postage will be paid by addressee.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 09:48:58PM +0900, Kyungmin Park wrote:
> On Fri, Jun 11, 2010 at 7:58 PM, Mark Brown
> > On Fri, Jun 11, 2010 at 09:02:45AM +0200, Marek Szyprowski wrote:

> >> +static irqreturn_t max8998_ono_irq(int irq, void *data)
> >> +{
> >> + ? ? return IRQ_HANDLED;
> >> +}

> > This needs at least a comment explaining why you don't need to do
> > anything for the interrupt.

> We just remove it. it's unused function actually.

I suspect it may be required for the wake IRQ functionality you're using
but ICBW.
