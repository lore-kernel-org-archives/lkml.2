Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1LILT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:19:56 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5054 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab1LILTy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:19:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 09 Dec 2011 03:19:29 -0800
Date: Fri, 9 Dec 2011 13:19:26 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Colin Cross <ccross@android.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        "Olof Johansson" <olof@lixom.net>, Gary King <gking@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v6 04/10] arm/tegra: prepare early init for multiple
 tegra variants
Message-ID: <20111209111925.GK27578@tbergstrom-lnx.Nvidia.com>
References: <1323348254-29072-1-git-send-email-pdeschrijver@nvidia.com>
 <1323348254-29072-5-git-send-email-pdeschrijver@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1750B77A7E@HQMAIL01.nvidia.com>
 <CAMbhsRTD1rQBY7Sn2km=XsUYsHMdqQqZSKu4agc0GB6+QE79fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAMbhsRTD1rQBY7Sn2km=XsUYsHMdqQqZSKu4agc0GB6+QE79fA@mail.gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 07:29:43PM +0100, Colin Cross wrote:
> On Thu, Dec 8, 2011 at 9:57 AM, Stephen Warren <swarren@nvidia.com> wrote:
> > Peter De Schrijver wrote at Thursday, December 08, 2011 5:44 AM:
> >> This patch splits the early init code in a common and a tegra20 specific part.
> >> L2 cache initialization is generalized and discovers the cache associativity
> >> at runtime. Also use arm_pm_restart instead of arm_arch_reset and reset the
> >> the system using the PMC reset feature rather then the CAR system reset.
> >
> > This one really should be at least 3 separate patches:
> > * s/tegra_init_early/tegra20_init_early/ in machine descriptions
> > * Switch reset mechanism from CAR to PMC
> > * tegra_init_cache modifications
> > * Not sure if all the ifdef additions go in the above, or if some should be
> >  separate?
> >
> > Still, I think it's probably OK to go in as it is even if it isn't optimal.
> 
> Please at least split out the reset change.  Does using the PMC reset
> instead of the CAR reset still result in a warm reset, or does it
> change to a cold reset?

What do you consider a cold reset in the tegra world?

Cheers,

Peter.
