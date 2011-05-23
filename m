Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab1EWJ66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:58:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59702 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1EWJ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:58:54 -0400
Date: Mon, 23 May 2011 10:58:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kristoffer Glembo <kristoffer@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Kevin Hilman <khilman@ti.com>,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] drivers/amba: probe via device tree
Message-ID: <20110523095829.GG17672@n2100.arm.linux.org.uk>
References: <1305829704-11774-1-git-send-email-robherring2@gmail.com> <20110519233958.GB18181@ponder.secretlab.ca> <4DD66B8A.5040404@gmail.com> <201105201621.03801.arnd@arndb.de> <4DD68614.6090209@gmail.com> <a42f0c27-2811-4b68-bedf-7dfaa7bff6ff@VA3EHSMHS025.ehs.local> <BANLkTi=8vX1Cs_fzpQXZBuuDuLYLu1FGmg@mail.gmail.com> <4DDA2AC0.1060406@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDA2AC0.1060406@gaisler.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 11:37:04AM +0200, Kristoffer Glembo wrote:
> Grant Likely wrote:
> > In the case we're talking about the bus really is an AMBA bus, and all
> > the devices on it are in some sense real amba devices.  The problem is
> > that not all of the devices on the bus implement peripheral ID
> > registers or other mechanisms that good upstanding AMBA devices are
> > expected to have.  
> 
> Before we go hardware bashing of non primecell AMBA devices I would just
> want to point out that the primecell stuff is not part of the AMBA
> specification.

And before we go down that route, let me point out that the 'amba bus'
stuff in the kernel is there to support primecells, rather than all
devices which the AMBA specification covers.

The reason it's called 'amba' is because back in 2001 or so when the
first primecell drivers were created, there was little information
available as to what AMBA, AHB, or APB even covered.  All I had to go
on were the primecell documents themselves.  The higher level documents
were not available to me.

So, despite it being called 'amba', it really is just for primecells
and if we didn't have the exposure to userspace, I'd have renamed it to
'apb' or similar instead.
