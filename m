Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925Ab2FGGQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 02:16:20 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47703 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758443Ab2FGGQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 02:16:18 -0400
MIME-Version: 1.0
Date: Thu, 7 Jun 2012 02:16:16 -0400
Message-ID: <CAHFgRy9jgxOrF=b=oQd-zK5CKxDacOKdBAX_BEuyW+R+sK_GyQ@mail.gmail.com>
Subject: 3.5.0+ - Linus GIT - WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0xeb/0x15f()
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wim Van Sebroeck <wim@iguana.be>, Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0xeb/0x15f()
Hardware name: UL50VT
NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
Modules linked in: hfsplus hfs vfat msdos fat snd_hrtimer ipv6
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm_oss snd_seq_dummy snd_mixer_oss uvcvideo videobuf2_core
snd_pcm videodev snd_seq_oss snd_seq_midi snd_rawmidi media
snd_seq_midi_event acpi_cpufreq videobuf2_vmalloc videobuf2_memops
snd_seq iwlwifi snd_timer snd_seq_device asus_laptop mac80211
sparse_keymap snd cfg80211 coretemp soundcore psmouse snd_page_alloc
rtc_cmos mperf processor evdev rfkill battery led_class input_polldev
ac i915 nouveau sr_mod cdrom sd_mod ehci_hcd atl1c uhci_hcd intel_agp
ttm usbcore intel_gtt usb_common drm_kms_helper thermal video
thermal_sys hwmon button
Pid: 3025, comm: hud-service Not tainted 3.5.0-rc1+ #128
Call Trace:
 <IRQ>  [<ffffffff8102d42f>] warn_slowpath_common+0x7e/0x97
 [<ffffffff8102d4dc>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff81360f1c>] dev_watchdog+0xeb/0x15f
 [<ffffffff8103af44>] run_timer_softirq+0x20e/0x356
 [<ffffffff8103ae7e>] ? run_timer_softirq+0x148/0x356
 [<ffffffff81360e31>] ? netif_tx_unlock+0x57/0x57
 [<ffffffff810344f8>] __do_softirq+0x103/0x239
 [<ffffffff8107122a>] ? clockevents_program_event+0x9c/0xb9
 [<ffffffff8140a4cc>] call_softirq+0x1c/0x30
 [<ffffffff81003bb9>] do_softirq+0x37/0x82
 [<ffffffff81034888>] irq_exit+0x4c/0xb1
 [<ffffffff8101ba71>] smp_apic_timer_interrupt+0x76/0x84
 [<ffffffff81409adc>] apic_timer_interrupt+0x6c/0x80
 <EOI>  [<ffffffff81105161>] ? fget_raw_light+0x4c/0x7d
 [<ffffffff81105161>] ? fget_raw_light+0x4c/0x7d
 [<ffffffff8111153b>] sys_fcntl+0x23/0x53b
 [<ffffffff81004b68>] ? print_context_stack+0x44/0xb1
 [<ffffffff81408fe2>] system_call_fastpath+0x16/0x1b
---[ end trace c1f284d9c873031d ]---
