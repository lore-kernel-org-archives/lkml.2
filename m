Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab2DCJ6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 05:58:51 -0400
Received: from www17.your-server.de ([213.133.104.17]:57779 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab2DCJ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 05:58:49 -0400
X-Greylist: delayed 1334 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2012 05:58:49 EDT
Message-ID: <1333445787.5010.3.camel@localhost.localdomain>
Subject: [CUSE/FUSE] - v3.3.0 - WARNING: at fs/inode.c:290 drop_nlink
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 03 Apr 2012 11:36:27 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[212015.864580] ------------[ cut here ]------------
[212015.864590] WARNING: at fs/inode.c:290 drop_nlink+0x40/0x50()
[212015.864594] Hardware name: Aspire 1810T
[212015.864596] Modules linked in: cuse ip6table_filter ip6_tables rndis_wlan rndis_host cdc_ether usbnet cdc_phonet phonet cdc_acm usblp vfat fat fuse nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_REJECT snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep btusb snd_seq snd_seq_device snd_pcm arc4 bluetooth acer_wmi snd_timer iwlwifi snd soundcore mac80211 sparse_keymap cfg80211 rfkill virtio_net virtio virtio_ring kvm_intel kvm uvcvideo videobuf2_core usb_storage videodev snd_page_alloc v4l2_compat_ioctl32 atl1c videobuf2_vmalloc videobuf2_memops wmi pcspkr joydev acerhdf uinput ipv6 [last unloaded: ip6_tables]
[212015.864652] Pid: 22344, comm: osspd Tainted: G        W    3.3.0 #156
[212015.864655] Call Trace:
[212015.864662]  [<ffffffff8102b62a>] warn_slowpath_common+0x7a/0xb0
[212015.864667]  [<ffffffff8102b675>] warn_slowpath_null+0x15/0x20
[212015.864671]  [<ffffffff810ecc80>] drop_nlink+0x40/0x50
[212015.864681]  [<ffffffffa02e88c7>] fuse_ctl_remove_conn+0x77/0x90 [fuse]
[212015.864688]  [<ffffffffa02e743d>] fuse_conn_kill+0xbd/0xf0 [fuse]
[212015.864693]  [<ffffffffa03390ea>] cuse_channel_release+0x7a/0xa0 [cuse]
[212015.864699]  [<ffffffff810d7a1a>] fput+0xda/0x210
[212015.864703]  [<ffffffff810d4c31>] filp_close+0x61/0x90
[212015.864707]  [<ffffffff8102e5a0>] put_files_struct+0x80/0xe0
[212015.864712]  [<ffffffff8102e653>] exit_files+0x23/0x30
[212015.864715]  [<ffffffff8102ebdf>] do_exit+0x57f/0x7b0
[212015.864721]  [<ffffffff8105055d>] ? check_preempt_wakeup+0x12d/0x290
[212015.864725]  [<ffffffff8104fb7c>] ? update_curr+0xec/0x120
[212015.864729]  [<ffffffff8102f107>] do_group_exit+0x37/0x70
[212015.864734]  [<ffffffff810397d3>] get_signal_to_deliver+0x1a3/0x4b0
[212015.864739]  [<ffffffff810020ad>] do_signal+0x5d/0x700
[212015.864745]  [<ffffffff81498f09>] ? schedule+0x39/0x50
[212015.864749]  [<ffffffff8102eb8b>] ? do_exit+0x52b/0x7b0
[212015.864753]  [<ffffffff810027cd>] do_notify_resume+0x5d/0x70
[212015.864758]  [<ffffffff8104c84e>] ? schedule_tail+0xe/0x50
[212015.864763]  [<ffffffff8149f4e4>] int_signal+0x12/0x17
[212015.864766] ---[ end trace a5b7cc65ea2aeccb ]---

