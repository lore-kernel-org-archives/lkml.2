Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab1JORHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 13:07:51 -0400
Received: from smtp.multi.fi ([85.134.37.151]:60289 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab1JORHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 13:07:50 -0400
X-Greylist: delayed 973 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Oct 2011 13:07:50 EDT
Message-ID: <4E99BA1A.3060002@mageia.org>
Date: Sat, 15 Oct 2011 19:51:38 +0300
From: Thomas Backlund <tmb@mageia.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PROBLEM] ASUS Sandybridge motherboards + PCI not working (IRQ
 n: nobody cared)
References: <4E98175A.8040905@pobox.com>
In-Reply-To: <4E98175A.8040905@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Palmer skrev 14.10.2011 14:04:
> Interrupt handling for *PCI boards with ASUS Sandybridge motherboards*
> seems to be broken.
>
> It has been seen with network and non-network PCI boards. PCIx network
> boards work OK. And all reports are for ASUS motherboards.
>
> It always results in the infamous "IRQ n: nobody cared" message usually
> within an hour. It is possible to restart things by rmmod/modprobe on
> the appropriate PCI driver.
>
> Andrew Morton kindly took a quick look and thinks it is most likely an
> ACPI bug.
>
> Configuration summary:
>   - ASUS P8H67-V/R3 Motherboard (others have problems with similar M/Bs)
>   - M/B BIOS 0804 (just updated to that - no change)
>   - Core i5/2500K
>   - Onboard ethernet (at11c driver - works)
>   - Additional PCIx Intel ethernet board (e1000e driver - works)
>   - Additional PCI Broadcom BCM5702X ethernet board (tg3 driver - fails)
> 	[ Also fails with other PCI boards such as RTL8139 ]
>   - Kernel 3.0.6
>
>
> Any help much appreciated...
>

Does it help to boot with: pci=nocrs ?

--
Thomas
