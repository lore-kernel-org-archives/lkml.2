Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966503Ab2EOTJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:09:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61534 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966455Ab2EOTJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:09:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 03/03] ARM: Undelete KZM9D mach-type
Date: Tue, 15 May 2012 19:09:47 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        horms@verge.net.au, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        rjw@sisk.pl, lethal@linux-sh.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
References: <20120514105424.8596.38355.sendpatchset@w520> <201205150832.10069.arnd@arndb.de> <20120515175609.04A4D3E080A@localhost>
In-Reply-To: <20120515175609.04A4D3E080A@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205151909.47381.arnd@arndb.de>
X-Provags-ID: V02:K0:mft/ow2QqtwcB2L5hJWnD5ar4QhEN239W0r0PUWj4Y0
 lnWGZbRNmBYO1ZatBAkCDNWTkAMmkjD3vU5fmh6SnLCBqVRsCO
 Dr1yz4CJWQ1JPg510fL9gX9I6RUQeG5fjqT38bYd3KoXKGNSiE
 XRjtcSFbVILUFDrD+UvfUrd8YI2vQ/a9M7YXHOIkgv/h5yQuIb
 lPDyPo23oHgie9tHQ3sW8JH+T/tU2oXEiJe8bo2FMvrvW5lvcm
 qKUnqhBbaKVAZrT+xjeUjDx7jGsTs4fTvXAcSSidLgAeGd7E4W
 82Rdwa1dhfvafLTMb/CKo/LQON5xaPSa1VFRbzXUL4JdmCGWLQ
 vU0RHlCzZZ+JKOgWqGdg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2012, Grant Likely wrote:
> On Tue, 15 May 2012 08:32:09 +0000, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 14 May 2012, Magnus Damm wrote:
> > > Right, I agree. Relying on a fixed DTB in an unreliable boot loader is
> > > the last thing I want to do.
> > > 
> > > So if your boot loader can't pass DTB to the kernel, and you want to
> > > have a single kernel supporting multiple boards, then do you see
> > > anything wrong with based on mach-type do a run time decision (in
> > > arch/arm/boot/compressed/) to override the ATAG from the boot loader
> > > with a compiled-in per-board DTB?
> > 
> > I know that we have discussed this in the past, but I don't remember
> > the outcome of the discussion, maybe someone else can help out here
> > (Grant?)
> > 
> > It's definitely technically possible to do it, but it could either be
> > that nobody has bothered to do the implementation, or that we had good
> > reasons against it and decided not to allow this.
> 
> Tony and I talked about this quite a bit during the last Connect.  The
> plan is to extend the existing bootwrapper ATAGs to DT code to allow
> appending multiple .dtbs to the zImage and selecting the correct one
> based on the machine number.  It shouldn't be very complicated, but I
> haven't had time to implement it.

Ok, good. so you are both on the same page then, Grant and Magnus.
I suppose you just need to coordinate then who is doing the work,
and it seems that Magnus is eager to prototype this.

	Arnd
