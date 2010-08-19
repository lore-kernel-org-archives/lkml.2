Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab0HSHZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 03:25:04 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:41081 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab0HSHZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 03:25:00 -0400
Date: Thu, 19 Aug 2010 09:24:23 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Fenghua Yu" <fenghua.yu@intel.com>
Cc: "Rudolf Marek" <r.marek@assembler.cz>, "Huaxu Wan" <huaxu.wan@intel.com>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "lm-sensors" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] drivers/hwmon/coretemp: Remove warnings of unused
 variables
Message-ID: <20100819092423.00f76256@hyperion.delvare>
In-Reply-To: <1282172027-640-2-git-send-email-fenghua.yu@intel.com>
References: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>
	<1282172027-640-2-git-send-email-fenghua.yu@intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fenghua,

On Wed, 18 Aug 2010 15:53:46 -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Remove compilation warnings of unused variables p and n in coretemp_init().
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  drivers/hwmon/coretemp.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index c070c97..de81111 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -518,7 +518,6 @@ static struct notifier_block coretemp_cpu_notifier __refdata = {
>  static int __init coretemp_init(void)
>  {
>  	int i, err = -ENODEV;
> -	struct pdev_entry *p, *n;
>  
>  	/* quick check if we run Intel */
>  	if (cpu_data(0).x86_vendor != X86_VENDOR_INTEL)

Thanks for the fix, but it is already in my tree:
ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-hwmon/hwmon-coretemp-fix-warning.patch

I'll send it to Linus as part as my next batch of hwmon fixes for
2.6.36.

-- 
Jean Delvare
