Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab2KILjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:39:05 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50416 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2KILjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:39:01 -0500
MIME-Version: 1.0
In-Reply-To: <1352460548-3494-1-git-send-email-hongbo.zhang@linaro.com>
References: <1352460548-3494-1-git-send-email-hongbo.zhang@linaro.com>
Date: Fri, 9 Nov 2012 19:39:00 +0800
Message-ID: <CAJLyvQwVZ1SHnrY9M9C-JgEvoz=n5-3RaDvd-vPy1-gyfmxmUg@mail.gmail.com>
Subject: Re: [PATCH V5 0/2] Upstream ST-Ericsson thermal driver
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: linux-acpi@vger.kernel.org, rui.zhang@intel.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        amit.kachhap@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui Zhang,
Please have a look at this patch set.
Since the previous 1/5, 2/5, 3/5 have been accepted, I'd like to send
these last two updated patches with Reviewed-by added in this new
thread.

Thanks.

On 9 November 2012 19:29, hongbo.zhang <hongbo.zhang@linaro.org> wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
>
> V4->V5 Changes:
>
> In patch "Thermal: Add ST-Ericsson DB8500 thermal driver":
>  - use flush_work instead of flush_work_sync since the later is deprecated now.
>  - parameter trip_points of db8500_thermal_match_cdev is renamed to trip_point;
>  - re-order oprerations in function db8500_thermal_update_config;
>
> hongbo.zhang (2):
>   Thermal: Add ST-Ericsson DB8500 thermal driver.
>   Thermal: Add ST-Ericsson DB8500 thermal properties and platform data.
>
>  .../devicetree/bindings/thermal/db8500-thermal.txt |  44 ++
>  arch/arm/boot/dts/dbx5x0.dtsi                      |  14 +
>  arch/arm/boot/dts/snowball.dts                     |  31 ++
>  arch/arm/configs/u8500_defconfig                   |   2 +
>  arch/arm/mach-ux500/board-mop500.c                 |  64 +++
>  drivers/thermal/Kconfig                            |  20 +
>  drivers/thermal/Makefile                           |   2 +
>  drivers/thermal/db8500_cpufreq_cooling.c           | 108 +++++
>  drivers/thermal/db8500_thermal.c                   | 531 +++++++++++++++++++++
>  include/linux/platform_data/db8500_thermal.h       |  38 ++
>  10 files changed, 854 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/thermal/db8500-thermal.txt
>  create mode 100644 drivers/thermal/db8500_cpufreq_cooling.c
>  create mode 100644 drivers/thermal/db8500_thermal.c
>  create mode 100644 include/linux/platform_data/db8500_thermal.h
>
> --
> 1.7.11.3
>
