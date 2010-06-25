Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab0FYFAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 01:00:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59475 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab0FYFAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 01:00:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: andrew hendry <andrew.hendry@gmail.com>
Subject: Re: 2.6.35-rc1 system oom, many processes killed but memory not free
Cc: kosaki.motohiro@jp.fujitsu.com,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTim7CiW-yfugZUAHZCqLvXKgt9CwolCvbLGdCLAk@mail.gmail.com>
References: <AANLkTim7CiW-yfugZUAHZCqLvXKgt9CwolCvbLGdCLAk@mail.gmail.com>
Message-Id: <20100625133542.8047.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 25 Jun 2010 14:00:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I left a 2.6.35-rc1 system, ubuntu 10.4/64 building randconfigs in a
> ramdisk overnight.
> /dev/ram0              9842848   5141780   4201068  56% /media/ramdisk

your total memory size is 8GB, but ramdisk size is 9.8GB. it's odd settings.

> 
> After about 3 hours oom killer started killing nearly all the
> processes, but the memory is still not released. Could ramdisk cause
> this? How can I find out what is still using all the memory?

Could.
but I'm unclear your case was happen by only ramdisk.
Can you remove such ramdisk at once?

> 
> cat /proc/meminfo
> MemTotal:        8187304 kB
> MemFree:          231976 kB
> Buffers:             424 kB
> Cached:            19728 kB
> SwapCached:        51144 kB
> Active:            14056 kB
> Inactive:          72592 kB
> Active(anon):      12900 kB
> Inactive(anon):    53940 kB
> Active(file):       1156 kB
> Inactive(file):    18652 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:       1986556 kB
> SwapFree:        1504676 kB
> Dirty:                 0 kB
> Writeback:         19720 kB
> AnonPages:         32884 kB
> Mapped:             4760 kB
> Shmem:                 4 kB
> Slab:              51652 kB
> SReclaimable:      28816 kB
> SUnreclaim:        22836 kB
> KernelStack:        2880 kB
> PageTables:        18484 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:     6080208 kB
> Committed_AS:    1133944 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:      350936 kB
> VmallocChunk:   34359369212 kB
> HardwareCorrupted:     0 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       2048 kB
> DirectMap4k:        7616 kB
> DirectMap2M:     8372224 kB



