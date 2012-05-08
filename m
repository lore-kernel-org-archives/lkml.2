Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab2EHNV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:21:59 -0400
Received: from proxyz12.mailnet.ptd.net ([204.186.204.104]:52065 "EHLO
	proxyz12.mailnet.ptd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab2EHNV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:21:57 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 May 2012 09:21:57 EDT
Message-ID: <4FA91C28.5080803@ptd.net>
Date: Tue, 08 May 2012 09:14:16 -0400
From: John <johnyost@ptd.net>
Organization: retired
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel BUG at mm/mmap.c 464!
X-Enigmail-Version: 1.4.1
OpenPGP: id=E23E3A2A
Content-Type: multipart/mixed;
 boundary="------------070905010202040902070307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070905010202040902070307
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Maintainers:
I received this entry in my syslog while the computer was idle.
See attached txt file 'mm_mmap_BUG.txt'

If this is not a real bug please accept my apologies for the
interruption. If the bug is real I would like to be personally CC'ed
the answers/comments posted to the list in response to this post.
I would be pleased to provide any additional information which may be
helpfull.	

The system was an athlon 64 X2 w 8GB memory
See attached 'lspci.txt'

I was running Slackware-current dated Mon May  7 18:54:03 UTC 2012
Kernel 3.3.4 was compiled using Slackware's config-generic-3.2.13.x64
all defaults were accepted during make oldconfig
.config changed only as follows:
processor was set K8
ext2/3/4 were changed from modules to builtins

anxiously awaiting any response
john

- -- 
John David Yost
AlleyTrotter
pub   4096R/E23E3A2A 2012-04-29 [expires: 2013-04-29]
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPqRwnAAoJEONdQfniPjoqH3YP/33r1OQBtDVFOUvkaz08E8L6
QkZw5nMpCOgwW9x3DVFoGlejdv0lfYLmbgr1J9R9AY1ur+n3xt3sVk1BfO+pa59R
m/m35Nk5/IJisZP9nMAPDfR+b7g6c2NC+XdMTs6Z1HVMrYEMkmamq4M5ib7Li2lj
JRnBpmb6Bbo1lK6FAnktZEJZ1badO8siHOJZ6lq04F7joKGpSgpAxYn2IIBoNDqO
Xs0H21MON2EduwIX4lfe6ADatmkmDKVdV3BDuyJwGJHeuJMO4Ja3ywIckUIDAGmS
71E+FNtvWKFgFi2VD6bOcmAqrShsHZG3bKS9AGnUiTXbb01Ibs5yp0eF5fIGyREt
GdC0NwaWYlit5s8VL14H0F27uNr8mIMyCTTu04DGq2lIn7GLP7sc/I6iFtNeuAqI
8paTDV2o55uci99XvnUAAzhKI0dDfAJfC8d039p4up/+XEm8rrZ9Vx5GlZrxlBqg
NLw1g1wq5F8V+h5NU7KQCZgj7g1vbI2cgSv4NZ7lB1ceih+Fm0Rf5Nr+k2JiCJvn
XYQPrGbXki3TlDXOmAXybvCiU0TD/8/R6plJrcNmIaKzgbyE8jhb62TDK/gn5hh9
eR/Hgdpw0gm82WP7U8HVj0o7rop6XWgs2f2Gi4N7gZ1dxKRZZ5hnAyY5EwZBrYYj
FPuVjTwGq1w1/DCmkm2T
=ssWR
-----END PGP SIGNATURE-----

--------------070905010202040902070307
Content-Type: application/pgp-keys;
 name="0xE23E3A2A.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0xE23E3A2A.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.11 (GNU/Linux)

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
=CQ/2
-----END PGP PUBLIC KEY BLOCK-----

--------------070905010202040902070307
Content-Type: text/plain; charset=ISO-8859-1;
 name="mm_mmap_BUG.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mm_mmap_BUG.txt"

May  7 22:57:44 retired kernel: [ 5753.667900] ------------[ cut here ]------------
May  7 22:57:44 retired kernel: [ 5753.667923] kernel BUG at mm/mmap.c:464!
May  7 22:57:44 retired kernel: [ 5753.667930] invalid opcode: 0000 [#1] SMP 
May  7 22:57:44 retired kernel: [ 5753.667940] CPU 0 
May  7 22:57:44 retired kernel: [ 5753.667944] Modules linked in: cpufreq_conservative powernow_k8 freq_table mperf snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 xt_limit xt_pkttype xt_tcpudp ipt_LOG xt_state iptable_mangle iptable_nat iptable_filter nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables nls_iso8859_1 nls_cp437 vfat fat lp fuse usblp usbhid hid usb_storage uas ohci_hcd ssb ppdev snd_hda_codec_idt processor nouveau ttm nv_tco snd_hda_intel snd_hda_codec mmc_core pcmcia parport_pc drm_kms_helper drm agpgart mxm_wmi video thermal_sys ehci_hcd i2c_nforce2 k8temp parport pcmcia_core i2c_core hwmon tg3 libphy wmi snd_hwdep evdev sg dcdbas snd_pcm snd_timer snd soundcore snd_page_alloc button serio_raw loop
May  7 22:57:44 retired kernel: [ 5753.668009] 
May  7 22:57:44 retired kernel: [ 5753.668009] Pid: 7979, comm: nepomukindexer Not tainted 3.3.4 #1 Dell Inc. OptiPlex 740/0TT708
May  7 22:57:44 retired kernel: [ 5753.668009] RIP: 0010:[<ffffffff81110d3a>]  [<ffffffff81110d3a>] vma_adjust+0x52a/0x530
May  7 22:57:44 retired kernel: [ 5753.668009] RSP: 0018:ffff8801e4addd28  EFLAGS: 00010287
May  7 22:57:44 retired kernel: [ 5753.668009] RAX: 00007fedd6e67000 RBX: ffff8801e48af0a8 RCX: ffff8801f6e9c2d8
May  7 22:57:44 retired kernel: [ 5753.668009] RDX: ffff8801f6e9c2a0 RSI: ffff8801e4b45930 RDI: 0000000000000001
May  7 22:57:44 retired kernel: [ 5753.668009] RBP: ffff8801e4adddb8 R08: ffff8801e4b45978 R09: ffff8801e4b45968
May  7 22:57:44 retired kernel: [ 5753.668009] R10: 00007fedd6e68000 R11: 0000000000000206 R12: ffff8801e48af348
May  7 22:57:44 retired kernel: [ 5753.668009] R13: ffff8801e4b45498 R14: ffff88022eacb8f0 R15: 0000000000000000
May  7 22:57:44 retired kernel: [ 5753.668009] FS:  00007feddf4207c0(0000) GS:ffff88023fc00000(0000) knlGS:0000000000000000
May  7 22:57:44 retired kernel: [ 5753.668009] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
May  7 22:57:44 retired kernel: [ 5753.668009] CR2: 00007feddb07c000 CR3: 00000001e496b000 CR4: 00000000000006f0
May  7 22:57:44 retired kernel: [ 5753.668009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May  7 22:57:44 retired kernel: [ 5753.668009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May  7 22:57:44 retired kernel: [ 5753.668009] Process nepomukindexer (pid: 7979, threadinfo ffff8801e4adc000, task ffff8802344d1b80)
May  7 22:57:44 retired kernel: [ 5753.668009] Stack:
May  7 22:57:44 retired kernel: [ 5753.668009]  ffff8801e4aea380 ffff8801e4aea388 0000000000000000 00000001ffffed73
May  7 22:57:44 retired kernel: [ 5753.668009]  00007fedd6e67000 0000000000000000 00000000e4adddb8 00007fedd82fc000
May  7 22:57:44 retired kernel: [ 5753.668009]  ffff88021721dd00 0000000000000000 ffff88023213c380 ffff88022eacb910
May  7 22:57:44 retired kernel: [ 5753.668009] Call Trace:
May  7 22:57:44 retired kernel: [ 5753.668009]  [<ffffffff81110e43>] __split_vma+0x103/0x1f0
May  7 22:57:44 retired kernel: [ 5753.668009]  [<ffffffff811128f0>] split_vma+0x20/0x30
May  7 22:57:44 retired kernel: [ 5753.668009]  [<ffffffff8111379d>] mprotect_fixup+0x58d/0x680
May  7 22:57:44 retired kernel: [ 5753.668009]  [<ffffffff810284c4>] ? do_page_fault+0x1a4/0x480
May  7 22:57:44 retired kernel: [ 5753.668009]  [<ffffffff81113a18>] sys_mprotect+0x188/0x270
May  7 22:57:44 retired kernel: [ 5753.668009]  [<ffffffff815b3012>] system_call_fastpath+0x16/0x1b
May  7 22:57:44 retired kernel: [ 5753.668009] Code: 84 7a ff ff ff e9 c4 fb ff ff 48 89 5a 10 e9 f8 fd ff ff b8 f4 ff ff ff e9 7b fe ff ff 49 8b 45 10 48 39 46 08 0f 83 af fe ff ff <0f> 0b 0f 1f 40 00 55 48 89 e5 48 83 ec 40 48 89 5d d8 4c 89 65 
May  7 22:57:44 retired kernel: [ 5753.668009] RIP  [<ffffffff81110d3a>] vma_adjust+0x52a/0x530
May  7 22:57:44 retired kernel: [ 5753.668009]  RSP <ffff8801e4addd28>
May  7 22:57:44 retired kernel: [ 5753.677144] ---[ end trace 502d4882d4041318 ]---
May  8 06:09:05 retired kernel: [31634.820582] [drm] nouveau 0000:03:00.0: EvoCh 1 Mthd 0x0080 Data 0x00000000 (0x0006 0x05)

--------------070905010202040902070307
Content-Type: text/plain; charset=ISO-8859-1;
 name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lspci.txt"

00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
00:02.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
00:03.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
00:04.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a3)
00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a3)
00:0a.2 RAM memory: nVidia Corporation MCP51 Memory Controller 0 (rev a3)
00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev a1)
00:0f.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev a1)
00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2)
00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5754 Gigabit Ethernet PCI Express (rev 02)
03:00.0 VGA compatible controller: nVidia Corporation G96 [GeForce 9500 GT] (rev a1)

--------------070905010202040902070307--
