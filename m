Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1C3MGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:06:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45484 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab1C3MGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:06:06 -0400
Message-ID: <4D931C98.4010009@monstr.eu>
Date: Wed, 30 Mar 2011 14:05:44 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] microblaze: Fix level/edge irq sensibility
References: <1301484264-6220-1-git-send-email-monstr@monstr.eu> <alpine.LFD.2.00.1103301403290.22418@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103301403290.22418@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 30 Mar 2011, Michal Simek wrote:
> 
>> Patches:
>> "microblaze: Convert to new irq function names"
>> sha (4adc192ec7d977c74c750320f289af9d61c1caca)
>> and
>> "microblaze: Use generic show_interrupts()"
>> sha(9d61c18b25726306c9231428c17db42e3ff29ba7)
>>
>> should also setup edge/level in irq_set_chip_and_handler_name
>> name parameter.
>>
>> Error log:
>> ~ # cat /proc/interrupts
>>            CPU0
>>   2:          2  Xilinx INTC-Xilinx INTC  eth0
>>   3:          2  Xilinx INTC-Xilinx INTC  eth0
>>   4:        241  Xilinx INTC-Xilinx INTC  timer
>>   6:        108  Xilinx INTC-Xilinx INTC  serial
>>
>> Fixed:
>> ~ # cat /proc/interrupts
>>            CPU0
>>   2:          2  Xilinx INTC-level     eth0
>>   3:          2  Xilinx INTC-level     eth0
>>   4:        238  Xilinx INTC-edge      timer
>>   6:        108  Xilinx INTC-level     serial
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
> Should I pick that up for the urgent fixes ?

No you shouldn't. It can go through my tree.
You can give me ACK if you like.

Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
