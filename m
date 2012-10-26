Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab2JZLKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:10:44 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39061 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758395Ab2JZLKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:10:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jingoo Han <jg1.han@samsung.com>,
        "'Daniel Lezcano'" <daniel.lezcano@linaro.org>
Cc: "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuidle: add missing header include
Date: Fri, 26 Oct 2012 13:14:37 +0200
Message-ID: <6329232.eg8Mc603Uh@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.3-8-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <001401cdb332$93ffe450$bbffacf0$%han@samsung.com>
References: <001401cdb332$93ffe450$bbffacf0$%han@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 26, 2012 01:30:07 PM Jingoo Han wrote:
> This patch adds missing device.h header to fix build warnings as below:
> 
> drivers/cpuidle/cpuidle.h:26:41: warning: 'struct device' declared inside parameter list [enabled by default]
> drivers/cpuidle/cpuidle.h:26:41: warning: its scope is only this definition or declaration, which is probably not what you want
> [enabled by default]
> drivers/cpuidle/cpuidle.h:27:45: warning: 'struct device' declared inside parameter list [enabled by default]
> In file included from drivers/cpuidle/driver.c:15:0:
> drivers/cpuidle/cpuidle.h:26:41: warning: 'struct device' declared inside parameter list [enabled by default]
> drivers/cpuidle/cpuidle.h:26:41: warning: its scope is only this definition or declaration, which is probably not what you want
> [enabled by default]
> drivers/cpuidle/cpuidle.h:27:45: warning: 'struct device' declared inside parameter list [enabled by default]
> 
> This build warning is introduced by commit efeca1b
> "cpuidle / sysfs: change function parameter".
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>

I fixed up the original patch.

Daniel, I must say I'm less and less impressed by the quality of code
I'm getting from you.  Please improve it.

Thanks,
Rafael


> ---
>  drivers/cpuidle/cpuidle.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
> index a5bbd1c..2120d9e 100644
> --- a/drivers/cpuidle/cpuidle.h
> +++ b/drivers/cpuidle/cpuidle.h
> @@ -5,6 +5,8 @@
>  #ifndef __DRIVER_CPUIDLE_H
>  #define __DRIVER_CPUIDLE_H
>  
> +#include <linux/device.h>
> +
>  /* For internal use only */
>  extern struct cpuidle_governor *cpuidle_curr_governor;
>  extern struct list_head cpuidle_governors;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
