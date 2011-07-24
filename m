Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab1GXBdF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 21:33:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab1GXBdA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 21:33:00 -0400
Date: Sat, 23 Jul 2011 21:32:57 -0400
From: Dave Jones <davej@redhat.com>
To: x86@kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: lockdep trace from post 3.0.
Message-ID: <20110724013257.GA6777@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just got this from a tree pulled this afternoon.

	Dave

WARNING: at kernel/lockdep.c:2532 trace_hardirqs_on_caller+0x77/0x170()
Hardware name: Adamo 13   
Modules linked in: can_raw cmtp kernelcapi hidp can_bcm caif_socket caif af_802154 phonet af_rxrpc can pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key decnet rose ax25 x25 atm appletalk ipx p8022 psnap p8023 fuse ppdev ebtable_nat ebtables parport_pc lp parport ipt_MASQUERADE iptable_nat nf_nat nfsd lockd nfs_acl auth_rpcgss xt_CHECKSUM iptable_mangle sunrpc bridge stp llc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables rfcomm bnep btusb bluetooth arc4 snd_hda_codec_hdmi snd_hda_codec_idt snd_usb_audio snd_hda_intel snd_hda_codec snd_usbmidi_lib snd_hwdep snd_rawmidi snd_seq dell_wmi sparse_keymap snd_seq_device cdc_acm cdc_ether iwlagn cdc_wdm usbnet mii uvcvideo mac80211 snd_pcm videodev dell_laptop v4l2_compat_ioctl32 i2c_i801 dcdbas joydev pcspkr cfg80211 microcode snd_timer iTCO_wdt rfkill iTCO_vendor_support snd soundcore snd_page_alloc tg3 wmi virtio_net kvm_intel kvm ipv6 xts gf128mul dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
Pid: 21180, comm: trinity Not tainted 3.0.0+ #101
Call Trace:
 [<ffffffff81057eac>] warn_slowpath_common+0x83/0x9b
 [<ffffffff814c581b>] ? __bad_area_nosemaphore+0x3a/0x1c2
 [<ffffffff81057ede>] warn_slowpath_null+0x1a/0x1c
 [<ffffffff8108b8ec>] trace_hardirqs_on_caller+0x77/0x170
 [<ffffffff8108b9f2>] trace_hardirqs_on+0xd/0xf
 [<ffffffff814c581b>] __bad_area_nosemaphore+0x3a/0x1c2
 [<ffffffff814c5a02>] bad_area+0x4a/0x51
 [<ffffffff814d3fea>] do_page_fault+0x22a/0x39d
 [<ffffffff814d0ff1>] ? _raw_spin_unlock_irq+0x2d/0x5e
 [<ffffffff810d6709>] ? trace_preempt_on+0x15/0x28
 [<ffffffff81045490>] ? finish_task_switch+0x7c/0xea
 [<ffffffff814d1000>] ? _raw_spin_unlock_irq+0x3c/0x5e
 [<ffffffff814d41fe>] ? sub_preempt_count+0xa1/0xb4
 [<ffffffff810d66e0>] ? time_hardirqs_off+0x1b/0x2f
 [<ffffffff81087d97>] ? trace_hardirqs_off_caller+0x3f/0x9c
 [<ffffffff8126757d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d1925>] page_fault+0x25/0x30
---[ end trace 120056b859fb46b6 ]---

