Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965460Ab2JYDtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:49:51 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58877 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934507Ab2JYDtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:49:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpom0EOAuahLQoNr1ODbTT-Trv3eE0-oBEmbbdbiKBJPCng@mail.gmail.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-7-git-send-email-hongbo.zhang@linaro.com>
	<CAKohpom0EOAuahLQoNr1ODbTT-Trv3eE0-oBEmbbdbiKBJPCng@mail.gmail.com>
Date: Thu, 25 Oct 2012 11:49:48 +0800
Message-ID: <CAJLyvQwhsN9cxy0YSmEGQ__1Wh3ajEmC5G6jpJ7KTXBR=BV+jA@mail.gmail.com>
Subject: Re: [PATCH V2 6/6] Thermal: Add ST-Ericsson DB8500 thermal properties
 and platform data.
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
>>  /*
>> + * Thermal Sensor
>> + */
>> +
>> +static struct resource db8500_thsens_resources[] = {
>> +       {
>> +               .name = "IRQ_HOTMON_LOW",
>> +               .start  = IRQ_PRCMU_HOTMON_LOW,
>> +               .end    = IRQ_PRCMU_HOTMON_LOW,
>> +               .flags  = IORESOURCE_IRQ,
>> +       },
>> +       {
>
> I prefer }, {
I just follow the style of all the other definitions, let's keep a
uniform style.

>
>> +               .name = "IRQ_HOTMON_HIGH",
>> +               .start  = IRQ_PRCMU_HOTMON_HIGH,
>> +               .end    = IRQ_PRCMU_HOTMON_HIGH,
>> +               .flags  = IORESOURCE_IRQ,
>> +       },
>> +};
[...]
>>
>>
>> _______________________________________________
>> linaro-dev mailing list
>> linaro-dev@lists.linaro.org
>> http://lists.linaro.org/mailman/listinfo/linaro-dev
