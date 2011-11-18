Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab1KRVnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:43:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57097 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755713Ab1KRVnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:43:23 -0500
Date: Fri, 18 Nov 2011 13:43:24 -0800
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 08/10] arm/tegra: pinmux tables and definitions for
 tegra30
Message-ID: <20111118214324.GD31678@quad.lixom.net>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
 <1321546766-26770-9-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321546766-26770-9-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


> @@ -667,7 +710,12 @@ void tegra_pinmux_config_pullupdown_table(const struct tegra_pingroup_config *co
>  }
>  
>  static struct of_device_id tegra_pinmux_of_match[] __devinitdata = {
> +#ifdef CONFIG_ARCH_TEGRA_2x_SOC
>  	{ .compatible = "nvidia,tegra20-pinmux", tegra20_pinmux_init },
> +#endif
> +#ifdef CONFIG_ARCH_TEGRA_3x_SOC
> +	{ .compatible = "nvidia,tegra30-pinmux", tegra30_pinmux_init },
> +#endif

Again, provide empty stubs instead of ifdeffing the table.


-Olof

