Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323Ab1JDT3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:29:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64922 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab1JDT3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:29:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Tony Lindgren <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 26/30] ARM: omap: add board autoselection
Date: Tue, 04 Oct 2011 21:29:36 +0200
Message-ID: <2340307.S2RzXdHlIz@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20111004155752.GT6324@atomide.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <201110040944.13205.arnd@arndb.de> <20111004155752.GT6324@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1nJaxU3iPYit9zyZv8AHLuioqM7O8zG4FcfaNqT8uxI
 LzjPQLSxrvXCnl7kYLZB+PWnUe35I/QFVnEwTBzxSPb19m5uSw
 AW2fDP4sl+60uQbdNZViLgua4OntskZsaUz9PoqEu2awxRIzDB
 Y1bxAAdbnlKNNDVMz1hRTtj9yYuJswCClPXpPC28aQXiYXLkvK
 niDzdlCaeR2ig5nLXHLGtULjUXDLcbY12yt3n/bcZyHVbbXhv7
 7ll+WsXVE+Tfg+wBQyvggMdv2YdopQoeUGRlDPzXovjLYENmGf
 V7VuBoLxAqlbVCfD75abTHO+aUuVD9qrWGE1usuFvwZqIwOXQP
 onL48+0AeHEht8zCoY3Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 October 2011 08:57:52 Tony Lindgren wrote:
> * Arnd Bergmann <arnd@arndb.de> [111004 00:10]:
> > On Monday 03 October 2011, Tony Lindgren wrote:
> >
> > > Yes please leave out the list so we don't need to constantly update it.
> > > Let's just always build in MACH_OMAP_GENERIC.
> > 
> > That's what I had initially, but now that board file has become
> > omap2-specific and no longer works on omap3-only or omap4-only
> > configurations.
> 
> Will send a pull request for basic DT bootstrap support from Benoit
> that fixes that. So maybe let's sort that out first, then always
> select it?

Yes, sounds good. That is certainly the better solution in the long run.

	Arnd
