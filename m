Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab1EVKAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 06:00:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45493 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab1EVKAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 06:00:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/2] drivers/amba: probe via device tree
Date: Sun, 22 May 2011 12:00:46 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
        Kevin Hilman <khilman@ti.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
References: <1305829704-11774-1-git-send-email-robherring2@gmail.com> <BANLkTi=8vX1Cs_fzpQXZBuuDuLYLu1FGmg@mail.gmail.com> <20110521234725.GB17672@n2100.arm.linux.org.uk>
In-Reply-To: <20110521234725.GB17672@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105221200.46810.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 22, 2011, Russell King - ARM Linux wrote:
> On Sat, May 21, 2011 at 11:42:34AM -0600, Grant Likely wrote:
> > Russell, it seems to me that the primary behaviour that amba_bus has
> > over platform_bus is the clock management, and secondarily
> > verification of the type of device by the device id.  Am I correct, or
> > am I missing something?
> 
> It matches by vendor/device ID just like PCI does, and does the bus
> clock management and power management in a really nice way, which I
> doubt platform devices will ever do.

Then we should use the AMBA bus where possible.  Also, if there are
AMBA devices that currently pretend to be platform devices, they should be
converted back to AMBA.

> The way this discussion is going, I'm going to suggest that we also
> convert PCI stuff to being platform devices too.  I don't see the
> point of PCI existing for all the same reasons being given in this
> thread.

I agree.

Thanks,
Rafael
