Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab2JORmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:42:53 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47635 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab2JORmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:42:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org
Subject: Re: [PATCH] cpufreq: core: Fix typo in comment describing show_bios_limit()
Date: Mon, 15 Oct 2012 19:46:31 +0200
Message-ID: <1774345.Nnc7VcJkzQ@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <718816abb84888e786c8bc478104668440b77324.1349766028.git.viresh.kumar@linaro.org>
References: <718816abb84888e786c8bc478104668440b77324.1349766028.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 of October 2012 12:32:48 Viresh Kumar wrote:
> show_bios_limit is mistakenly written as show_scaling_driver in a comment
> describing purpose of show_bios_limit() routine.
> 
> Fix it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks for the patch, I will queue it up for v3.8.

Rafael


> ---
>  drivers/cpufreq/cpufreq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index fb8a527..021973b 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -581,7 +581,7 @@ static ssize_t show_scaling_setspeed(struct cpufreq_policy *policy, char *buf)
>  }
>  
>  /**
> - * show_scaling_driver - show the current cpufreq HW/BIOS limitation
> + * show_bios_limit - show the current cpufreq HW/BIOS limitation
>   */
>  static ssize_t show_bios_limit(struct cpufreq_policy *policy, char *buf)
>  {
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
