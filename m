Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992920Ab2KOINp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:13:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:50253 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992492Ab2KOINn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:13:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,255,1352102400"; 
   d="scan'208";a="249421693"
Message-ID: <1352967218.2080.15.camel@rzhang1-mobl4>
Subject: Re: [PATCH V5 1/2] Thermal: Add ST-Ericsson DB8500 thermal driver.
From: Zhang Rui <rui.zhang@intel.com>
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, amit.kachhap@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Date: Thu, 15 Nov 2012 16:13:38 +0800
In-Reply-To: <1352460548-3494-2-git-send-email-hongbo.zhang@linaro.com>
References: <1352460548-3494-1-git-send-email-hongbo.zhang@linaro.com>
	 <1352460548-3494-2-git-send-email-hongbo.zhang@linaro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-09 at 19:29 +0800, hongbo.zhang wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
> 
> This driver is based on the thermal management framework in thermal_sys.c. A
> thermal zone device is created with the trip points to which cooling devices
> can be bound, the current cooling device is cpufreq, e.g. CPU frequency is
> clipped down to cool the CPU, and other cooling devices can be added and bound
> to the trip points dynamically.  The platform specific PRCMU interrupts are
> used to active thermal update when trip points are reached.
> 
> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
> Reviewed-by: Francesco Lavra <francescolavra.fl@gmail.com>

> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> index e1cb6bd..54c8fd0 100644
> --- a/drivers/thermal/Kconfig
> +++ b/drivers/thermal/Kconfig
> @@ -31,6 +31,26 @@ config CPU_THERMAL
>  	  and not the ACPI interface.
>  	  If you want this support, you should say Y here.
>  
> +config DB8500_THERMAL
> +	bool "DB8500 thermal management"

why is this bool?

thanks,
rui


