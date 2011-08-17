Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab1HQLoC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 07:44:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51199 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1HQLn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 07:43:59 -0400
Date: Wed, 17 Aug 2011 12:43:55 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [RFC PATCH v2 06/13] docs/dt: Document nvidia,tegra20-pinmux
 binding
Message-ID: <20110817114355.GC2909@pulham.picochip.com>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com>
 <201108161551.31389.arnd@arndb.de>
 <74CDBE0F657A3D45AFBB94109FB122FF04AEA2537D@HQMAIL01.nvidia.com>
 <201108171337.26166.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108171337.26166.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wed, Aug 17, 2011 at 01:37:25PM +0200, Arnd Bergmann wrote:
> The split I had in mind is more to the effect that the .dtsi file
> describes the set of pins that is there with their names and addresses,
> while the board specific file describes how they are set up. Does that
> make sense? I think I'm still missing some essential aspect of what the
> pinmux code actually does ;-)
> 
> I now saw that you have the full description in the
> arch/arm/mach-tegra/pinmux-t2-tables.c and arch/arm/mach-tegra/pinmux.c
> files, with all the names again, and apparently your patch set leaves
> these around. Do you think it's possible to actually move the static
> tables from there into the device tree and do the entire setup based
> on that?

The platform I'm working on has a different method of muxing for almost 
every pin (some aren't even memory mapped registers) so defining the SoC 
pin definitions in the DTS could result in some pretty horrible 
bindings.

Stephens bindings for configuring the muxing of the pins works quite 
nicely for our platform though, and I'm just about to post patches that 
abstract the tegra specific bits out.

Jamie
