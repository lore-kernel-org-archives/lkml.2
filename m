Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab1DNKTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:19:10 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48934 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697Ab1DNKTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=VpB8eZ0iYcOk4L9emM4O1m981le5Bi3Unlk8mtLdXhWlgTBw4FZ+NDE4a1ioBfGevV
         CZWxFr1r8lixSejLghaigVC/Z+JrCNcnEOMJuDjr/sajn11u/F0faQ7xnKYzeAiIzXAU
         Z39Twju9YsiY50JL5t6PCNyU3YC1wts4hgM3I=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <BANLkTinq=mC9rs5R3U8FPLCp-GgCJris_g@mail.gmail.com>
References: <BANLkTikd2MpRPF37R+vCwnb7Lzzd6EiS7A@mail.gmail.com>
	<BANLkTinq=mC9rs5R3U8FPLCp-GgCJris_g@mail.gmail.com>
Date: Thu, 14 Apr 2011 12:19:07 +0200
Message-ID: <BANLkTimT9OhHLL5NaPOP30MdiMfmmmEcyQ@mail.gmail.com>
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ related?)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 11:16 AM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> [ Adding CC to RCU maintainer (Hi Paul :-)) ]
>
> Helping me for now with (see also Documentation/RCU/stallwarn.txt):
>
> # cat /sys/module/rcutree/parameters/rcu_cpu_stall_suppress
> 0
>
> # echo "1" > /sys/module/rcutree/parameters/rcu_cpu_stall_suppress
>
> # cat /sys/module/rcutree/parameters/rcu_cpu_stall_suppress
> 1
>
> - Sedat -
>

That workaround helped till a system-freeze when generating a tarball
from my current kernel-tree.
I switched back to my yesterday's linux-next kernel.

- Sedat -

> On Thu, Apr 14, 2011 at 10:59 AM, Sedat Dilek
> <sedat.dilek@googlemail.com> wrote:
>> On Thu, Apr 14, 2011 at 7:01 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> Hi all,
>>>
>>> Changes since 20110413:
>>>
>>> Dropped tree: xen
>>>
>>> The gfs2 tree lost its conflict.
>>>
>>> The net tree lost its build failure.
>>>
>>> The wireless tree lost all but one conflict.
>>>
>>> The trivial tree lost its conflict.
>>>
>>> The tip tree gained a conflict against Linus' tree.
>>>
>>> The usb tree gained a conflict against the s5p tree.
>>>
>>> The staging tree lost its conflicts.
>>>
>>> ----------------------------------------------------------------------------
>>
>> Just a quick hello and an attached dmesg.
>> Yesterday's linux-next (next-20110413) with same kernel-config was OK.
>>
>> ( Also, I have seen a section-mismatch in x86 (IIRC mm) missing
>> __init... but that's another story. )
>>
>> - Sedat -
>>
>> P.S.: diff between today's and yesterday's kernel-config
>>
>> $ diff -uprN /boot/config-2.6.39-rc3-next20110413.2-686-small
>> /boot/config-2.6.39-rc3-next20110414.2-686-small
>> --- /boot/config-2.6.39-rc3-next20110413.2-686-small    2011-04-13
>> 12:32:09.000000000 +0200
>> +++ /boot/config-2.6.39-rc3-next20110414.2-686-small    2011-04-14
>> 10:23:25.000000000 +0200
>> @@ -1,7 +1,7 @@
>>  #
>>  # Automatically generated make config: don't edit
>>  # Linux/x86 2.6.39-rc3 Kernel Configuration
>> -# Wed Apr 13 11:55:54 2011
>> +# Thu Apr 14 09:43:03 2011
>>  #
>>  # CONFIG_64BIT is not set
>>  CONFIG_X86_32=y
>> @@ -2602,6 +2602,7 @@ CONFIG_USB_UHCI_HCD=m
>>  #
>>  # Enable Host or Gadget support to see Inventra options
>>  #
>> +# CONFIG_USB_RENESAS_USBHS is not set
>>
>>  #
>>  # USB Device Class drivers
>>
>
