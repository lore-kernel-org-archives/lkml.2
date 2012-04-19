Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab2DSSNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:13:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48919 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2DSSNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:13:46 -0400
MIME-Version: 1.0
In-Reply-To: <4F904C17.6010705@fold.natur.cuni.cz>
References: <4F6A483D.50702@fold.natur.cuni.cz>
	<4F6A5A53.305@fold.natur.cuni.cz>
	<CAE9FiQXP7fO9OGN557jdofFFiFj96wL--ZA8X3UPEJ6o9JLvBw@mail.gmail.com>
	<4F8BEB1D.9080903@fold.natur.cuni.cz>
	<CAE9FiQXoX3J6P_9Tun_XbkK3egvSeBZxAtC13HacFDO0fwmZaA@mail.gmail.com>
	<4F8C6E4E.1000205@fold.natur.cuni.cz>
	<CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com>
	<CAE9FiQUFB=9zbP1yuBDH1RJrCCP=83kV_fH+TEtk80981-uP=w@mail.gmail.com>
	<CAE9FiQUbzM_TVu+bbXa6LWiUt01QsFiGoyYd0qV=41dXx4J31g@mail.gmail.com>
	<4F8D1B72.2000105@fold.natur.cuni.cz>
	<CAE9FiQW2MAW_WT+sq8XVtMOx=uR8FAN8O2wL2AOxkFBfEM285g@mail.gmail.com>
	<CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com>
	<4F8D390F.9050408@fold.natur.cuni.cz>
	<CAE9FiQU-_BCCS1OKagVuj8YNrut8-6GH2_i86FsfS8UDWQ1pRA@mail.gmail.com>
	<CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com>
	<4F8EFFA3.3050705@fold.natur.cuni.cz>
	<CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com>
	<4F904C17.6010705@fold.natur.cuni.cz>
Date: Thu, 19 Apr 2012 11:13:45 -0700
X-Google-Sender-Auth: s6E2AcJ06afainPWp-ULjmfNhHo
Message-ID: <CAE9FiQUCBRZ1UmML7brL6U6W9GbMNUtkzG0tF7vOPwt4HorXXA@mail.gmail.com>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 10:32 AM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
>  this brought me to and issue with "Intel® 6 Series Express Chipset B2 stepping" chips
> having enabled SATA ports 2-5. This is my case:
>
> [    3.037832] ahci 0000:00:1f.2: version 3.0
> [    3.037880] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
> [    3.037906] ahci: SSS flag set, parallel bus scan disabled
> [    3.048233] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x31 impl SATA mode
> [    3.048335] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst
> [    3.048371] ahci 0000:00:1f.2: setting latency timer to 64
> [    3.088902] scsi0 : ahci
> [    3.089010] scsi1 : ahci
> [    3.089098] scsi2 : ahci
> [    3.089185] scsi3 : ahci
> [    3.089272] scsi4 : ahci
> [    3.089361] scsi5 : ahci
> [    3.090528] ata1: SATA max UDMA/133 abar m2048@0xf7f06000 port 0xf7f06100 irq 44
> [    3.091400] ata2: DUMMY
> [    3.092262] ata3: DUMMY
> [    3.093112] ata4: DUMMY
> [    3.093952] ata5: SATA max UDMA/133 abar m2048@0xf7f06000 port 0xf7f06300 irq 44
> [    3.094803] ata6: SATA max UDMA/133 abar m2048@0xf7f06000 port 0xf7f06380 irq 44
>
>
> Is this bug anyhow related to this already known chipset issue?
>
> http://support.dell.com/support/topics/global.aspx/support/kcs/document?c=us&cs=04&docid=389728&l=en&s=bsd
> http://www.intel.com/support/chipsets/6/sb/CS-032521.htm
> http://www.intel.com/support/chipsets/6/sb/CS-032521.htm
>
>>
>
>
> So you found two issues, right?
>
> Issue 1:
>
> Yinghai Lu wrote:
>> for USB 3.0:
>>               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>>                       Changed: MRL- PresDet- LinkState+
>>
>> PresDet+: mean that card is still there. so no interrupt is generated
>> by chipset.
>>
>> that present bit is decide by by inband link or out of band.
>>
>> sometimes when out of band pres is no, present bit could be keep flip
>> around because in root port try to retrain to detect ...
>> but it is not the case.
>>
>> the pin "CPPE#  PCI Express interface presence detect" should get into
>> hotplug FPGA in motherboard.
>>
>> You may need to check with vendor about if there is any problem with
>> that hotplug FPGA.

Not sure about this one. could be that outofband signal is not used.



>
>
> Issue 2:
>>>> Can you try to use acpiphp instead of pciehp?
>>
>> looks your BIOS does not support acpiphp.
>>
>> Maybe you have to stay with
>>
>> echo 1  > .../pcie_link_disable
>> echo 0  > .../pcie_link_disable
>>
>> after removal every time.
>>
>
> Does it make sense to report this to Dell (that it does not support ACPI hotplug)?
> Can they fix it with BIOS or whatever? Thay will anyways replace my motherboard
> in the laptop if my system is really affected.

even there is intel silicon problem <user can not disable inband
present detecting, and that could report wrong status>
Dell should have good design to workaround it like add logic to check
CPPE and reset the link if needed.

>
> Can I just return the thing after 2.5 months completely?

You need to talk to dell about that.

How about those test on other shipped OS?

Yinghai
