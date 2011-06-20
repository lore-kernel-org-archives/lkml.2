Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab1FTKHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:07:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49688 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab1FTKHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:07:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:date:content-type:x-mailer
         :content-transfer-encoding:message-id:mime-version;
        b=tX1ydyxbndxBA57S/5MM3BRzwlMnrZyOHs5f/tDf34HLlSCGZeXiQTHIxdCcFnSz0G
         I7wNbQoyiYqajJuqtIEHyCUFmASoV8GuToqztgTZ9tnBoDi7K3yY75ON5ptk4E+0048w
         WscS4Or35kt4hwCRQRt+9ogLGzi2bymro2iIg=
Subject: re: PROBLEM: some unknown oops (?)
From: "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>
To: linux-kernel@vger.kernel.org
Date: Mon, 20 Jun 2011 12:07:26 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 
Content-Transfer-Encoding: 7bit
Message-ID: <1308564448.4779.8.camel@soho.example.org>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did not use 2.6.38.x at all because of the previously reported oops

I began to use 2.6.39.1 without problem. But the oops are still there.
It seems to happen after roughly 12 hours of use (of the kernel) and any
process can trigger the oooops

After that. other process stop to respond on the desktop.
In a terminal, ps aux never complete and hangs. command like
less /var/log/messages do the same. unless I press ctrl-C (why do I have
to press ctrl-C for less to output something ? that does not happen
normally)

I can provide more details if any one is interested. It's still
archlinux with same hardware

