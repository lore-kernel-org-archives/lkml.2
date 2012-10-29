Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab2J2BQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 21:16:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17330 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab2J2BQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 21:16:15 -0400
X-AuditID: cbfee61b-b7f616d00000319b-1e-508dd8ddc115
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>
Cc: "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001401cdb332$93ffe450$bbffacf0$%han@samsung.com>
 <508DA864.8020503@linaro.org>
In-reply-to: <508DA864.8020503@linaro.org>
Subject: Re: [PATCH] cpuidle: add missing header include
Date: Mon, 29 Oct 2012 10:16:13 +0900
Message-id: <002101cdb572$fcc4d670$f64e8350$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac21VhxJlyvWyWmnTmO0eUNpDbqJNwAG+E7w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jQd27N3oDDCZNUrO4vGsOm8Xn3iOM
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXcfShecF644uj0qYwNjL/5uxg5OCQETCQ6TtR2MXIC
	mWISF+6tZ+ti5OIQEpjOKLH03S0WkISQwC9GiftTREBsNgE1iS9fDrOD2CICBhKvT/9mB2lg
	FpjGKPHn/wxmiIZYiaY/EM2cAloSa882MYLYwgIWEucPvQWzWQRUJSZc7GUCsXkFbCWWPZrJ
	DGELSvyYfI8F5DhmAXWJKVNyQcLMAtoST95dYIW4WV3i0V9diBOMJO7f6GaGKBGR2PfiHeME
	RqFZSAbNQhg0C8mgWUg6FjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIDuVn0jsYVzVY
	HGIU4GBU4uFNuNAbIMSaWFZcmXuIUYKDWUmEdyk3UIg3JbGyKrUoP76oNCe1+BCjNAeLkjhv
	s0dKgJBAemJJanZqakFqEUyWiYNTqoGxPuSezJnlLy821gh+edMb+MJRLOruvTVXft45uqd+
	5zfrya8mfrGx1rTYffE6W0sW39r+WrYDfLsvK/FIG3CkqNi8WDKPfS/vhhn+/WUavuYfkptD
	roarujY+mrb88n7Dg0cKa2J/33mbmfM94dti1vx9jfWJN+wkhIIerIjbr+NgWcZys+WwEktx
	RqKhFnNRcSIAgjgsnmECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 29, 2012 6:49 AM Marek Vasut wrote
> 
> On 10/26/2012 06:30 AM, Jingoo Han wrote:
> > This patch adds missing device.h header to fix build warnings as below:
> >
> > drivers/cpuidle/cpuidle.h:26:41: warning: 'struct device' declared inside parameter list [enabled by
> default]
> > drivers/cpuidle/cpuidle.h:26:41: warning: its scope is only this definition or declaration, which is
> probably not what you want
> > [enabled by default]
> > drivers/cpuidle/cpuidle.h:27:45: warning: 'struct device' declared inside parameter list [enabled by
> default]
> > In file included from drivers/cpuidle/driver.c:15:0:
> > drivers/cpuidle/cpuidle.h:26:41: warning: 'struct device' declared inside parameter list [enabled by
> default]
> > drivers/cpuidle/cpuidle.h:26:41: warning: its scope is only this definition or declaration, which is
> probably not what you want
> > [enabled by default]
> > drivers/cpuidle/cpuidle.h:27:45: warning: 'struct device' declared inside parameter list [enabled by
> default]
> >
> > This build warning is introduced by commit efeca1b
> > "cpuidle / sysfs: change function parameter".
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> > ---
> 
> Jingoo, could you copy-pastebin your config file. I don't have this
> warning and I would like to understand why.

Hi Daniel Lezcano,

Could you build the code by using GCC 4.6.x?
In my opinion, it would be better.

Also, my config option is as below:
    make exynos4_defconfig + CONFIG_CPU_IDLE

Best regards,
Jingoo Han


> 
> Thanks
>   -- Daniel
> 
> >  drivers/cpuidle/cpuidle.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
> > index a5bbd1c..2120d9e 100644
> > --- a/drivers/cpuidle/cpuidle.h
> > +++ b/drivers/cpuidle/cpuidle.h
> > @@ -5,6 +5,8 @@
> >  #ifndef __DRIVER_CPUIDLE_H
> >  #define __DRIVER_CPUIDLE_H
> >
> > +#include <linux/device.h>
> > +
> >  /* For internal use only */
> >  extern struct cpuidle_governor *cpuidle_curr_governor;
> >  extern struct list_head cpuidle_governors;
> 
> 
> --
>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
> 
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog

