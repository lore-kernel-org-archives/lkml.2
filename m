Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab1GSW7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:59:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54027 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1GSW7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:59:22 -0400
Date: Tue, 19 Jul 2011 16:59:19 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Warren <swarren@nvidia.com>
Cc: Andrew Chew <AChew@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        Dan Willemsen <dwillemsen@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@vger.kernel.org" <linux-arm-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] usb: tegra20-ehci: Add devicetree support.
Message-ID: <20110719225919.GW6848@ponder.secretlab.ca>
References: <1311115617-9697-1-git-send-email-achew@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF049EBDED24@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049EBDED24@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 03:56:29PM -0700, Stephen Warren wrote:
> achew@nvidia.com wrote at Tuesday, July 19, 2011 4:47 PM:
> > From: Andrew Chew <achew@nvidia.com>
> > 
> > Add code to try to get platform data information (register base, irq,
> > modes, various tuning parameters) from device tree, if not present in board
> > files.
> > 
> > Signed-off-by: Andrew Chew <achew@nvidia.com>
> > ---
> >  .../devicetree/bindings/usb/tegra20-ehci.txt       |   27 +++
> >  arch/arm/mach-tegra/include/mach/usb_phy.h         |    2 +-
> >  drivers/usb/host/ehci-tegra.c                      |  197 +++++++++++++++++++-
> >  3 files changed, 219 insertions(+), 7 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/usb/tegra20-ehci.txt
> 
> I sent a variety of comments on this patch internally to Andrew, but the
> email crossed paths with the posting to the public mailing lists. I won't
> bother repeating those comments here, but I assume they'll be addressed
> in a new version of this patch.

Okay, I'll wait for the next version then.

g.

