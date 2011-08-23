Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1HWSlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:41:40 -0400
Received: from void.printf.net ([89.145.121.20]:48560 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab1HWSle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:41:34 -0400
From: Chris Ball <cjb@laptop.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawn.guo@linaro.org>, linux-mmc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sdhci/tegra: Add Device Tree probing support
References: <1314123334-23133-1-git-send-email-swarren@nvidia.com>
Date: Tue, 23 Aug 2011 14:41:05 -0400
In-Reply-To: <1314123334-23133-1-git-send-email-swarren@nvidia.com> (Stephen
	Warren's message of "Tue, 23 Aug 2011 12:15:33 -0600")
Message-ID: <m2ippo2cou.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Aug 23 2011, Stephen Warren wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
>
> Add hooks to read gpio configuration out of the device tree node.
>
> [grant.likely: Rewrite of original patch from John Bonesio]
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> [swarren: Fixed tegra_sdhci_get_ro() to retrieve pdata correctly]
> [swarren: Reworked to avoid #ifdef CONFIG_OF]
> [swarren: Reworked binding based on fsl-imx-esdhc.txt]
> [swarren: Documented binding]
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Theoretically, these two patches should be merged in order in one place,
> since the 2nd logically depends on the first. However, it's really just
> a documentation dependency, so I think it's fine to merge them into the
> MMC and DT trees separately and let them meet in linux-next.
>
>  .../devicetree/bindings/mmc/nvidia-sdhci.txt       |   25 ++++++++++
>  drivers/mmc/host/sdhci-tegra.c                     |   51 +++++++++++++++----
>  2 files changed, 65 insertions(+), 11 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt

Okay, I've pushed this patch [1/2] to mmc-next for 3.2.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
