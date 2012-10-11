Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab2JKLXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 07:23:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43625 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab2JKLXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 07:23:42 -0400
Message-ID: <5076AC36.8090503@gmail.com>
Date: Thu, 11 Oct 2012 16:53:34 +0530
From: shubhro <omaplinuxkernel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, p_gortmaker@yahoo.com, dchen@diasemi.com,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [Patch v3 3/7] RTC: DA9055 RTC driver
References: <1349952025.9228.3.camel@dhruva>
In-Reply-To: <1349952025.9228.3.camel@dhruva>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 October 2012 04:10 PM, Ashish Jangam wrote:
> +#define da9055_rtc_freeze NULL
> +#endif
> +
> +static const struct dev_pm_ops da9055_rtc_pm_ops = {
> +	.suspend = da9055_rtc_suspend,
> +	.resume = da9055_rtc_resume,
> +
> +	.freeze = da9055_rtc_freeze,
> +	.thaw = da9055_rtc_resume,
> +	.restore = da9055_rtc_resume,
> +
> +	.poweroff = da9055_rtc_suspend,
> +};
You may want to use simple dev pm ops