Jun 20 04:53:48 soho -- MARK --
Jun 20 05:13:48 soho -- MARK --
Jun 20 05:33:48 soho -- MARK --
Jun 20 05:53:48 soho -- MARK --
Jun 20 06:13:48 soho -- MARK --
Jun 20 06:33:49 soho -- MARK --
Jun 20 06:53:49 soho -- MARK --
Jun 20 07:13:49 soho -- MARK --
Jun 20 07:33:49 soho -- MARK --
Jun 20 07:53:49 soho -- MARK --
Jun 20 08:13:50 soho -- MARK --
Jun 20 08:33:50 soho -- MARK --
Jun 20 08:51:21 soho kernel: [75480.609173] preload         D 00000000
0  1113      1 0x00000000
Jun 20 08:51:21 soho kernel: [75480.609184]  f41abee0 00000086 00000000
00000000 f41abf04 f0dfb580 58bf32e7 00004480
Jun 20 08:51:21 soho kernel: [75480.609199]  c111f20b 0024c5a3 00000003
f41abe74 c112ec7a f41abf18 f0dfb580 c152c480
Jun 20 08:51:21 soho kernel: [75480.609212]  c112ed38 c152c480 f5a06480
f3d38460 f2aff020 c111ffdc f41abecc f41abec8
Jun 20 08:51:21 soho kernel: [75480.609225] Call Trace:
Jun 20 08:51:21 soho kernel: [75480.609241]  [<c111f20b>] ? do_lookup
+0xdb/0x230
Jun 20 08:51:21 soho kernel: [75480.609250]  [<c112ec7a>] ?
mntput_no_expire+0x2a/0xd0
Jun 20 08:51:21 soho kernel: [75480.609257]  [<c112ed38>] ? mntput
+0x18/0x30
Jun 20 08:51:21 soho kernel: [75480.609264]  [<c111ffdc>] ?
path_lookupat+0x2ec/0x710
Jun 20 08:51:21 soho kernel: [75480.609274]  [<c134aee5>]
rwsem_down_failed_common+0x95/0xe0
Jun 20 08:51:21 soho kernel: [75480.609282]  [<c134af62>]
rwsem_down_read_failed+0x12/0x14
Jun 20 08:51:21 soho kernel: [75480.609289]  [<c134af9f>]
call_rwsem_down_read_failed+0x7/0xc
Jun 20 08:51:21 soho kernel: [75480.609299]  [<c134a7d2>] ? down_read
+0x12/0x20
Jun 20 08:51:21 soho kernel: [75480.609309]  [<c1160e6d>]
get_mm_exe_file+0x1d/0x40
Jun 20 08:51:21 soho kernel: [75480.609317]  [<c1160ed3>] proc_exe_link
+0x43/0xa0
Jun 20 08:51:21 soho kernel: [75480.609324]  [<c115eb74>]
proc_pid_readlink+0x34/0xd0
Jun 20 08:51:21 soho kernel: [75480.609333]  [<c112a4e1>] ? touch_atime
+0x61/0x140
Jun 20 08:51:21 soho kernel: [75480.609339]  [<c112ed38>] ? mntput
+0x18/0x30
Jun 20 08:51:21 soho kernel: [75480.609347]  [<c1118e31>] sys_readlinkat
+0x91/0xa0
Jun 20 08:51:21 soho kernel: [75480.609355]  [<c1118e6c>] sys_readlink
+0x2c/0x30
Jun 20 08:51:21 soho kernel: [75480.609363]  [<c134c11f>]
sysenter_do_call+0x12/0x28
Jun 20 08:51:21 soho kernel: [75480.609402] radiotray       D f28a3f40
0 30728  29584 0x00000000
Jun 20 08:51:21 soho kernel: [75480.609410]  f28a3f50 00200086 00000002
f28a3f40 f64689cc 9f378045 00000000 f8dd1940
Jun 20 08:51:21 soho kernel: [75480.609423]  00000000 f28a3f98 f28a3f64
c1114344 00001000 ef8bdb58 f64689cc c152c480
Jun 20 08:51:21 soho kernel: [75480.609435]  00000000 c152c480 f5806480
f48fc8c0 c1465fe0 f2bc1840 f28a3f2c c10ebfbd
Jun 20 08:51:21 soho kernel: [75480.609448] Call Trace:
Jun 20 08:51:21 soho kernel: [75480.609474]  [<c1114344>] ? do_sync_read
+0xa4/0xe0
Jun 20 08:51:21 soho kernel: [75480.609484]  [<c10ebfbd>] ?
handle_mm_fault+0xfd/0x210
Jun 20 08:51:21 soho kernel: [75480.609491]  [<c112ec7a>] ?
mntput_no_expire+0x2a/0xd0
Jun 20 08:51:21 soho kernel: [75480.609498]  [<c134aee5>]
rwsem_down_failed_common+0x95/0xe0
Jun 20 08:51:21 soho kernel: [75480.609516]  [<c134af42>]
rwsem_down_write_failed+0x12/0x20
Jun 20 08:51:21 soho kernel: [75480.609523]  [<c134afaa>]
call_rwsem_down_write_failed+0x6/0x8
Jun 20 08:51:21 soho kernel: [75480.609531]  [<c134a7fa>] ? down_write
+0x1a/0x1c
Jun 20 08:51:21 soho kernel: [75480.609539]  [<c10f0614>] sys_munmap
+0x34/0x60
Jun 20 08:51:21 soho kernel: [75480.609546]  [<c134c11f>]
sysenter_do_call+0x12/0x28
Jun 20 08:51:21 soho kernel: [75480.609562] source:src      D dfe4bed0
0 13601  29584 0x00000000
Jun 20 08:51:21 soho kernel: [75480.609570]  dfe4bee0 00000086 00000002
dfe4bed0 dfe4be90 dfe4beb8 f09e185c dfe4be68
Jun 20 08:51:21 soho kernel: [75480.609582]  00000000 dfe4beb4 dfe4beb8
00000000 dfe4be78 c5b4f6c0 00001000 c152c480
Jun 20 08:51:21 soho kernel: [75480.609593]  00000000 c152c480 f5806480
ce0d8460 c1465fe0 0a614d68 dfe4bebc 00000000
Jun 20 08:51:21 soho kernel: [75480.609605] Call Trace:
Jun 20 08:51:21 soho kernel: [75480.609614]  [<c1147203>] ?
fsnotify_clear_marks_by_inode+0x73/0xb0
Jun 20 08:51:21 soho kernel: [75480.609623]  [<c112a334>] ?
free_inode_nonrcu+0x14/0x20
Jun 20 08:51:21 soho kernel: [75480.609630]  [<c112a334>] ?
free_inode_nonrcu+0x14/0x20
Jun 20 08:51:21 soho kernel: [75480.609637]  [<c134aee5>]
rwsem_down_failed_common+0x95/0xe0
Jun 20 08:51:21 soho kernel: [75480.609646]  [<c1028a30>] ?
vmalloc_sync_all+0x120/0x120
Jun 20 08:51:21 soho kernel: [75480.609652]  [<c134af62>]
rwsem_down_read_failed+0x12/0x14
Jun 20 08:51:21 soho kernel: [75480.609659]  [<c134af9f>]
call_rwsem_down_read_failed+0x7/0xc
Jun 20 08:51:21 soho kernel: [75480.609667]  [<c134a7d2>] ? down_read
+0x12/0x20
Jun 20 08:51:21 soho kernel: [75480.609673]  [<c1028b7c>] do_page_fault
+0x14c/0x420
Jun 20 08:51:21 soho kernel: [75480.609680]  [<c112ecde>] ?
mntput_no_expire+0x8e/0xd0
Jun 20 08:51:21 soho kernel: [75480.609689]  [<c106e288>] ? ktime_get_ts
+0xe8/0x110
Jun 20 08:51:21 soho kernel: [75480.609697]  [<c11262aa>] ? sys_poll
+0x5a/0xd0
Jun 20 08:51:21 soho kernel: [75480.609704]  [<c1028a30>] ?
vmalloc_sync_all+0x120/0x120
Jun 20 08:51:21 soho kernel: [75480.609711]  [<c134be93>] error_code
+0x67/0x6c
Jun 20 08:51:21 soho kernel: [75480.609765] ps              D f41cde50
0 13796  13795 0x00000000
Jun 20 08:51:21 soho kernel: [75480.609773]  f41cde60 00000086 00000002
f41cde50 f41cddd8 f41cdeec d8bdec08 d1f5d2d8
Jun 20 08:51:21 soho kernel: [75480.609786]  00000000 d1d07e80 00000000
00000000 00000000 d1f5d2d8 d8bdec08 c152c480
Jun 20 08:51:21 soho kernel: [75480.609798]  f41cde14 c152c480 f5a06480
eff15a40 f487f020 d8bdec00 00000001 000a00d0
Jun 20 08:51:21 soho kernel: [75480.609810] Call Trace:
Jun 20 08:51:21 soho kernel: [75480.609818]  [<c112ec7a>] ?
mntput_no_expire+0x2a/0xd0
Jun 20 08:51:21 soho kernel: [75480.609825]  [<c134aee5>]
rwsem_down_failed_common+0x95/0xe0
Jun 20 08:51:21 soho kernel: [75480.609832]  [<c134af62>]
rwsem_down_read_failed+0x12/0x14
Jun 20 08:51:21 soho kernel: [75480.609839]  [<c134af9f>]
call_rwsem_down_read_failed+0x7/0xc
Jun 20 08:51:21 soho kernel: [75480.609847]  [<c134a7d2>] ? down_read
+0x12/0x20
Jun 20 08:51:21 soho kernel: [75480.609853]  [<c10ec5e8>]
__access_remote_vm+0x28/0x170
Jun 20 08:51:21 soho kernel: [75480.609862]  [<c10436be>] ? get_task_mm
+0x3e/0x60
Jun 20 08:51:21 soho kernel: [75480.609869]  [<c10ec97b>]
access_process_vm+0x4b/0x70
Jun 20 08:51:21 soho kernel: [75480.609877]  [<c115d975>]
proc_pid_cmdline+0x75/0xf0
Jun 20 08:51:21 soho kernel: [75480.609885]  [<c115e047>] proc_info_read
+0x77/0xc0
Jun 20 08:51:21 soho kernel: [75480.609892]  [<c1114b38>] vfs_read
+0x88/0x160
Jun 20 08:51:21 soho kernel: [75480.609899]  [<c115dfd0>] ?
proc_loginuid_read+0xc0/0xc0
Jun 20 08:51:21 soho kernel: [75480.609905]  [<c1114c4d>] sys_read
+0x3d/0x70
Jun 20 08:51:21 soho kernel: [75480.609912]  [<c134c11f>]
sysenter_do_call+0x12/0x28
Jun 20 08:51:39 soho pulseaudio[29604]: ratelimit.c: 103 events
suppressed
Jun 20 08:53:21 soho kernel: [75600.609171] preload         D 00000000
0  1113      1 0x00000000
Jun 20 08:53:21 soho kernel: [75600.609182]  f41abee0 00000086 00000000
00000000 f41abf04 f0dfb580 58bf32e7 00004480
Jun 20 08:53:21 soho kernel: [75600.609197]  c111f20b 0024c5a3 00000003
f41abe74 c112ec7a f41abf18 f0dfb580 c152c480
Jun 20 08:53:21 soho kernel: [75600.609210]  c112ed38 c152c480 f5a06480
f3d38460 f2aff020 c111ffdc f41abecc f41abec8
Jun 20 08:53:21 soho kernel: [75600.609223] Call Trace:
Jun 20 08:53:21 soho kernel: [75600.609239]  [<c111f20b>] ? do_lookup
+0xdb/0x230
Jun 20 08:53:21 soho kernel: [75600.609249]  [<c112ec7a>] ?
mntput_no_expire+0x2a/0xd0
Jun 20 08:53:21 soho kernel: [75600.609256]  [<c112ed38>] ? mntput
+0x18/0x30
Jun 20 08:53:21 soho kernel: [75600.609262]  [<c111ffdc>] ?
path_lookupat+0x2ec/0x710
Jun 20 08:53:21 soho kernel: [75600.609272]  [<c134aee5>]
rwsem_down_failed_common+0x95/0xe0
Jun 20 08:53:21 soho kernel: [75600.609280]  [<c134af62>]
rwsem_down_read_failed+0x12/0x14
Jun 20 08:53:21 soho kernel: [75600.609287]  [<c134af9f>]
call_rwsem_down_read_failed+0x7/0xc
Jun 20 08:53:21 soho kernel: [75600.609297]  [<c134a7d2>] ? down_read
+0x12/0x20
Jun 20 08:53:21 soho kernel: [75600.609307]  [<c1160e6d>]
get_mm_exe_file+0x1d/0x40
Jun 20 08:53:21 soho kernel: [75600.609315]  [<c1160ed3>] proc_exe_link
+0x43/0xa0
Jun 20 08:53:21 soho kernel: [75600.609322]  [<c115eb74>]
proc_pid_readlink+0x34/0xd0
Jun 20 08:53:21 soho kernel: [75600.609331]  [<c112a4e1>] ? touch_atime
+0x61/0x140
Jun 20 08:53:21 soho kernel: [75600.609338]  [<c112ed38>] ? mntput
+0x18/0x30
Jun 20 08:53:21 soho kernel: [75600.609346]  [<c1118e31>] sys_readlinkat
+0x91/0xa0
Jun 20 08:53:21 soho kernel: [75600.609353]  [<c1118e6c>] sys_readlink
+0x2c/0x30
Jun 20 08:53:21 soho kernel: [75600.609361]  [<c134c11f>]
sysenter_do_call+0x12/0x28
Jun 20 08:53:21 soho kernel: [75600.609398] radiotray       D f28a3f40
0 30728  29584 0x00000000
Jun 20 08:53:21 soho kernel: [75600.609407]  f28a3f50 00200086 00000002
f28a3f40 f64689cc 9f378045 00000000 f8dd1940
Jun 20 08:53:21 soho kernel: [75600.609420]  00000000 f28a3f98 f28a3f64
c1114344 00001000 ef8bdb58 f64689cc c152c480
Jun 20 08:53:21 soho kernel: [75600.609432]  00000000 c152c480 f5806480
f48fc8c0 c1465fe0 f2bc1840 f28a3f2c c10ebfbd
Jun 20 08:53:21 soho kernel: [75600.609445] Call Trace:
Jun 20 08:53:21 soho kernel: [75600.609471]  [<c1114344>] ? do_sync_read
+0xa4/0xe0
Jun 20 08:53:21 soho kernel: [75600.609481]  [<c10ebfbd>] ?
handle_mm_fault+0xfd/0x210
Jun 20 08:53:21 soho kernel: [75600.609488]  [<c112ec7a>] ?
mntput_no_expire+0x2a/0xd0
Jun 20 08:53:21 soho kernel: [75600.609495]  [<c134aee5>]
rwsem_down_failed_common+0x95/0xe0
Jun 20 08:53:21 soho kernel: [75600.609503]  [<c134af42>]
rwsem_down_write_failed+0x12/0x20
Jun 20 08:53:21 soho kernel: [75600.609510]  [<c134afaa>]
call_rwsem_down_write_failed+0x6/0x8
Jun 20 08:53:21 soho kernel: [75600.609518]  [<c134a7fa>] ? down_write
+0x1a/0x1c
Jun 20 08:53:21 soho kernel: [75600.609526]  [<c10f0614>] sys_munmap
+0x34/0x60
Jun 20 08:53:21 soho kernel: [75600.609533]  [<c134c11f>]
sysenter_do_call+0x12/0x28
Jun 20 08:53:21 soho kernel: [75600.609549] source:src      D dfe4bed0
0 13601  29584 0x00000000
Jun 20 08:53:21 soho kernel: [75600.609558]  dfe4bee0 00000086 00000002
dfe4bed0 dfe4be90 dfe4beb8 f09e185c dfe4be68
Jun 20 08:53:21 soho kernel: [75600.609570]  00000000 dfe4beb4 dfe4beb8
00000000 dfe4be78 c5b4f6c0 00001000 c152c480
Jun 20 08:53:21 soho kernel: [75600.609582]  00000000 c152c480 f5806480
ce0d8460 c1465fe0 0a614d68 dfe4bebc 00000000
Jun 20 08:53:21 soho kernel: [75600.609595] Call Trace:
Jun 20 08:53:21 soho kernel: [75600.609604]  [<c1147203>] ?
fsnotify_clear_marks_by_inode+0x73/0xb0
Jun 20 08:53:21 soho kernel: [75600.609612]  [<c112a334>] ?
free_inode_nonrcu+0x14/0x20
Jun 20 08:53:21 soho kernel: [75600.609619]  [<c112a334>] ?
free_inode_nonrcu+0x14/0x20
Jun 20 08:53:21 soho kernel: [75600.609626]  [<c134aee5>]
rwsem_down_failed_common+0x95/0xe0
Jun 20 08:53:21 soho kernel: [75600.609635]  [<c1028a30>] ?
vmalloc_sync_all+0x120/0x120
Jun 20 08:53:21 soho kernel: [75600.609641]  [<c134af62>]
rwsem_down_read_failed+0x12/0x14
Jun 20 08:53:21 soho kernel: [75600.609648]  [<c134af9f>]
call_rwsem_down_read_failed+0x7/0xc
Jun 20 08:53:21 soho kernel: [75600.609656]  [<c134a7d2>] ? down_read
+0x12/0x20
Jun 20 08:53:21 soho kernel: [75600.609662]  [<c1028b7c>] do_page_fault
+0x14c/0x420
Jun 20 08:53:21 soho kernel: [75600.609669]  [<c112ecde>] ?
mntput_no_expire+0x8e/0xd0
Jun 20 08:53:21 soho kernel: [75600.609678]  [<c106e288>] ? ktime_get_ts
+0xe8/0x110
Jun 20 08:53:21 soho kernel: [75600.609686]  [<c11262aa>] ? sys_poll
+0x5a/0xd0
Jun 20 08:53:21 soho kernel: [75600.609693]  [<c1028a30>] ?
vmalloc_sync_all+0x120/0x120
Jun 20 08:53:21 soho kernel: [75600.609700]  [<c134be93>] error_code
+0x67/0x6c
Jun 20 08:53:21 soho kernel: [75600.609754] ps              D f41cde50
0 13796  13795 0x00000000
Jun 20 08:53:21 soho kernel: [75600.609762]  f41cde60 00000086 00000002
f41cde50 f41cddd8 f41cdeec d8bdec08 d1f5d2d8
Jun 20 08:53:21 soho kernel: [75600.609774]  00000000 d1d07e80 00000000
00000000 00000000 d1f5d2d8 d8bdec08 c152c480
Jun 20 08:53:21 soho kernel: [75600.609786]  f41cde14 c152c480 f5a06480
eff15a40 f487f020 d8bdec00 00000001 000a00d0
Jun 20 08:53:21 soho kernel: [75600.609798] Call Trace:
Jun 20 08:53:21 soho kernel: [75600.609807]  [<c112ec7a>] ?
mntput_no_expire+0x2a/0xd0
Jun 20 08:53:21 soho kernel: [75600.609814]  [<c134aee5>]
rwsem_down_failed_common+0x95/0xe0
Jun 20 08:53:21 soho kernel: [75600.609821]  [<c134af62>]
rwsem_down_read_failed+0x12/0x14
Jun 20 08:53:21 soho kernel: [75600.609828]  [<c134af9f>]
call_rwsem_down_read_failed+0x7/0xc
Jun 20 08:53:21 soho kernel: [75600.609836]  [<c134a7d2>] ? down_read
+0x12/0x20
Jun 20 08:53:21 soho kernel: [75600.609842]  [<c10ec5e8>]
__access_remote_vm+0x28/0x170
Jun 20 08:53:21 soho kernel: [75600.609851]  [<c10436be>] ? get_task_mm
+0x3e/0x60
Jun 20 08:53:21 soho kernel: [75600.609858]  [<c10ec97b>]
access_process_vm+0x4b/0x70
Jun 20 08:53:21 soho kernel: [75600.609867]  [<c115d975>]
proc_pid_cmdline+0x75/0xf0
Jun 20 08:53:21 soho kernel: [75600.609875]  [<c115e047>] proc_info_read
+0x77/0xc0
Jun 20 08:53:21 soho kernel: [75600.609881]  [<c1114b38>] vfs_read
+0x88/0x160
Jun 20 08:53:21 soho kernel: [75600.609888]  [<c115dfd0>] ?
proc_loginuid_read+0xc0/0xc0
Jun 20 08:53:21 soho kernel: [75600.609895]  [<c1114c4d>] sys_read
+0x3d/0x70
Jun 20 08:53:21 soho kernel: [75600.609902]  [<c134c11f>]
sysenter_do_call+0x12/0x28
Jun 20 08:53:21 soho kernel: [75600.609917] ps              D d3187e50
0 13859  13856 0x00000000
Jun 20 08:53:21 soho kernel: [75600.609926]  d3187e60 00200086 00000002
d3187e50 d3187dd8 d3187eec f0b666c8 d1f5d2d8
Jun 20 08:53:21 soho kernel: [75600.609938]  00000000 d1d07e80 00000000
00000000 00000000 d1f5d2d8 f0b666c8 c152c480
Jun 20 08:53:21 soho kernel: [75600.609949]  d3187e14 c152c480 f5806480
f0afc460 c1465fe0 f0b666c0 00000001 000a00d0
Jun 20 08:53:21 soho kernel: [75600.609962] Call Trace:
Jun 20 08:53:21 soho kernel: [75600.609970]  [<c112ec7a>] ?
mntput_no_expire+0x2a/0xd0
Jun 20 08:53:21 soho kernel: [75600.609977]  [<c134aee5>]
rwsem_down_failed_common+0x95/0xe0
Jun 20 08:53:21 soho kernel: [75600.609985]  [<c134af62>]
rwsem_down_read_failed+0x12/0x14
Jun 20 08:53:21 soho kernel: [75600.609992]  [<c134af9f>]
call_rwsem_down_read_failed+0x7/0xc
Jun 20 08:53:21 soho kernel: [75600.609999]  [<c134a7d2>] ? down_read
+0x12/0x20
Jun 20 08:53:21 soho kernel: [75600.610006]  [<c10ec5e8>]
__access_remote_vm+0x28/0x170
Jun 20 08:53:21 soho kernel: [75600.610013]  [<c10436be>] ? get_task_mm
+0x3e/0x60
Jun 20 08:53:21 soho kernel: [75600.610020]  [<c10ec97b>]
access_process_vm+0x4b/0x70
Jun 20 08:53:21 soho kernel: [75600.610028]  [<c115d975>]
proc_pid_cmdline+0x75/0xf0
Jun 20 08:53:21 soho kernel: [75600.610035]  [<c115e047>] proc_info_read
+0x77/0xc0
Jun 20 08:53:21 soho kernel: [75600.610042]  [<c1114b38>] vfs_read
+0x88/0x160
Jun 20 08:53:21 soho kernel: [75600.610049]  [<c115dfd0>] ?
proc_loginuid_read+0xc0/0xc0
Jun 20 08:53:21 soho kernel: [75600.610056]  [<c1114c4d>] sys_read
+0x3d/0x70
Jun 20 08:53:21 soho kernel: [75600.610063]  [<c134c11f>]
sysenter_do_call+0x12/0x28
Jun 20 08:53:21 soho kernel: [75600.610078] ps              D ce00be50
0 13916      1 0x00000004
Jun 20 08:53:21 soho kernel: [75600.610087]  ce00be60 00200086 00000002
ce00be50 ce00bdd8 ce00beec c02cd324 00004498
Jun 20 08:53:21 soho kernel: [75600.610099]  0157e264 d1d07e80 00000000
00000000 00000000 d1f5d2d8 ce02df08 c152c480
Jun 20 08:53:21 soho kernel: [75600.610111]  ce00be14 c152c480 f5a06480
f0aff020 f28fc000 ce02df00 00000001 000a00d0
Jun 20 08:53:21 soho kernel: [75600.610124] Call Trace:
Jun 20 08:53:21 soho kernel: [75600.610132]  [<c112ec7a>] ?
mntput_no_expire+0x2a/0xd0
Jun 20 08:53:21 soho kernel: [75600.610139]  [<c134aee5>]
rwsem_down_failed_common+0x95/0xe0
Jun 20 08:53:21 soho kernel: [75600.610146]  [<c134af62>]
rwsem_down_read_failed+0x12/0x14
Jun 20 08:53:21 soho kernel: [75600.610153]  [<c134af9f>]
call_rwsem_down_read_failed+0x7/0xc
Jun 20 08:53:21 soho kernel: [75600.610160]  [<c134a7d2>] ? down_read
+0x12/0x20
Jun 20 08:53:21 soho kernel: [75600.610167]  [<c10ec5e8>]
__access_remote_vm+0x28/0x170
Jun 20 08:53:21 soho kernel: [75600.610174]  [<c10436be>] ? get_task_mm
+0x3e/0x60
Jun 20 08:53:21 soho kernel: [75600.610181]  [<c10ec97b>]
access_process_vm+0x4b/0x70
Jun 20 08:53:21 soho kernel: [75600.610190]  [<c115d975>]
proc_pid_cmdline+0x75/0xf0
Jun 20 08:53:21 soho kernel: [75600.610197]  [<c115e047>] proc_info_read
+0x77/0xc0
Jun 20 08:53:21 soho kernel: [75600.610204]  [<c1114b38>] vfs_read
+0x88/0x160
Jun 20 08:53:21 soho kernel: [75600.610211]  [<c115dfd0>] ?
proc_loginuid_read+0xc0/0xc0
Jun 20 08:53:21 soho kernel: [75600.610217]  [<c1114c4d>] sys_read
+0x3d/0x70
Jun 20 08:53:21 soho kernel: [75600.610224]  [<c134c11f>]
sysenter_do_call+0x12/0x28
Jun 20 08:53:50 soho -- MARK --

