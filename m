Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab1G3Roj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 13:44:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:56183 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab1G3Roc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 13:44:32 -0400
Message-ID: <4E3442F9.2060901@windriver.com>
Date: Sat, 30 Jul 2011 13:44:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dave Jones <davej@redhat.com>, <linux-kernel@vger.kernel.org>,
        <patches@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] cpufreq: Fix build of s3c64xx cpufreq driver for header
 change
References: <1311952766-11693-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1311952766-11693-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-07-29 11:19 AM, Mark Brown wrote:
> Some header change has removed an implicit include of module.h, breaking
> the build due to the use of THIS_MODULE. Fix that.

Thanks, I'll apply it to the module.h cleanup branch that is soaking
in linux-next.

P.

> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/cpufreq/s3c64xx-cpufreq.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
> index b8d1d20..3475f65 100644
> --- a/drivers/cpufreq/s3c64xx-cpufreq.c
> +++ b/drivers/cpufreq/s3c64xx-cpufreq.c
> @@ -15,6 +15,7 @@
>  #include <linux/clk.h>
>  #include <linux/err.h>
>  #include <linux/regulator/consumer.h>
> +#include <linux/module.h>
>  
>  static struct clk *armclk;
>  static struct regulator *vddarm;
