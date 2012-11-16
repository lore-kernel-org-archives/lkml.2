Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab2KPD4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 22:56:44 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13253 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2KPD4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 22:56:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 15 Nov 2012 19:56:36 -0800
Message-ID: <50A5B970.7020600@nvidia.com>
Date: Fri, 16 Nov 2012 11:56:32 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] Device tree updates for host1x support
References: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

Thank you for your hard work.

The series,

Acked-by: Mark Zhang <markz@nvidia.com>
Reviewed-by: Mark Zhang <markz@nvidia.com>
Tested-by: Mark Zhang <markz@nvidia.com>

On Ventana, LVDS and HDMI worked.
PS: Alex's power sequence patch is needed to enable panel and backlight.
    Also we need to define dc and hdmi nodes in tegra20-ventana.dts.
    We may publish the patches for different boards next.

Mark
On 11/16/2012 05:07 AM, Thierry Reding wrote:
> This second version of this patch series splits the patches up into more
> logical chunks as requested by Stephen. Instead of renaming the matching
> parameters in the clock driver, this version renames the AUXDATA entries
> to match what the clock driver expects. Furthermore the host1x clock is
> initialized to 150 MHz instead of the unsupported 144 MHz.
> 
> Thierry
> 
> Thierry Reding (6):
>   ARM: tegra: Add Tegra20 host1x support
>   ARM: tegra: Add AUXDATA for Tegra20 host1x
>   ARM: tegra: Add Tegra20 host1x clock support
>   ARM: tegra: Add Tegra30 host1x support
>   ARM: tegra: Add AUXDATA for Tegra30 host1x
>   ARM: tegra: Add Tegra30 host1x clock support
> 
>  arch/arm/boot/dts/tegra20.dtsi            | 87 +++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/tegra30.dtsi            | 87 +++++++++++++++++++++++++++++++
>  arch/arm/mach-tegra/board-dt-tegra20.c    |  9 ++++
>  arch/arm/mach-tegra/board-dt-tegra30.c    |  9 ++++
>  arch/arm/mach-tegra/tegra20_clocks_data.c | 11 ++--
>  arch/arm/mach-tegra/tegra30_clocks_data.c |  5 +-
>  6 files changed, 203 insertions(+), 5 deletions(-)
> 
