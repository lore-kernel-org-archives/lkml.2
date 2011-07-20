Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab1GTQED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 12:04:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35955 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab1GTQEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 12:04:01 -0400
Date: Wed, 20 Jul 2011 17:03:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Erik Gilling <konkers@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arm/dt: tegra devicetree support
Message-ID: <20110720160355.GB2406@sirena.org.uk>
References: <20110719234158.2779.15394.stgit@ponder>
 <74CDBE0F657A3D45AFBB94109FB122FF049EBDEE27@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049EBDEE27@HQMAIL01.nvidia.com>
X-Cookie: Formatted to fit your screen.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 08:37:19AM -0700, Stephen Warren wrote:
> Grant Likely wrote at Tuesday, July 19, 2011 5:43 PM:

> > +	sound {
> > +		compatible = "nvidia,harmony-sound", "nvidia,tegra-wm8903";

> I thought the sound bindings were still somewhat experimental and not
> completely agreed upon. One issue I see is that Device Tree is
> supposed to represent pure HW, rather than driver-required abstractions,
> and at least the compatible name here is pretty Linux-driver-specific.

The current decision is that the schematic for embedded audio hardware
is sufficiently interesting to be considered hardware in its own right
separately to the chips contained within it.  

> > +		spkr-en-gpios = <&codec 2 0>;

> Should that be "gpio" not "gpios", since there is only one?

There's only one in this board but one does see designs with separate
left and right channel enables sometimes, or separate front and back
speaker enables for phones.
