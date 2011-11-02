Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab1KBQYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:24:32 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1625 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab1KBQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:24:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 02 Nov 2011 09:24:21 -0700
Date: Wed, 2 Nov 2011 18:24:18 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 8/8] arm/tegra: add support for tegra30 based board
 cardhu
Message-ID: <20111102162418.GN13358@tbergstrom-lnx.Nvidia.com>
References: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com>
 <1320242948-21061-9-git-send-email-pdeschrijver@nvidia.com>
 <20111102154610.GJ13358@tbergstrom-lnx.Nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173F9A46C4@HQMAIL01.nvidia.com>
 <20111102161919.GM13358@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111102161919.GM13358@tbergstrom-lnx.Nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 05:19:19PM +0100, Peter De Schrijver wrote:
> On Wed, Nov 02, 2011 at 05:07:52PM +0100, Stephen Warren wrote:
> > Peter De Schrijver wrote at Wednesday, November 02, 2011 9:46 AM:
> > > On Wed, Nov 02, 2011 at 03:09:07PM +0100, Peter De Schrijver wrote:
> > > > Add support for the tegra30 based cardhu development board. Cardhu is a tablet
> > > > formfactor reference design for tegra30. The patch provides a device tree for
> > > > the board, updates Makefile.boot to build the dtb, includes the platform in
> > > > Kconfig and updates board-dt.c.
> > ...
> > > > diff --git a/arch/arm/boot/dts/tegra-cardhu.dts b/arch/arm/boot/dts/tegra-cardhu.dts
> > > > new file mode 100644
> > > > index 0000000..70c41fc
> > > > --- /dev/null
> > > > +++ b/arch/arm/boot/dts/tegra-cardhu.dts
> > > > @@ -0,0 +1,36 @@
> > > > +/dts-v1/;
> > > > +
> > > > +/include/ "tegra30.dtsi"
> > > > +
> > > > +/ {
> > > > +	model = "NVIDIA Tegra30 Cardhu evaluation board";
> > > 
> > > And this should probably be removed.
> > 
> > I don't follow the reasoning here; it seems correct to identify what this
> > .dts file applies to, and having a model property is consistent with other
> > .dts files, including non-Tegra boards.
> 
> hmm :) Based on your comments on the previous version, I thought you wanted
> to move this do a different patch which also does it for other boards.
> 

Ok. The comment was related to device_type = "memory"; in the same patch.
Sorry for the confusion.

Cheers,

Peter.
