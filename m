Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422848Ab2JYDqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:46:23 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63469 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422763Ab2JYDqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:46:14 -0400
MIME-Version: 1.0
In-Reply-To: <1351089124.18179.12.camel@joe-AO722>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	<1351079900-32236-7-git-send-email-hongbo.zhang@linaro.com>
	<1351089124.18179.12.camel@joe-AO722>
Date: Thu, 25 Oct 2012 11:45:52 +0800
Message-ID: <CAJLyvQyRBT+p6mkXkhBUx0vOoW+Xo7TqpJ=gHGc-3p_qqjq4UA@mail.gmail.com>
Subject: Re: [PATCH V2 6/6] Thermal: Add ST-Ericsson DB8500 thermal properties
 and platform data.
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, "hongbo.zhang" <hongbo.zhang@linaro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 October 2012 22:32, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-10-24 at 19:58 +0800, hongbo.zhang wrote:
>> This patch adds device tree properties for ST-Ericsson DB8500 thermal driver,
>> also adds the platform data to support the old fashion.
>
> Just a trivial note:
>
>> diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
>
>> @@ -229,6 +230,67 @@ static struct ab8500_platform_data ab8500_platdata = {
>>  };
>>
>>  /*
>> + * Thermal Sensor
>> + */
>> +
>> +static struct resource db8500_thsens_resources[] = {
>
> should there be a const in any of these?
There will be warnings from gcc:
warning: initialization discards 'const' qualifier from pointer target
type [enabled by default]

>
>> +static struct db8500_thsens_platform_data db8500_thsens_data = {
> []
>> +static struct platform_device u8500_thsens_device = {
> []
>> +static struct platform_device u8500_cpufreq_cooling_device = {
>
>
