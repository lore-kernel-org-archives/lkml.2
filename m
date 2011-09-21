Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1IUU3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:29:20 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13240 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1IUU3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:29:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 21 Sep 2011 13:29:05 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Olof Johansson <olof@lixom.net>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>,
        Grant Likely <grant.likely@secretlab.ca>, Chris Ball <cjb@laptop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Date: Wed, 21 Sep 2011 13:29:03 -0700
Subject: RE: [PATCH 3/3] arm/tegra: Move "gpio-names.h" into
 <mach/gpio-tegra.h>
Thread-Topic: [PATCH 3/3] arm/tegra: Move "gpio-names.h" into
 <mach/gpio-tegra.h>
Thread-Index: Acx4mxfbt+R3FbVyROaUp3LQ0HMWgAAAad4w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173818019E@HQMAIL01.nvidia.com>
References: <1316633620-13184-1-git-send-email-swarren@nvidia.com>
	<1316633620-13184-3-git-send-email-swarren@nvidia.com>
 <CAOesGMhdkrtjvXWHhbLSj804s+CzTthn_hrGafp5K=Va5MTZ=w@mail.gmail.com>
In-Reply-To: <CAOesGMhdkrtjvXWHhbLSj804s+CzTthn_hrGafp5K=Va5MTZ=w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote at Wednesday, September 21, 2011 2:15 PM:
> On Wed, Sep 21, 2011 at 12:33 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > This centralizes all SoC-level GPIO-related definitions into a single
> > header file.
> >
> > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> >
> >  arch/arm/mach-tegra/gpio-names.h              |  247 -------------------------
> >  arch/arm/mach-tegra/include/mach/gpio-tegra.h |  225 ++++++++++++++++++++++
> >  11 files changed, 226 insertions(+), 257 deletions(-)
> >  delete mode 100644 arch/arm/mach-tegra/gpio-names.h
> 
> The main reason that gpio-names.h was only in the mach directory and
> not under include in the first place, is to discourage use outside of
> the base platform code and board definitions.
> 
> There should be no need for drivers and non-mach-tegra code to use the
> file, so doing a current-directory include of it should be OK. Or do
> you have other plans for it?

My primary motivation was to bring Tegra into line with what appears to
be common practice amongst other ARM sub-architectures; many of
mach-$x/include/mach/gpio-$x.h define the GPIO names there.

Still, your argument is valid; I don't foresee a need to anything other
than mach-tegra/*.c to need the GPIO names file.

So, feel free to take/drop this patch as you desire.

-- 
nvpublic

