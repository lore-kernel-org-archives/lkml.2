Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab0LATFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:05:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40523 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356Ab0LATFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:05:10 -0500
Date: Wed, 1 Dec 2010 19:04:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Kconfig: add new symbol MIGHT_HAVE_PCI
Message-ID: <20101201190429.GC29347@n2100.arm.linux.org.uk>
References: <1291217412-9435-1-git-send-email-ulli.kroll@googlemail.com> <20101201185103.GK32355@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101201185103.GK32355@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 07:51:03PM +0100, Uwe Kleine-König wrote:
> On Wed, Dec 01, 2010 at 04:30:12PM +0100, Hans Ulli Kroll wrote:
> > Today more boards with arm cpu have selectable pci bus.
> > This patch makes this more scalable and remove line continuations in
> > Kconfig
> > 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
> > ---
> >  arch/arm/Kconfig                 |    7 ++++++-
> >  arch/arm/mach-cns3xxx/Kconfig    |    1 +
> >  arch/arm/mach-integrator/Kconfig |    1 +
> >  arch/arm/mach-ks8695/Kconfig     |    1 +
> >  arch/arm/mach-pxa/Kconfig        |    1 +
> >  arch/arm/mach-versatile/Kconfig  |    1 +
> >  6 files changed, 11 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index a19a526..614cf2f 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -34,6 +34,9 @@ config ARM
> >  config HAVE_PWM
> >  	bool
> >  
> > +config MIGHT_HAVE_PCI
> HAVE_PCI or HAS_PCI is a more usual name for this purpose.

This has been discussed in the thread "[PATCH] ARM: Gemini: Add support
for PCI Bus".
