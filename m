Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab2KPD5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 22:57:32 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3448 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2KPD5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 22:57:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 15 Nov 2012 19:57:08 -0800
Message-ID: <50A5B98E.8070002@nvidia.com>
Date: Fri, 16 Nov 2012 11:57:02 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Dave Airlie <airlied@redhat.com>, Rob Clark <rob@ti.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] NVIDIA Tegra DRM driver
References: <1353014903-17429-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1353014903-17429-1-git-send-email-thierry.reding@avionic-design.de>
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
On 11/16/2012 05:28 AM, Thierry Reding wrote:
> This third version of the patch series cleans up some minor issues that
> were found in the previous versions, such as deferred probe not working
> properly and the display remaining enabled after the driver is removed.
> 
> I've also put the two patches in this series into the tegra/drm/for-3.8
> branch of my repository on gitorious[0].
> 
> Thierry
> 
> [0]: git://gitorious.org/thierryreding/linux.git
> 
> Thierry Reding (2):
>   drm: Add NVIDIA Tegra20 support
>   drm: tegra: Add HDMI support
> 
>  .../bindings/gpu/nvidia,tegra20-host1x.txt         |  191 +++
>  drivers/gpu/drm/Kconfig                            |    2 +
>  drivers/gpu/drm/Makefile                           |    1 +
>  drivers/gpu/drm/tegra/Kconfig                      |   23 +
>  drivers/gpu/drm/tegra/Makefile                     |    7 +
>  drivers/gpu/drm/tegra/dc.c                         |  833 ++++++++++++
>  drivers/gpu/drm/tegra/dc.h                         |  388 ++++++
>  drivers/gpu/drm/tegra/drm.c                        |  115 ++
>  drivers/gpu/drm/tegra/drm.h                        |  234 ++++
>  drivers/gpu/drm/tegra/fb.c                         |   56 +
>  drivers/gpu/drm/tegra/hdmi.c                       | 1334 ++++++++++++++++++++
>  drivers/gpu/drm/tegra/hdmi.h                       |  575 +++++++++
>  drivers/gpu/drm/tegra/host1x.c                     |  322 +++++
>  drivers/gpu/drm/tegra/output.c                     |  272 ++++
>  drivers/gpu/drm/tegra/rgb.c                        |  228 ++++
>  15 files changed, 4581 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
>  create mode 100644 drivers/gpu/drm/tegra/Kconfig
>  create mode 100644 drivers/gpu/drm/tegra/Makefile
>  create mode 100644 drivers/gpu/drm/tegra/dc.c
>  create mode 100644 drivers/gpu/drm/tegra/dc.h
>  create mode 100644 drivers/gpu/drm/tegra/drm.c
>  create mode 100644 drivers/gpu/drm/tegra/drm.h
>  create mode 100644 drivers/gpu/drm/tegra/fb.c
>  create mode 100644 drivers/gpu/drm/tegra/hdmi.c
>  create mode 100644 drivers/gpu/drm/tegra/hdmi.h
>  create mode 100644 drivers/gpu/drm/tegra/host1x.c
>  create mode 100644 drivers/gpu/drm/tegra/output.c
>  create mode 100644 drivers/gpu/drm/tegra/rgb.c
> 
