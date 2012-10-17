Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2JQOVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:21:14 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37662 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab2JQOVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:21:12 -0400
MIME-Version: 1.0
In-Reply-To: <1350387889-15324-3-git-send-email-hongbo.zhang@linaro.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1350387889-15324-3-git-send-email-hongbo.zhang@linaro.com>
Date: Wed, 17 Oct 2012 19:51:10 +0530
Message-ID: <CAKohponedzqv3XeEjH+bSM6Ub2FU0yQma1W_AwuQaabpfL=tKA@mail.gmail.com>
Subject: Re: [PATCH 2/5] Thermal: add indent for code alignment.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 October 2012 17:14, hongbo.zhang <hongbo.zhang@linaro.org> wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>

People always like to see a commit log here :)

> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
> ---
>  drivers/thermal/cpu_cooling.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> index cc1c930..b6b4c2a 100644
> --- a/drivers/thermal/cpu_cooling.c
> +++ b/drivers/thermal/cpu_cooling.c
> @@ -369,7 +369,7 @@ struct thermal_cooling_device *cpufreq_cooling_register(
>                         if (min != policy.cpuinfo.min_freq ||
>                                 max != policy.cpuinfo.max_freq)
>                                 return ERR_PTR(-EINVAL);
> -}
> +               }

Apart from that:

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
