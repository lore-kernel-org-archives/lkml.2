Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab0JLSoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:44:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60883 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab0JLSow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=WyfHz/FPxiGGhqr4W95pxeshPGeYJL/R1aeUdSKtA+qzs5z3K+keiXchJyrYfH8iCh
         xEXSYhAjSqCo6uRpvRPTfKR8axloh7ZR6gpxWZxVDW4VX1IL7lAH4GrYW7eSLmadJVqX
         GRh3+iuITTwnf2hCbfjvWOnWAKrFaD33QmcM8=
MIME-Version: 1.0
Date: Wed, 13 Oct 2010 00:14:51 +0530
Message-ID: <AANLkTimAbCZNhLQ5nADUiAC+7JpAeJBEmjFwdxyZ-FxO@mail.gmail.com>
Subject: [LogFS] [2.6.36-rc7] Kernel BUG at lib/btree.c:465!
From: Prasad Joshi <prasadjoshi124@gmail.com>
To: linux-fsdevel@vger.kernel.org, Joern <joern@logfs.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oct 11 20:10:18 localhost kernel: ------------[ cut here ]------------
Oct 11 20:10:18 localhost kernel: kernel BUG at lib/btree.c:465!
Oct 11 20:10:18 localhost kernel: invalid opcode: 0000 [#1] SMP
Oct 11 20:10:18 localhost kernel: last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.1/0000:0b:00.0/ssb0:0/net/wlan0/statistics/collisions
Oct 11 20:10:19 localhost kernel: CPU 1
Oct 11 20:10:19 localhost kernel: Modules linked in: logfs
zlib_deflate fuse sunrpc cpufreq_ondemand acpi_cpufreq freq_table
mperf dm_multipath uinput arc4 ecb snd_hda_codec_idt
snd_hda_codec_intelhdmi b43 mac80211 snd_hda_intel snd_hda_codec
snd_hwdep sdhci_pci firewire_ohci snd_seq snd_seq_device snd_pcm sdhci
cfg80211 snd_timer uvcvideo firewire_core snd ssb mmc_core sky2
videodev crc_itu_t i2c_i801 iTCO_wdt iTCO_vendor_support soundcore
snd_page_alloc v4l1_compat shpchp v4l2_compat_ioctl32 joydev pcspkr
dell_laptop dcdbas serio_raw dell_wmi wmi i915 drm_kms_helper drm
i2c_algo_bit i2c_core video output [last unloaded: logfs]
Oct 11 20:10:19 localhost kernel:
Oct 11 20:10:19 localhost kernel: Pid: 3090, comm: fs_stress Not
tainted 2.6.36-rc7+ #2 0U990C/Inspiron 1525
Oct 11 20:10:19 localhost kernel: RIP: 0010:[<ffffffff8120f4e6>]
[<ffffffff8120f4e6>] btree_insert_level+0x121/0x38c
Oct 11 20:10:19 localhost kernel: RSP: 0018:ffff8800746399b8  EFLAGS: 00010246
Oct 11 20:10:19 localhost kernel: RAX: 0000000000000000 RBX:
ffffffff81a70000 RCX: ffff880074639a40
Oct 11 20:10:19 localhost kernel: RDX: ffff88006aff44a0 RSI:
ffff88006aff4480 RDI: 0000000000000001
Oct 11 20:10:19 localhost kernel: RBP: ffff880074639a18 R08:
0000000000000001 R09: 0000000000000050
Oct 11 20:10:19 localhost kernel: R10: ffff8800021147f0 R11:
ffff880007b88040 R12: ffff88006aff4480
Oct 11 20:10:19 localhost kernel: R13: ffff88007c91fc80 R14:
0000000000000004 R15: 0000000000000005
Oct 11 20:10:19 localhost kernel: FS:  00007f73d384d710(0000)
GS:ffff880002100000(0000) knlGS:0000000000000000
Oct 11 20:10:19 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Oct 11 20:10:19 localhost kernel: CR2: 00007f2090004f68 CR3:
0000000076b90000 CR4: 00000000000406e0
Oct 11 20:10:19 localhost kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Oct 11 20:10:19 localhost kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Oct 11 20:10:19 localhost kernel: Process fs_stress (pid: 3090,
threadinfo ffff880074638000, task ffff8800372e5cc0)
Oct 11 20:10:19 localhost kernel: Stack:
Oct 11 20:10:19 localhost kernel: ffff88003adf3d80 ffff8800734cc000
00000002746399d8 ffff880007b88140
Oct 11 20:10:19 localhost kernel: <0> 0000000100000050
ffff880074639a40 ffff88003adf3d80 ffff88007c91f000
Oct 11 20:10:19 localhost kernel: <0> ffff880007b88140
ffff8800734cc000 ffff88003adf3d80 00000000000009a5
Oct 11 20:10:19 localhost kernel: Call Trace:
Oct 11 20:10:19 localhost kernel: [<ffffffff8120f763>] btree_insert+0x12/0x14
Oct 11 20:10:19 localhost kernel: [<ffffffffa0172cdc>]
fill_shadow_tree+0x279/0x2d2 [logfs]
Oct 11 20:10:19 localhost kernel: [<ffffffffa01731cb>]
logfs_write_i0+0x144/0x183 [logfs]
Oct 11 20:10:19 localhost kernel: [<ffffffffa017417d>]
__logfs_write_rec+0x10a/0x1bb [logfs]
Oct 11 20:10:19 localhost kernel: [<ffffffffa017416f>]
__logfs_write_rec+0xfc/0x1bb [logfs]
Oct 11 20:10:19 localhost kernel: [<ffffffffa0174288>]
logfs_write_rec+0x5a/0xa5 [logfs]
Oct 11 20:10:19 localhost kernel: [<ffffffffa01746b8>]
__logfs_delete+0x61/0x63 [logfs]
Oct 11 20:10:19 localhost kernel: [<ffffffffa01753b8>]
logfs_evict_inode+0xe9/0x189 [logfs]
Oct 11 20:10:19 localhost kernel: [<ffffffff8111b61e>] evict+0x27/0x97
Oct 11 20:10:19 localhost kernel: [<ffffffff8111ba62>] iput+0x1c1/0x22a
Oct 11 20:10:19 localhost kernel: [<ffffffffa016ee1b>]
__logfs_create+0x15a/0x182 [logfs]
Oct 11 20:10:19 localhost kernel: [<ffffffffa016ef62>]
logfs_create+0x5a/0x5f [logfs]
