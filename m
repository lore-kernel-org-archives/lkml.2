Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab2KCXDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 19:03:14 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:60435 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab2KCXDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 19:03:07 -0400
Message-ID: <5095A2A1.5070703@gmail.com>
Date: Sat, 03 Nov 2012 16:02:57 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: WARNING: at arch/x86/kernel/apic/ipi.c:109 default_send_IPI_mask_logical+0xaa/0xe0()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not sure what/where this is coming from.. seen this a few times already.

[16870.135447] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[16870.135448] cfg80211:   (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[16870.135449] cfg80211:   (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[16870.135451] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 3000 mBm)
[20138.399483] ------------[ cut here ]------------
[20138.399497] WARNING: at arch/x86/kernel/apic/ipi.c:109 
default_send_IPI_mask_logical+0xaa/0xe0()
[20138.399500] Hardware name: 0914
[20138.399501] empty IPI mask
[20138.399503] Modules linked in: fuse af_packet xt_LOG xt_tcpudp 
xt_limit xt_pkttype xt_conntrack ipt_REJECT iptable_raw iptable_filter 
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 ip_tables x_tables cpufreq_conservative 
cpufreq_userspace cpufreq_powersave arc4 acpi_cpufreq mperf ath9k 
snd_hda_codec_hdmi mac80211 snd_hda_codec_conexant snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm snd_seq ath9k_common snd_timer ath9k_hw 
snd_seq_device ath cfg80211 snd coretemp ideapad_laptop sparse_keymap 
crc32c_intel pcspkr sr_mod cdrom battery ac soundcore rfkill mei 
iTCO_wdt wmi sg intel_ips iTCO_vendor_support i2c_i801 lpc_ich joydev 
snd_page_alloc mfd_core microcode autofs4 i915 drm_kms_helper thermal 
drm ahci i2c_algo_bit libahci ehci_hcd i2c_core libata video usbcore 
usb_common button processor thermal_sys hwmon scsi_dh_alua scsi_dh_rdac 
scsi_dh_emc scsi_dh_hp_sw scsi_dh
[20138.399579] Pid: 5798, comm: Chrome_CacheThr Not tainted 
3.6.0-00722-gbd0d104 #4
[20138.399581] Call Trace:
[20138.399589]  [<c023040d>] warn_slowpath_common+0x6d/0xa0
[20138.399591]  [<c021e95a>] ? default_send_IPI_mask_logical+0xaa/0xe0
[20138.399593]  [<c021e95a>] ? default_send_IPI_mask_logical+0xaa/0xe0
[20138.399596]  [<c02304be>] warn_slowpath_fmt+0x2e/0x30
[20138.399598]  [<c021e95a>] default_send_IPI_mask_logical+0xaa/0xe0
[20138.399603]  [<c021cac3>] native_send_call_func_ipi+0x43/0x70
[20138.399608]  [<c028d79d>] smp_call_function_many+0x16d/0x200
[20138.399613]  [<c022b4d0>] ? do_flush_tlb_all+0x40/0x40
[20138.399615]  [<c022b596>] native_flush_tlb_others+0x26/0x30
[20138.399617]  [<c022b835>] flush_tlb_page+0x55/0xc0
[20138.399620]  [<c022a8f1>] ptep_set_access_flags+0x51/0x60
[20138.399624]  [<c02fc2b7>] do_wp_page+0x2b7/0x6e0
[20138.399630]  [<c068db44>] ? _raw_spin_lock+0x44/0x50
[20138.399632]  [<c02fe09a>] handle_pte_fault+0x42a/0x7b0
[20138.399634]  [<c0226d6e>] ? arch_flush_lazy_mmu_mode+0x3e/0x60
[20138.399637]  [<c02fe566>] handle_mm_fault+0x146/0x1c0
[20138.399639]  [<c0690c80>] ? spurious_fault+0xaa/0xaa
[20138.399641]  [<c0690d96>] do_page_fault+0x116/0x460
[20138.399647]  [<c0492356>] ? copy_to_user+0x46/0x60
[20138.399649]  [<c0690c80>] ? spurious_fault+0xaa/0xaa
[20138.399652]  [<c068e9ea>] error_code+0x5a/0x60
[20138.399656]  [<c0680000>] ? check_tsc_warp+0x88/0x1a4
[20138.399658]  [<c0690c80>] ? spurious_fault+0xaa/0xaa
[20138.399660] ---[ end trace cf34c8b2f45a88bc ]--

probably can bisect this.. but wont be for a while(2 weeks or so) since 
I am already bisect something else.

Justin P. Mattock
