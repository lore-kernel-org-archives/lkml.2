Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab2CKVhH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 17:37:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2CKVg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 17:36:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v2 1/2] ARM: AT91: Add parameter for AT91_HAS_PATA
Date: Sun, 11 Mar 2012 21:36:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Alan Ott <alan@signal11.us>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
References: <1331415380-10928-1-git-send-email-alan@signal11.us> <1331415531-10961-1-git-send-email-alan@signal11.us> <20120311183856.GA13869@game.jcrosoft.org>
In-Reply-To: <20120311183856.GA13869@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203112136.47694.arnd@arndb.de>
X-Provags-ID: V02:K0:H4lP8zfTbyvV9aEMrnfOeq/dCvyR3UHQlBJJxbp1QBH
 gfoIHl4edHuR9DMhqHx34tjH4rh7QGjJDF71Mq3TJ3shjzjtl1
 O+Jc15WZ+D/qZMRYEgDzhoMmd4Oo3mhlA5xWjB+MJGkeKIPHxp
 pzed0UVgcCFDPjvycjG9aWBYhvTnCwvsZcE2GwAsSAViQRMEai
 hwU3CZS8QVGuIUuNJzuuARVFFSzZkodIHGtMgL/fzTn39K6asP
 W3LnGD37YVb4Cl/v8Z3h0ps8e3fTSOxxtAUlVMCwbbCiokvvcI
 I7BWBIeStQr7/LzZKQboJJXtFe7yCWY/Op5haKYHq0sSKmVG5h
 8EOwSyp5pPt3BBx3ECHk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > 
> > diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> > index 71feb00..9eeeabe 100644
> > --- a/arch/arm/mach-at91/Kconfig
> > +++ b/arch/arm/mach-at91/Kconfig
> > @@ -24,6 +24,9 @@ config AT91_SAM9_ALT_RESET
> >  config AT91_SAM9G45_RESET
> >       bool
> >  
> > +config AT91_HAS_PATA
> > +     bool
> what is the need for this?
> 
> As we switch to DT, I don't want to track the soc list in the Kconfig anymore
> if the soc support the PATA will be describe in the DT
> 

When I originally wrote the patch, I was hitting build errors when trying
to enable the at91 pata driver on socs that don't have the right declarations
in their headers. If that has been resolved in a better way already, this
patch can be dropped.

	Arnd
