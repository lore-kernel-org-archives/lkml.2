Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2KZGW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 01:22:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:12061 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab2KZGWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 01:22:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,318,1352102400"; 
   d="scan'208";a="254153390"
Message-ID: <1353910930.2172.1.camel@rzhang1-mobl4>
Subject: Re: [RESEND PATCH] MAINTAINERS: Add maintainers for exynos thermal
 driver
From: Zhang Rui <rui.zhang@intel.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Mon, 26 Nov 2012 14:22:10 +0800
In-Reply-To: <1353905151-20735-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1353905151-20735-1-git-send-email-jonghwa3.lee@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please send this patch to Linus and cc the list.

thanks,
rui

On Mon, 2012-11-26 at 13:45 +0900, Jonghwa Lee wrote:
> Add Amit and I as maintainers for exynos thermal driver.
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
>  MAINTAINERS |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 59203e7..e839fb8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2960,6 +2960,13 @@ S:	Maintained
>  F:	drivers/video/exynos/exynos_mipi*
>  F:	include/video/exynos_mipi*
>  
> +EXYNOS THERMAL DRIVER
> +M:	Jonghwa Lee <jonghwa3.lee@samsung.com>
> +M:	Amit Daniel Kachhap <amit.kachhap@linaro.org>
> +L:	linux-pm@vger.kernel.org
> +S:	Maintained
> +F:	drivers/thermal/exynos_thermal.c
> +
>  F71805F HARDWARE MONITORING DRIVER
>  M:	Jean Delvare <khali@linux-fr.org>
>  L:	lm-sensors@lm-sensors.org


