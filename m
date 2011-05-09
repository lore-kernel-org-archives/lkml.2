Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1EIM3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 08:29:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37699 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752352Ab1EIM3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 08:29:39 -0400
Date: Mon, 9 May 2011 14:29:41 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Liam Girdwood <lrg@kernel.org>, Graeme Gregory <gg@slimlogic.co.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [PATCH 4/4] USB: TWL6025 allow different regulator name
Message-ID: <20110509122941.GA3225@opensource.wolfsonmicro.com>
References: <1303897191-14792-1-git-send-email-gg@slimlogic.co.uk>
 <1303897191-14792-5-git-send-email-gg@slimlogic.co.uk>
 <20110427104542.GZ13227@legolas.emea.dhcp.ti.com>
 <1304867317.3246.10.camel@odin>
 <20110509090335.GC1254@legolas.emea.dhcp.ti.com>
 <1304941430.3192.4.camel@odin>
 <20110509121600.GK1254@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110509121600.GK1254@legolas.emea.dhcp.ti.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 03:16:03PM +0300, Felipe Balbi wrote:
> On Mon, May 09, 2011 at 12:43:49PM +0100, Liam Girdwood wrote:

> > I think it's the lesser evil though, especially for device integrators.
> > They will just match the regulator name from the schematics together
> > with the TRM name when creating their regulator constraints and having
> > different names here will definitely cause confusion.

> Any chance Device Tree could be used to pass that data to kernel
> instead, together with regulator names and all needed data for each one
> of them ?

I'm pretty sure that as soon as we have viable device tree support for
relevant platforms in mainline we'll have regulator support, though I'm
not sure that this will help too much with the naming as you'll still
have to figure out what the consumer requests.  We shouldn't be passing
in the consumer supply names from device tree (at least not a board
specific one) as this breaks the model that the supply names correspond
to the chip pins.
