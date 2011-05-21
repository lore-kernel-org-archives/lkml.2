Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab1EUXr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 19:47:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58018 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab1EUXry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 19:47:54 -0400
Date: Sun, 22 May 2011 00:47:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
        Kevin Hilman <khilman@ti.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] drivers/amba: probe via device tree
Message-ID: <20110521234725.GB17672@n2100.arm.linux.org.uk>
References: <1305829704-11774-1-git-send-email-robherring2@gmail.com> <20110519233958.GB18181@ponder.secretlab.ca> <4DD66B8A.5040404@gmail.com> <201105201621.03801.arnd@arndb.de> <4DD68614.6090209@gmail.com> <a42f0c27-2811-4b68-bedf-7dfaa7bff6ff@VA3EHSMHS025.ehs.local> <BANLkTi=8vX1Cs_fzpQXZBuuDuLYLu1FGmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=8vX1Cs_fzpQXZBuuDuLYLu1FGmg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 11:42:34AM -0600, Grant Likely wrote:
> Russell, it seems to me that the primary behaviour that amba_bus has
> over platform_bus is the clock management, and secondarily
> verification of the type of device by the device id.  Am I correct, or
> am I missing something?

It matches by vendor/device ID just like PCI does, and does the bus
clock management and power management in a really nice way, which I
doubt platform devices will ever do.

The way this discussion is going, I'm going to suggest that we also
convert PCI stuff to being platform devices too.  I don't see the
point of PCI existing for all the same reasons being given in this
thread.
