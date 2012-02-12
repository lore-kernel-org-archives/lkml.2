Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab2BLRPE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 12:15:04 -0500
Received: from www17.your-server.de ([213.133.104.17]:50554 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab2BLRPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 12:15:00 -0500
Message-ID: <1329063403.1449.14.camel@localhost.localdomain>
Subject: NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jcliburn@gmail.com, chris.snook@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Feb 2012 17:16:43 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

abrt_version:   2.0.7
cmdline:        BOOT_IMAGE=/vmlinuz-3.2.3 root=/dev/sda2 rootfstype=ext4 rootflags=data=writeback ro quiet rhgb
kernel:         3.2.3
reason:         WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x1e7/0x1f0()
time:           Sa 04 Feb 2012 15:31:22 CET

backtrace:
:WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x1e7/0x1f0()
:Hardware name: Aspire 1810T
:NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
:Modules linked in: vfat fat fuse bluetooth nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_REJECT ip6table_filter ip6_tables snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep uvcvideo snd_seq arc4 videodev usb_storage snd_seq_device v4l2_compat_ioctl32 snd_pcm snd_timer acer_wmi iwlwifi snd mac80211 sparse_keymap cfg80211 rfkill soundcore snd_page_alloc joydev wmi acerhdf pcspkr virtio_net virtio atl1c virtio_ring kvm_intel kvm uinput ipv6 [last unloaded: scsi_wait_scan]
:Pid: 0, comm: swapper Not tainted 3.2.3 #5
:Call Trace:
: <IRQ>  [<ffffffff810322ca>] warn_slowpath_common+0x7a/0xb0
: [<ffffffff81018a18>] ? lapic_next_event+0x18/0x20
: [<ffffffff810323a1>] warn_slowpath_fmt+0x41/0x50
: [<ffffffff8104e9be>] ? hrtimer_interrupt+0xfe/0x1f0
: [<ffffffff8102c350>] ? wake_up_process+0x10/0x20
: [<ffffffff813e9397>] dev_watchdog+0x1e7/0x1f0
: [<ffffffff8103cfcf>] run_timer_softirq+0xef/0x210
: [<ffffffff813e91b0>] ? qdisc_reset+0x50/0x50
: [<ffffffff81037827>] __do_softirq+0x87/0x110
: [<ffffffff814945fa>] call_softirq+0x1a/0x30
: [<ffffffff810038bd>] do_softirq+0x4d/0x80
: [<ffffffff81037a8e>] irq_exit+0x7e/0xa0
: [<ffffffff8100375b>] do_IRQ+0x5b/0xd0
: [<ffffffff8148de29>] common_interrupt+0x69/0x69
: <EOI>  [<ffffffff8124e115>] ? acpi_idle_enter_bm+0x1c0/0x1ff
: [<ffffffff8124e110>] ? acpi_idle_enter_bm+0x1bb/0x1ff
: [<ffffffff813a24b4>] ? menu_select+0xd4/0x390
: [<ffffffff813a150b>] cpuidle_idle_call+0x8b/0xe0
: [<ffffffff810011ed>] cpu_idle+0x9d/0xe0
: [<ffffffff8147d08e>] rest_init+0x62/0x64
: [<ffffffff81699b54>] start_kernel+0x358/0x363
: [<ffffffff81699322>] x86_64_start_reservations+0x132/0x136
: [<ffffffff81699416>] x86_64_start_kernel+0xf0/0xf7
: [<ffffffff81017e70>] ? acpi_suspend_lowlevel+0x1b0/0x1b0

END:


