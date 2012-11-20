Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2KTHdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:33:47 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8150 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab2KTHdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:33:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 19 Nov 2012 23:33:45 -0800
Message-ID: <50AB3250.1060804@nvidia.com>
Date: Tue, 20 Nov 2012 15:33:36 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Zhang <markz@nvidia.com>
CC: "airlied@linux.ie" <airlied@linux.ie>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2] drm: Add NVIDIA Tegra30 support
References: <1353396376-24121-1-git-send-email-markz@nvidia.com>
In-Reply-To: <1353396376-24121-1-git-send-email-markz@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen & Thierry,

I downloaded all patches from patchwork so right now it should not have
space issues.

Mark
On 11/20/2012 03:26 PM, Mark Zhang wrote:
> This patch is based on Thierry's drm patch for Tegra20:
> - [PATCH v2 0/6] Device tree updates for host1x support
> - [PATCH v3 0/2] NVIDIA Tegra DRM driver
> 
> It adds the support for NVIDIA Tegra30.
> 
> Signed-off-by: Mark Zhang <markz@nvidia.com>
> ---
>  drivers/gpu/drm/tegra/dc.c     |    1 +
>  drivers/gpu/drm/tegra/host1x.c |    3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
> index 53b9852..37bd759 100644
> --- a/drivers/gpu/drm/tegra/dc.c
> +++ b/drivers/gpu/drm/tegra/dc.c
> @@ -818,6 +818,7 @@ static int tegra_dc_remove(struct platform_device *pdev)
>  }
>  
>  static struct of_device_id tegra_dc_of_match[] = {
> +	{ .compatible = "nvidia,tegra30-dc", },
>  	{ .compatible = "nvidia,tegra20-dc", },
>  	{ },
>  };
> diff --git a/drivers/gpu/drm/tegra/host1x.c b/drivers/gpu/drm/tegra/host1x.c
> index 1f728cd..28c28ac 100644
> --- a/drivers/gpu/drm/tegra/host1x.c
> +++ b/drivers/gpu/drm/tegra/host1x.c
> @@ -66,6 +66,8 @@ static int host1x_remove_drm_client(struct host1x *host1x,
>  static int host1x_parse_dt(struct host1x *host1x)
>  {
>  	static const char * const compat[] = {
> +		"nvidia,tegra30-dc",
> +		"nvidia,tegra30-hdmi",
>  		"nvidia,tegra20-dc",
>  		"nvidia,tegra20-hdmi",
>  	};
> @@ -268,6 +270,7 @@ int host1x_unregister_client(struct host1x *host1x,
>  }
>  
>  static struct of_device_id tegra_host1x_of_match[] = {
> +	{ .compatible = "nvidia,tegra30-host1x", },
>  	{ .compatible = "nvidia,tegra20-host1x", },
>  	{ },
>  };
> 
