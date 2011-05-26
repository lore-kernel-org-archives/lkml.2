Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405Ab1EZVyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:54:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35311 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab1EZVyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:54:18 -0400
Date: Thu, 26 May 2011 22:53:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
        spi mailing list <spi-devel-general@lists.sourceforge.net>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/5] dmaengine: add ep93xx DMA support
Message-ID: <20110526215349.GM24876@n2100.arm.linux.org.uk>
References: <cover.1306082097.git.mika.westerberg@iki.fi> <e6777eb9f7228ee1dadec1f0c9f16c3afc44c307.1306082097.git.mika.westerberg@iki.fi> <BANLkTi=3z3kO5VEe2up8Mfm+bNXkY3baUw@mail.gmail.com> <20110525195413.GC2996@acer> <BANLkTin8Trn-44Op+GbxrgocFrnPuXUZ2w@mail.gmail.com> <20110526043344.GA2749@acer> <BANLkTikzrXRmdnv_v_nmJw7Nvsr6TY-5RQ@mail.gmail.com> <20110526183800.GE2957@acer> <0D753D10438DA54287A00B027084269764D3319EC4@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B027084269764D3319EC4@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 01:48:12PM -0500, H Hartley Sweeten wrote:
> I think the biggest hurdle with using the amba-pl022 driver is that the ep93xx
> spi peripheral does not have the registers with the pid and cid id's.  Without
> those I don't think the amba bus driver will be able to match the device to
> the driver.

I've just committed Linus' patches to allow a provided ID to override
what the bus code finds.
