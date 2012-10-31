Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965309Ab2JaCSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 22:18:18 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47484 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2JaCSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 22:18:16 -0400
MIME-Version: 1.0
In-Reply-To: <1351615741-24134-6-git-send-email-hongbo.zhang@linaro.com>
References: <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	<1351615741-24134-1-git-send-email-hongbo.zhang@linaro.com>
	<1351615741-24134-6-git-send-email-hongbo.zhang@linaro.com>
Date: Wed, 31 Oct 2012 07:48:15 +0530
X-Google-Sender-Auth: ZvUtv9JjC0wDxeR6FSaxufhRsfE
Message-ID: <CAOh2x==HB5Jn0iy3dbaL=G0jD5UcP=TwQcxhzQXz9-kbQBdA8A@mail.gmail.com>
Subject: Re: [PATCH V3 5/5] Thermal: Add ST-Ericsson DB8500 thermal properties
 and platform data.
From: viresh kumar <viresh.kumar@linaro.org>
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, rui.zhang@intel.com, amit.kachhap@linaro.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 10:19 PM, hongbo.zhang <hongbo.zhang@linaro.org> wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>

Just a minor comment below.

> This patch adds device tree properties for ST-Ericsson DB8500 thermal driver,
> also adds the platform data to support the old fashion.
>
> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

> ---
>  arch/arm/boot/dts/dbx5x0.dtsi      | 14 +++++++++
>  arch/arm/boot/dts/snowball.dts     | 31 ++++++++++++++++++
>  arch/arm/configs/u8500_defconfig   |  4 +++
>  arch/arm/mach-ux500/board-mop500.c | 64 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 113 insertions(+)

> diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
> index cc5e7a8..34918c4 100644
> --- a/arch/arm/configs/u8500_defconfig
> +++ b/arch/arm/configs/u8500_defconfig
> @@ -118,3 +118,7 @@ CONFIG_DEBUG_KERNEL=y
>  CONFIG_DEBUG_INFO=y
>  # CONFIG_FTRACE is not set
>  CONFIG_DEBUG_USER=y
> +CONFIG_THERMAL=y
> +CONFIG_CPU_THERMAL=y
> +CONFIG_DB8500_THERMAL=y
> +CONFIG_DB8500_CPUFREQ_COOLING=y

Have you entered these manually?? Or used make savedefconfig?
