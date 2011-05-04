Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab1EDQrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:47:51 -0400
Received: from christianhoffmann.info ([88.175.101.52]:34212 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab1EDQru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:47:50 -0400
Message-ID: <4DC1832E.5030806@christianhoffmann.info>
Date: Wed, 04 May 2011 18:47:42 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: john stultz <johnstul@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
References: <4DBEFCBA.3070501@christianhoffmann.info>  <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>  <1304372955.3226.15.camel@work-vm>  <4DBF2FB4.8000304@christianhoffmann.info> <1304470839.3037.12.camel@work-vm> <4DC100D0.1030302@christianhoffmann.info> <alpine.LFD.2.02.1105041015220.3005@ionos>
In-Reply-To: <alpine.LFD.2.02.1105041015220.3005@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Huch. There is something badly wrong. Can you provide the output of
>
>   cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>
> please ?

$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
tsc hpet acpi_pm

>
>> [  147.940143] Refined TSC clocksource calibration: 2809.409 MHz.
>> [  147.940147] Switching to clocksource tsc
>
> I just looked at the two boot logs you provided. So the main
> difference is that TSC gets installed way later.
>
> Can you please boot the "working" kernel with clocksource=hpet on the
> commandline and verify whether the boot hang appears there as well?
>

No, it works fine. See http://pastebin.com/raw.php?i=4wJWkiNM.

Rgds,
Chris

