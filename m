Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab2DUAER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:04:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56410 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2DUAEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:04:16 -0400
MIME-Version: 1.0
In-Reply-To: <4F91F639.6000107@fold.natur.cuni.cz>
References: <4F6A483D.50702@fold.natur.cuni.cz>
	<CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com>
	<4F8D390F.9050408@fold.natur.cuni.cz>
	<CAE9FiQU-_BCCS1OKagVuj8YNrut8-6GH2_i86FsfS8UDWQ1pRA@mail.gmail.com>
	<CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com>
	<4F8EFFA3.3050705@fold.natur.cuni.cz>
	<CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com>
	<4F8F243B.70906@fold.natur.cuni.cz>
	<CAE9FiQXx1NcGY9cHDiM5isx7NyxWN--Exb-4Gfj0arr6vf5ghQ@mail.gmail.com>
	<4F909CEB.3060407@fold.natur.cuni.cz>
	<CAE9FiQU7gnKiwazN_2ykbXSkcuDqWMZNt0CHiGvae2L+rTVGug@mail.gmail.com>
	<CAE9FiQUk8D20mEFPE0ahwfigbEOHpbRp-X0wt4DC+293msw=4Q@mail.gmail.com>
	<4F91473A.1080007@fold.natur.cuni.cz>
	<CAE9FiQUQRAfdG1J6XUVcOVkeR00vyqnCrBg1O3S_ByC3dKOUog@mail.gmail.com>
	<4F919C22.1070608@fold.natur.cuni.cz>
	<4F919CD5.7070004@fold.natur.cuni.cz>
	<CAE9FiQV_cRTDTBmQwNLJtT-N=HTAxBiphBLDmKxM-N0JKyoR-w@mail.gmail.com>
	<4F91F639.6000107@fold.natur.cuni.cz>
Date: Fri, 20 Apr 2012 17:04:15 -0700
X-Google-Sender-Auth: n8OLxcU4YmwLzsSErgAnR0Czfp8
Message-ID: <CAE9FiQUFcOV5Vgc_yeU5KSsSPccdmTjyGjGjSOYwrLt-kETGKQ@mail.gmail.com>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 4:50 PM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
>
>
> Yinghai Lu wrote:
>> On Fri, Apr 20, 2012 at 10:28 AM, Martin Mokrejs
>> <mmokrejs@fold.natur.cuni.cz> wrote:
>>>
>
> inserting
>
> Apr 21 01:38:03 vostro kernel: [  166.843165] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
> Apr 21 01:38:03 vostro kernel: [  166.843272] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
> Apr 21 01:38:03 vostro kernel: [  166.843329] xhci_hcd 0000:11:00.0: xHCI Host Controller
> Apr 21 01:38:03 vostro kernel: [  166.843335] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
> Apr 21 01:38:03 vostro kernel: [  166.843637] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
> Apr 21 01:38:03 vostro kernel: [  166.843923] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
> Apr 21 01:38:03 vostro kernel: [  166.843925] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> Apr 21 01:38:03 vostro kernel: [  166.843926] usb usb5: Product: xHCI Host Controller
> Apr 21 01:38:03 vostro kernel: [  166.843927] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
> Apr 21 01:38:03 vostro kernel: [  166.843928] usb usb5: SerialNumber: 0000:11:00.0
> Apr 21 01:38:03 vostro kernel: [  166.844076] hub 5-0:1.0: USB hub found
> Apr 21 01:38:03 vostro kernel: [  166.844088] hub 5-0:1.0: 2 ports detected
> Apr 21 01:38:03 vostro kernel: [  166.844162] xhci_hcd 0000:11:00.0: xHCI Host Controller
> Apr 21 01:38:03 vostro kernel: [  166.844164] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
> Apr 21 01:38:03 vostro kernel: [  166.846869] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
> Apr 21 01:38:03 vostro kernel: [  166.846872] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> Apr 21 01:38:03 vostro kernel: [  166.846874] usb usb6: Product: xHCI Host Controller
> Apr 21 01:38:03 vostro kernel: [  166.846876] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
> Apr 21 01:38:03 vostro kernel: [  166.846878] usb usb6: SerialNumber: 0000:11:00.0
> Apr 21 01:38:03 vostro kernel: [  166.847205] hub 6-0:1.0: USB hub found
> Apr 21 01:38:03 vostro kernel: [  166.847224] hub 6-0:1.0: 2 ports detected
>
> removed
>
> re-inserting
>

so pcie_aspm=off not help.

Yinghai
