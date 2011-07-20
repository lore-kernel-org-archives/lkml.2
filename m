Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab1GTSsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:48:00 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41981 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab1GTSr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:47:59 -0400
Date: Wed, 20 Jul 2011 12:47:58 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Erik Gilling <konkers@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arm/dt: tegra devicetree support
Message-ID: <20110720184758.GG4642@ponder.secretlab.ca>
References: <20110719234158.2779.15394.stgit@ponder>
 <74CDBE0F657A3D45AFBB94109FB122FF049EBDEE27@HQMAIL01.nvidia.com>
 <20110720160355.GB2406@sirena.org.uk>
 <20110720183133.GE4642@ponder.secretlab.ca>
 <74CDBE0F657A3D45AFBB94109FB122FF049EBDEF01@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049EBDEF01@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 11:40:28AM -0700, Stephen Warren wrote:
> Grant Likely wrote at Wednesday, July 20, 2011 12:32 PM:
> > The compatible property here definitely represents the hardware
> > because it reflects the sound infrastructure on the harmony board.
> 
> I can see that argument for "nvidia,harmony-sound".
> 
> But "nvidia,tegra-wm8903" is pretty generic; I can certainly see there
> being Tegra 20 systems that use a WM8903 but are so different from either
> Harmony or anything supported by sound/soc/tegra/tegra_wm8903.c that the
> existing driver isn't applicable. And hence, there may be a different
> ASoC driver for such board(s), and hence choosing such a generic name as
> "tegra-wm8903" for Harmony/Seaboard's audio layout seems like it might
> cause problems in the future.
> 
> I'm fine with such a generic name for the platform driver, since that name
> can fairly easily be modified just by editing the driver and the board file.
> But since *.dts files are at least logically separate from the kernel, such
> naming future-proofing is a little more important.

Sure, the tegra-wm8903 property can be dropped.  If we start to see a
really well established pattern of the tegra paired with a wm8903,
then at that point we can define a compatible property for it and
document exactly what it means (document the boundaries and
assumptions that the compatible value requires).

g.
