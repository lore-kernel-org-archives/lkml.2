Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2LOISe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 03:18:34 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64352 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2LOISc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 03:18:32 -0500
MIME-Version: 1.0
In-Reply-To: <50CB9FF8.2070502@redhat.com>
References: <CANmqhJAuLoi_Y2Hsz+UnddHXYd9TCW-7qxp3fybDayfh33Y3Zg@mail.gmail.com>
	<1355415792.2229.7.camel@ul30vt.home>
	<CANmqhJBAxzVa5Ds0gojnYDDku5UbXGwfCNC=+z3XmVonF-_j2w@mail.gmail.com>
	<50CB9FF8.2070502@redhat.com>
Date: Sat, 15 Dec 2012 16:18:30 +0800
Message-ID: <CANmqhJCg05aQhhupM_Tmnj6rPHP5uwS76HnVL3t6V-Q5X-t2gw@mail.gmail.com>
Subject: Re: DMAR and DRHD errors[DMAR:[fault reason 06] PTE Read access is
 not set] Vt-d & intel_iommu
From: Jason Gao <pkill.2012@gmail.com>
To: Don Dutile <ddutile@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 5:54 AM, Don Dutile <ddutile@redhat.com> wrote:
> mptsas or smi fw has to be different....
this server:
# inventory_firmware
Wait while we inventory system:
System inventory:
        BIOS = 6.3.0
        SAS/SATA Backplane 0:0 Backplane Firmware = 1.07
        PERC 6/i Integrated Controller 0 Firmware = 6.3.1-0003
        Dell OS Drivers Pack, v.6.5.3, A00 = 6.5.3
        Dell Lifecycle Controller = 1.5.5.27
        NetXtreme II BCM5709 Gigabit Ethernet rev 20 (eth1) = 7.2.20
        NetXtreme II BCM5709 Gigabit Ethernet rev 20 (eth0) = 7.2.20
        ST3600057SS Firmware = es66
        iDRAC6 = 1.92
        NetXtreme II BCM5709 Gigabit Ethernet rev 20 (eth2) = 7.2.20
        NetXtreme II BCM5709 Gigabit Ethernet rev 20 (eth3) = 7.2.20
        Dell 32 Bit Diagnostics, v.5154A0, 5154.1 = 5154a0
        System BIOS for PowerEdge R710 = 6.3.0

other servers:
# inventory_firmware
Wait while we inventory system:
System inventory:
        BIOS = 6.3.0
        SAS/SATA Backplane 0:0 Backplane Firmware = 1.07
        PERC H700 Integrated Controller 0 Firmware = 12.10.4-0001
        Dell OS Drivers Pack, 7.1.0.9, A00 = 7.1.0.9
        Dell Lifecycle Controller, 1.5.5.27, A00 = 1.5.5.27
        ST3600057SS Firmware = es65
        iDRAC6 = 1.90
        Dell 32 Bit Diagnostics, v.5154A0, 5154.
