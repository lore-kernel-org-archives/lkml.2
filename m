Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab1EBUmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 16:42:21 -0400
Received: from christianhoffmann.info ([88.175.101.52]:39101 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab1EBUmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 16:42:18 -0400
Message-ID: <4DBF1725.3030800@christianhoffmann.info>
Date: Mon, 02 May 2011 22:42:13 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
References: <4DBEFCBA.3070501@christianhoffmann.info> <1304363375.3226.5.camel@work-vm>
In-Reply-To: <1304363375.3226.5.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Hrm. So, on older kernels, what do you see from:
> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> $ cat /sys/devices/system/clocksource/clocksource0/available_clocksource

On older and newer kernel I see the same output:
$ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
tsc
$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
tsc hpet acpi_pm

>
> Hrm. The delay in the dmesg logs doesn't really seem to correlate that
> closely with the delayed tsc calibration. Hrmm..
>

Maybe some side effect somehow. I can't explain.

Rgds,
Chris
