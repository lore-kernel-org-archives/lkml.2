Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab0IMOvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:51:20 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:43504 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab0IMOvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:51:17 -0400
Date: Mon, 13 Sep 2010 16:15:48 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: Linux Kernel-Liste <linux-kernel@vger.kernel.org>
Subject: Xorg crash, stack trace recovered
Message-ID: <20100913141548.GF25129@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  When X crasheѕ, rarely there's a dump or log msg to shed some 
  light on maybe why it happened. This time magic sysrq key continued to
  work. See below.


Jun 22 20:22:30 localhost udevd[549]: worker [19053] unexpectedly returned with status 0x0100
Jun 22 20:22:30 localhost udevd[549]: worker [19053] failed while handling '/devices/pci0000:00/0000:00:1c.3/0000:02:00.0/ieee80211/phy1/rfkill1'
Jun 22 20:28:32 localhost kernel: [114828.971555] SysRq : Emergency Sync
Jun 22 20:28:32 localhost kernel: [114828.972089] Emergency Sync complete
Jun 22 20:28:35 localhost kernel: [114832.262692] SysRq : Show Memory
Jun 22 20:28:35 localhost kernel: [114832.262704] Mem-Info:
Jun 22 20:28:35 localhost kernel: [114832.262708] DMA per-cpu:
Jun 22 20:28:35 localhost kernel: [114832.262714] CPU    0: hi:    0, btch:   1 usd:   0
Jun 22 20:28:35 localhost kernel: [114832.262719] CPU    1: hi:    0, btch:   1 usd:   0
Jun 22 20:28:35 localhost kernel: [114832.262723] Normal per-cpu:
Jun 22 20:28:35 localhost kernel: [114832.262728] CPU    0: hi:  186, btch:  31 usd: 161
Jun 22 20:28:35 localhost kernel: [114832.262733] CPU    1: hi:  186, btch:  31 usd: 150
Jun 22 20:28:35 localhost kernel: [114832.262736] HighMem per-cpu:
Jun 22 20:28:35 localhost kernel: [114832.262741] CPU    0: hi:  186, btch:  31 usd: 165
Jun 22 20:28:35 localhost kernel: [114832.262746] CPU    1: hi:  186, btch:  31 usd: 107
Jun 22 20:28:35 localhost kernel: [114832.262757] active_anon:177018 inactive_anon:48675 isolated_anon:0
Jun 22 20:28:35 localhost kernel: [114832.262760]  active_file:168667 inactive_file:303672 isolated_file:0
Jun 22 20:28:35 localhost kernel: [114832.262762]  unevictable:694 dirty:7 writeback:0 unstable:0
Jun 22 20:28:35 localhost kernel: [114832.262765]  free:228323 slab_reclaimable:60136 slab_unreclaimable:9337
Jun 22 20:28:35 localhost kernel: [114832.262767]  mapped:28348 shmem:42718 pagetables:1728 bounce:0
Jun 22 20:28:35 localhost kernel: [114832.262783] DMA free:3532kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:11712kB inactive_file:456kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15808kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:156kB slab_unreclaimable:44kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jun 22 20:28:35 localhost kernel: [114832.262796] lowmem_reserve[]: 0 867 3943 3943
Jun 22 20:28:35 localhost kernel: [114832.262816] Normal free:11348kB min:3732kB low:4664kB high:5596kB active_anon:36kB inactive_anon:11636kB active_file:261492kB inactive_file:231368kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:887976kB mlocked:0kB dirty:12kB writeback:0kB mapped:492kB shmem:616kB slab_reclaimable:240388kB slab_unreclaimable:37304kB kernel_stack:2736kB pagetables:6912kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jun 22 20:28:35 localhost kernel: [114832.262830] lowmem_reserve[]: 0 0 24610 24610
Jun 22 20:28:35 localhost kernel: [114832.262849] HighMem free:898412kB min:512kB low:3820kB high:7132kB active_anon:708036kB inactive_anon:183064kB active_file:401464kB inactive_file:982864kB unevictable:2776kB isolated(anon):0kB isolated(file):0kB present:3150088kB mlocked:2776kB dirty:16kB writeback:0kB mapped:112900kB shmem:170256kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
Jun 22 20:28:35 localhost kernel: [114832.262862] lowmem_reserve[]: 0 0 0 0
Jun 22 20:28:35 localhost kernel: [114832.262870] DMA: 1*4kB 1*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3532kB
Jun 22 20:28:35 localhost kernel: [114832.262893] Normal: 1763*4kB 218*8kB 5*16kB 6*32kB 4*64kB 0*128kB 0*256kB 2*512kB 1*1024kB 0*2048kB 0*4096kB = 11372kB
Jun 22 20:28:35 localhost kernel: [114832.262916] HighMem: 1363*4kB 1016*8kB 11498*16kB 9068*32kB 3009*64kB 1162*128kB 181*256kB 33*512kB 6*1024kB 0*2048kB 0*4096kB = 898412kB
Jun 22 20:28:35 localhost kernel: [114832.262940] 515545 total pagecache pages
Jun 22 20:28:35 localhost kernel: [114832.262944] 0 pages in swap cache
Jun 22 20:28:35 localhost kernel: [114832.262949] Swap cache stats: add 0, delete 0, find 0/0
Jun 22 20:28:35 localhost kernel: [114832.262953] Free swap  = 2097144kB
Jun 22 20:28:35 localhost kernel: [114832.262956] Total swap = 2097144kB
Jun 22 20:28:35 localhost kernel: [114832.263671] 1310720 pages RAM
Jun 22 20:28:35 localhost kernel: [114832.263671] 1082882 pages HighMem
Jun 22 20:28:35 localhost kernel: [114832.263671] 306665 pages reserved
Jun 22 20:28:35 localhost kernel: [114832.263671] 310922 pages shared
Jun 22 20:28:35 localhost kernel: [114832.263671] 562852 pages non-shared
Jun 22 20:28:36 localhost kernel: [114833.625172] SysRq : Emergency Sync
Jun 22 20:28:36 localhost kernel: [114833.625337] Emergency Sync complete
Jun 22 20:28:36 localhost kernel: [114833.712844] SysRq : Dump ftrace buffer
Jun 22 20:28:36 localhost kernel: [114833.712855] Dumping ftrace buffer:
Jun 22 20:28:36 localhost kernel: [114833.712862]    (ftrace buffer empty)
Jun 22 20:28:58 localhost kernel: [114855.787677] SysRq : Emergency Sync
Jun 22 20:28:58 localhost kernel: [114855.787894] Emergency Sync complete
Jun 22 20:29:03 localhost kernel: [114860.822181] SysRq : Show Regs
Jun 22 20:29:03 localhost kernel: [114860.822192] Modules linked in: uvcvideo option usbserial usb_storage atl1c bridge stp iwlagn iwlcore ipt_MASQUERADE xt_TCPMSS iptable_nat nf_nat iptable_mangle ipt_LOG xt_physdev xt_tcpudp xt_state iptable_filter ip_tables x_tables mac80211 cfg80211 [last unloaded: atl1c]
Jun 22 20:29:03 localhost kernel: [114860.822240]
Jun 22 20:29:03 localhost kernel: [114860.822249] Pid: 5091, comm: Xorg Tainted: G        W  2.6.33.4 #1 Aspire 1810T
Jun 22 20:29:03 localhost kernel: [114860.822256] EIP: 0060:[<c13d014e>] EFLAGS: 00203297 CPU: 0
Jun 22 20:29:03 localhost kernel: [114860.822269] EIP is at drm_clflush_pages+0x3e/0x90
Jun 22 20:29:03 localhost kernel: [114860.822275] EAX: fffb7000 EBX: 00000796 ECX: fffb7d80 EDX: 00000d80
Jun 22 20:29:03 localhost kernel: [114860.822281] ESI: 00001000 EDI: f9902000 EBP: e5fafb40 ESP: f6187e5c
Jun 22 20:29:03 localhost kernel: [114860.822286]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jun 22 20:29:03 localhost kernel: [114860.822293] Process Xorg (pid: 5091, ti=f6186000 task=f6cba570 task.ti=f6186000)
Jun 22 20:29:03 localhost kernel: [114860.822298] Stack:
Jun 22 20:29:03 localhost kernel: [114860.822302]  c17d3b8c e3cf47c0 f6c84800 00000001 c13ea56d 00001000 e3cf47c0 00000000
Jun 22 20:29:03 localhost kernel: [114860.822315] <0> 00000001 e5fafb40 c13ebcec 00000000 00000001 f6c7fdf8 f6187f00 f6c84800
Jun 22 20:29:03 localhost kernel: [114860.822329] <0> e5fafb40 e3cf47c0 c13f06ca 00000000 e659af3c f6c84814 ae5df000 ae5ed000
Jun 22 20:29:03 localhost kernel: [114860.822344] Call Trace:
Jun 22 20:29:03 localhost kernel: [114860.822356]  [<c13ea56d>] ? i915_gem_object_flush_cpu_write_domain+0x3d/0xc0
Jun 22 20:29:03 localhost kernel: [114860.822366]  [<c13ebcec>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
Jun 22 20:29:03 localhost kernel: [114860.822375]  [<c13f06ca>] ? i915_gem_fault+0x13a/0x150
Jun 22 20:29:03 localhost kernel: [114860.822383]  [<c13f0590>] ? i915_gem_fault+0x0/0x150
Jun 22 20:29:03 localhost kernel: [114860.822394]  [<c10cdaa2>] ? __do_fault+0x52/0x4b0
Jun 22 20:29:03 localhost kernel: [114860.822403]  [<c13f0590>] ? i915_gem_fault+0x0/0x150
Jun 22 20:29:03 localhost kernel: [114860.822410]  [<c10cfaf3>] ? handle_mm_fault+0x133/0x8b0
Jun 22 20:29:03 localhost kernel: [114860.822420]  [<c100b9bb>] ? restore_i387_xstate+0x1ab/0x280
Jun 22 20:29:03 localhost kernel: [114860.822430]  [<c10250c9>] ? do_page_fault+0xf9/0x300
Jun 22 20:29:03 localhost kernel: [114860.822438]  [<c1002181>] ? sys_sigreturn+0xd1/0xf0
Jun 22 20:29:03 localhost kernel: [114860.822446]  [<c1024fd0>] ? do_page_fault+0x0/0x300
Jun 22 20:29:03 localhost kernel: [114860.822457]  [<c16f61d2>] ? error_code+0x66/0x6c
Jun 22 20:29:03 localhost kernel: [114860.822465]  [<c1024fd0>] ? do_page_fault+0x0/0x300
Jun 22 20:29:03 localhost kernel: [114860.822469] Code: 0f ae f0 89 f6 85 d2 74 44 31 db 66 90 8b 04 9f 85 c0 74 32 ba 03 00 00 00 e8 8f a1 c5 ff 31 d2 90 8d 74 26 00 8d 0c 10 0f ae 39 <0f> b7 0d a6 90 a0 c1 01 ca 81 fa ff 0f 00 00 76 e9 ba 03 00 00
Jun 22 20:29:03 localhost kernel: [114860.822554] Call Trace:
Jun 22 20:29:03 localhost kernel: [114860.822562]  [<c13ea56d>] ? i915_gem_object_flush_cpu_write_domain+0x3d/0xc0
Jun 22 20:29:03 localhost kernel: [114860.822571]  [<c13ebcec>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
Jun 22 20:29:03 localhost kernel: [114860.822580]  [<c13f06ca>] ? i915_gem_fault+0x13a/0x150
Jun 22 20:29:03 localhost kernel: [114860.822588]  [<c13f0590>] ? i915_gem_fault+0x0/0x150
Jun 22 20:29:03 localhost kernel: [114860.822596]  [<c10cdaa2>] ? __do_fault+0x52/0x4b0
Jun 22 20:29:03 localhost kernel: [114860.822605]  [<c13f0590>] ? i915_gem_fault+0x0/0x150
Jun 22 20:29:03 localhost kernel: [114860.822612]  [<c10cfaf3>] ? handle_mm_fault+0x133/0x8b0
Jun 22 20:29:03 localhost kernel: [114860.822620]  [<c100b9bb>] ? restore_i387_xstate+0x1ab/0x280
Jun 22 20:29:03 localhost kernel: [114860.822630]  [<c10250c9>] ? do_page_fault+0xf9/0x300
Jun 22 20:29:03 localhost kernel: [114860.822637]  [<c1002181>] ? sys_sigreturn+0xd1/0xf0
Jun 22 20:29:03 localhost kernel: [114860.822644]  [<c1024fd0>] ? do_page_fault+0x0/0x300
Jun 22 20:29:03 localhost kernel: [114860.822653]  [<c16f61d2>] ? error_code+0x66/0x6c
Jun 22 20:29:03 localhost kernel: [114860.822661]  [<c1024fd0>] ? do_page_fault+0x0/0x300
Jun 22 20:29:03 localhost kernel: [114860.822667]
Jun 22 20:29:03 localhost kernel: [114860.822671] CPU#0: ctrl:       ffffffffffffffff
Jun 22 20:29:03 localhost kernel: [114860.822675] CPU#0: status:     0000000000000000
Jun 22 20:29:03 localhost kernel: [114860.822679] CPU#0: overflow:   0000000000000000
Jun 22 20:29:03 localhost kernel: [114860.822683] CPU#0: fixed:      0000000000000000
Jun 22 20:29:03 localhost kernel: [114860.822687] CPU#0: used:       0000000000000000
Jun 22 20:29:03 localhost kernel: [114860.822692] CPU#0:   gen-PMC0 ctrl:  0000000000000000
Jun 22 20:29:03 localhost kernel: [114860.822696] CPU#0:   gen-PMC0 count: 0000000000000000
Jun 22 20:29:03 localhost kernel: [114860.822700] CPU#0:   gen-PMC0 left:  0000000000000000
Jun 22 20:29:03 localhost kernel: [114860.822705] CPU#0:   gen-PMC1 ctrl:  0000000000000000
Jun 22 20:29:03 localhost kernel: [114860.822710] CPU#0:   gen-PMC1 count: 0000000000000000
Jun 22 20:29:03 localhost kernel: [114860.822714] CPU#0:   gen-PMC1 left:  0000000000000000
Jun 22 20:29:03 localhost kernel: [114860.822719] CPU#0: fixed-PMC0 count: 0000000000000000
Jun 22 20:29:03 localhost kernel: [114860.822723] CPU#0: fixed-PMC1 count: 0000000000000000
Jun 22 20:29:03 localhost kernel: [114860.822728] CPU#0: fixed-PMC2 count: 0000000000000000


                  Cheers,

                          Nils

