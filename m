Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1DSMs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 08:48:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60387 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1DSMs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 08:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:date:content-type:x-mailer
         :content-transfer-encoding:message-id:mime-version;
        b=KtJaYDBrb26HPUD+GpVjtynPuBWlLRJNaDAwFys1nsTTuEsNbQuBDIRO6bEMCVrlhp
         PCidCkszLa5AkV2AXgqbK95JrZ1kskyKsu9emp8lJNpa5eJRozn3BjfkINOuvtcZyl4y
         a0ieB4mVhQ3N8PttKOqfypW0XjSvkD6ZRHles=
Subject: Re: PROBLEM: some unknown oops (?)
From: "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>
To: linux-kernel@vger.kernel.org
Date: Tue, 19 Apr 2011 14:48:20 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.0 
Content-Transfer-Encoding: 7bit
Message-ID: <1303217301.26866.1.camel@soho.example.org>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

here is some more:
Apr 19 13:47:21 soho kernel: privoxy         D f7304280     0 29584
1 0x00000000
Apr 19 13:47:21 soho kernel: da9dff50 00000086 f6a08900 f7304280
f6de94e0 aebf8fff dc877aec aebf9000
Apr 19 13:47:21 soho kernel: db0f8450 7d1a7067 f5fb8e00 db383d10
00000000 f5a06380 c14c0380 db0f8450
Apr 19 13:47:21 soho kernel: db0f8614 ee7ef174 000057a2 c14c0380
f5a06380 db0f8450 dba20cf0 aebf9000
Apr 19 13:47:21 soho kernel: Call Trace:
Apr 19 13:47:21 soho kernel: [<c10dbb76>] ? zap_page_range+0xe6/0x100
Apr 19 13:47:21 soho kernel: [<c10d8fd7>] ? sys_madvise+0xa7/0x610
Apr 19 13:47:21 soho kernel: [<c111ded9>] ? mntput_no_expire+0x89/0xd0
Apr 19 13:47:21 soho kernel: [<c1319b25>] rwsem_down_failed_common
+0x95/0xe0
Apr 19 13:47:21 soho kernel: [<c1319b82>] rwsem_down_write_failed
+0x12/0x20
Apr 19 13:47:21 soho kernel: [<c1319bea>] call_rwsem_down_write_failed
+0x6/0x8
Apr 19 13:47:21 soho kernel: [<c1319395>] ? down_write+0x15/0x17
Apr 19 13:47:21 soho kernel: [<c10e14cf>] sys_munmap+0x2f/0x60
Apr 19 13:47:21 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 19 13:47:21 soho kernel: privoxy         D c12bfbdd     0 29585
1 0x00000000
Apr 19 13:47:21 soho kernel: dc9a3ee4 00000086 dc9a3e78 c12bfbdd
01b7b76a 00000286 da96d400 da96d4b0
Apr 19 13:47:21 soho kernel: 00000000 dc9a3e64 c127079f da96d4b0
dc9a3e78 f5a06380 c14c0380 db1a9e30
Apr 19 13:47:21 soho kernel: db1a9ff4 ef11a29e 000057a2 c14c0380
f5a06380 db1a9e30 dba20cf0 00000286
Apr 19 13:47:21 soho kernel: Call Trace:
Apr 19 13:47:21 soho kernel: [<c12bfbdd>] ? tcp_transmit_skb+0x35d/0x800
Apr 19 13:47:21 soho kernel: [<c127079f>] ? sk_reset_timer+0xf/0x20
Apr 19 13:47:21 soho kernel: [<c10059f6>] ? do_IRQ+0x46/0xb0
Apr 19 13:47:21 soho kernel: [<c1319b25>] rwsem_down_failed_common
+0x95/0xe0
Apr 19 13:47:21 soho kernel: [<c1319ba2>] rwsem_down_read_failed
+0x12/0x14
Apr 19 13:47:21 soho kernel: [<c1319bdf>] call_rwsem_down_read_failed
+0x7/0xc
Apr 19 13:47:21 soho kernel: [<c131937d>] ? down_read+0xd/0x10
Apr 19 13:47:21 soho kernel: [<c10d8f8f>] sys_madvise+0x5f/0x610
Apr 19 13:47:21 soho kernel: [<c111ded9>] ? mntput_no_expire+0x89/0xd0
Apr 19 13:47:21 soho kernel: [<c111df33>] ? mntput+0x13/0x20
Apr 19 13:47:21 soho kernel: [<c1105c54>] ? fput+0x134/0x1d0
Apr 19 13:47:21 soho kernel: [<c1103349>] ? filp_close+0x49/0x70
Apr 19 13:47:21 soho kernel: [<c11033df>] ? sys_close+0x6f/0xc0
Apr 19 13:47:21 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 19 13:48:38 soho kernel: gnome-settings-[25863]: segfault at
b448c160 ip b448c160 sp bfa6a73c error 4 in libdbus-1.so.3.5.3[b44c0000
+3b000]
Apr 19 13:48:46 soho shutdown[29680]: shutting down for system reboot
Apr 19 13:48:50 soho init: Switching to runlevel: 6
Apr 19 13:49:14 soho shutdown[29738]: shutting down for system reboot
Apr 19 13:49:16 soho shutdown[29740]: shutting down for system reboot
Apr 19 13:49:17 soho shutdown[29742]: shutting down for system reboot
Apr 19 13:49:17 soho shutdown[29744]: shutting down for system reboot
Apr 19 13:49:18 soho shutdown[29746]: shutting down for system reboot
Apr 19 13:49:18 soho shutdown[29748]: shutting down for system reboot
Apr 19 13:49:18 soho shutdown[29750]: shutting down for system reboot
Apr 19 13:49:18 soho shutdown[29752]: shutting down for system reboot
Apr 19 13:49:21 soho kernel: preload         D 00000000     0  2695
1 0x00000000
Apr 19 13:49:21 soho kernel: f3c01ee0 00000086 f38eb810 00000000
dc56e880 f3c01f00 dc56e100 f3c01e78
Apr 19 13:49:21 soho kernel: c110ed4d 0000416d 00000001 f449ef00
f3c01e78 f5806380 c14c0380 f38eb810
Apr 19 13:49:21 soho kernel: f38eb9d4 5d461119 000057a6 c14c0380
f5806380 f38eb810 db85ef70 f5fb4660
Apr 19 13:49:21 soho kernel: Call Trace:
Apr 19 13:49:21 soho kernel: [<c110ed4d>] ? do_lookup+0xdd/0x260
Apr 19 13:49:21 soho kernel: [<c111de75>] ? mntput_no_expire+0x25/0xd0
Apr 19 13:49:21 soho kernel: [<c111df33>] ? mntput+0x13/0x20
Apr 19 13:49:21 soho kernel: [<c1319b25>] rwsem_down_failed_common
+0x95/0xe0
Apr 19 13:49:21 soho kernel: [<c1319ba2>] rwsem_down_read_failed
+0x12/0x14
Apr 19 13:49:21 soho kernel: [<c1319bdf>] call_rwsem_down_read_failed
+0x7/0xc
Apr 19 13:49:21 soho kernel: [<c131937d>] ? down_read+0xd/0x10
Apr 19 13:49:21 soho kernel: [<c114e968>] get_mm_exe_file+0x18/0x40
Apr 19 13:49:21 soho kernel: [<c114e9ce>] proc_exe_link+0x3e/0x90
Apr 19 13:49:21 soho kernel: [<c114ccef>] proc_pid_readlink+0x2f/0xc0
Apr 19 13:49:21 soho kernel: [<c1119abc>] ? touch_atime+0x5c/0x140
Apr 19 13:49:21 soho kernel: [<c111df33>] ? mntput+0x13/0x20
Apr 19 13:49:21 soho kernel: [<c1108e89>] sys_readlinkat+0x89/0x90
Apr 19 13:49:21 soho kernel: [<c1108eb7>] sys_readlink+0x27/0x30
Apr 19 13:49:21 soho kernel: [<c10037df>] sysenter_do_call+0x12/0x28
Apr 19 13:49:21 soho kernel: privoxy         D c12bfbdd     0 29559
1 0x00000000
Apr 19 13:49:21 soho kernel: f358bee4 00000086 f358be78 c12bfbdd
dba99910 f358be64 00000006 00000020
Apr 19 13:49:21 soho kernel: 00008000 00000002 00000000 01b7f3b2
01b7f3b2 f5806380 c14c0380 da92d140
Apr 19 13:49:21 soho kernel: da92d304 f5c60ef9 000057ae c14c0380
f5806380 da92d140 f3c35e30 00000286
Apr 19 13:49:21 soho kernel: Call Trace:
Apr 19 13:49:21 soho kernel: [<c12bfbdd>] ? tcp_transmit_skb+0x35d/0x800
Apr 19 13:49:21 soho kernel: [<c10f379e>] ? add_partial+0x3e/0x70
Apr 19 13:49:21 soho kernel: [<c13150df>] ? __slab_free+0x8c/0x122
Apr 19 13:49:21 soho kernel: [<c1319b25>] rwsem_down_failed_common
+0x95/0xe0
Apr 19 13:49:21 soho kernel: [<c1319ba2>] rwsem_down_read_failed
+0x12/0x14
Apr 19 13:49:21 soho kernel: [<c1319bdf>] call_rwsem_down_read_failed
+0x7/0xc
Apr 19 13:49:21 soho kernel: [<c131937d>] ? down_read+0xd/0x10
Apr 19 13:49:21 soho kernel: [<c10d8f8f>] sys_madvise+0x5f/0x610
Apr 19 13:49:21 soho kernel: [<c111ded9>] ? mntput_no_expire+0x89/0xd0

