Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203Ab1IZFcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 01:32:04 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:35770 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab1IZFcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 01:32:03 -0400
Date: Mon, 26 Sep 2011 01:31:40 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Jon Mason <mason@myri.com>
Cc: linux-kernel@vger.kernel.org, Jordan Hargrave <Jordan_Hargrave@dell.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: regression introduced by "PCI: Set PCI-E Max Payload Size on fabric" patch
Message-ID: <0900cbc2-1551-4bf6-b7fd-4273c1641651@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <CAMaF-rMFrx_hLq9u7WDL8=9fpBtKkFEiiumXH+Ps=UnRx7W9ag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.66.13.193]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> 
> 
> 
> On Fri, Sep 23, 2011 at 4:20 AM, CAI Qian < caiqian@redhat.com >
> wrote:
> 
> 
> After reverted this commit,
> 
> b03e7495a862b028294f59fc87286d6d78ee7fa1
> PCI: Set PCI-E Max Payload Size on fabric
> 
> A server with qla2xxx is able to boot the latest mainly kernel.
> 
> 
> 
> What kernel version? This should be fixed in v3.1-rc6.
It was v3.1-rc4, and confirmed it was gone for the latest -rc7 version.
It was apparently I checked out a slight old tree. Sorry for the
false alarm.

CAI Qian
> 
> 
> 
> QLogic Fibre Channel HBA Driver: 8.03.07.03-k
> qla2xxx 0000:06:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> qla2xxx 0000:06:02.0: Found an ISP2422, irq 17, iobase 0xf9dfe000
> qla2xxx 0000:06:02.0: Configuring PCI space...
> qla2xxx 0000:06:02.0: Configure NVRAM parameters...
> qla2xxx 0000:06:02.0: Verifying loaded RISC code...
> qla2xxx 0000:06:02.0: FW: Loading via request-firmware...
> qla2xxx 0000:06:02.0: Allocated (64 KB) for EFT...
> qla2xxx 0000:06:02.0: Allocated (773 KB) for firmware dump...
> scsi1 : qla2xxx
> 
> Otherwise, it hung right here.
> 
> scsi0 : ioc0: LSISAS1064E B1, FwRev=011b5700h, Ports=1, MaxQ=277,
> IRQ=19
> mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 5, phy 0,
> sas_addr 0x5000cca0007ed401
> scsi scan: INQUIRY result too short (5), using 36
> scsi 0:0:0:0: Direct-Access PQ: 0 ANSI: 0
> mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 4, phy 1,
> sas_addr 0x5000c50017501eb1
> scsi 0:0:1:0: Direct-Access IBM-ESXS ST9146803SS B536 PQ: 0 ANSI: 5
> mptsas: ioc0: attaching raid volume, channel 1, id 3
> scsi 0:1:3:0: Direct-Access LSILOGIC Logical Volume 3000 PQ: 0 ANSI:
> 2
> sd 0:1:3:0: [sda] 285155328 512-byte logical blocks: (145 GB/135 GiB)
> sd 0:1:3:0: [sda] Write Protect is off
> sd 0:1:3:0: [sda] Got wrong page
> sd 0:1:3:0: [sda] Assuming drive cache: write through
> sd 0:1:3:0: [sda] Got wrong page
> sd 0:1:3:0: [sda] Assuming drive cache: write through
> 
> CAI Qian
> 
> 
