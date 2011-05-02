Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744Ab1EBW1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:27:08 -0400
Received: from christianhoffmann.info ([88.175.101.52]:50262 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab1EBW1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:27:06 -0400
Message-ID: <4DBF2FB4.8000304@christianhoffmann.info>
Date: Tue, 03 May 2011 00:27:00 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
References: <4DBEFCBA.3070501@christianhoffmann.info>	 <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info> <1304372955.3226.15.camel@work-vm>
In-Reply-To: <1304372955.3226.15.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2011 11:49 PM, john stultz wrote:
> On Mon, 2011-05-02 at 22:42 +0200, Christian Hoffmann wrote:
>> Hi,
>>
>>> Hrm. So, on older kernels, what do you see from:
>>> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>>> $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>>
>> On older and newer kernel I see the same output:
>> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>> tsc
>> $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>> tsc hpet acpi_pm
>
> Can you reproduce the hang booting with "clocksource=hpet" and
> "clocksource=acpi_pm" ?

Both hang also.

Rgds,
Chris
