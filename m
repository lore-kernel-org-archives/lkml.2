Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2KUJE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:04:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:31135 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab2KUJEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:04:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,291,1352102400"; 
   d="scan'208";a="245241322"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
CC: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "jonghwa3.lee@samsung.com" <jonghwa3.lee@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [PATCH 0/4] thermal: Add support for interrupt based
 notification to thermal layer
Thread-Topic: [PATCH 0/4] thermal: Add support for interrupt based
 notification to thermal layer
Thread-Index: AQHNvWlDDa5UjDojT0WwvnH5MQ2RZpf0EweA
Date: Wed, 21 Nov 2012 09:04:06 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B909263264C2D@SHSMSX101.ccr.corp.intel.com>
References: <1352348786-24255-1-git-send-email-amit.kachhap@linaro.org>
In-Reply-To: <1352348786-24255-1-git-send-email-amit.kachhap@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Amit,

As THERMAL_TREND_RAISE_FULL/THERMAL_TREND_DROP_FULL
has been introduced to thermal next tree,
I'd like to get your plan about this patch set?

Thanks,
Rui

> -----Original Message-----
> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
> owner@vger.kernel.org] On Behalf Of Amit Daniel Kachhap
> Sent: Thursday, November 08, 2012 12:26 PM
> To: linux-pm@lists.linux-foundation.org
> Cc: linux-samsung-soc@vger.kernel.org; linux-kernel@vger.kernel.org; R,
> Durgadoss; lenb@kernel.org; Zhang, Rui; linux-acpi@vger.kernel.org;
> amit.kachhap@linaro.org; jonghwa3.lee@samsung.com
> Subject: [PATCH 0/4] thermal: Add support for interrupt based
> notification to thermal layer
> Importance: High
> 
> The patch submitted by Jonghwa Lee
> (https://patchwork.kernel.org/patch/1683441/)
> adds support for interrupt based notification to thermal layer. This is
> a good feature but the current thermal framework needs polling/regular
> notification for invoking suitable cooling action. So adding 2 new
> thermal trend type to implement this feature.
> 
> All these patches are based on thermal maintainer next tree.
> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next
> 
> Amit Daniel Kachhap (3):
>   thermal: Add new thermal trend type to support quick cooling
>   thermal: exynos: Miscellaneous fixes to support falling threshold
>     interrupt
>   thermal: exynos: Use the new thermal trend type for quick cooling
>     action.
> 
> Jonghwa Lee (1):
>   Thermal: exynos: Add support for temperature falling interrupt.
> 
>  drivers/thermal/exynos_thermal.c             |  105 +++++++++++++++---
> --------
>  drivers/thermal/step_wise.c                  |   19 ++++-
>  include/linux/platform_data/exynos_thermal.h |    3 +
>  include/linux/thermal.h                      |    2 +
>  4 files changed, 80 insertions(+), 49 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
