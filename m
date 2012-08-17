Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab2HQLk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 07:40:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54517 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977Ab2HQLkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 07:40:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: dedekind1@gmail.com
Subject: Re: [PATCH] ARM: LPC32xx: Provide DMA filter callbacks via platform data
Date: Fri, 17 Aug 2012 11:40:50 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Roland Stigge <stigge@antcom.de>, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org
References: <1345122935-22115-1-git-send-email-stigge@antcom.de> <1345201311.27859.51.camel@sauron.fi.intel.com> <1345201835.27859.52.camel@sauron.fi.intel.com>
In-Reply-To: <1345201835.27859.52.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208171140.50388.arnd@arndb.de>
X-Provags-ID: V02:K0:xRDyaWLwyfZeFDd5nLl5MJHnZyltSnUU/QJO30GAyAV
 4QT2NgYpskeJqr/7XIkVqMNE1X6URODy4EQzr7zOf4jgpeodBl
 q5RCsD/Az6yIXb80doijwx9VsBdTF69Baa0njiH1JUVnKKydsr
 fEPP3wWkXqqqN3J4uoJEQh8Io4VU0296K2oSbgLwe2lZekSFGR
 i9AMCBW4ZSeT/17nCKAb2vdVDx6qDMYWlhZpjKeA8Ys+tfJIg2
 1xStxshbcqk+TkvqEvGWQaBVomkuubCrNuWoHfr9xEJRLWqnfx
 1+63Yf+EXhTSA9hMVLGxP4WYs4JUR0KRQ8haT2HpncI+dH6ZI6
 TdasZJY7CbIhmy8tehpo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2012, Artem Bityutskiy wrote:
>   Show Details
>   On Fri, 2012-08-17 at 14:01 +0300, Artem Bityutskiy wrote:
> > > To later avoid collisions on subsystem merge, can you please leave the
> > > patch with arch/arm/mach-lpc32xx/phy3250.c for arm-soc.git? (I will
> > > provide a pull request for Arnd and Olof, as usual.)
> > 
> > Only if Arnd insists. Otherwise I'd prefer to resolve collisions (they
> > cannot be hard with this patch) than pulling the soc tree to the mtd
> > tree.
> 
> Actually the mtd patches do not compile-depend on it, sorry, I am
> dropping it from the MTD tree. Thanks!

For reference, I'm fine with either outcome, I don't mind seeing an
occasional collision with subsystem trees, as they tend to be trivial
to resolve.

If you split a series to go through multiple git trees, you have to
ensure that both halves are actually regression free by themselves,
which typically ends up being much harder than fixing a small merge
conflict.

	Arnd
