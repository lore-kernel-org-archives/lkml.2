Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab2LNG4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 01:56:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51576 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab2LNG43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 01:56:29 -0500
MIME-Version: 1.0
In-Reply-To: <1355460351.2229.20.camel@ul30vt.home>
References: <CANmqhJAuLoi_Y2Hsz+UnddHXYd9TCW-7qxp3fybDayfh33Y3Zg@mail.gmail.com>
	<1355415792.2229.7.camel@ul30vt.home>
	<CANmqhJBAxzVa5Ds0gojnYDDku5UbXGwfCNC=+z3XmVonF-_j2w@mail.gmail.com>
	<1355460351.2229.20.camel@ul30vt.home>
Date: Fri, 14 Dec 2012 14:56:27 +0800
Message-ID: <CANmqhJB4=Xuho0BrfhRO1hkL6yp=BxSxQoSAUgL=eNkZgyk8SQ@mail.gmail.com>
Subject: Re: DMAR and DRHD errors[DMAR:[fault reason 06] PTE Read access is
 not set] Vt-d & intel_iommu
From: Jason Gao <pkill.2012@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 12:45 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> Is the MegaRAID firmware and system management firmware the same as
> well?  Thanks.

I'v updated  all the firmware using Dell's firmware-tools:

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

Thanks
