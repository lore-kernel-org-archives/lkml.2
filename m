Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966Ab1JGMat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 08:30:49 -0400
Received: from d1.icnet.pl ([212.160.220.21]:54865 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab1JGMar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 08:30:47 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH 3.1-rc3] gpio/omap: fix build error with certain OMAP1 configs
Date: Fri, 7 Oct 2011 14:30:14 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
References: <201108231342.25101.jkrzyszt@tis.icnet.pl> <87sjoshx2k.fsf@ti.com>
In-Reply-To: <87sjoshx2k.fsf@ti.com>
MIME-Version: 1.0
Message-Id: <201110071430.14420.jkrzyszt@tis.icnet.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia wtorek, 23 sierpnia 2011 o 19:11:47 Kevin Hilman napisał(a):
> Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> writes:
> 
> > With commit f64ad1a0e21a, "gpio/omap: cleanup _set_gpio_wakeup(), remove 
> > ifdefs", access to build time conditionally omitted 'suspend_wakeup' 
> > member of the 'gpio_bank' structure has been placed unconditionally in 
> > function _set_gpio_wakeup(), which is always built. This resulted in the 
> > driver compilation broken for certain OMAP1, i.e., non-OMAP16xx, 
> > configurations.
> >
> > Really required or not in previously excluded cases, define this 
> > structure member unconditionally as a fix.
> >
> > Tested with a custom OMAP1510 only configuration.
> >
> > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> 
> Verified that this fixes a build problem when building for OMAP1
> (730/850 only)
> 
> Acked-by: Kevin Hilman <khilman@ti.com>
> 
> Grant, can you queue this as a fix for 3.1-rc?

Hi,
Sorry for being so late with checking this, but it looks like this patch 
never got into 3.1-rc, as it should, leaving the issue not fixed.
Any chance for it still being pushed into 3.1?

Thanks,
Janusz
