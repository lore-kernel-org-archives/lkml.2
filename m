Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab2EJLO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 07:14:56 -0400
Received: from trinity.fluff.org ([89.16.178.74]:39328 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab2EJLOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 07:14:17 -0400
Date: Thu, 10 May 2012 11:41:36 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Wolfgang Denk <wd@denx.de>, linux-embedded@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Igor Grinberg <grinberg@compulab.co.il>,
        Olof Johansson <olof@lixom.net>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@ardb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: Handling of modular boards
Message-ID: <20120510104136.GA30103@trinity.fluff.org>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com>
 <201205041934.08830.arnd@arndb.de>
 <20120504203357.6B79B206451@gemini.denx.de>
 <20120504220944.GT14230@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120504220944.GT14230@opensource.wolfsonmicro.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 11:09:45PM +0100, Mark Brown wrote:
> On Fri, May 04, 2012 at 10:33:57PM +0200, Wolfgang Denk wrote:
> 
> > On the other hand, some of the issues we're trying to solve here
> > for the kernel are also present in the boot loader, so this needs to
> > do this anyway - whether by inserting new or modifying (enabling or
> > disabling) existing properties in the DT is not really relevant here.
> 
> FWIW if the bootloader can usefully handle this stuff I think that's a
> good approach but there is substantial variation in quality of
> implementation between bootloaders and even when the bootloader is a
> good one it's not always practical to update it or the data it relies
> on.

I agree, the list of devices should be in the device-tree handed to
whatever OS is being booted. It isn't a Linux specific problem that
we're looking at here.

Any operating system, pre-OS test suite, etc. is going going to need
this information, and in my view the bootloader should be doing whatever
is needed to create a device-tree to passed through to the next loaded
system.

Also, having the information available to $bootloader means the user
can verify the presence of the peripherals before the OS is loaded.

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

