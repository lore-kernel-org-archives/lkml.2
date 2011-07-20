Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1GTShF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:37:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63414 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab1GTShE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:37:04 -0400
Date: Wed, 20 Jul 2011 12:31:33 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Warren <swarren@nvidia.com>, Erik Gilling <konkers@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arm/dt: tegra devicetree support
Message-ID: <20110720183133.GE4642@ponder.secretlab.ca>
References: <20110719234158.2779.15394.stgit@ponder>
 <74CDBE0F657A3D45AFBB94109FB122FF049EBDEE27@HQMAIL01.nvidia.com>
 <20110720160355.GB2406@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720160355.GB2406@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 05:03:55PM +0100, Mark Brown wrote:
> On Wed, Jul 20, 2011 at 08:37:19AM -0700, Stephen Warren wrote:
> > Grant Likely wrote at Tuesday, July 19, 2011 5:43 PM:
> 
> > > +	sound {
> > > +		compatible = "nvidia,harmony-sound", "nvidia,tegra-wm8903";
> 
> > I thought the sound bindings were still somewhat experimental and not
> > completely agreed upon. One issue I see is that Device Tree is
> > supposed to represent pure HW, rather than driver-required abstractions,
> > and at least the compatible name here is pretty Linux-driver-specific.
> 
> The current decision is that the schematic for embedded audio hardware
> is sufficiently interesting to be considered hardware in its own right
> separately to the chips contained within it.

Correct.  For complex composite devices like audio, it is completely
appropriate to have a root node that represents the entire complex and
how it is wired together.

The compatible property here definitely represents the hardware
because it reflects the sound infrastructure on the harmony board.

g.
