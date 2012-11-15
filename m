Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab2KOIc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:32:26 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57550 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab2KOIcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:32:23 -0500
MIME-Version: 1.0
In-Reply-To: <1352967218.2080.15.camel@rzhang1-mobl4>
References: <1352460548-3494-1-git-send-email-hongbo.zhang@linaro.com>
	<1352460548-3494-2-git-send-email-hongbo.zhang@linaro.com>
	<1352967218.2080.15.camel@rzhang1-mobl4>
Date: Thu, 15 Nov 2012 16:32:22 +0800
Message-ID: <CAJLyvQyu_oU7xx92JTOj6bvF+7-hOJfM=kTHj6JMogaYjC+Jww@mail.gmail.com>
Subject: Re: [PATCH V5 1/2] Thermal: Add ST-Ericsson DB8500 thermal driver.
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, amit.kachhap@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2012 16:13, Zhang Rui <rui.zhang@intel.com> wrote:
> On Fri, 2012-11-09 at 19:29 +0800, hongbo.zhang wrote:
>> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
>>
>> This driver is based on the thermal management framework in thermal_sys.c. A
>> thermal zone device is created with the trip points to which cooling devices
>> can be bound, the current cooling device is cpufreq, e.g. CPU frequency is
>> clipped down to cool the CPU, and other cooling devices can be added and bound
>> to the trip points dynamically.  The platform specific PRCMU interrupts are
>> used to active thermal update when trip points are reached.
>>
>> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
>> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
>> Reviewed-by: Francesco Lavra <francescolavra.fl@gmail.com>
>
>> diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
>> index e1cb6bd..54c8fd0 100644
>> --- a/drivers/thermal/Kconfig
>> +++ b/drivers/thermal/Kconfig
>> @@ -31,6 +31,26 @@ config CPU_THERMAL
>>         and not the ACPI interface.
>>         If you want this support, you should say Y here.
>>
>> +config DB8500_THERMAL
>> +     bool "DB8500 thermal management"
>
> why is this bool?

platform specific PRCMU interfaces are used, and those interfaces are
not exported, so my driver cannot be compiled as a module.

>
> thanks,
> rui
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
