Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab1KRMDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 07:03:33 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10324 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab1KRMDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 07:03:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 18 Nov 2011 04:03:13 -0800
Date: Fri, 18 Nov 2011 14:03:09 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Marc Dietrich <marvin24@gmx.de>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] arm/tegra: convert tegra20 to GIC devicetree binding
Message-ID: <20111118120309.GY19069@tbergstrom-lnx.Nvidia.com>
References: <1321542430-17971-1-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74C1E@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740D74C1E@HQMAIL01.nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 07:51:35PM +0100, Stephen Warren wrote:
> Peter De Schrijver wrote at Thursday, November 17, 2011 8:07 AM:
> > Convert tegra20 IRQ intialization to the GIC devicetree binding. Modify the
> > interrupt definitions in the dts files according to
> > Documentation/devicetree/bindings/arm/gic.txt
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> tegra-harmony.dts contains an interrupts property that wasn't updated,
> for the WM8903 codec.
> 
> board-dt.c contains logic to search for a node with compatible of
> nvidia,tegra20-gic, and then call irq_domain_add_simple. I assume that
> logic is replaced by the new common GIC code, and so should be removed
> from board-dt.c entirely?
> 
> >  	serial@70006000 {
> >  		compatible = "nvidia,tegra20-uart";
> > -		reg = <0x70006000 0x40>;
> > +		reg = <0x70006000 0x040>;
> 
> Here and a few other places, why change the reg property?

Oops. That was probably an overly agressive search and replace :)

Cheers,

Peter.
