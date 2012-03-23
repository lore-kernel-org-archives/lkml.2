Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2CWFWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 01:22:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52083 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2CWFWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 01:22:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAMfrEMa65+X1zA5fQ7R+Zt8tGjf9XtcHnPodiJgy+9bwO-nFkg@mail.gmail.com>
References: <CAMfrEMaV03CEZ-h7k9K78c8+T+AC47=QypnyhQG7LFgrQQ32tA@mail.gmail.com>
	<4F6AAC57.3090507@gmail.com>
	<CAMfrEMbUsdnQ3Roe89YaV5F2xhTwbgRhWcM9E1jizqUEbCi=QQ@mail.gmail.com>
	<CADLC3L29fiago4Nkxbb3Ey8iS3GGp_G_NP77esdAqQVYHFLBLw@mail.gmail.com>
	<CAMfrEMYUWG39Z-y8sU+7eDdePQWg9U5kow_ipZANwD-s=BOh_A@mail.gmail.com>
	<CAMfrEMZ27UWKTASUFaEG1KLysRgAukVruOx2Q-s-FXzOQJe_zA@mail.gmail.com>
	<CAMfrEMa65+X1zA5fQ7R+Zt8tGjf9XtcHnPodiJgy+9bwO-nFkg@mail.gmail.com>
