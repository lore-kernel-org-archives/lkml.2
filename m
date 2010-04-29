Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553Ab0D3UhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:37:18 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:59004 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759194Ab0D3UhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=O0omdxPLyFpQie1LoQsHnD61oZMlQ5reIAWmyM35ljbk2Fz0zKBeCwpazmsv74sJYG
         XgZaH3phBvWxIo19iAXSQkKZhoanL/SRnFre2p/a7DmlrDb5+K8PAA28Kp3pUplEOkF6
         NOCESFqk5y54b0DocjfsHWRARjXGaJq1v0PlA=
Message-ID: <4BD9ADE2.3090208@gmail.com>
Date: Thu, 29 Apr 2010 09:03:46 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: MacBookPro2,2 unable too boot with the latest HEAD
References: <i2vdd18b0c31004140812i6a0e9430u68ab49b24273fe9b@mail.gmail.com> <20100419142804.3cd53666.akpm@linux-foundation.org> <4BCCCCDF.4010605@gmail.com> <20100419145741.95688467.akpm@linux-foundation.org> <alpine.LFD.2.00.1004201011050.2402@sony> <4BD999C8.7090602@gmail.com> <4BD9A150.6060402@suse.de>
In-Reply-To: <4BD9A150.6060402@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2010 08:10 AM, Alexey Starikovskiy wrote:
> 29.04.2010 18:38, Justin P. Mattock пишет:
>> On 04/20/2010 07:17 AM, Len Brown wrote:
>>>
>>>>> the patch here fixes it for me:ACPI: EC: Limit burst to 64 bit
>>>>> https://bugzilla.kernel.org/attachment.cgi?id=25962
>>>>
>>>> hm. I wonder how you go from a bugzilla attachment back up tot he bug
>>>> to which it is attached?
>>>
>>> Use "A comment contains this string" in bugzilla's advanced search
>>> and plug in "attachment.cgi?id=25962" for this case.
>>>
>>> you'll find the patch in this comment:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=15749#c7
>>>
>>> It is a bit more user friendly to supply the
>>> URL of the commment containing the patch rather than
>>> the direct URL of the attachment itself.
>>>
>>>> Oh well. Alexey, I trust that patch is in the 2.6.34 queue?
>>>
>>> it shipped in 2.6.34-rc5 in commit
>>> 2060c44576c79086ff24718878d7edaa7384a985
>>>
>>> thanks,
>>> Len Brown, Intel Open Source Technology Center
>>>
>>>
>>
>>
>> ahh... o.k. so I just have to add
>> #(then a comment number) i.g.
>> #7 at the end of the bug URL.
>>
>> make sense...
>>
>> off topic of this bug, I've another
>> issue over here with the iMac9,1
>> (that I've been slowly working on)
>>
>> basically long story short there is
>> no entry for the AC adapter in it's
>> dsdt(ACPI0003)
>> ac.c:
>> static const struct acpi_device_id ac_device_ids[] = {
>> {"ACPI0003", 0},
>> {"", 0},
>> };
>>
>> causing no entries in /proc/acpi/*
>> and /sys/class/power_supply
>>
>> This doesn't seem to be a big issue
>> it's just one machine defaults to ac
>> and then another machine defaults to battery
>> (keep in mind both machines are iMac9,1's
>> just different gpu's).
>>
>> is there some boot param to tell the kernel
>> to simply go to ac?
>>
>> Justin P. Mattock
> There is no external AC switch. You may try to blacklist ac driver, so
> kernel might be fulled into being run on a desktop...
> You might also open a bug report for this issue, so we could give a more
> meaningful answer...
>
> Regards,
> Alex.
>

your right!!
(I've been putting off filling a bug
only to really see if I can do this,but the more
I look into it the more daunting it becomes).

as for the issue, I was thinking in the area of a dmi blacklist
or something to where proc_mkdir etc..
will just make the file "online" to trick
the kernel and any other mechanism reading
those files.

but first things first, I'll file a bug.

Justin P. Mattock
