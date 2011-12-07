Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab1LGSjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:39:00 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43247 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab1LGSi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:38:58 -0500
MIME-Version: 1.0
In-Reply-To: <4EDF7153.7090306@bitmer.com>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
	<1309427470-605-4-git-send-email-balbi@ti.com>
	<CAMP44s3hFyAK+1W6eU30RNn3=cPDRGKXW+E+sDoWNrNhU0ZpPA@mail.gmail.com>
	<20111207065106.GE32368@legolas.emea.dhcp.ti.com>
	<CAMP44s0psqeMEh8vgYSfV=MAqSOJ6+EpWndXpc89qfGHMX_f=w@mail.gmail.com>
	<20111207133937.GX32368@legolas.emea.dhcp.ti.com>
	<4EDF7153.7090306@bitmer.com>
Date: Wed, 7 Dec 2011 20:31:02 +0200
Message-ID: <CAMP44s1ugKT0P_8bzMh-HRQ_rOk-b52bd=haKROmei71WvAcpQ@mail.gmail.com>
Subject: Re: [regression] Re: [PATCH 3/7] mfd: twl4030-irq: drop the kthread
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: balbi@ti.com, Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 3:59 PM, Jarkko Nikula <jarkko.nikula@bitmer.com> wrote:
> On 12/07/2011 03:39 PM, Felipe Balbi wrote:
>>>
>>> I'll try to flash a system to NAND, since I can't seem to just get the
>>> MMC to work when the cover is open and the device is connected to the
>>> jig to see if I can see something from serial console.
>>>
>>> You don't have any idea about what to try?
>>
>>
>> you could cut the back cover so that it just fits the device on the jig
>> (I did that to an old cover), then it works just fine :-)
>>
> You could also go without breaking the back cover by putting a magnet on top
> the hal sensor (like tape a piece from a fridge magnet). See here the place:
>
> http://talk.maemo.org/showthread.php?p=1008775
>
> Another option is to to set .gpio_cd = -EINVAL for external mmc in
> arch/arm/mach-omap2/board-rx51-peripherals.c.

Nice. That gpio_cd trick did it :)

-- 
Felipe Contreras
