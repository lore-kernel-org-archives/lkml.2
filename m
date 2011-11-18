Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab1KRVv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:51:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11626 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab1KRVv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:51:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 18 Nov 2011 13:51:12 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Olof Johansson <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 18 Nov 2011 13:51:11 -0800
Subject: RE: [PATCH 08/10] arm/tegra: pinmux tables and definitions for
 tegra30
Thread-Topic: [PATCH 08/10] arm/tegra: pinmux tables and definitions for
 tegra30
Thread-Index: AcymOxkE/O04jbZXQ5uvyX6uNqHQqgAAPb6A
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74FA4@HQMAIL01.nvidia.com>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
 <1321546766-26770-9-git-send-email-pdeschrijver@nvidia.com>
 <20111118214324.GD31678@quad.lixom.net>
In-Reply-To: <20111118214324.GD31678@quad.lixom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote at Friday, November 18, 2011 2:43 PM:
> > @@ -667,7 +710,12 @@ void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *co
> >  }
> >
> >  static struct of_device_id tegra_pinmux_of_match[] __devinitdata = {
> > +#ifdef CONFIG_ARCH_TEGRA_2x_SOC
> >  	{ .compatible = "nvidia,tegra20-pinmux", tegra20_pinmux_init },
> > +#endif
> > +#ifdef CONFIG_ARCH_TEGRA_3x_SOC
> > +	{ .compatible = "nvidia,tegra30-pinmux", tegra30_pinmux_init },
> > +#endif
> 
> Again, provide empty stubs instead of ifdeffing the table.

Isn't it better for the driver not to support that compatible flag, rather
than claiming support, but then not actually working correctly?

-- 
nvpublic

