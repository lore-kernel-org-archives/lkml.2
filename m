Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab0JRB7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 21:59:46 -0400
Received: from [120.204.251.227] ([120.204.251.227]:13879 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750801Ab0JRB7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 21:59:45 -0400
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Oct 2010 21:59:43 EDT
Subject: oom_killer crash linux system
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
To: linux-kernel@vger.kernel.org, rientjes@google.com, fengguang.wu@intel.com
Cc: figo1802 <figo1802@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 09:47:39 +0800
Message-ID: <1287366459.2035.1.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Oct 2010 01:51:22.0042 (UTC) FILETIME=[F70831A0:01CB6E66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

i have a desktop run linux2.6.35 and have 2GB ram. i turn off the swap
partition, and i open huge applications , let the system eat more and
more memory.
when the system eat more than 1.7G ram, the system crashed.

i see the /var/log/message, the oom_killer had kill "xorg" processer, so
the system crashed, so why the oom_killer will select the fundamental
processer like xorg ,
 gnome and so on? why it not select my opened applications  to kill
which had eated huge memory?

Thanks !
Figo.zhang


here is the message log:

Sep 28 17:27:56 myhost kernel: Mem-Info:
Sep 28 17:27:56 myhost kernel: DMA per-cpu:
Sep 28 17:27:56 myhost kernel: CPU    0: hi:    0, btch:   1 usd:   0
Sep 28 17:27:56 myhost kernel: CPU    1: hi:    0, btch:   1 usd:   0
Sep 28 17:27:56 myhost kernel: Normal per-cpu:
Sep 28 17:27:56 myhost kernel: CPU    0: hi:  186, btch:  31 usd:   0
Sep 28 17:27:56 myhost kernel: CPU    1: hi:  186, btch:  31 usd:   0
Sep 28 17:27:56 myhost kernel: HighMem per-cpu:
Sep 28 17:27:56 myhost kernel: CPU    0: hi:  186, btch:  31 usd:   0
Sep 28 17:27:56 myhost kernel: CPU    1: hi:  186, btch:  31 usd:  30
Sep 28 17:27:56 myhost kernel: active_anon:208615 inactive_anon:72967
isolated_anon:0
Sep 28 17:27:56 myhost kernel: active_file:93203 inactive_file:100283
isolated_file:0
Sep 28 17:27:56 myhost kernel: unevictable:5 dirty:15 writeback:0
unstable:0
Sep 28 17:27:56 myhost kernel: free:11973 slab_reclaimable:4067
slab_unreclaimable:3996
Sep 28 17:27:56 myhost kernel: mapped:85844 shmem:47072 pagetables:1776
bounce:0
Sep 28 17:27:56 myhost kernel: DMA free:7972kB min:64kB low:80kB
high:96kB active_anon:1536kB inactive_anon:3972kB active_file:1076kB
inactive_file:1232kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15788kB mlocked:0kB dirty:0kB writeback:0kB
mapped:1144kB shmem:3104kB slab_reclaimable:24kB slab_unreclaimable:16kB
kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Sep 28 17:27:56 myhost kernel: lowmem_reserve[]: 0 865 1980 1980
Sep 28 17:27:56 myhost kernel: Normal free:39448kB min:3728kB low:4660kB
high:5592kB active_anon:326192kB inactive_anon:104140kB
active_file:165600kB inactive_file:165936kB unevictable:20kB
isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:20kB
dirty:0kB writeback:0kB mapped:142524kB shmem:62444kB
slab_reclaimable:16244kB slab_unreclaimable:15968kB kernel_stack:2664kB
pagetables:7104kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
Sep 28 17:27:56 myhost kernel: lowmem_reserve[]: 0 0 8921 8921
Sep 28 17:27:56 myhost kernel: HighMem free:472kB min:512kB low:1712kB
high:2912kB active_anon:506732kB inactive_anon:183756kB
active_file:206136kB inactive_file:233964kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:1141984kB mlocked:0kB
dirty:124kB writeback:0kB mapped:199708kB shmem:122740kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
Sep 28 17:27:56 myhost kernel: lowmem_reserve[]: 0 0 0 0
Sep 28 17:27:56 myhost kernel: DMA: 5*4kB 8*8kB 39*16kB 43*32kB 16*64kB
6*128kB 6*256kB 1*512kB 2*1024kB 0*2048kB 0*4096kB = 7972kB
Sep 28 17:27:56 myhost kernel: Normal: 292*4kB 107*8kB 1161*16kB
199*32kB 45*64kB 31*128kB 8*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB =
39448kB
Sep 28 17:27:56 myhost kernel: HighMem: 4*4kB 0*8kB 1*16kB 4*32kB 5*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 480kB
Sep 28 17:27:56 myhost kernel: 240589 total pagecache pages
Sep 28 17:27:56 myhost kernel: 0 pages in swap cache
Sep 28 17:27:56 myhost kernel: Swap cache stats: add 0, delete 0, find
0/0
Sep 28 17:27:56 myhost kernel: Free swap  = 0kB
Sep 28 17:27:56 myhost kernel: Total swap = 0kB
Sep 28 17:27:56 myhost kernel: 515070 pages RAM
Sep 28 17:27:56 myhost kernel: 287745 pages HighMem
Sep 28 17:27:56 myhost kernel: 8280 pages reserved
Sep 28 17:27:56 myhost kernel: 433443 pages shared
Sep 28 17:27:56 myhost kernel: 284256 pages non-shared
Sep 28 17:28:10 myhost kernel: Xorg invoked oom-killer: gfp_mask=0x80d2,
order=0, oom_adj=0
Sep 28 17:28:10 myhost kernel: Xorg cpuset=/ mems_allowed=0
Sep 28 17:28:10 myhost kernel: Pid: 1586, comm: Xorg Not tainted
2.6.35-ARCH #1
Sep 28 17:28:10 myhost kernel: Call Trace:
Sep 28 17:28:10 myhost kernel: [<c10c00c9>] dump_header+0x69/0x1a0
Sep 28 17:28:10 myhost kernel: [<c11886c9>] ? ___ratelimit+0x89/0x110
Sep 28 17:28:10 myhost kernel: [<c10c0254>] oom_kill_process+0x54/0x140
Sep 28 17:28:10 myhost kernel: [<c10c064e>] ? select_bad_process
+0x9e/0xd0
Sep 28 17:28:10 myhost kernel: [<c10c06d1>] __out_of_memory+0x51/0xb0
Sep 28 17:28:10 myhost kernel: [<c10c09c2>] out_of_memory+0x52/0xd0
Sep 28 17:28:10 myhost kernel: [<c10c4022>] __alloc_pages_nodemask
+0x5e2/0x600
Sep 28 17:28:10 myhost kernel: [<c10dfed6>] __vmalloc_area_node
+0x76/0x100
Sep 28 17:28:10 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:10 myhost kernel: [<c10dfffa>] __vmalloc_node+0x9a/0xa0
Sep 28 17:28:10 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:10 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:10 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:10 myhost kernel: [<c10e0155>] __vmalloc+0x25/0x30
Sep 28 17:28:10 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:10 myhost kernel: [<f8613aa7>] i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:10 myhost kernel: [<f8461457>] ? drm_mm_get_block_generic
+0x37/0x90 [drm]
Sep 28 17:28:10 myhost kernel: [<f8615161>] i915_gem_object_bind_to_gtt
+0xf1/0x260 [i915]
Sep 28 17:28:10 myhost kernel: [<c12e817a>] ? __mutex_lock_slowpath
+0x1ea/0x2b0
Sep 28 17:28:10 myhost kernel: [<f8616897>] i915_gem_object_pin
+0xc7/0xf0 [i915]
Sep 28 17:28:10 myhost kernel: [<f8616ecd>] i915_gem_do_execbuffer
+0x4ed/0x1090 [i915]
Sep 28 17:28:10 myhost kernel: [<f861638f>] ?
i915_gem_object_set_to_gtt_domain+0x4f/0x100 [i915]
Sep 28 17:28:10 myhost kernel: [<c118d862>] ? _copy_from_user+0x32/0x50
Sep 28 17:28:10 myhost kernel: [<f8617ae7>] i915_gem_execbuffer2
+0x77/0x1e0 [i915]
Sep 28 17:28:10 myhost kernel: [<f8458308>] drm_ioctl+0x1b8/0x460 [drm]
Sep 28 17:28:10 myhost kernel: [<f8617a70>] ? i915_gem_execbuffer2
+0x0/0x1e0 [i915]
Sep 28 17:28:10 myhost kernel: [<c10f672c>] ? do_sync_read+0x9c/0xd0
Sep 28 17:28:10 myhost kernel: [<c11048e4>] vfs_ioctl+0x34/0xa0
Sep 28 17:28:10 myhost kernel: [<f8458150>] ? drm_ioctl+0x0/0x460 [drm]
Sep 28 17:28:10 myhost kernel: [<c1104ff6>] do_vfs_ioctl+0x66/0x560
Sep 28 17:28:10 myhost kernel: [<c115d93f>] ? security_file_permission
+0xf/0x20
Sep 28 17:28:10 myhost kernel: [<c10f6a3d>] ? rw_verify_area+0x5d/0xd0
Sep 28 17:28:10 myhost kernel: [<c10f6f8d>] ? vfs_read+0x11d/0x180
Sep 28 17:28:10 myhost kernel: [<c110554f>] sys_ioctl+0x5f/0x80
Sep 28 17:28:10 myhost kernel: [<c100379f>] sysenter_do_call+0x12/0x28
Sep 28 17:28:10 myhost kernel: Mem-Info:
Sep 28 17:28:10 myhost kernel: DMA per-cpu:
Sep 28 17:28:10 myhost kernel: CPU    0: hi:    0, btch:   1 usd:   0
Sep 28 17:28:10 myhost kernel: CPU    1: hi:    0, btch:   1 usd:   0
Sep 28 17:28:10 myhost kernel: Normal per-cpu:
Sep 28 17:28:10 myhost kernel: CPU    0: hi:  186, btch:  31 usd:   9
Sep 28 17:28:10 myhost kernel: CPU    1: hi:  186, btch:  31 usd:  30
Sep 28 17:28:10 myhost kernel: HighMem per-cpu:
Sep 28 17:28:10 myhost kernel: CPU    0: hi:  186, btch:  31 usd:   2
Sep 28 17:28:10 myhost kernel: CPU    1: hi:  186, btch:  31 usd:  30
Sep 28 17:28:10 myhost kernel: active_anon:209750 inactive_anon:72131
isolated_anon:0
Sep 28 17:28:10 myhost kernel: active_file:93065 inactive_file:100131
isolated_file:0
Sep 28 17:28:10 myhost kernel: unevictable:5 dirty:12 writeback:18
unstable:0
Sep 28 17:28:10 myhost kernel: free:11950 slab_reclaimable:4061
slab_unreclaimable:3996
Sep 28 17:28:10 myhost kernel: mapped:85924 shmem:47752 pagetables:1765
bounce:0
Sep 28 17:28:10 myhost kernel: DMA free:7972kB min:64kB low:80kB
high:96kB active_anon:1536kB inactive_anon:3980kB active_file:1076kB
inactive_file:1232kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15788kB mlocked:0kB dirty:0kB writeback:0kB
mapped:1144kB shmem:3112kB slab_reclaimable:24kB slab_unreclaimable:16kB
kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:3744 all_unreclaimable? yes
Sep 28 17:28:10 myhost kernel: lowmem_reserve[]: 0 865 1980 1980
Sep 28 17:28:10 myhost kernel: Normal free:39360kB min:3728kB low:4660kB
high:5592kB active_anon:330892kB inactive_anon:100024kB
active_file:165300kB inactive_file:165724kB unevictable:20kB
isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:20kB
dirty:32kB writeback:80kB mapped:142300kB shmem:63064kB
slab_reclaimable:16220kB slab_unreclaimable:15968kB kernel_stack:2648kB
pagetables:7060kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:500960 all_unreclaimable? yes
Sep 28 17:28:10 myhost kernel: lowmem_reserve[]: 0 0 8921 8921
Sep 28 17:28:10 myhost kernel: HighMem free:468kB min:512kB low:1712kB
high:2912kB active_anon:506572kB inactive_anon:184520kB
active_file:205884kB inactive_file:233568kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:1141984kB mlocked:0kB
dirty:16kB writeback:0kB mapped:200252kB shmem:124832kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:697088 all_unreclaimable? yes
Sep 28 17:28:10 myhost kernel: lowmem_reserve[]: 0 0 0 0
Sep 28 17:28:10 myhost kernel: DMA: 5*4kB 8*8kB 39*16kB 43*32kB 16*64kB
6*128kB 6*256kB 1*512kB 2*1024kB 0*2048kB 0*4096kB = 7972kB
Sep 28 17:28:10 myhost kernel: Normal: 440*4kB 124*8kB 1160*16kB
198*32kB 45*64kB 25*128kB 8*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB =
39360kB
Sep 28 17:28:10 myhost kernel: HighMem: 17*4kB 0*8kB 3*16kB 3*32kB
2*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 468kB
Sep 28 17:28:10 myhost kernel: 240978 total pagecache pages
Sep 28 17:28:10 myhost kernel: 0 pages in swap cache
Sep 28 17:28:10 myhost kernel: Swap cache stats: add 0, delete 0, find
0/0
Sep 28 17:28:10 myhost kernel: Free swap  = 0kB
Sep 28 17:28:10 myhost kernel: Total swap = 0kB
Sep 28 17:28:10 myhost kernel: 515070 pages RAM
Sep 28 17:28:10 myhost kernel: 287745 pages HighMem
Sep 28 17:28:10 myhost kernel: 8280 pages reserved
Sep 28 17:28:10 myhost kernel: 430061 pages shared
Sep 28 17:28:10 myhost kernel: 286215 pages non-shared
Sep 28 17:28:40 myhost kernel: conky invoked oom-killer:
gfp_mask=0x280da, order=0, oom_adj=0
Sep 28 17:28:40 myhost kernel: conky cpuset=/ mems_allowed=0
Sep 28 17:28:40 myhost kernel: Pid: 28231, comm: conky Not tainted
2.6.35-ARCH #1
Sep 28 17:28:40 myhost kernel: Call Trace:
Sep 28 17:28:40 myhost kernel: [<c10c00c9>] dump_header+0x69/0x1a0
Sep 28 17:28:40 myhost kernel: [<c11886c9>] ? ___ratelimit+0x89/0x110
Sep 28 17:28:40 myhost kernel: [<c10c0254>] oom_kill_process+0x54/0x140
Sep 28 17:28:40 myhost kernel: [<c10c064e>] ? select_bad_process
+0x9e/0xd0
Sep 28 17:28:40 myhost kernel: [<c10c06d1>] __out_of_memory+0x51/0xb0
Sep 28 17:28:40 myhost kernel: [<c10c09c2>] out_of_memory+0x52/0xd0
Sep 28 17:28:40 myhost kernel: [<c10c4022>] __alloc_pages_nodemask
+0x5e2/0x600
Sep 28 17:28:40 myhost kernel: [<c10d6c65>] handle_mm_fault+0x665/0x8f0
Sep 28 17:28:40 myhost kernel: [<c1028a20>] ? do_page_fault+0x0/0x3b0
Sep 28 17:28:40 myhost kernel: [<c1028b70>] do_page_fault+0x150/0x3b0
Sep 28 17:28:40 myhost kernel: [<c1028a20>] ? do_page_fault+0x0/0x3b0
Sep 28 17:28:40 myhost kernel: [<c12e9fa3>] error_code+0x73/0x78
Sep 28 17:28:40 myhost kernel: [<c118d3c0>] ? __copy_to_user_ll
+0x40/0x70
Sep 28 17:28:40 myhost kernel: [<c118d8ae>] copy_to_user+0x2e/0x50
Sep 28 17:28:40 myhost kernel: [<c1110cbd>] seq_read+0x24d/0x3f0
Sep 28 17:28:40 myhost kernel: [<c10da11d>] ? mmap_region+0x15d/0x400
Sep 28 17:28:40 myhost kernel: [<c1110a70>] ? seq_read+0x0/0x3f0
Sep 28 17:28:40 myhost kernel: [<c1139afe>] proc_reg_read+0x5e/0x90
Sep 28 17:28:40 myhost kernel: [<c10f6f07>] vfs_read+0x97/0x180
Sep 28 17:28:40 myhost kernel: [<c1139aa0>] ? proc_reg_read+0x0/0x90
Sep 28 17:28:40 myhost kernel: [<c10f702d>] sys_read+0x3d/0x70
Sep 28 17:28:40 myhost kernel: [<c100379f>] sysenter_do_call+0x12/0x28
Sep 28 17:28:40 myhost kernel: Mem-Info:
Sep 28 17:28:40 myhost kernel: DMA per-cpu:
Sep 28 17:28:40 myhost kernel: CPU    0: hi:    0, btch:   1 usd:   0
Sep 28 17:28:40 myhost kernel: CPU    1: hi:    0, btch:   1 usd:   0
Sep 28 17:28:40 myhost kernel: Normal per-cpu:
Sep 28 17:28:40 myhost kernel: CPU    0: hi:  186, btch:  31 usd:   2
Sep 28 17:28:40 myhost kernel: CPU    1: hi:  186, btch:  31 usd:  30
Sep 28 17:28:40 myhost kernel: HighMem per-cpu:
Sep 28 17:28:40 myhost kernel: CPU    0: hi:  186, btch:  31 usd:   1
Sep 28 17:28:40 myhost kernel: CPU    1: hi:  186, btch:  31 usd:  30
Sep 28 17:28:40 myhost kernel: active_anon:209853 inactive_anon:72409
isolated_anon:0
Sep 28 17:28:40 myhost kernel: active_file:93594 inactive_file:99962
isolated_file:32
Sep 28 17:28:40 myhost kernel: unevictable:5 dirty:0 writeback:0
unstable:0
Sep 28 17:28:40 myhost kernel: free:11938 slab_reclaimable:4089
slab_unreclaimable:3994
Sep 28 17:28:40 myhost kernel: mapped:86446 shmem:48138 pagetables:1765
bounce:0
Sep 28 17:28:40 myhost kernel: DMA free:7972kB min:64kB low:80kB
high:96kB active_anon:1596kB inactive_anon:3864kB active_file:1092kB
inactive_file:1228kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15788kB mlocked:0kB dirty:0kB writeback:0kB
mapped:1160kB shmem:2996kB slab_reclaimable:24kB slab_unreclaimable:16kB
kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:3808 all_unreclaimable? yes
Sep 28 17:28:40 myhost kernel: lowmem_reserve[]: 0 865 1980 1980
Sep 28 17:28:40 myhost kernel: Normal free:39324kB min:3728kB low:4660kB
high:5592kB active_anon:327108kB inactive_anon:104096kB
active_file:165324kB inactive_file:165648kB unevictable:20kB
isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:20kB
dirty:0kB writeback:0kB mapped:142348kB shmem:62508kB
slab_reclaimable:16332kB slab_unreclaimable:15960kB kernel_stack:2632kB
pagetables:7060kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:547296 all_unreclaimable? no
Sep 28 17:28:40 myhost kernel: lowmem_reserve[]: 0 0 8921 8921
Sep 28 17:28:40 myhost kernel: HighMem free:456kB min:512kB low:1712kB
high:2912kB active_anon:510708kB inactive_anon:181676kB
active_file:207960kB inactive_file:233072kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:1141984kB mlocked:0kB
dirty:0kB writeback:0kB mapped:202276kB shmem:127048kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:667264 all_unreclaimable? yes
Sep 28 17:28:40 myhost kernel: lowmem_reserve[]: 0 0 0 0
Sep 28 17:28:40 myhost kernel: DMA: 7*4kB 11*8kB 31*16kB 42*32kB 16*64kB
7*128kB 6*256kB 1*512kB 2*1024kB 0*2048kB 0*4096kB = 7972kB
Sep 28 17:28:40 myhost kernel: Normal: 430*4kB 163*8kB 1102*16kB
199*32kB 45*64kB 30*128kB 8*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB =
39376kB
Sep 28 17:28:40 myhost kernel: HighMem: 2*4kB 0*8kB 4*16kB 4*32kB 2*64kB
1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 456kB
Sep 28 17:28:40 myhost kernel: 241743 total pagecache pages
Sep 28 17:28:40 myhost kernel: 0 pages in swap cache
Sep 28 17:28:40 myhost kernel: Swap cache stats: add 0, delete 0, find
0/0
Sep 28 17:28:40 myhost kernel: Free swap  = 0kB
Sep 28 17:28:40 myhost kernel: Total swap = 0kB
Sep 28 17:28:40 myhost kernel: 515070 pages RAM
Sep 28 17:28:40 myhost kernel: 287745 pages HighMem
Sep 28 17:28:40 myhost kernel: 8280 pages reserved
Sep 28 17:28:40 myhost kernel: 434921 pages shared
Sep 28 17:28:40 myhost kernel: 282424 pages non-shared
Sep 28 17:28:42 myhost kernel: Xorg invoked oom-killer: gfp_mask=0x80d2,
order=0, oom_adj=0
Sep 28 17:28:42 myhost kernel: Xorg cpuset=/ mems_allowed=0
Sep 28 17:28:42 myhost kernel: Pid: 1586, comm: Xorg Not tainted
2.6.35-ARCH #1
Sep 28 17:28:42 myhost kernel: Call Trace:
Sep 28 17:28:42 myhost kernel: [<c10c00c9>] dump_header+0x69/0x1a0
Sep 28 17:28:42 myhost kernel: [<c11886c9>] ? ___ratelimit+0x89/0x110
Sep 28 17:28:42 myhost kernel: [<c10c0254>] oom_kill_process+0x54/0x140
Sep 28 17:28:42 myhost kernel: [<c10c064e>] ? select_bad_process
+0x9e/0xd0
Sep 28 17:28:42 myhost kernel: [<c10c06d1>] __out_of_memory+0x51/0xb0
Sep 28 17:28:42 myhost kernel: [<c10c09c2>] out_of_memory+0x52/0xd0
Sep 28 17:28:42 myhost kernel: [<c10c4022>] __alloc_pages_nodemask
+0x5e2/0x600
Sep 28 17:28:42 myhost kernel: [<c10dfed6>] __vmalloc_area_node
+0x76/0x100
Sep 28 17:28:42 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:42 myhost kernel: [<c10dfffa>] __vmalloc_node+0x9a/0xa0
Sep 28 17:28:42 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:42 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:42 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:42 myhost kernel: [<c10e0155>] __vmalloc+0x25/0x30
Sep 28 17:28:42 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:42 myhost kernel: [<f8613aa7>] i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:42 myhost kernel: [<f8461457>] ? drm_mm_get_block_generic
+0x37/0x90 [drm]
Sep 28 17:28:42 myhost kernel: [<f8615161>] i915_gem_object_bind_to_gtt
+0xf1/0x260 [i915]
Sep 28 17:28:42 myhost kernel: [<c12e817a>] ? __mutex_lock_slowpath
+0x1ea/0x2b0
Sep 28 17:28:42 myhost kernel: [<f8616897>] i915_gem_object_pin
+0xc7/0xf0 [i915]
Sep 28 17:28:42 myhost kernel: [<f8616ecd>] i915_gem_do_execbuffer
+0x4ed/0x1090 [i915]
Sep 28 17:28:42 myhost kernel: [<f861638f>] ?
i915_gem_object_set_to_gtt_domain+0x4f/0x100 [i915]
Sep 28 17:28:42 myhost kernel: [<f8617ab5>] ? i915_gem_execbuffer2
+0x45/0x1e0 [i915]
Sep 28 17:28:42 myhost kernel: [<c118d862>] ? _copy_from_user+0x32/0x50
Sep 28 17:28:42 myhost kernel: [<f8617ae7>] i915_gem_execbuffer2
+0x77/0x1e0 [i915]
Sep 28 17:28:42 myhost kernel: [<f8458308>] drm_ioctl+0x1b8/0x460 [drm]
Sep 28 17:28:42 myhost kernel: [<f8617a70>] ? i915_gem_execbuffer2
+0x0/0x1e0 [i915]
Sep 28 17:28:42 myhost kernel: [<c115d93f>] ? security_file_permission
+0xf/0x20
Sep 28 17:28:42 myhost kernel: [<c10f6a3d>] ? rw_verify_area+0x5d/0xd0
Sep 28 17:28:42 myhost kernel: [<c11048e4>] vfs_ioctl+0x34/0xa0
Sep 28 17:28:42 myhost kernel: [<f8458150>] ? drm_ioctl+0x0/0x460 [drm]
Sep 28 17:28:42 myhost kernel: [<c1104ff6>] do_vfs_ioctl+0x66/0x560
Sep 28 17:28:42 myhost kernel: [<c10625c2>] ? lock_hrtimer_base.clone.21
+0x22/0x50
Sep 28 17:28:42 myhost kernel: [<c10626b7>] ? hrtimer_try_to_cancel
+0x77/0xd0
Sep 28 17:28:42 myhost kernel: [<c1048434>] ? do_setitimer+0x154/0x200
Sep 28 17:28:42 myhost kernel: [<c104858c>] ? sys_setitimer+0x4c/0xa0
Sep 28 17:28:42 myhost kernel: [<c110554f>] sys_ioctl+0x5f/0x80
Sep 28 17:28:42 myhost kernel: [<c100379f>] sysenter_do_call+0x12/0x28
Sep 28 17:28:42 myhost kernel: Mem-Info:
Sep 28 17:28:42 myhost kernel: DMA per-cpu:
Sep 28 17:28:42 myhost kernel: CPU    0: hi:    0, btch:   1 usd:   0
Sep 28 17:28:42 myhost kernel: CPU    1: hi:    0, btch:   1 usd:   0
Sep 28 17:28:42 myhost kernel: Normal per-cpu:
Sep 28 17:28:42 myhost kernel: CPU    0: hi:  186, btch:  31 usd:   1
Sep 28 17:28:42 myhost kernel: CPU    1: hi:  186, btch:  31 usd:  42
Sep 28 17:28:42 myhost kernel: HighMem per-cpu:
Sep 28 17:28:42 myhost kernel: CPU    0: hi:  186, btch:  31 usd:   0
Sep 28 17:28:42 myhost kernel: CPU    1: hi:  186, btch:  31 usd:  32
Sep 28 17:28:42 myhost kernel: active_anon:209044 inactive_anon:73210
isolated_anon:0
Sep 28 17:28:42 myhost kernel: active_file:93609 inactive_file:99939
isolated_file:32
Sep 28 17:28:42 myhost kernel: unevictable:5 dirty:0 writeback:0
unstable:0
Sep 28 17:28:42 myhost kernel: free:11947 slab_reclaimable:4057
slab_unreclaimable:3984
Sep 28 17:28:42 myhost kernel: mapped:86447 shmem:48674 pagetables:1735
bounce:0
Sep 28 17:28:42 myhost kernel: DMA free:7972kB min:64kB low:80kB
high:96kB active_anon:1596kB inactive_anon:3864kB active_file:1092kB
inactive_file:1228kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15788kB mlocked:0kB dirty:0kB writeback:0kB
mapped:1160kB shmem:2996kB slab_reclaimable:24kB slab_unreclaimable:16kB
kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:3648 all_unreclaimable? yes
Sep 28 17:28:42 myhost kernel: lowmem_reserve[]: 0 865 1980 1980
Sep 28 17:28:42 myhost kernel: Normal free:39304kB min:3728kB low:4660kB
high:5592kB active_anon:324036kB inactive_anon:107432kB
active_file:165332kB inactive_file:165540kB unevictable:20kB
isolated(anon):0kB isolated(file):128kB present:885944kB mlocked:20kB
dirty:0kB writeback:0kB mapped:142356kB shmem:62772kB
slab_reclaimable:16204kB slab_unreclaimable:15920kB kernel_stack:2624kB
pagetables:6940kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:644096 all_unreclaimable? yes
Sep 28 17:28:42 myhost kernel: lowmem_reserve[]: 0 0 8921 8921
Sep 28 17:28:42 myhost kernel: HighMem free:512kB min:512kB low:1712kB
high:2912kB active_anon:510544kB inactive_anon:181544kB
active_file:208012kB inactive_file:232988kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:1141984kB mlocked:0kB
dirty:0kB writeback:0kB mapped:202272kB shmem:128928kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:667424 all_unreclaimable? yes
Sep 28 17:28:42 myhost kernel: lowmem_reserve[]: 0 0 0 0
Sep 28 17:28:42 myhost kernel: DMA: 7*4kB 11*8kB 31*16kB 42*32kB 16*64kB
7*128kB 6*256kB 1*512kB 2*1024kB 0*2048kB 0*4096kB = 7972kB
Sep 28 17:28:42 myhost kernel: Normal: 446*4kB 162*8kB 1106*16kB
197*32kB 45*64kB 29*128kB 8*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB =
39304kB
Sep 28 17:28:42 myhost kernel: HighMem: 48*4kB 0*8kB 0*16kB 4*32kB
3*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 512kB
Sep 28 17:28:42 myhost kernel: 242288 total pagecache pages
Sep 28 17:28:42 myhost kernel: 0 pages in swap cache
Sep 28 17:28:42 myhost kernel: Swap cache stats: add 0, delete 0, find
0/0
Sep 28 17:28:42 myhost kernel: Free swap  = 0kB
Sep 28 17:28:42 myhost kernel: Total swap = 0kB
Sep 28 17:28:42 myhost kernel: 515070 pages RAM
Sep 28 17:28:42 myhost kernel: 287745 pages HighMem
Sep 28 17:28:42 myhost kernel: 8280 pages reserved
Sep 28 17:28:42 myhost kernel: 430124 pages shared
Sep 28 17:28:42 myhost kernel: 285406 pages non-shared
Sep 28 17:28:42 myhost kernel: Xorg invoked oom-killer: gfp_mask=0x80d2,
order=0, oom_adj=0
Sep 28 17:28:42 myhost kernel: Xorg cpuset=/ mems_allowed=0
Sep 28 17:28:42 myhost kernel: Pid: 1586, comm: Xorg Not tainted
2.6.35-ARCH #1
Sep 28 17:28:42 myhost kernel: Call Trace:
Sep 28 17:28:42 myhost kernel: [<c10c00c9>] dump_header+0x69/0x1a0
Sep 28 17:28:42 myhost kernel: [<c11886c9>] ? ___ratelimit+0x89/0x110
Sep 28 17:28:42 myhost kernel: [<c10c0254>] oom_kill_process+0x54/0x140
Sep 28 17:28:42 myhost kernel: [<c10c064e>] ? select_bad_process
+0x9e/0xd0
Sep 28 17:28:42 myhost kernel: [<c10c06d1>] __out_of_memory+0x51/0xb0
Sep 28 17:28:42 myhost kernel: [<c10c09c2>] out_of_memory+0x52/0xd0
Sep 28 17:28:42 myhost kernel: [<c10c4022>] __alloc_pages_nodemask
+0x5e2/0x600
Sep 28 17:28:42 myhost kernel: [<c10dfed6>] __vmalloc_area_node
+0x76/0x100
Sep 28 17:28:42 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:42 myhost kernel: [<c10dfffa>] __vmalloc_node+0x9a/0xa0
Sep 28 17:28:42 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:42 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:42 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:42 myhost kernel: [<c10e0155>] __vmalloc+0x25/0x30
Sep 28 17:28:42 myhost kernel: [<f8613aa7>] ? i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:42 myhost kernel: [<f8613aa7>] i915_gem_object_get_pages
+0xf7/0x1c0 [i915]
Sep 28 17:28:42 myhost kernel: [<f8461457>] ? drm_mm_get_block_generic
+0x37/0x90 [drm]
Sep 28 17:28:42 myhost kernel: [<f8615161>] i915_gem_object_bind_to_gtt
+0xf1/0x260 [i915]
Sep 28 17:28:42 myhost kernel: [<c12e817a>] ? __mutex_lock_slowpath
+0x1ea/0x2b0
Sep 28 17:28:42 myhost kernel: [<f8616897>] i915_gem_object_pin
+0xc7/0xf0 [i915]
Sep 28 17:28:42 myhost kernel: [<f8616ecd>] i915_gem_do_execbuffer
+0x4ed/0x1090 [i915]
Sep 28 17:28:42 myhost kernel: [<f861638f>] ?
i915_gem_object_set_to_gtt_domain+0x4f/0x100 [i915]
Sep 28 17:28:42 myhost kernel: [<f8617ab5>] ? i915_gem_execbuffer2
+0x45/0x1e0 [i915]
Sep 28 17:28:42 myhost kernel: [<c118d862>] ? _copy_from_user+0x32/0x50
Sep 28 17:28:42 myhost kernel: [<f8617ae7>] i915_gem_execbuffer2
+0x77/0x1e0 [i915]
Sep 28 17:28:42 myhost kernel: [<f8458308>] drm_ioctl+0x1b8/0x460 [drm]
Sep 28 17:28:42 myhost kernel: [<f8617a70>] ? i915_gem_execbuffer2
+0x0/0x1e0 [i915]
Sep 28 17:28:42 myhost kernel: [<c115d93f>] ? security_file_permission
+0xf/0x20
Sep 28 17:28:42 myhost kernel: [<c10f6a3d>] ? rw_verify_area+0x5d/0xd0
Sep 28 17:28:42 myhost kernel: [<c11048e4>] vfs_ioctl+0x34/0xa0
Sep 28 17:28:42 myhost kernel: [<f8458150>] ? drm_ioctl+0x0/0x460 [drm]
Sep 28 17:28:42 myhost kernel: [<c1104ff6>] do_vfs_ioctl+0x66/0x560
Sep 28 17:28:42 myhost kernel: [<c10625c2>] ? lock_hrtimer_base.clone.21
+0x22/0x50
Sep 28 17:28:42 myhost kernel: [<c10626b7>] ? hrtimer_try_to_cancel
+0x77/0xd0
Sep 28 17:28:42 myhost kernel: [<c1048434>] ? do_setitimer+0x154/0x200
Sep 28 17:28:42 myhost kernel: [<c104858c>] ? sys_setitimer+0x4c/0xa0
Sep 28 17:28:42 myhost kernel: [<c110554f>] sys_ioctl+0x5f/0x80
Sep 28 17:28:42 myhost kernel: [<c100379f>] sysenter_do_call+0x12/0x28
Sep 28 17:28:42 myhost kernel: Mem-Info:
Sep 28 17:28:42 myhost kernel: DMA per-cpu:
Sep 28 17:28:42 myhost kernel: CPU    0: hi:    0, btch:   1 usd:   0
Sep 28 17:28:42 myhost kernel: CPU    1: hi:    0, btch:   1 usd:   0
Sep 28 17:28:42 myhost kernel: Normal per-cpu:
Sep 28 17:28:42 myhost kernel: CPU    0: hi:  186, btch:  31 usd:   1
Sep 28 17:28:42 myhost kernel: CPU    1: hi:  186, btch:  31 usd:  42
Sep 28 17:28:42 myhost kernel: HighMem per-cpu:
Sep 28 17:28:42 myhost kernel: CPU    0: hi:  186, btch:  31 usd:   0
Sep 28 17:28:42 myhost kernel: CPU    1: hi:  186, btch:  31 usd:  32
Sep 28 17:28:42 myhost kernel: active_anon:209044 inactive_anon:73210
isolated_anon:0
Sep 28 17:28:42 myhost kernel: active_file:93609 inactive_file:99964
isolated_file:0
Sep 28 17:28:42 myhost kernel: unevictable:5 dirty:0 writeback:0
unstable:0
Sep 28 17:28:42 myhost kernel: free:11947 slab_reclaimable:4057
slab_unreclaimable:3984
Sep 28 17:28:42 myhost kernel: mapped:86447 shmem:48674 pagetables:1735
bounce:0
Sep 28 17:28:42 myhost kernel: DMA free:7972kB min:64kB low:80kB
high:96kB active_anon:1596kB inactive_anon:3864kB active_file:1092kB
inactive_file:1228kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:15788kB mlocked:0kB dirty:0kB writeback:0kB
mapped:1160kB shmem:2996kB slab_reclaimable:24kB slab_unreclaimable:16kB
kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:3648 all_unreclaimable? yes
Sep 28 17:28:42 myhost kernel: lowmem_reserve[]: 0 865 1980 1980
Sep 28 17:28:42 myhost kernel: Normal free:39304kB min:3728kB low:4660kB
high:5592kB active_anon:324036kB inactive_anon:107432kB
active_file:165332kB inactive_file:165640kB unevictable:20kB
isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:20kB
dirty:0kB writeback:0kB mapped:142356kB shmem:62772kB
slab_reclaimable:16204kB slab_unreclaimable:15920kB kernel_stack:2624kB
pagetables:6940kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:644864 all_unreclaimable? yes
Sep 28 17:28:42 myhost kernel: lowmem_reserve[]: 0 0 8921 8921
Sep 28 17:28:42 myhost kernel: HighMem free:512kB min:512kB low:1712kB
high:2912kB active_anon:510544kB inactive_anon:181544kB
active_file:208012kB inactive_file:232988kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:1141984kB mlocked:0kB
dirty:0kB writeback:0kB mapped:202272kB shmem:128928kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:667488 all_unreclaimable? yes
Sep 28 17:28:42 myhost kernel: lowmem_reserve[]: 0 0 0 0
Sep 28 17:28:42 myhost kernel: DMA: 7*4kB 11*8kB 31*16kB 42*32kB 16*64kB
7*128kB 6*256kB 1*512kB 2*1024kB 0*2048kB 0*4096kB = 7972kB
Sep 28 17:28:42 myhost kernel: Normal: 446*4kB 162*8kB 1106*16kB
197*32kB 45*64kB 29*128kB 8*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB =
39304kB
Sep 28 17:28:42 myhost kernel: HighMem: 48*4kB 0*8kB 0*16kB 4*32kB
3*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 512kB
Sep 28 17:28:42 myhost kernel: 242288 total pagecache pages
Sep 28 17:28:42 myhost kernel: 0 pages in swap cache
Sep 28 17:28:42 myhost kernel: Swap cache stats: add 0, delete 0, find
0/0
Sep 28 17:28:42 myhost kernel: Free swap  = 0kB
Sep 28 17:28:42 myhost kernel: Total swap = 0kB
Sep 28 17:28:42 myhost kernel: 515070 pages RAM
Sep 28 17:28:42 myhost kernel: 287745 pages HighMem
Sep 28 17:28:42 myhost kernel: 8280 pages reserved
Sep 28 17:28:42 myhost kernel: 430123 pages shared
Sep 28 17:28:42 myhost kernel: 285406 pages non-shared
Sep 28 17:28:42 myhost kernel: device eth0 left promiscuous mode
Sep 28 17:28:42 myhost kernel: bridge-eth0: disabled promiscuous mode
Sep 28 17:29:11 myhost cntlm[1523]: Connection accepted from
127.0.0.1:55605
Sep 28 17:29:23 myhost cntlm[1523]: Connection accepted from
127.0.0.1:55607
Sep 28 17:29:53 myhost chmsee: Libgcrypt warning: missing initialization
- please fix the application
Sep 28 17:30:18 myhost cntlm[1523]: Connection accepted from
127.0.0.1:55619
Sep 28 17:30:21 myhost cntlm[1523]: Connection accepted from
127.0.0.1:55621
Sep 28 17:30:25 myhost cntlm[1523]: The request was denied!
Sep 28 17:31:48 myhost cntlm[1523]: Connection accepted from
127.0.0.1:37870
Sep 28 17:34:16 myhost kernel: i915          D f6639f00     0  1003
2 0x00000000
Sep 28 17:34:16 myhost kernel: f6639f10 00000046 00000002 f6639f00
f645f8c0 c2808140 f7042280 c12f2680
Sep 28 17:34:16 myhost kernel: c2888140 c1002666 c1487140 c1487140
c1487140 f645f8c0 c1487140 00000000
Sep 28 17:34:16 myhost kernel: 00000000 c1487140 f645f8c0 00000001
f70ec814 f70ec818 00000246 f6639f3c
Sep 28 17:34:16 myhost kernel: Call Trace:
Sep 28 17:34:16 myhost kernel: [<c1002666>] ? __switch_to+0xb6/0x180
Sep 28 17:34:16 myhost kernel: [<c12e809c>] __mutex_lock_slowpath
+0x10c/0x2b0
Sep 28 17:34:16 myhost kernel: [<c12e824b>] mutex_lock+0xb/0x20
Sep 28 17:34:18 myhost kernel: [<f8613448>] i915_gem_retire_work_handler
+0x28/0xc0 [i915]
Sep 28 17:34:18 myhost kernel: [<f8613420>] ?
i915_gem_retire_work_handler+0x0/0xc0 [i915]
Sep 28 17:34:18 myhost kernel: [<c105abc0>] worker_thread+0x110/0x250
Sep 28 17:34:18 myhost kernel: [<c102f0b0>] ? __wake_up_common+0x40/0x70
Sep 28 17:34:18 myhost kernel: [<c105eb30>] ? autoremove_wake_function
+0x0/0x40
Sep 28 17:34:18 myhost kernel: [<c105aab0>] ? worker_thread+0x0/0x250
Sep 28 17:34:18 myhost kernel: [<c105e71c>] kthread+0x6c/0x80
Sep 28 17:34:18 myhost kernel: [<c105e6b0>] ? kthread+0x0/0x80
Sep 28 17:34:18 myhost kernel: [<c1003d3e>] kernel_thread_helper
+0x6/0x18
Sep 28 17:34:20 myhost kernel: Xorg          D f73c1da8     0  1586
1525 0x00400004
Sep 28 17:34:20 myhost kernel: f73c1db8 00203086 00000002 f73c1da8
f62d7b80 000000db c173fe00 c12f2680
Sep 28 17:34:20 myhost kernel: c2808140 f73c1d9c c1487140 c1487140
c1487140 f707b810 c1487140 00000000
Sep 28 17:34:20 myhost kernel: 00203246 c1487140 f707b810 00000001
f70ec814 f70ec818 00203246 f73c1de4
Sep 28 17:34:20 myhost kernel: Call Trace:
Sep 28 17:34:20 myhost kernel: [<c12e809c>] __mutex_lock_slowpath
+0x10c/0x2b0
Sep 28 17:34:20 myhost kernel: [<c12e824b>] mutex_lock+0xb/0x20
Sep 28 17:34:20 myhost kernel: [<f8618cb0>] i915_gem_madvise_ioctl
+0x40/0x130 [i915]
Sep 28 17:34:20 myhost kernel: [<f8458308>] drm_ioctl+0x1b8/0x460 [drm]
Sep 28 17:34:20 myhost kernel: [<f8618c70>] ? i915_gem_madvise_ioctl
+0x0/0x130 [i915]
Sep 28 17:34:20 myhost kernel: [<c10f672c>] ? do_sync_read+0x9c/0xd0
Sep 28 17:34:20 myhost kernel: [<c11048e4>] vfs_ioctl+0x34/0xa0
Sep 28 17:34:20 myhost kernel: [<f8458150>] ? drm_ioctl+0x0/0x460 [drm]
Sep 28 17:34:20 myhost kernel: [<c1104ff6>] do_vfs_ioctl+0x66/0x560
Sep 28 17:34:20 myhost kernel: [<c115d93f>] ? security_file_permission
+0xf/0x20
Sep 28 17:34:20 myhost kernel: [<c10f6a3d>] ? rw_verify_area+0x5d/0xd0
Sep 28 17:34:20 myhost kernel: [<c10f6f8d>] ? vfs_read+0x11d/0x180
Sep 28 17:34:20 myhost kernel: [<c110554f>] sys_ioctl+0x5f/0x80
Sep 28 17:34:20 myhost kernel: [<c100379f>] sysenter_do_call+0x12/0x28

