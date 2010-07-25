Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab0GYQLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 12:11:36 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:50047 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab0GYQLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 12:11:19 -0400
Date: Sun, 25 Jul 2010 17:56:14 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: linux-kernel@vger.kernel.org
Subject: Xorg invoked oom-killer: gfp_mask=0x0, order=0, oom_adj=0
Message-ID: <20100725155614.GH31966@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

 IRC, there was plenty of RAM available but this happened nevertheless.

  Maybe someone can tell what did really happen?

  Cheers,

    Nils

762.224601] Xorg invoked oom-killer: gfp_mask=0x0, order=0, oom_adj=0
762.224612] Xorg cpuset=/ mems_allowed=0
762.224621] Pid: 5905, comm: Xorg Tainted: G        W  2.6.32.7 #8
762.224626] Call Trace:
762.224643]  [<c10b85d0>] ? oom_kill_process+0xa0/0x290
762.224652]  [<c10b8bee>] ? select_bad_process+0x9e/0xc0
762.224660]  [<c10b8c5e>] ? __out_of_memory+0x4e/0xb0
762.224668]  [<c10b8dc3>] ? pagefault_out_of_memory+0x53/0x90
762.224679]  [<c1024d69>] ? mm_fault_error+0x39/0xc0
762.224689]  [<c10d00fa>] ? handle_mm_fault+0x17a/0x8a0
762.224700]  [<c1065e4e>] ? hrtimer_interrupt+0xee/0x230
762.224709]  [<c10250dc>] ? do_page_fault+0x2ec/0x300
762.224718]  [<c1024df0>] ? do_page_fault+0x0/0x300
762.224727]  [<c1746d56>] ? error_code+0x66/0x6c
762.224736]  [<c1024df0>] ? do_page_fault+0x0/0x300
762.224741] Mem-Info:
762.224746] DMA per-cpu:
762.224751] CPU    0: hi:    0, btch:   1 usd:   0
762.224756] CPU    1: hi:    0, btch:   1 usd:   0
762.224760] Normal per-cpu:
762.224765] CPU    0: hi:  186, btch:  31 usd: 160
762.224770] CPU    1: hi:  186, btch:  31 usd:  50
762.224774] HighMem per-cpu:
762.224779] CPU    0: hi:  186, btch:  31 usd:  76
762.224784] CPU    1: hi:  186, btch:  31 usd:  94
762.224796] active_anon:537763 inactive_anon:149804 isolated_anon:32
762.224799]  active_file:62383 inactive_file:57654 isolated_file:0
762.224801]  unevictable:105232 dirty:12 writeback:7215 unstable:0
762.224804]  free:26914 slab_reclaimable:8147 slab_unreclaimable:28974
762.224806]  mapped:43883 shmem:334718 pagetables:3487 bounce:0
762.224821] DMA free:4356kB min:64kB low:80kB high:96kB active_anon:0kB inacti
762.224833] lowmem_reserve[]: 0 867 3967 3967
762.224854] Normal free:102904kB min:3732kB low:4664kB high:5596kB active_anon
762.224867] lowmem_reserve[]: 0 0 24801 24801
762.224887] HighMem free:396kB min:512kB low:3848kB high:7184kB active_anon:19
762.224900] lowmem_reserve[]: 0 0 0 0
762.224909] DMA: 165*4kB 133*8kB 164*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512k
762.224934] Normal: 25206*4kB 4*8kB 42*16kB 5*32kB 3*64kB 0*128kB 0*256kB 0*51
762.224958] HighMem: 99*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB
762.224982] 527234 total pagecache pages
762.224986] 71142 pages in swap cache
762.224992] Swap cache stats: add 340259, delete 269117, find 18318349/1832953
762.224997] Free swap  = 1406684kB
762.225000] Total swap = 1951856kB
762.258668] 1294336 pages RAM
762.258674] 1066498 pages HighMem
762.258678] 304794 pages reserved
762.258681] 325984 pages shared
762.258685] 758050 pages non-shared
762.258692] Out of memory: kill process 10323 (sh) score 261759 or a child


