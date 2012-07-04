Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab2GDKoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:44:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:48031 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751998Ab2GDKoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:44:04 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX18lOtsJxKkl0iWSVRbrisHul2oaq+Yj+KiUr5GNrD
	m4NfNDc+Q1o8PR
From: Marc Dietrich <marvin24@gmx.de>
To: Wei Ni <wni@nvidia.com>
Cc: swarren@nvidia.com, olof@lixom.net, ccross@android.com,
        linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ldewangan@nvidia.com, arnd@arndb.de, grant.likely@secretlab.ca,
        cjb@laptop.org
Subject: Re: [PATCH 1/5] ARM: tegra: set up wlan clocks for tegra dt
Date: Wed, 04 Jul 2012 12:43:50 +0200
Message-ID: <6135516.CD1aogiCta@fb07-iapwap2>
User-Agent: KMail/4.8.4 (Linux/3.4.4-3-desktop; KDE/4.8.4; x86_64; ; )
In-Reply-To: <1341394488-13169-2-git-send-email-wni@nvidia.com>
References: <1341394488-13169-1-git-send-email-wni@nvidia.com> <1341394488-13169-2-git-send-email-wni@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 4. Juli 2012, 17:34:44 schrieb Wei Ni:
> Set up the wlan clock tree for Tegra20 and Tegra30.
> 
> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>  arch/arm/mach-tegra/board-dt-tegra20.c |    1 +
>  arch/arm/mach-tegra/board-dt-tegra30.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c
> b/arch/arm/mach-tegra/board-dt-tegra20.c index 70a19a9..fbcc7d9 100644
> --- a/arch/arm/mach-tegra/board-dt-tegra20.c
> +++ b/arch/arm/mach-tegra/board-dt-tegra20.c
> @@ -78,6 +78,7 @@ static __initdata struct tegra_clk_init_table
> tegra_dt_clk_init_table[] = { { "pll_a",      "pll_p_out1",   56448000,    
>   true },
>  	{ "pll_a_out0", "pll_a",        11289600,       true },
>  	{ "cdev1",      NULL,           0,              true },
> +	{ "blink",      "clk_32k",      32768,          true },

what's the reason to enable this on all boards? Would it make sense to set 
this to "false" instead?

Marc


>  	{ "i2s1",       "pll_a_out0",   11289600,       false},
>  	{ "i2s2",       "pll_a_out0",   11289600,       false},
>  	{ NULL,		NULL,		0,		0},
> diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c
> b/arch/arm/mach-tegra/board-dt-tegra30.c index 53bf60f..2d73c61 100644
> --- a/arch/arm/mach-tegra/board-dt-tegra30.c
> +++ b/arch/arm/mach-tegra/board-dt-tegra30.c
> @@ -61,6 +61,7 @@ static __initdata struct tegra_clk_init_table
> tegra_dt_clk_init_table[] = { { "pll_a_out0",	"pll_a",	11289600,	true },
>  	{ "extern1",	"pll_a_out0",	0,		true },
>  	{ "clk_out_1",	"extern1",	0,		true },
> +	{ "blink",	"clk_32k",	32768,		true },
>  	{ "i2s0",	"pll_a_out0",	11289600,	false},
>  	{ "i2s1",	"pll_a_out0",	11289600,	false},
>  	{ "i2s2",	"pll_a_out0",	11289600,	false},
