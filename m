Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137Ab2EIJat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:30:49 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:50740 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758882Ab2EIJar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:30:47 -0400
Date: Wed, 9 May 2012 10:41:02 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linus.walleij@linaro.org
Cc: broonie@opensource.wolfsonmicro.com, swarren@wwwdotorg.org,
        sameo@linux.intel.com, linux-embedded@vger.kernel.org,
        linux-kernel@vger.kernel.org, grinberg@compulab.co.il, olof@lixom.net,
        arnd@ardb.de, linux-arm-kernel@lists.infradead.org
Subject: Re: Handling of modular boards
Message-ID: <20120509084102.GA16228@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <CACRpkdbyp=BNGn8Eub6vcAgB9CS5PhYcGt2foi8kNxA3oU5Fzg@mail.gmail.com>
References: <CACRpkdbyp=BNGn8Eub6vcAgB9CS5PhYcGt2foi8kNxA3oU5Fzg@mail.gmail.com>
  <20120504185850.GO14230@opensource.wolfsonmicro.com>
  <4FA432E9.9050606@wwwdotorg.org>
  <20120504204455.GR14230@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

>> This is another issue - a similar set of problems does apply to some PCI
>> type cards where the PCI device is essentially a bridge to a typical
>> embedded system - though practically speaking it's much less severe.
> 
> I think Alessandro is working on a board like that right now, so looping
> in Ale to this discussion to get his attention...

> I think Alessandro is working on a board like that right now, so looping
> in Ale to this discussion to get his attention...

Yes, that's it. The vendor of my thing has wrapped everything under
pci headers, so the "typical embedded system", which actually is a
demasculated ARM SoC is self-described by PCI (no need for device tree)

A previous poster said:
>>> b) Doesn't integrate well with hotplug; the DT for the board
>>> configuration is static at boot. What if a board can be unplugged and
>>> another plugged in; a reboot or similar would be needed to adjust the
>>> kernel to this.

I think you need some enumeration mechanism in this case. Actually, I
think this will become common in the near future, as you can reprogram
your FPGA devices while the system runs.

The issue is real, and I'm involved in a self-description project; it
allows to use the well-known bus abstraction (with bus controller,
devices, drivers) to ease handling soft cores that may come and go
while the system is alive.

Thank you Linus for involving me, I'll now go to read the whole thread
/alessandro
