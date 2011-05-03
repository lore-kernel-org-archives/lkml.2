Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1ECSc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 14:32:27 -0400
Received: from mx1.unsolicited.net ([173.255.193.191]:34650 "EHLO
	mx1.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab1ECSc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 14:32:26 -0400
X-Greylist: delayed 1168 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 14:32:25 EDT
Message-ID: <4DC0459E.8040206@unsolicited.net>
Date: Tue, 03 May 2011 19:12:46 +0100
From: David <david@unsolicited.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Christian Hoffmann <email@christianhoffmann.info>
CC: johnstul@us.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
References: <4DBEFCBA.3070501@christianhoffmann.info>
In-Reply-To: <4DBEFCBA.3070501@christianhoffmann.info>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/11 19:49, Christian Hoffmann wrote:
> Hi all,
>
> I have a strange hang/timeout when booting kernel 2.6.38 and newer. It hangs after a few initialization steps and then after 145 seconds, it continues to boot.
>

fwiw, mine does pretty much the same... I've been ignoring it.

May  3 17:40:50 david kernel: [    2.064787] system 00:0b: [io  0x0300-0x030f] has been reserved
May  3 17:40:50 david kernel: [    2.064791] system 00:0b: [io  0x0a30-0x0a3f] has been reserved
May  3 17:40:50 david kernel: [    2.064838] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
May  3 17:40:50 david kernel: [    2.064938] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
May  3 17:40:50 david kernel: [    2.064940] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
May  3 17:40:50 david kernel: [    2.064942] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
May  3 17:40:50 david kernel: [    2.064943] system 00:0d: [mem 0x00100000-0xdfffffff] could not be reserved
May  3 17:40:50 david kernel: [    2.064945] system 00:0d: [mem 0xfec00000-0xffffffff] could not be reserved
May  3 17:40:50 david kernel: [    2.065011] pnp: PnP ACPI: found 14 devices
May  3 17:40:50 david kernel: [    2.065012] ACPI: ACPI bus type pnp unregistered
May  3 17:40:50 david kernel: [    2.064327] Switched to NOHz mode on CPU #2
May  3 17:40:50 david kernel: [    2.065566] Switched to NOHz mode on CPU #0
May  3 17:40:50 david kernel: [    2.064334] Switched to NOHz mode on CPU #3
May  3 17:40:50 david kernel: [    2.064338] Switched to NOHz mode on CPU #1
May  3 17:40:50 david kernel: [    2.068059] pci 0000:00:01.0: PCI bridge to [bus 01-01]
May  3 17:40:50 david kernel: [    2.068061] pci 0000:00:01.0:   bridge window [io  0xc000-0xcfff]
May  3 17:40:50 david kernel: [    2.068064] pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe9fffff]
May  3 17:40:50 david kernel: [    2.068066] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
May  3 17:40:50 david kernel: [    2.068069] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
May  3 17:40:50 david kernel: [    2.068070] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
May  3 17:40:50 david kernel: [    2.068073] pci 0000:00:0a.0:   bridge window [mem 0xfea00000-0xfeafffff]
May  3 17:40:50 david kernel: [    2.068075] pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
May  3 17:40:50 david kernel: [    2.068078] pci 0000:00:14.4: PCI bridge to [bus 03-03]
May  3 17:40:50 david kernel: [    2.068080] pci 0000:00:14.4:   bridge window [io  0xe000-0xefff]
May  3 17:40:50 david kernel: [    2.068084] pci 0000:00:14.4:   bridge window [mem 0xfeb00000-0xfebfffff]
May  3 17:40:50 david kernel: [    2.068088] pci 0000:00:14.4:   bridge window [mem pref disabled]
May  3 17:40:50 david kernel: [    2.068102] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
May  3 17:40:50 david kernel: [    2.068155] NET: Registered protocol family 2
May  3 17:40:50 david kernel: [    2.068243] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
May  3 17:40:50 david kernel: [    2.068926] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
May  3 17:40:50 david kernel: [    2.070825] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
May  3 17:40:50 david kernel: [    2.071064] TCP: Hash tables configured (established 524288 bind 65536)
May  3 17:40:50 david kernel: [    2.071066] TCP reno registered
May  3 17:40:50 david kernel: [    2.071073] UDP hash table entries: 2048 (order: 4, 65536 bytes)
May  3 17:40:50 david kernel: [    2.071095] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
May  3 17:40:50 david kernel: [    2.071183] NET: Registered protocol family 1
May  3 17:40:50 david kernel: [    2.071192] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
May  3 17:40:50 david kernel: [  147.471348] PCI-DMA: Disabling AGP.
May  3 17:40:50 david kernel: [  147.471436] PCI-DMA: aperture base @ c0000000 size 65536 KB
May  3 17:40:50 david kernel: [  147.471437] PCI-DMA: using GART IOMMU.
May  3 17:40:50 david kernel: [  147.471439] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
May  3 17:40:50 david kernel: [  147.474743] audit: initializing netlink socket (disabled)
May  3 17:40:50 david kernel: [  147.474756] type=2000 audit(1304440837.469:1): initialized
May  3 17:40:50 david kernel: [  147.490902] HugeTLB registered 2 MB page size, pre-allocated 0 pages
May  3 17:40:50 david kernel: [  147.491941] VFS: Disk quotas dquot_6.5.2
May  3 17:40:50 david kernel: [  147.491973] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
May  3 17:40:50 david kernel: [  147.492452] fuse init (API version 7.16)
May  3 17:40:50 david kernel: [  147.492512] msgmni has been set to 7920
May  3 17:40:50 david kernel: [  147.492744] io scheduler noop registered
May  3 17:40:50 david kernel: [  147.492745] io scheduler deadline registered
May  3 17:40:50 david kernel: [  147.492768] io scheduler cfq registered (default)
May  3 17:40:50 david kernel: [  147.492968] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
May  3 17:40:50 david kernel: [  147.492983] pciehp: PCI Express Hot Plug Controller Driver version: 0.4

