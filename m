Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab2BLRPC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 12:15:02 -0500
Received: from www17.your-server.de ([213.133.104.17]:50551 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab2BLRO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 12:14:59 -0500
Message-ID: <1329062976.1449.9.camel@localhost.localdomain>
Subject: reclaim is false, SEQ_RX_FRAME unset: REPLY_RX_PHY_CMD
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ilw@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Feb 2012 17:09:36 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

abrt_version:   2.0.7
cmdline:        BOOT_IMAGE=/vmlinuz-3.2.0 root=/dev/sda2 rootfstype=ext4 rootflags=data=writeback ro quiet rhgb
kernel:         3.2.0
reason:         [101743.201071] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:461 iwl_irq_tasklet+0x436/0x860 [iwlwifi]()
time:           Fr 13 Jan 2012 19:34:43 CET

backtrace:
:[101743.201071] WARNING: at drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:461 iwl_irq_tasklet+0x436/0x860 [iwlwifi]()
:[101743.201075] Hardware name: Aspire 1810T
:[101743.201077] reclaim is false, SEQ_RX_FRAME unset: REPLY_RX_PHY_CMD
:[101743.201080] Modules linked in: vfat fat arc4 iwlwifi mac80211 cfg80211 fuse bluetooth nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_REJECT ip6table_filter ip6_tables snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel uvcvideo snd_hda_codec videodev snd_hwdep snd_seq v4l2_compat_ioctl32 usb_storage snd_seq_device snd_pcm acer_wmi snd_timer sparse_keymap rfkill snd joydev soundcore atl1c wmi snd_page_alloc pcspkr acerhdf virtio_net virtio virtio_ring kvm_intel kvm uinput ipv6 [last unloaded: scsi_wait_scan]
:[101743.201125] Pid: 0, comm: swapper Tainted: G        W    3.2.0 #2
:[101743.201128] Call Trace:
:[101743.201131]  <IRQ>  [<ffffffff8103225a>] warn_slowpath_common+0x7a/0xb0
:[101743.201143]  [<ffffffff81018a18>] ? lapic_next_event+0x18/0x20
:[101743.201148]  [<ffffffff81032331>] warn_slowpath_fmt+0x41/0x50
:[101743.201153]  [<ffffffff810298e4>] ? __enqueue_entity+0x74/0x80
:[101743.201160]  [<ffffffffa02d0876>] iwl_irq_tasklet+0x436/0x860 [iwlwifi]
:[101743.201166]  [<ffffffff810374aa>] tasklet_action+0x4a/0x90
:[101743.201172]  [<ffffffff81081386>] ? handle_irq_event_percpu+0x86/0x150
:[101743.201177]  [<ffffffff810377b7>] __do_softirq+0x87/0x110
:[101743.201183]  [<ffffffff81493f3a>] call_softirq+0x1a/0x30
:[101743.201187]  [<ffffffff810038bd>] do_softirq+0x4d/0x80
:[101743.201191]  [<ffffffff81037a1e>] irq_exit+0x7e/0xa0
:[101743.201195]  [<ffffffff8100375b>] do_IRQ+0x5b/0xd0
:[101743.201199]  [<ffffffff8148d7e9>] common_interrupt+0x69/0x69
:[101743.201201]  <EOI>  [<ffffffff8124ddc9>] ? acpi_idle_enter_bm+0x1c0/0x1ff
:[101743.201210]  [<ffffffff8124ddc4>] ? acpi_idle_enter_bm+0x1bb/0x1ff
:[101743.201216]  [<ffffffff813a1ea4>] ? menu_select+0xd4/0x390
:[101743.201221]  [<ffffffff813a0efb>] cpuidle_idle_call+0x8b/0xe0
:[101743.201225]  [<ffffffff810011ed>] cpu_idle+0x9d/0xe0
:[101743.201231]  [<ffffffff8147ca2e>] rest_init+0x62/0x64
:[101743.201236]  [<ffffffff81697b54>] start_kernel+0x358/0x363
:[101743.201240]  [<ffffffff81697322>] x86_64_start_reservations+0x132/0x136
:[101743.201244]  [<ffffffff81697416>] x86_64_start_kernel+0xf0/0xf7
:[101743.201248]  [<ffffffff81017e70>] ? acpi_suspend_lowlevel+0x1b0/0x1b0

END:

