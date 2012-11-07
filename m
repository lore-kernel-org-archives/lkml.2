Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab2KGGyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 01:54:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:64724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab2KGGyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 01:54:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,727,1344236400"; 
   d="scan'208";a="216182107"
Message-ID: <1352271255.2137.33.camel@rzhang1-mobl4>
Subject: Re: [PATCH V3 1/5] Thermal: add indent for code alignment.
From: Zhang Rui <rui.zhang@intel.com>
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, amit.kachhap@linaro.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, "hongbo.zhang" <hongbo.zhang@linaro.com>
Date: Wed, 07 Nov 2012 14:54:15 +0800
In-Reply-To: <1351615741-24134-2-git-send-email-hongbo.zhang@linaro.com>
References: <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	 <1351615741-24134-1-git-send-email-hongbo.zhang@linaro.com>
	 <1351615741-24134-2-git-send-email-hongbo.zhang@linaro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 17:48 +0100, hongbo.zhang wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
> 
> The curly bracket should be aligned with corresponding if else statements.
> 
> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

applied to thermal-next.

thanks,
rui

> ---
>  drivers/thermal/cpu_cooling.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index cc1c930..b6b4c2a 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -369,7 +369,7 @@ struct thermal_cooling_device *cpufreq_cooling_register(
>  			if (min != policy.cpuinfo.min_freq ||
>  				max != policy.cpuinfo.max_freq)
>  				return ERR_PTR(-EINVAL);
> -}
> +		}
>  	}
>  	cpufreq_dev = kzalloc(sizeof(struct cpufreq_cooling_device),
>  			GFP_KERNEL);


