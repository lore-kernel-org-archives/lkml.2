Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2BAH0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:26:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61731 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab2BAH0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:26:18 -0500
Date: Tue, 31 Jan 2012 23:26:17 -0800
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/8] ARM: tegra: functions to access the flowcontroller
Message-ID: <20120201072617.GC7399@quad.lixom.net>
References: <1328028051-24271-1-git-send-email-pdeschrijver@nvidia.com>
 <1328028051-24271-3-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328028051-24271-3-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 06:40:40PM +0200, Peter De Schrijver wrote:
> Introduce some functions to write to the flowcontroller registers.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  arch/arm/mach-tegra/Makefile   |    1 +
>  arch/arm/mach-tegra/flowctrl.c |   62 ++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-tegra/flowctrl.h |    5 +++
>  3 files changed, 68 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-tegra/flowctrl.c
> 
> diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
> index b78bda8..60c286e 100644
> --- a/arch/arm/mach-tegra/Makefile
> +++ b/arch/arm/mach-tegra/Makefile
> @@ -6,6 +6,7 @@ obj-y                                   += irq.o
>  obj-y                                   += clock.o
>  obj-y                                   += timer.o
>  obj-y					+= fuse.o
> +obj-y					+= flowctrl.o
>  obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= powergate.o
>  obj-$(CONFIG_ARCH_TEGRA_2x_SOC)         += tegra2_clocks.o
>  obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= tegra2_emc.o
> diff --git a/arch/arm/mach-tegra/flowctrl.c b/arch/arm/mach-tegra/flowctrl.c
> new file mode 100644
> index 0000000..fef66a7
> --- /dev/null
> +++ b/arch/arm/mach-tegra/flowctrl.c
> @@ -0,0 +1,62 @@
> +/*
> + * arch/arm/mach-tegra/flowctrl.c
> + *
> + * functions and macros to control the flowcontroller

Nit:

It would be more useful here to get one or two sentences about what the flow
controller unit is used for, etc.


-Olof
