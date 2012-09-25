Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab2IYUNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 16:13:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60597 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab2IYUNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 16:13:15 -0400
MIME-Version: 1.0
In-Reply-To: <506201AB.9060408@eldiabloenlosdetalles.net>
References: <5061F84B.3030603@eldiabloenlosdetalles.net>
	<506200FD.2060305@linux.vnet.ibm.com>
	<506201AB.9060408@eldiabloenlosdetalles.net>
Date: Tue, 25 Sep 2012 17:13:14 -0300
Message-ID: <CAH0vN5KLUAJ_nknPcZmzx9T0ugi+HUk49wWvmK49gB49FkQGFw@mail.gmail.com>
Subject: Re: Slow Resume with SSD
From: Marcos Souza <marcos.souza.org@gmail.com>
To: Carlos Moffat <carlos@eldiabloenlosdetalles.net>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, computersforpeace@gmail.com,
        ming.m.lin@intel.com, Norbert Preining <preining@logic.at>,
        jgarzik@pobox.com, Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Carlos

2012/9/25 Carlos Moffat <carlos@eldiabloenlosdetalles.net>:
> Hi
>
> On 09/25/2012 12:07 PM, Srivatsa S. Bhat wrote:
>>
>> On 09/26/2012 12:00 AM, Carlos Moffat wrote:
>>>
>>> Hi,
>>>
>>> (please let me know if this is the wrong list to ask this)
>>>
>>> I have a Crucial M4 512 GB SSD installed on my Thinkpad X220 (Ubuntu
>>> Precise). Overall this runs very nicely, but it takes 10+ seconds to
>>> resume from suspend, apparently because some issue with the hardrive.
>>> The only message I see while resuming is "COMRESET failed (errno=-16)".
>>>
>>> [52483.228615] ata1: link is slow to respond, please be patient (ready=0)
>>> [52487.870616] ata1: COMRESET failed (errno=-16)
>>> [52488.190222] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
>>> [52488.190752] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
>>> succeeded
>>> [52488.190754] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
>>> LOCK) filtered out
>>> [52488.190755] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
>>> filtered out
>>> [52488.191849] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES)
>>> succeeded
>>> [52488.191855] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
>>> LOCK) filtered out
>>> [52488.191860] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
>>> filtered out
>>> [52488.192406] ata1.00: configured for UDMA/100
>>> [52488.206298] sd 0:0:0:0: [sda] Starting disk
>>> [52488.207334] Extended CMOS year: 2000
>>> [52488.208335] PM: resume of devices complete after 10376.896 msecs
>>> [52488.208552] PM: resume devices took 10.376 seconds
>>>
>>> The only relevant post I've found was in the crucial support site:
>>>
>>>
>>> http://forums.crucial.com/t5/Solid-State-Drives-SSD/SOLVED-M4-CT512M4SSD1-7mm-512Gb-SSD-too-slow-when-laptop-wakes/td-p/102666
>>>
>>>
>>> which suggested adding libata.force=nohrst as a boot option to get rid
>>> of the problem.
>>>
>>> I tried that, but the laptop wouldn't suspend.
>>>
>>> Any ideas?
>>>
>>
>> (Adding relevant people to CC)
>>
>> I recall seeing a similar problem getting fixed in mainline quite a long
>> time ago (around v3.3 I think). Did you try the latest mainline kernel?
>>
>> Regards,
>> Srivatsa S. Bhat
>>
>
>
> Yes, I'm using 3.5.4 (Ubuntu Mainline packages).

I believe that the kernel that Ubuntu uses have some patches from
them, am I right?

Can you try the last stable kernel(vanilla) from mainline? Maybe
downloading from the kernel.org and compiling.

This can help us to track the error.

Thanks!

> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Att,

Marcos Paulo de Souza
Acadêmico de Ciencia da Computação - FURB - SC
Github: https://github.com/marcosps/
"Uma vida sem desafios é uma vida sem razão"
"A life without challenges, is a non reason life"
