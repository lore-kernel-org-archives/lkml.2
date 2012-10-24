Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934971Ab2JXOcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:32:08 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41951 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934917Ab2JXOcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:32:05 -0400
Message-ID: <1351089124.18179.12.camel@joe-AO722>
Subject: Re: [PATCH V2 6/6] Thermal: Add ST-Ericsson DB8500 thermal
 properties and platform data.
From: Joe Perches <joe@perches.com>
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, "hongbo.zhang" <hongbo.zhang@linaro.com>
Date: Wed, 24 Oct 2012 07:32:04 -0700
In-Reply-To: <1351079900-32236-7-git-send-email-hongbo.zhang@linaro.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	 <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	 <1351079900-32236-7-git-send-email-hongbo.zhang@linaro.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 19:58 +0800, hongbo.zhang wrote:
> This patch adds device tree properties for ST-Ericsson DB8500 thermal driver,
> also adds the platform data to support the old fashion.

Just a trivial note:

> diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c

> @@ -229,6 +230,67 @@ static struct ab8500_platform_data ab8500_platdata = {
>  };
>  
>  /*
> + * Thermal Sensor
> + */
> +
> +static struct resource db8500_thsens_resources[] = {

should there be a const in any of these?

> +static struct db8500_thsens_platform_data db8500_thsens_data = {
[]
> +static struct platform_device u8500_thsens_device = {
[]
> +static struct platform_device u8500_cpufreq_cooling_device = {