Date: Thu, 22 Mar 2012 23:22:53 -0600
Message-ID: <CADLC3L2XSJoPtt3g+GAc=JvMz3OjFewnt-BPBPyrVG+ZcxvW4w@mail.gmail.com>
Subject: Re: IDE DVD and CD drive seem to not work with Linux desktop 3.3.0-030300-generic
From: Robert Hancock <hancockrwd@gmail.com>
To: Chris Holland <bandidoirlandes@gmail.com>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, jbarnes@virtuousgeek.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 10:46 PM, Chris Holland
<bandidoirlandes@gmail.com> wrote:
> On Thu, Mar 22, 2012 at 9:44 PM, Chris Holland
> <bandidoirlandes@gmail.com> wrote:
>> On Thu, Mar 22, 2012 at 9:30 PM, Chris Holland
>> <bandidoirlandes@gmail.com> wrote:
>>> On Thu, Mar 22, 2012 at 9:15 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
>>>> On Wed, Mar 21, 2012 at 11:44 PM, Chris Holland
>>>> <bandidoirlandes@gmail.com> wrote:
>>>>>
>>>>> On Wed, Mar 21, 2012 at 11:36 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
>>>>> > On 03/21/2012 10:29 PM, Chris Holland wrote:
>>>>> >>
>>>>> >> Please cc me at: bandidoirlandes@gmail.com
>>>>> >>
>>>>> >> My optical drives are not working with 3.3 but they worked fine with
>>>>> >> 3.3rc7
>>>>> >> These are the kernels from http://kernel.ubuntu.com/~kernel-ppa/mainline/
>>>>> >> Ubuntu 11.10
>>>>> >>
>>>>> >> Not working
>>>>> >> Linux desktop 3.3.0-030300-generic #201203182135 SMP Mon Mar 19
>>>>> >> 01:36:20 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
>>>>> >> cat /var/log/dmesg | egrep '(CD|DVD)'
>>>>> >> [    0.000000]   CD000-EFFFF uncachable
>>>>> >>
>>>>> >> Working
>>>>> >> Linux desktop 3.3.0-030300rc7-generic #201203101735 SMP Sat Mar 10
>>>>> >> 22:36:28 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
>>>>> >> cat /var/log/dmesg | egrep '(CD|DVD)'
>>>>> >> [    0.000000]   CD000-EFFFF uncachable
>>>>> >> [    0.092676] ACPI Warning: Incorrect checksum in table [TAMG] -
>>>>> >> 0xCD, should be 0xCC (20120111/tbutils-321)
>>>>> >> [    6.324511] ata9.01: ATAPI: LITE-ON DVDRW SHW-160P6S, PS0A, max UDMA/66
>>>>> >> [    6.397218] scsi 8:0:0:0: CD-ROM            LITE-ON  LTR-48246S
>>>>> >>   SS0B PQ: 0 ANSI: 5
>>>>> >> [    6.419770] cdrom: Uniform CD-ROM driver Revision: 3.20
>>>>> >> [    6.419898] sr 8:0:0:0: Attached scsi CD-ROM sr0
>>>>> >> [    6.427088] scsi 8:0:1:0: CD-ROM            LITE-ON  DVDRW
>>>>> >> SHW-160P6S PS0A PQ: 0 ANSI: 5
>>>>> >> [    6.429600] sr 8:0:1:0: Attached scsi CD-ROM sr1
>>>>> >>
>>>>> >> I tried to do a git bisect but I dont know what I am doing. Might just
>>>>> >> be my computer acting up.
>>>>> >
>>>>> >
>>>>> > Can you post the full dmesg output from the non-working kernel?
>>>>
>>>>> [    3.231464] pata_jmicron 0000:03:00.1: setting latency timer to 64
>>>>> [    3.255549] scsi8 : pata_jmicron
>>>>> [    3.260534] scsi9 : pata_jmicron
>>>>> [    3.260933] ata9: PATA max UDMA/100 cmd 0xef00 ctl 0xee00 bmdma 0xeb00 irq 16
>>>>> [    3.260936] ata10: PATA max UDMA/100 cmd 0xed00 ctl 0xec00 bmdma
>>>>> 0xeb08 irq 16
>>>>
>>>> Hmm, seems like nothing detected on that port at all. Do you have some
>>>> output from a working boot?
>>>
>>> Working dmesg http://pastebin.com/jDaMhWXc
>>>
>>> This is a issue that others are having it seems.
>>> https://bugs.archlinux.org/task/29030
>>> https://bugs.archlinux.org/task/29045
>>>
>>>
>>> I did some work with git bisect but i dont know what i am doing though
>>> so this might not be the actual issue
>>> last build is going with 4949be16822e92a18ea0cc1616319926628092ee is
>>> the first bad commit removed.
>>> Waiting to see if it works.
>>
>> The only thing I saw different between the dmesg output was from the 3.3rc7
>> [    5.937329] pata_jmicron 0000:03:00.1: setting latency timer to 64
>> [    5.946289] scsi8 : pata_jmicron.
>> [    5.970116] scsi9 : pata_jmicron
>> [    5.970501] ata9: PATA max UDMA/100 cmd 0xef00 ctl 0xee00 bmdma 0xeb00 irq 16
>> [    5.970503] ata10: PATA max UDMA/100 cmd 0xed00 ctl 0xec00 bmdma
>> 0xeb08 irq 16
>>
>> then you get
>> [    6.324507] ata9.00: ATAPI: LITE-ON LTR-48246S, SS0B, max UDMA/33
>> [    6.324511] ata9.01: ATAPI: LITE-ON DVDRW SHW-160P6S, PS0A, max UDMA/66
>> [    6.340507] ata9.00: configured for UDMA/33
>> [    6.372507] ata9.01: configured for UDMA/66
>> [    6.397218] scsi 8:0:0:0: CD-ROM            LITE-ON  LTR-48246S
>>  SS0B PQ: 0 ANSI: 5
>> [    6.419767] sr0: scsi3-mmc drive: 42x/48x writer cd/rw xa/form2 cdda tray
>> [    6.419770] cdrom: Uniform CD-ROM driver Revision: 3.20
>> [    6.419898] sr 8:0:0:0: Attached scsi CD-ROM sr0
>> [    6.419957] sr 8:0:0:0: Attached scsi generic sg4 type 5
>> [    6.427088] scsi 8:0:1:0: CD-ROM            LITE-ON  DVDRW
>> SHW-160P6S PS0A PQ: 0 ANSI: 5
>> [    6.429493] sr1: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
>> [    6.429600] sr 8:0:1:0: Attached scsi CD-ROM sr1
>> [    6.429658] sr 8:0:1:0: Attached scsi generic sg5 type 5
>>
>>
>> On 3.3 I only get
>> [    3.231464] pata_jmicron 0000:03:00.1: setting latency timer to 64
>> [    3.255549] scsi8 : pata_jmicron
>> [    3.260534] scsi9 : pata_jmicron
>> [    3.260933] ata9: PATA max UDMA/100 cmd 0xef00 ctl 0xee00 bmdma 0xeb00 irq 16
>> [    3.260936] ata10: PATA max UDMA/100 cmd 0xed00 ctl 0xec00 bmdma
>> 0xeb08 irq 16
>>
>> Or thats how it looks to me
>
> With lots of help on irc I did
>
> git bisect reset
> git revert 4949be16822e
> cp /boot/config-3.3.0-030300-generic .config
> make oldconfig
> fakeroot make deb-pkg
>
> seems to fix it....
> cat /var/log/dmesg | egrep '(CD|DVD)'
> [    0.000000] Linux version 3.3.0+ (root@desktop) (gcc version 4.6.1
> (Ubuntu/Linaro 4.6.1-9ubuntu3) ) #8 SMP Thu Mar 22 22:06:21 CDT 2012
> [    0.000000]   CD000-EFFFF uncachable
> [    5.669815] ata9.01: ATAPI: LITE-ON DVDRW SHW-160P6S, PS0A, max UDMA/66
> [    5.745430] scsi 8:0:0:0: CD-ROM            LITE-ON  LTR-48246S
>  SS0B PQ: 0 ANSI: 5
> [    5.768369] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    5.768481] sr 8:0:0:0: Attached scsi CD-ROM sr0
> [    5.775750] scsi 8:0:1:0: CD-ROM            LITE-ON  DVDRW
> SHW-160P6S PS0A PQ: 0 ANSI: 5
> [    5.778227] sr 8:0:1:0: Attached scsi CD-ROM sr1
>
>
> But again I don't know what I am doing, and could be completely in the
> wrong spot.

I think you may have found a valid bad commit causing your issue,
which is this one:

>From 4949be16822e92a18ea0cc1616319926628092ee Mon Sep 17 00:00:00 2001
From: Matthew Garrett <mjg@redhat.com>
Date: Tue, 6 Mar 2012 13:41:49 -0500
Subject: [PATCH] PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled

Right now we won't touch ASPM state if ASPM is disabled, except in the case
where we find a device that appears to be too old to reliably support ASPM.
Right now we'll clear it in that case, which is almost certainly the wrong
thing to do. The easiest way around this is just to disable the blacklisting
when ASPM is disabled.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

It looks like your system's FADT says it doesn't support ASPM, so we
are disabling it:

ACPI FADT declares the system doesn't support PCIe ASPM, so disable it

and this device (or at least the other function on the same JMicron
SATA/PATA controller device) is a pre-PCIe 1.1 device:

pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can
enable it with 'pcie_aspm=force'

Before this patch we would have been forcing ASPM off on this device,
whereas now it appears we'll leave it as it was. Maybe this device
busts somehow if ASPM is allowed to be left on for it?

Matthew, any thoughts? Maybe this device needs a specific blacklist
entry to disable ASPM or something?
