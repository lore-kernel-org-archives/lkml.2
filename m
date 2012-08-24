Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab2HXJCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:02:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53431 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276Ab2HXJBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:01:39 -0400
Message-ID: <50374118.8020506@monstr.eu>
Date: Fri, 24 Aug 2012 10:53:44 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Crosthwaite <peter.crosthwaite@petalogix.com>
CC: Stephan Linz <linz@li-pro.net>, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] microblaze: improve failure handling for GPIO reset
References: <1344451432-30735-1-git-send-email-linz@li-pro.net> <CAEgOgz6AjqM7TcpZfp5RBbSD3Bo8fv+JcGVOZz5Ohignchw+=g@mail.gmail.com>
In-Reply-To: <CAEgOgz6AjqM7TcpZfp5RBbSD3Bo8fv+JcGVOZz5Ohignchw+=g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 08:02 AM, Peter Crosthwaite wrote:
> On Thu, Aug 9, 2012 at 4:43 AM, Stephan Linz <linz@li-pro.net> wrote:
>> Early exit from of_platform_reset_gpio_probe() if there
>> was no GPIO reset line configured.
>>
>> Avoid kernel oops in gpio_system_reset():
>>
>> [   96.603690] Restarting system.
>> [   96.606094] Machine restart...
>> [   96.608810] Oops: kernel access of bad area, sig: 11
>> [   96.613662]  Registers dump: mode=824C1D1C
>> [   96.617858]  r1=C000BB0C, r2=00000000, r3=FFFFFEF8, r4=000015B4
>> [   96.623736]  r5=C0276270, r6=00000001, r7=FFFFFFFF, r8=000015B4
>> [   96.629597]  r9=000015B3, r10=000015B4, r11=00000000, r12=00000000
>> [   96.635733]  r13=00000000, r14=0000000F, r15=C0002B04, r16=00000000
>> [   96.641973]  r17=C011E1A0, r18=80000115, r19=00000010, r20=48184ED8
>> [   96.648184]  r21=00000000, r22=FFFFFFEA, r23=00000001, r24=FEE1DEAD
>> [   96.654396]  r25=00000054, r26=1000B1C8, r27=00000000, r28=00000000
>> [   96.660622]  r29=00000000, r30=00000000, r31=C24A97E0, rPC=C011E1A0
>> [   96.666849]  msr=000042A2, ear=0000004C, esr=00000872, fsr=362E3639
>>
>> Signed-off-by: Stephan Linz <linz@li-pro.net>
>
> Tested-by: Peter Crosthwaite <peter.crosthwaite@petalogix.com>
>
>> ---
>> v2 Remove additional printk message from machine_restart()
>> ---
>>   arch/microblaze/kernel/reset.c |    6 +++++-
>>   1 files changed, 5 insertions(+), 1 deletions(-)

I have added it to my next branch to the previous patch.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
