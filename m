Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2BLRPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 12:15:01 -0500
Received: from www17.your-server.de ([213.133.104.17]:50548 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab2BLRO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 12:14:59 -0500
Message-ID: <1329062442.1449.4.camel@localhost.localdomain>
Subject: queueing ieee80211 work while going to suspend
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        johannes <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Feb 2012 17:00:42 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

abrt_version:   2.0.7
cmdline:        BOOT_IMAGE=/vmlinuz-3.2.5 root=/dev/sda2 rootfstype=ext4 rootflags=data=writeback ro quiet rhgb
kernel:         3.2.5
reason:         WARNING: at net/mac80211/util.c:537 ieee80211_can_queue_work+0x35/0x40 [mac80211]()
time:           Mi 08 Feb 2012 14:46:05 CET

backtrace:
:WARNING: at net/mac80211/util.c:537 ieee80211_can_queue_work+0x35/0x40 [mac80211]()
:Hardware name: Aspire 1810T
:queueing ieee80211 work while going to suspend
:Modules linked in: fuse nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_REJECT ip6table_filter ip6_tables snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm arc4 snd_timer snd uvcvideo videodev v4l2_compat_ioctl32 usb_storage btusb soundcore snd_page_alloc acer_wmi virtio_net virtio virtio_ring kvm_intel sparse_keymap bluetooth iwlwifi wmi mac80211 cfg80211 rfkill atl1c pcspkr joydev acerhdf kvm uinput ipv6 [last unloaded: scsi_wait_scan]
:Pid: 0, comm: swapper Not tainted 3.2.5 #6
:Call Trace:
: <IRQ>  [<ffffffff810322ca>] warn_slowpath_common+0x7a/0xb0
: [<ffffffff810323a1>] warn_slowpath_fmt+0x41/0x50
: [<ffffffff8105941e>] ? tick_program_event+0x1e/0x20
: [<ffffffff8104e9be>] ? hrtimer_interrupt+0xfe/0x1f0
: [<ffffffffa01175a5>] ieee80211_can_queue_work+0x35/0x40 [mac80211]
: [<ffffffffa01176fb>] ieee80211_queue_work+0x1b/0x40 [mac80211]
: [<ffffffffa0102cdf>] ieee80211_sta_timer+0x2f/0x40 [mac80211]
: [<ffffffff8103cfcf>] run_timer_softirq+0xef/0x210
: [<ffffffffa0102cb0>] ? ieee80211_sta_bcn_mon_timer+0x40/0x40 [mac80211]
: [<ffffffff81037827>] __do_softirq+0x87/0x110
: [<ffffffff8149463a>] call_softirq+0x1a/0x30
: [<ffffffff810038bd>] do_softirq+0x4d/0x80
: [<ffffffff81037a8e>] irq_exit+0x7e/0xa0
: [<ffffffff8100375b>] do_IRQ+0x5b/0xd0
: [<ffffffff8148de69>] common_interrupt+0x69/0x69
: <EOI>  [<ffffffff8124e125>] ? acpi_idle_enter_bm+0x1c0/0x1ff
: [<ffffffff8124e120>] ? acpi_idle_enter_bm+0x1bb/0x1ff
: [<ffffffff813a24c4>] ? menu_select+0xd4/0x390
: [<ffffffff813a151b>] cpuidle_idle_call+0x8b/0xe0
: [<ffffffff810011ed>] cpu_idle+0x9d/0xe0
: [<ffffffff8147d09e>] rest_init+0x62/0x64
: [<ffffffff81699b54>] start_kernel+0x358/0x363
: [<ffffffff81699322>] x86_64_start_reservations+0x132/0x136
: [<ffffffff81699416>] x86_64_start_kernel+0xf0/0xf7
: [<ffffffff81017e70>] ? acpi_suspend_lowlevel+0x1b0/0x1b0

END:

