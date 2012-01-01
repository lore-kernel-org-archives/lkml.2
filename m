Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab2AAG2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 01:28:07 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52342 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2AAG2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 01:28:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAH1LqYj0pPnv-2dTx5gCXO=S8ypk_fSO6PDpwX-dToJp9ZWOnQ@mail.gmail.com>
References: <CAH1LqYj0pPnv-2dTx5gCXO=S8ypk_fSO6PDpwX-dToJp9ZWOnQ@mail.gmail.com>
From: Vasco Dias <rafa.vasco@gmail.com>
Date: Sun, 1 Jan 2012 06:27:22 +0000
Message-ID: <CAH1LqYiEx0ZEZZWZUsuR3Mj1TC-DX-NPs1VwFPSHiwQExiSv1Q@mail.gmail.com>
Subject: Re: Problem with efibootmgr on asus 1215b
To: linux-kernel@vger.kernel.org
Cc: mikew@google.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the attachments.

relevant kernel.log:
Jan  1 04:30:12 localhost kernel: [ 3103.586496] INFO:
rcu_preempt_state detected stalls on CPUs/tasks: { 1} (detected by 0,
t=450258 jiffies)
Jan  1 04:30:12 localhost kernel: [ 3103.586519] sending NMI to all CPUs:
Jan  1 04:30:12 localhost kernel: [ 2420.190015] NMI backtrace for cpu 1
Jan  1 04:30:12 localhost kernel: [ 2420.190015] CPU 1
Jan  1 04:30:12 localhost kernel: [ 2420.190015] Modules linked in:
efivars ipv6 fuse uvcvideo videodev media joydev v4l2_compat_ioctl32
bcma arc4 snd_hda_codec_realtek snd_hda_codec_hdmi i2c_piix4
brcmsmac(C) snd_hda_intel mac80211 snd_hda_codec snd_hwdep snd_pcm
snd_timer brcmutil(C) cfg80211 serio_raw snd eeepc_wmi asus_wmi
sparse_keymap ohci_hcd xhci_hcd ehci_hcd pcspkr psmouse evdev usbcore
soundcore snd_page_alloc sp5100_tco k10temp rfkill pci_hotplug thermal
wmi video ac battery button cpufreq_ondemand powernow_k8 freq_table
processor mperf ext4 mbcache jbd2 crc16 sd_mod ahci libahci libata
scsi_mod radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
Jan  1 04:30:12 localhost kernel: [ 2420.190015]
Jan  1 04:30:12 localhost kernel: [ 2420.190015] Pid: 1426, comm:
efibootmgr Tainted: G      D WC  3.1.6-1-ARCH #1 ASUSTeK Computer INC.
1215B/1215B
Jan  1 04:30:12 localhost kernel: [ 2420.190015] RIP:
0010:[<ffffffff81409b69>]  [<ffffffff81409b69>]
_raw_spin_lock+0x29/0x30
Jan  1 04:30:12 localhost kernel: [ 2420.190015] RSP:
0018:ffff88012c51d558  EFLAGS: 00000097
Jan  1 04:30:12 localhost kernel: [ 2420.190015] RAX: 0000000000002625
RBX: 0000000000000000 RCX: 0000000000000009
Jan  1 04:30:12 localhost kernel: [ 2420.190015] RDX: 00000000ffffffff
RSI: 0000000000000039 RDI: ffffffffa02fe460
Jan  1 04:30:12 localhost kernel: [ 2420.190015] RBP: ffff88012c51d558
R08: 000000000000000a R09: 000000000000fff4
Jan  1 04:30:12 localhost kernel: [ 2420.190015] R10: 0000000000000000
R11: 0000000000000000 R12: 00000000000119c4
Jan  1 04:30:12 localhost kernel: [ 2420.190015] R13: ffffffffa02fe460
R14: 0000000000000400 R15: 0000000000000400
Jan  1 04:30:12 localhost kernel: [ 2420.190015] FS:
00007fd102cdb700(0000) GS:ffff88013ed00000(0000)
knlGS:0000000000000000
Jan  1 04:30:12 localhost kernel: [ 2420.190015] CS:  0010 DS: 0000
ES: 0000 CR0: 0000000080050033
Jan  1 04:30:12 localhost kernel: [ 2420.190015] CR2: 00000000ffe13c4a
CR3: 000000012827e000 CR4: 00000000000006e0
Jan  1 04:30:12 localhost kernel: [ 2420.190015] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Jan  1 04:30:12 localhost kernel: [ 2420.190015] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan  1 04:30:12 localhost kernel: [ 2420.190015] Process efibootmgr
(pid: 1426, threadinfo ffff88012c51c000, task ffff88010bc52b20)
Jan  1 04:31:57 localhost kernel: [ 2420.190015] Stack:
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  ffff88012c51d6c8
ffffffffa02fcff3 ffffffffa02fe4a0 0000000000000400
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  0000000181abffc0
0000000000000000 ffff88012c51d618 ffffffff81277ffc
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  ffff880137be7a10
00ffffff00000000 ffff88012c51d5e8 00000000402ce684
Jan  1 04:31:57 localhost kernel: [ 2420.190015] Call Trace:
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffffa02fcff3>]
efi_pstore_write+0xc3/0x390 [efivars]
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff81277ffc>]
? cfb_fillrect+0x18c/0x380
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8122f86c>]
? vsnprintf+0x35c/0x600
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8122fb50>]
? sprintf+0x40/0x50
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff811d44c9>]
pstore_dump+0x169/0x1f0
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff810638e4>]
kmsg_dump+0x94/0xe0
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff81061d06>]
oops_exit+0x26/0x30
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff810181cc>]
oops_end+0x7c/0xf0
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff814001df>]
no_context+0x209/0x218
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff814003b7>]
__bad_area_nosemaphore+0x1c9/0x1e8
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff814003e9>]
bad_area_nosemaphore+0x13/0x15
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8103ef1d>]
do_page_fault+0x3dd/0x4c0
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff810580f8>]
? load_balance+0xb8/0x7e0
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8140a725>]
page_fault+0x25/0x30
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff811ce88d>]
? open+0x10d/0x1b0
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8115b702>]
? __dentry_open+0x242/0x3f0
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff811ce780>]
? bin_vma_open+0x70/0x70
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff81048b8b>]
? efi_call5+0x4b/0x80
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff810483e1>]
? virt_efi_set_variable+0x31/0x40
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffffa02fd4c2>]
? efivar_create+0x1e2/0x280 [efivars]
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff811cea41>]
? write+0x111/0x190
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8115d81f>]
? vfs_write+0xaf/0x180
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8115db4a>]
? sys_write+0x4a/0x90
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8140acc2>]
? system_call_fastpath+0x16/0x1b
Jan  1 04:31:57 localhost kernel: [ 2420.190015] Code: 90 90 55 48 89
e5 66 66 66 66 90 65 48 8b 04 25 88 c4 00 00 83 80 44 e0 ff ff 01 b8
00 01 00 00 f0 66 0f c1 07 38 e0 74 06 f3 90 <8a> 07 eb f6 5d c3 90 55
48 89 e5 66 66 66 66 90 9c 58 66 66 90
Jan  1 04:31:57 localhost kernel: [ 2420.190015] Call Trace:
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffffa02fcff3>]
efi_pstore_write+0xc3/0x390 [efivars]
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff81277ffc>]
? cfb_fillrect+0x18c/0x380
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8122f86c>]
? vsnprintf+0x35c/0x600
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8122fb50>]
? sprintf+0x40/0x50
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff811d44c9>]
pstore_dump+0x169/0x1f0
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff810638e4>]
kmsg_dump+0x94/0xe0
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff81061d06>]
oops_exit+0x26/0x30
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff810181cc>]
oops_end+0x7c/0xf0
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff814001df>]
no_context+0x209/0x218
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff814003b7>]
__bad_area_nosemaphore+0x1c9/0x1e8
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff814003e9>]
bad_area_nosemaphore+0x13/0x15
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8103ef1d>]
do_page_fault+0x3dd/0x4c0
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff810580f8>]
? load_balance+0xb8/0x7e0
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8140a725>]
page_fault+0x25/0x30
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff811ce88d>]
? open+0x10d/0x1b0
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8115b702>]
? __dentry_open+0x242/0x3f0
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff811ce780>]
? bin_vma_open+0x70/0x70
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff81048b8b>]
? efi_call5+0x4b/0x80
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff810483e1>]
? virt_efi_set_variable+0x31/0x40
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffffa02fd4c2>]
? efivar_create+0x1e2/0x280 [efivars]
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff811cea41>]
? write+0x111/0x190
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8115d81f>]
? vfs_write+0xaf/0x180
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8115db4a>]
? sys_write+0x4a/0x90
Jan  1 04:31:57 localhost kernel: [ 2420.190015]  [<ffffffff8140acc2>]
? system_call_fastpath+0x16/0x1b
Jan  1 04:31:57 localhost kernel: [ 3103.587495] NMI backtrace for cpu 0
Jan  1 04:31:57 localhost kernel: [ 3103.587501] CPU 0
Jan  1 04:31:57 localhost kernel: [ 3103.587506] Modules linked in:
efivars ipv6 fuse uvcvideo videodev media joydev v4l2_compat_ioctl32
bcma arc4 snd_hda_codec_realtek snd_hda_codec_hdmi i2c_piix4
brcmsmac(C) snd_hda_intel mac80211 snd_hda_codec snd_hwdep snd_pcm
snd_timer brcmutil(C) cfg80211 serio_raw snd eeepc_wmi asus_wmi
sparse_keymap ohci_hcd xhci_hcd ehci_hcd pcspkr psmouse evdev usbcore
soundcore snd_page_alloc sp5100_tco k10temp rfkill pci_hotplug thermal
wmi video ac battery button cpufreq_ondemand powernow_k8 freq_table
processor mperf ext4 mbcache jbd2 crc16 sd_mod ahci libahci libata
scsi_mod radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
Jan  1 04:31:57 localhost kernel: [ 3103.587662]
Jan  1 04:31:57 localhost kernel: [ 3103.587671] Pid: 0, comm: swapper
Tainted: G      D WC  3.1.6-1-ARCH #1 ASUSTeK Computer INC.
1215B/1215B
Jan  1 04:31:57 localhost kernel: [ 3103.587685] RIP:
0010:[<ffffffff810362d6>]  [<ffffffff810362d6>]
flat_send_IPI_all+0x66/0x70
Jan  1 04:31:57 localhost kernel: [ 3103.587707] RSP:
0018:ffff88013ec03dd0  EFLAGS: 00000082
Jan  1 04:31:57 localhost kernel: [ 3103.587715] RAX: 0000000000000c00
RBX: 0000000000002710 RCX: 0000000000000005
Jan  1 04:31:57 localhost kernel: [ 3103.587722] RDX: 0000000000000000
RSI: 0000000000000002 RDI: 0000000000000082
Jan  1 04:31:57 localhost kernel: [ 3103.587730] RBP: ffff88013ec03de8
R08: 000000000000000a R09: 0000000000000000
Jan  1 04:31:57 localhost kernel: [ 3103.587738] R10: 0000000000000000
R11: 0000000000000001 R12: ffffffff818bd500
Jan  1 04:31:57 localhost kernel: [ 3103.587745] R13: ffffffff818bd600
R14: ffffffff818bda00 R15: 0000000000000087
Jan  1 04:31:57 localhost kernel: [ 3103.587755] FS:
00007fe149b5e700(0000) GS:ffff88013ec00000(0000)
knlGS:0000000000000000
Jan  1 04:31:57 localhost kernel: [ 3103.587764] CS:  0010 DS: 0000
ES: 0000 CR0: 000000008005003b
Jan  1 04:31:57 localhost kernel: [ 3103.587770] CR2: 00007f35caba1000
CR3: 000000012c760000 CR4: 00000000000006f0
Jan  1 04:31:57 localhost kernel: [ 3103.587778] DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
Jan  1 04:31:57 localhost kernel: [ 3103.587786] DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan  1 04:31:57 localhost kernel: [ 3103.587795] Process swapper (pid:
0, threadinfo ffffffff81800000, task ffffffff8189d020)
Jan  1 04:31:57 localhost kernel: [ 3103.587802] Stack:
Jan  1 04:31:57 localhost kernel: [ 3103.587807]  ffffffff810332fa
000000000000000a ffff88013ec0e2c0 ffff88013ec03e38
Jan  1 04:31:57 localhost kernel: [ 3103.587821]  ffffffff810cae81
0000000000000046 ffffffff818bda00 00000000201d6000
Jan  1 04:31:57 localhost kernel: [ 3103.587833]  0000000000000000
0000000000000000 0000000000000000 ffff88013ec0df80
Jan  1 04:31:57 localhost kernel: [ 3103.587846] Call Trace:
Jan  1 04:31:57 localhost kernel: [ 3103.587852]  <IRQ>
Jan  1 04:31:57 localhost kernel: [ 3103.587864]  [<ffffffff810332fa>]
? arch_trigger_all_cpu_backtrace+0x5a/0x90
Jan  1 04:31:57 localhost kernel: [ 3103.587877]  [<ffffffff810cae81>]
__rcu_pending+0x391/0x3c0
Jan  1 04:31:57 localhost kernel: [ 3103.587888]  [<ffffffff810cbdf2>]
rcu_check_callbacks+0x132/0x1b0
Jan  1 04:31:57 localhost kernel: [ 3103.587900]  [<ffffffff81073308>]
update_process_times+0x48/0x90
Jan  1 04:31:57 localhost kernel: [ 3103.587913]  [<ffffffff81096854>]
tick_sched_timer+0x64/0xc0
Jan  1 04:31:57 localhost kernel: [ 3103.587924]  [<ffffffff81088964>]
__run_hrtimer+0x74/0x2c0
Jan  1 04:31:57 localhost kernel: [ 3103.587935]  [<ffffffff810967f0>]
? tick_nohz_handler+0x100/0x100
Jan  1 04:31:57 localhost kernel: [ 3103.587945]  [<ffffffff8101c139>]
? read_tsc+0x9/0x20
Jan  1 04:31:57 localhost kernel: [ 3103.587955]  [<ffffffff81089623>]
hrtimer_interrupt+0xf3/0x210
Jan  1 04:31:57 localhost kernel: [ 3103.587968]  [<ffffffff8140d8c9>]
smp_apic_timer_interrupt+0x69/0x99
Jan  1 04:31:57 localhost kernel: [ 3103.587979]  [<ffffffff8140b79e>]
apic_timer_interrupt+0x6e/0x80
Jan  1 04:31:57 localhost kernel: [ 3103.587986]  <EOI>
Jan  1 04:31:57 localhost kernel: [ 3103.587995]  [<ffffffff8101c643>]
? native_sched_clock+0x13/0x80
Jan  1 04:31:57 localhost kernel: [ 3103.588016]  [<ffffffffa0186e5e>]
? acpi_idle_enter_simple+0xf5/0x12d [processor]
Jan  1 04:31:57 localhost kernel: [ 3103.588032]  [<ffffffffa0186e5a>]
? acpi_idle_enter_simple+0xf1/0x12d [processor]
Jan  1 04:31:57 localhost kernel: [ 3103.588045]  [<ffffffff8131dc96>]
cpuidle_idle_call+0xc6/0x350
Jan  1 04:31:57 localhost kernel: [ 3103.588056]  [<ffffffff81013229>]
cpu_idle+0xc9/0x120
Jan  1 04:31:57 localhost kernel: [ 3103.588068]  [<ffffffff813e70f2>]
rest_init+0x96/0xa4
Jan  1 04:31:57 localhost kernel: [ 3103.588079]  [<ffffffff8194fc15>]
start_kernel+0x3bf/0x3cc
Jan  1 04:31:57 localhost kernel: [ 3103.588091]  [<ffffffff8194f347>]
x86_64_start_reservations+0x132/0x136
Jan  1 04:31:57 localhost kernel: [ 3103.588102]  [<ffffffff8194f140>]
? early_idt_handlers+0x140/0x140
Jan  1 04:31:57 localhost kernel: [ 3103.588113]  [<ffffffff8194f44d>]
x86_64_start_kernel+0x102/0x111
Jan  1 04:31:57 localhost kernel: [ 3103.588120] Code: 04 08 00 0d 00
00 08 00 09 f8 83 ff 02 0f 44 c2 89 04 25 00 b3 5f ff 5d c3 48 8b 3d
05 07 5d 00 be 02 00 00 00 e8 8b fd ff ff 5d <c3> 66 0f 1f 84 00 00 00
00 00 55 48 89 e5 66 66 66 66 90 80 3d
Jan  1 04:31:57 localhost kernel: [ 3103.588220] Call Trace:
Jan  1 04:31:57 localhost kernel: [ 3103.588224]  <IRQ>
[<ffffffff810332fa>] ? arch_trigger_all_cpu_backtrace+0x5a/0x90
Jan  1 04:31:57 localhost kernel: [ 3103.588241]  [<ffffffff810cae81>]
__rcu_pending+0x391/0x3c0
Jan  1 04:31:57 localhost kernel: [ 3103.588251]  [<ffffffff810cbdf2>]
rcu_check_callbacks+0x132/0x1b0
Jan  1 04:31:57 localhost kernel: [ 3103.588262]  [<ffffffff81073308>]
update_process_times+0x48/0x90
Jan  1 04:31:57 localhost kernel: [ 3103.588272]  [<ffffffff81096854>]
tick_sched_timer+0x64/0xc0
Jan  1 04:31:57 localhost kernel: [ 3103.588282]  [<ffffffff81088964>]
__run_hrtimer+0x74/0x2c0
Jan  1 04:31:57 localhost kernel: [ 3103.588292]  [<ffffffff810967f0>]
? tick_nohz_handler+0x100/0x100
Jan  1 04:31:57 localhost kernel: [ 3103.588302]  [<ffffffff8101c139>]
? read_tsc+0x9/0x20
Jan  1 04:31:57 localhost kernel: [ 3103.588311]  [<ffffffff81089623>]
hrtimer_interrupt+0xf3/0x210
Jan  1 04:31:57 localhost kernel: [ 3103.588323]  [<ffffffff8140d8c9>]
smp_apic_timer_interrupt+0x69/0x99
Jan  1 04:31:57 localhost kernel: [ 3103.588332]  [<ffffffff8140b79e>]
apic_timer_interrupt+0x6e/0x80
Jan  1 04:31:57 localhost kernel: [ 3103.588339]  <EOI>
[<ffffffff8101c643>] ? native_sched_clock+0x13/0x80
Jan  1 04:31:57 localhost kernel: [ 3103.588362]  [<ffffffffa0186e5e>]
? acpi_idle_enter_simple+0xf5/0x12d [processor]
Jan  1 04:31:57 localhost kernel: [ 3103.588378]  [<ffffffffa0186e5a>]
? acpi_idle_enter_simple+0xf1/0x12d [processor]
Jan  1 04:31:57 localhost kernel: [ 3103.588389]  [<ffffffff8131dc96>]
cpuidle_idle_call+0xc6/0x350
Jan  1 04:31:57 localhost kernel: [ 3103.588399]  [<ffffffff81013229>]
cpu_idle+0xc9/0x120
Jan  1 04:31:57 localhost kernel: [ 3103.588410]  [<ffffffff813e70f2>]
rest_init+0x96/0xa4
Jan  1 04:31:57 localhost kernel: [ 3103.588420]  [<ffffffff8194fc15>]
start_kernel+0x3bf/0x3cc
Jan  1 04:31:57 localhost kernel: [ 3103.588431]  [<ffffffff8194f347>]
x86_64_start_reservations+0x132/0x136
Jan  1 04:31:57 localhost kernel: [ 3103.588442]  [<ffffffff8194f140>]
? early_idt_handlers+0x140/0x140
Jan  1 04:31:57 localhost kernel: [ 3103.588453]  [<ffffffff8194f44d>]
x86_64_start_kernel+0x102/0x111

latest dmesg:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.6-1-ARCH (tobias@T-POWA-LX) (gcc
version 4.6.2 20111125 (prerelease) (GCC) ) #1 SMP PREEMPT Thu Dec 22
09:11:48 CET 2011
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-linux
root=/dev/disk/by-uuid/07dbe71d-e532-45b9-9e37-ea311341b0a6
resume=/dev/disk/by-uuid/2d71cb2c-018e-4b01-8e29-bf6014d85968 ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000a7b51000 (usable)
[    0.000000]  BIOS-e820: 00000000a7b51000 - 00000000a7ba2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000a7ba2000 - 00000000a7cd6000 (reserved)
[    0.000000]  BIOS-e820: 00000000a7cd6000 - 00000000a7ce7000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000a7ce7000 - 00000000a7d0b000 (reserved)
[    0.000000]  BIOS-e820: 00000000a7d0b000 - 00000000a7d0c000 (usable)
[    0.000000]  BIOS-e820: 00000000a7d0c000 - 00000000a7d0d000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000a7d0d000 - 00000000a7d10000 (usable)
[    0.000000]  BIOS-e820: 00000000a7d10000 - 00000000a7d16000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000a7d16000 - 00000000a7d1d000 (reserved)
[    0.000000]  BIOS-e820: 00000000a7d1d000 - 00000000a7d24000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000a7d24000 - 00000000a7d4b000 (reserved)
[    0.000000]  BIOS-e820: 00000000a7d4b000 - 00000000a7d8e000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000a7d8e000 - 00000000a7f00000 (usable)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec11000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed61000 - 00000000fed71000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed80000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fef00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100001000 - 000000013f000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] EFI v2.00 by American Megatrends
[    0.000000]  ACPI 2.0=0xa7b94000  SMBIOS=0xa7d49b18
ACPI=0xa7b94000  MPS=0xfcab0
[    0.000000] Kernel-defined memdesc doesn't match the one from EFI!
[    0.000000] EFI: mem00: type=3, attr=0xf,
range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] EFI: mem01: type=7, attr=0xf,
range=[0x0000000000008000-0x000000000007f000) (0MB)
[    0.000000] EFI: mem02: type=4, attr=0xf,
range=[0x000000000007f000-0x0000000000080000) (0MB)
[    0.000000] EFI: mem03: type=3, attr=0xf,
range=[0x0000000000080000-0x00000000000a0000) (0MB)
[    0.000000] EFI: mem04: type=2, attr=0xf,
range=[0x0000000000100000-0x00000000003f2000) (2MB)
[    0.000000] EFI: mem05: type=7, attr=0xf,
range=[0x00000000003f2000-0x0000000001000000) (12MB)
[    0.000000] EFI: mem06: type=2, attr=0xf,
range=[0x0000000001000000-0x0000000001100000) (1MB)
[    0.000000] EFI: mem07: type=4, attr=0xf,
range=[0x0000000001100000-0x0000000001464000) (3MB)
[    0.000000] EFI: mem08: type=3, attr=0xf,
range=[0x0000000001464000-0x0000000001468000) (0MB)
[    0.000000] EFI: mem09: type=4, attr=0xf,
range=[0x0000000001468000-0x0000000001498000) (0MB)
[    0.000000] EFI: mem10: type=3, attr=0xf,
range=[0x0000000001498000-0x000000000149b000) (0MB)
[    0.000000] EFI: mem11: type=4, attr=0xf,
range=[0x000000000149b000-0x000000000149f000) (0MB)
[    0.000000] EFI: mem12: type=3, attr=0xf,
range=[0x000000000149f000-0x00000000014ae000) (0MB)
[    0.000000] EFI: mem13: type=4, attr=0xf,
range=[0x00000000014ae000-0x00000000014af000) (0MB)
[    0.000000] EFI: mem14: type=3, attr=0xf,
range=[0x00000000014af000-0x00000000014b0000) (0MB)
[    0.000000] EFI: mem15: type=4, attr=0xf,
range=[0x00000000014b0000-0x00000000014ba000) (0MB)
[    0.000000] EFI: mem16: type=3, attr=0xf,
range=[0x00000000014ba000-0x00000000014c4000) (0MB)
[    0.000000] EFI: mem17: type=4, attr=0xf,
range=[0x00000000014c4000-0x00000000014d2000) (0MB)
[    0.000000] EFI: mem18: type=3, attr=0xf,
range=[0x00000000014d2000-0x00000000014d3000) (0MB)
[    0.000000] EFI: mem19: type=4, attr=0xf,
range=[0x00000000014d3000-0x00000000014d4000) (0MB)
[    0.000000] EFI: mem20: type=3, attr=0xf,
range=[0x00000000014d4000-0x00000000014d7000) (0MB)
[    0.000000] EFI: mem21: type=4, attr=0xf,
range=[0x00000000014d7000-0x00000000014ec000) (0MB)
[    0.000000] EFI: mem22: type=3, attr=0xf,
range=[0x00000000014ec000-0x00000000014f2000) (0MB)
[    0.000000] EFI: mem23: type=4, attr=0xf,
range=[0x00000000014f2000-0x0000000001503000) (0MB)
[    0.000000] EFI: mem24: type=3, attr=0xf,
range=[0x0000000001503000-0x0000000001504000) (0MB)
[    0.000000] EFI: mem25: type=4, attr=0xf,
range=[0x0000000001504000-0x0000000001509000) (0MB)
[    0.000000] EFI: mem26: type=3, attr=0xf,
range=[0x0000000001509000-0x0000000001510000) (0MB)
[    0.000000] EFI: mem27: type=4, attr=0xf,
range=[0x0000000001510000-0x0000000001515000) (0MB)
[    0.000000] EFI: mem28: type=3, attr=0xf,
range=[0x0000000001515000-0x000000000151d000) (0MB)
[    0.000000] EFI: mem29: type=4, attr=0xf,
range=[0x000000000151d000-0x0000000001555000) (0MB)
[    0.000000] EFI: mem30: type=3, attr=0xf,
range=[0x0000000001555000-0x0000000001557000) (0MB)
[    0.000000] EFI: mem31: type=4, attr=0xf,
range=[0x0000000001557000-0x0000000001558000) (0MB)
[    0.000000] EFI: mem32: type=3, attr=0xf,
range=[0x0000000001558000-0x0000000001576000) (0MB)
[    0.000000] EFI: mem33: type=4, attr=0xf,
range=[0x0000000001576000-0x0000000001581000) (0MB)
[    0.000000] EFI: mem34: type=3, attr=0xf,
range=[0x0000000001581000-0x0000000001599000) (0MB)
[    0.000000] EFI: mem35: type=4, attr=0xf,
range=[0x0000000001599000-0x000000000159d000) (0MB)
[    0.000000] EFI: mem36: type=3, attr=0xf,
range=[0x000000000159d000-0x00000000015a0000) (0MB)
[    0.000000] EFI: mem37: type=4, attr=0xf,
range=[0x00000000015a0000-0x00000000015a3000) (0MB)
[    0.000000] EFI: mem38: type=3, attr=0xf,
range=[0x00000000015a3000-0x00000000015a4000) (0MB)
[    0.000000] EFI: mem39: type=4, attr=0xf,
range=[0x00000000015a4000-0x00000000015a8000) (0MB)
[    0.000000] EFI: mem40: type=3, attr=0xf,
range=[0x00000000015a8000-0x00000000015aa000) (0MB)
[    0.000000] EFI: mem41: type=4, attr=0xf,
range=[0x00000000015aa000-0x00000000015b7000) (0MB)
[    0.000000] EFI: mem42: type=3, attr=0xf,
range=[0x00000000015b7000-0x00000000015cc000) (0MB)
[    0.000000] EFI: mem43: type=4, attr=0xf,
range=[0x00000000015cc000-0x00000000015d2000) (0MB)
[    0.000000] EFI: mem44: type=3, attr=0xf,
range=[0x00000000015d2000-0x00000000015e4000) (0MB)
[    0.000000] EFI: mem45: type=4, attr=0xf,
range=[0x00000000015e4000-0x00000000015f0000) (0MB)
[    0.000000] EFI: mem46: type=3, attr=0xf,
range=[0x00000000015f0000-0x00000000015f4000) (0MB)
[    0.000000] EFI: mem47: type=4, attr=0xf,
range=[0x00000000015f4000-0x00000000015f6000) (0MB)
[    0.000000] EFI: mem48: type=3, attr=0xf,
range=[0x00000000015f6000-0x0000000001638000) (0MB)
[    0.000000] EFI: mem49: type=4, attr=0xf,
range=[0x0000000001638000-0x00000000016ad000) (0MB)
[    0.000000] EFI: mem50: type=3, attr=0xf,
range=[0x00000000016ad000-0x00000000016b5000) (0MB)
[    0.000000] EFI: mem51: type=4, attr=0xf,
range=[0x00000000016b5000-0x00000000016ce000) (0MB)
[    0.000000] EFI: mem52: type=3, attr=0xf,
range=[0x00000000016ce000-0x00000000016d1000) (0MB)
[    0.000000] EFI: mem53: type=4, attr=0xf,
range=[0x00000000016d1000-0x0000000001b3d000) (4MB)
[    0.000000] EFI: mem54: type=3, attr=0xf,
range=[0x0000000001b3d000-0x0000000001b42000) (0MB)
[    0.000000] EFI: mem55: type=4, attr=0xf,
range=[0x0000000001b42000-0x0000000001b48000) (0MB)
[    0.000000] EFI: mem56: type=3, attr=0xf,
range=[0x0000000001b48000-0x0000000001b4b000) (0MB)
[    0.000000] EFI: mem57: type=4, attr=0xf,
range=[0x0000000001b4b000-0x0000000001b4d000) (0MB)
[    0.000000] EFI: mem58: type=3, attr=0xf,
range=[0x0000000001b4d000-0x0000000001b4f000) (0MB)
[    0.000000] EFI: mem59: type=4, attr=0xf,
range=[0x0000000001b4f000-0x0000000001b51000) (0MB)
[    0.000000] EFI: mem60: type=3, attr=0xf,
range=[0x0000000001b51000-0x0000000001b53000) (0MB)
[    0.000000] EFI: mem61: type=4, attr=0xf,
range=[0x0000000001b53000-0x0000000001b6a000) (0MB)
[    0.000000] EFI: mem62: type=3, attr=0xf,
range=[0x0000000001b6a000-0x0000000001b8c000) (0MB)
[    0.000000] EFI: mem63: type=4, attr=0xf,
range=[0x0000000001b8c000-0x0000000001b9e000) (0MB)
[    0.000000] EFI: mem64: type=3, attr=0xf,
range=[0x0000000001b9e000-0x0000000001ba0000) (0MB)
[    0.000000] EFI: mem65: type=4, attr=0xf,
range=[0x0000000001ba0000-0x0000000001bab000) (0MB)
[    0.000000] EFI: mem66: type=3, attr=0xf,
range=[0x0000000001bab000-0x0000000001bb2000) (0MB)
[    0.000000] EFI: mem67: type=4, attr=0xf,
range=[0x0000000001bb2000-0x0000000001bb4000) (0MB)
[    0.000000] EFI: mem68: type=3, attr=0xf,
range=[0x0000000001bb4000-0x0000000001bb6000) (0MB)
[    0.000000] EFI: mem69: type=4, attr=0xf,
range=[0x0000000001bb6000-0x0000000001bcf000) (0MB)
[    0.000000] EFI: mem70: type=3, attr=0xf,
range=[0x0000000001bcf000-0x0000000001bd3000) (0MB)
[    0.000000] EFI: mem71: type=4, attr=0xf,
range=[0x0000000001bd3000-0x0000000001bd5000) (0MB)
[    0.000000] EFI: mem72: type=3, attr=0xf,
range=[0x0000000001bd5000-0x0000000001bd7000) (0MB)
[    0.000000] EFI: mem73: type=4, attr=0xf,
range=[0x0000000001bd7000-0x0000000001bdc000) (0MB)
[    0.000000] EFI: mem74: type=3, attr=0xf,
range=[0x0000000001bdc000-0x0000000001bed000) (0MB)
[    0.000000] EFI: mem75: type=4, attr=0xf,
range=[0x0000000001bed000-0x0000000001bf1000) (0MB)
[    0.000000] EFI: mem76: type=3, attr=0xf,
range=[0x0000000001bf1000-0x0000000001bf5000) (0MB)
[    0.000000] EFI: mem77: type=4, attr=0xf,
range=[0x0000000001bf5000-0x0000000001bf8000) (0MB)
[    0.000000] EFI: mem78: type=3, attr=0xf,
range=[0x0000000001bf8000-0x0000000001bfb000) (0MB)
[    0.000000] EFI: mem79: type=4, attr=0xf,
range=[0x0000000001bfb000-0x0000000001e87000) (2MB)
[    0.000000] EFI: mem80: type=3, attr=0xf,
range=[0x0000000001e87000-0x0000000001e8a000) (0MB)
[    0.000000] EFI: mem81: type=4, attr=0xf,
range=[0x0000000001e8a000-0x0000000001e8b000) (0MB)
[    0.000000] EFI: mem82: type=3, attr=0xf,
range=[0x0000000001e8b000-0x0000000001e91000) (0MB)
[    0.000000] EFI: mem83: type=4, attr=0xf,
range=[0x0000000001e91000-0x0000000001e92000) (0MB)
[    0.000000] EFI: mem84: type=2, attr=0xf,
range=[0x0000000001e92000-0x0000000001e98000) (0MB)
[    0.000000] EFI: mem85: type=4, attr=0xf,
range=[0x0000000001e98000-0x000000000211c000) (2MB)
[    0.000000] EFI: mem86: type=2, attr=0xf,
range=[0x000000000211c000-0x000000000212f000) (0MB)
[    0.000000] EFI: mem87: type=4, attr=0xf,
range=[0x000000000212f000-0x0000000002130000) (0MB)
[    0.000000] EFI: mem88: type=2, attr=0xf,
range=[0x0000000002130000-0x0000000002134000) (0MB)
[    0.000000] EFI: mem89: type=7, attr=0xf,
range=[0x0000000002134000-0x0000000002137000) (0MB)
[    0.000000] EFI: mem90: type=4, attr=0xf,
range=[0x0000000002137000-0x0000000002140000) (0MB)
[    0.000000] EFI: mem91: type=7, attr=0xf,
range=[0x0000000002140000-0x0000000002168000) (0MB)
[    0.000000] EFI: mem92: type=2, attr=0xf,
range=[0x0000000002168000-0x00000000021d4000) (0MB)
[    0.000000] EFI: mem93: type=1, attr=0xf,
range=[0x00000000021d4000-0x000000000228f000) (0MB)
[    0.000000] EFI: mem94: type=2, attr=0xf,
range=[0x000000000228f000-0x00000000022d2000) (0MB)
[    0.000000] EFI: mem95: type=1, attr=0xf,
range=[0x00000000022d2000-0x00000000022f1000) (0MB)
[    0.000000] EFI: mem96: type=7, attr=0xf,
range=[0x00000000022f1000-0x0000000037abe000) (855MB)
[    0.000000] EFI: mem97: type=2, attr=0xf,
range=[0x0000000037abe000-0x0000000037d57000) (2MB)
[    0.000000] EFI: mem98: type=7, attr=0xf,
range=[0x0000000037d57000-0x000000007e16f000) (1124MB)
[    0.000000] EFI: mem99: type=2, attr=0xf,
range=[0x000000007e16f000-0x00000000a7b51000) (665MB)
[    0.000000] EFI: mem100: type=10, attr=0xf,
range=[0x00000000a7b51000-0x00000000a7ba2000) (0MB)
[    0.000000] EFI: mem101: type=0, attr=0xf,
range=[0x00000000a7ba2000-0x00000000a7cd6000) (1MB)
[    0.000000] EFI: mem102: type=10, attr=0xf,
range=[0x00000000a7cd6000-0x00000000a7ce7000) (0MB)
[    0.000000] EFI: mem103: type=6, attr=0x800000000000000f,
range=[0x00000000a7ce7000-0x00000000a7d09000) (0MB)
[    0.000000] EFI: mem104: type=5, attr=0x800000000000000f,
range=[0x00000000a7d09000-0x00000000a7d0a000) (0MB)
[    0.000000] EFI: mem105: type=6, attr=0x800000000000000f,
range=[0x00000000a7d0a000-0x00000000a7d0b000) (0MB)
[    0.000000] EFI: mem106: type=7, attr=0xf,
range=[0x00000000a7d0b000-0x00000000a7d0c000) (0MB)
[    0.000000] EFI: mem107: type=10, attr=0xf,
range=[0x00000000a7d0c000-0x00000000a7d0d000) (0MB)
[    0.000000] EFI: mem108: type=7, attr=0xf,
range=[0x00000000a7d0d000-0x00000000a7d10000) (0MB)
[    0.000000] EFI: mem109: type=10, attr=0xf,
range=[0x00000000a7d10000-0x00000000a7d16000) (0MB)
[    0.000000] EFI: mem110: type=5, attr=0x800000000000000f,
range=[0x00000000a7d16000-0x00000000a7d1d000) (0MB)
[    0.000000] EFI: mem111: type=10, attr=0xf,
range=[0x00000000a7d1d000-0x00000000a7d24000) (0MB)
[    0.000000] EFI: mem112: type=6, attr=0x800000000000000f,
range=[0x00000000a7d24000-0x00000000a7d25000) (0MB)
[    0.000000] EFI: mem113: type=5, attr=0x800000000000000f,
range=[0x00000000a7d25000-0x00000000a7d2b000) (0MB)
[    0.000000] EFI: mem114: type=6, attr=0x800000000000000f,
range=[0x00000000a7d2b000-0x00000000a7d3c000) (0MB)
[    0.000000] EFI: mem115: type=5, attr=0x800000000000000f,
range=[0x00000000a7d3c000-0x00000000a7d48000) (0MB)
[    0.000000] EFI: mem116: type=6, attr=0x800000000000000f,
range=[0x00000000a7d48000-0x00000000a7d4b000) (0MB)
[    0.000000] EFI: mem117: type=10, attr=0xf,
range=[0x00000000a7d4b000-0x00000000a7d8e000) (0MB)
[    0.000000] EFI: mem118: type=3, attr=0xf,
range=[0x00000000a7d8e000-0x00000000a7ef6000) (1MB)
[    0.000000] EFI: mem119: type=4, attr=0xf,
range=[0x00000000a7ef6000-0x00000000a7ef7000) (0MB)
[    0.000000] EFI: mem120: type=3, attr=0xf,
range=[0x00000000a7ef7000-0x00000000a7f00000) (0MB)
[    0.000000] EFI: mem121: type=7, attr=0xf,
range=[0x0000000100001000-0x000000013f000000) (1007MB)
[    0.000000] EFI: mem122: type=11, attr=0x8000000000000001,
range=[0x00000000e0000000-0x00000000f0000000) (256MB)
[    0.000000] EFI: mem123: type=11, attr=0x8000000000000001,
range=[0x00000000fec00000-0x00000000fec01000) (0MB)
[    0.000000] EFI: mem124: type=11, attr=0x8000000000000001,
range=[0x00000000fec10000-0x00000000fec11000) (0MB)
[    0.000000] EFI: mem125: type=11, attr=0x8000000000000001,
range=[0x00000000fed00000-0x00000000fed01000) (0MB)
[    0.000000] EFI: mem126: type=11, attr=0x8000000000000001,
range=[0x00000000fed61000-0x00000000fed71000) (0MB)
[    0.000000] EFI: mem127: type=11, attr=0x8000000000000001,
range=[0x00000000fed80000-0x00000000fed90000) (0MB)
[    0.000000] EFI: mem128: type=11, attr=0x8000000000000001,
range=[0x00000000fef00000-0x0000000100000000) (17MB)
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: ASUSTeK Computer INC. 1215B/1215B, BIOS 0503 11/30/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x13f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CEFFF write-protect
[    0.000000]   CF000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0A7F00000 mask FFFF00000 uncachable
[    0.000000]   2 base 0A8000000 mask FF8000000 uncachable
[    0.000000]   3 base 0B0000000 mask FF0000000 uncachable
[    0.000000]   4 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 000000013f000000 aka 5104M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000a7f00000 - 0000000100000000
(usable) ==> (reserved)
[    0.000000] last_pfn = 0xa7f00 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fcd10] fcd10
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 20480
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000a7f00000
[    0.000000]  0000000000 - 0080000000 page 1G
[    0.000000]  0080000000 - 00a7e00000 page 2M
[    0.000000]  00a7e00000 - 00a7f00000 page 4k
[    0.000000] kernel direct mapping tables up to a7f00000 @ 1fffd000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-000000013f000000
[    0.000000]  0100000000 - 013f000000 page 2M
[    0.000000] kernel direct mapping tables up to 13f000000 @ a7d0e000-a7d10000
[    0.000000] RAMDISK: 37abe000 - 37d57000
[    0.000000] ACPI: RSDP 00000000a7b94000 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000a7b94070 0005C (v01 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000a7b9c6e0 000F4 (v04 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero
address or length: 0x0000000000000000/0x1 (20110623/tbfadt-560)
[    0.000000] ACPI: DSDT 00000000a7b94158 08581 (v02 ALASKA    A M I
00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000a7d23f80 00040
[    0.000000] ACPI: APIC 00000000a7b9c7d8 00062 (v03 ALASKA    A M I
01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000a7b9c840 0003C (v01 ALASKA    A M I
01072009 MSFT 00010013)
[    0.000000] ACPI: SLIC 00000000a7b9c880 00176 (v00 _ASUS_ Notebook
00000000      00000000)
[    0.000000] ACPI: HPET 00000000a7b9c9f8 00038 (v01 ALASKA    A M I
01072009 AMI  00000004)
[    0.000000] ACPI: SSDT 00000000a7b9ca30 00406 (v01 AMD    POWERNOW
00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 00000000a7b9ce38 0168E (v02    AMD     ALIB
00000001 MSFT 04000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000013f000000
[    0.000000] Initmem setup node 0 0000000000000000-000000013f000000
[    0.000000]   NODE_DATA [000000013effb000 - 000000013effffff]
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD ->
[ffff88013ac00000-ffff88013e5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013f000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x000a7b51
[    0.000000]     0: 0x000a7d0b -> 0x000a7d0c
[    0.000000]     0: 0x000a7d0d -> 0x000a7d10
[    0.000000]     0: 0x000a7d8e -> 0x000a7f00
[    0.000000]     0: 0x00100001 -> 0x0013f000
[    0.000000] On node 0 totalpages: 945238
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 10 pages reserved
[    0.000000]   DMA zone: 3910 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 666887 pages, LIFO batch:31
[    0.000000]   Normal zone: 4032 pages used for memmap
[    0.000000]   Normal zone: 254015 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000a7b51000 - 00000000a7ba2000
[    0.000000] PM: Registered nosave memory: 00000000a7ba2000 - 00000000a7cd6000
[    0.000000] PM: Registered nosave memory: 00000000a7cd6000 - 00000000a7ce7000
[    0.000000] PM: Registered nosave memory: 00000000a7ce7000 - 00000000a7d0b000
[    0.000000] PM: Registered nosave memory: 00000000a7d0c000 - 00000000a7d0d000
[    0.000000] PM: Registered nosave memory: 00000000a7d10000 - 00000000a7d16000
[    0.000000] PM: Registered nosave memory: 00000000a7d16000 - 00000000a7d1d000
[    0.000000] PM: Registered nosave memory: 00000000a7d1d000 - 00000000a7d24000
[    0.000000] PM: Registered nosave memory: 00000000a7d24000 - 00000000a7d4b000
[    0.000000] PM: Registered nosave memory: 00000000a7d4b000 - 00000000a7d8e000
[    0.000000] PM: Registered nosave memory: 00000000a7f00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fec11000
[    0.000000] PM: Registered nosave memory: 00000000fec11000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed01000
[    0.000000] PM: Registered nosave memory: 00000000fed01000 - 00000000fed61000
[    0.000000] PM: Registered nosave memory: 00000000fed61000 - 00000000fed71000
[    0.000000] PM: Registered nosave memory: 00000000fed71000 - 00000000fed80000
[    0.000000] PM: Registered nosave memory: 00000000fed80000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 0000000100000000
[    0.000000] PM: Registered nosave memory: 0000000100000000 - 0000000100001000
[    0.000000] Allocating PCI resources starting at a7f00000 (gap:
a7f00000:38100000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64
nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88013ec00000 s80448
r8192 d21952 u1048576
[    0.000000] pcpu-alloc: s80448 r8192 d21952 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 924812
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-linux
root=/dev/disk/by-uuid/07dbe71d-e532-45b9-9e37-ea311341b0a6
resume=/dev/disk/by-uuid/2d71cb2c-018e-4b01-8e29-bf6014d85968 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 3636684k/5226496k available (4158k kernel code,
1445544k absent, 144268k reserved, 5286k data, 712k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:2304
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 30408704 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1646.684 MHz processor.
[    0.003339] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3294.59 BogoMIPS (lpj=5488946)
[    0.003347] pid_max: default: 32768 minimum: 301
[    0.109382] Security Framework initialized
[    0.109396] AppArmor: AppArmor disabled by boot time parameter
[    0.110176] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.112827] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.114096] Mount-cache hash table entries: 256
[    0.114917] Initializing cgroup subsys cpuacct
[    0.114981] Initializing cgroup subsys memory
[    0.115014] Initializing cgroup subsys devices
[    0.115019] Initializing cgroup subsys freezer
[    0.115022] Initializing cgroup subsys net_cls
[    0.115026] Initializing cgroup subsys blkio
[    0.115121] tseg: 00a7f00000
[    0.115126] CPU: Physical Processor ID: 0
[    0.115129] CPU: Processor Core ID: 0
[    0.115132] mce: CPU supports 6 MCE banks
[    0.117104] ACPI: Core revision 20110623
[    0.126685] ftrace: allocating 16320 entries in 65 pages
[    0.130573] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.166073] CPU0: AMD E-450 APU with Radeon(tm) HD Graphics stepping 00
[    0.166656] Performance Events: AMD PMU driver.
[    0.166656] ... version:                0
[    0.166656] ... bit width:              48
[    0.166656] ... generic registers:      4
[    0.166656] ... value mask:             0000ffffffffffff
[    0.166656] ... max period:             00007fffffffffff
[    0.166656] ... fixed-purpose events:   0
[    0.166656] ... event mask:             000000000000000f
[    0.184009] NMI watchdog enabled, takes one hw-pmu counter.
[    0.210102] Booting Node   0, Processors  #1 Ok.
[    0.210112] smpboot cpu 1: start_ip = 99000
[    0.306698] NMI watchdog enabled, takes one hw-pmu counter.
[    0.313363] Brought up 2 CPUs
[    0.313376] Total of 2 processors activated (6588.69 BogoMIPS).
[    0.314278] devtmpfs: initialized
[    0.317849] PM: Registering ACPI NVS region at a7b51000 (331776 bytes)
[    0.317849] PM: Registering ACPI NVS region at a7cd6000 (69632 bytes)
[    0.317849] PM: Registering ACPI NVS region at a7d0c000 (4096 bytes)
[    0.317849] PM: Registering ACPI NVS region at a7d10000 (24576 bytes)
[    0.317849] PM: Registering ACPI NVS region at a7d1d000 (28672 bytes)
[    0.317849] PM: Registering ACPI NVS region at a7d4b000 (274432 bytes)
[    0.320040] print_constraints: dummy:
[    0.320212] NET: Registered protocol family 16
[    0.320476] Extended Config Space enabled on 0 nodes
[    0.320511] ACPI: bus type pci registered
[    0.320811] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.320817] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.375671] PCI: Using configuration type 1 for base access
[    0.376798] bio: create slab <bio-0> at 0
[    0.376900] ACPI: Added _OSI(Module Device)
[    0.376900] ACPI: Added _OSI(Processor Device)
[    0.376900] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.376900] ACPI: Added _OSI(Processor Aggregator Device)
[    0.378844] ACPI: EC: Look up EC in DSDT
[    0.381576] ACPI: Executed 3 blocks of module-level executable AML code
[    0.394290] ACPI: Interpreter enabled
[    0.394300] ACPI: (supports S0 S3 S4 S5)
[    0.394338] ACPI: Using IOAPIC for interrupt routing
[    0.404587] ACPI: EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
[    0.404908] ACPI: No dock devices found.
[    0.404912] HEST: Table not found.
[    0.404919] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.405147] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.405577] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.405582] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.405587] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
[    0.405592] pci_root PNP0A08:00: host bridge window [mem
0x000c8000-0x000dffff]
[    0.405597] pci_root PNP0A08:00: host bridge window [mem
0xc0000000-0xffffffff]
[    0.405606] pci_root PNP0A08:00: ignoring host bridge window [mem
0x000c8000-0x000dffff] (conflicts with Video ROM [mem
0x000c0000-0x000ce3ff])
[    0.405626] pci 0000:00:00.0: [1022:1510] type 0 class 0x000600
[    0.405683] pci 0000:00:01.0: [1002:9806] type 0 class 0x000300
[    0.405698] pci 0000:00:01.0: reg 10: [mem 0xc0000000-0xcfffffff pref]
[    0.405709] pci 0000:00:01.0: reg 14: [io  0xf000-0xf0ff]
[    0.405719] pci 0000:00:01.0: reg 18: [mem 0xfeb00000-0xfeb3ffff]
[    0.405766] pci 0000:00:01.0: supports D1 D2
[    0.405791] pci 0000:00:01.1: [1002:1314] type 0 class 0x000403
[    0.405804] pci 0000:00:01.1: reg 10: [mem 0xfeb44000-0xfeb47fff]
[    0.405862] pci 0000:00:01.1: supports D1 D2
[    0.405964] pci 0000:00:04.0: [1022:1512] type 1 class 0x000604
[    0.406022] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.406029] pci 0000:00:04.0: PME# disabled
[    0.406079] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.406105] pci 0000:00:11.0: reg 10: [io  0xf140-0xf147]
[    0.406120] pci 0000:00:11.0: reg 14: [io  0xf130-0xf133]
[    0.406134] pci 0000:00:11.0: reg 18: [io  0xf120-0xf127]
[    0.406148] pci 0000:00:11.0: reg 1c: [io  0xf110-0xf113]
[    0.406162] pci 0000:00:11.0: reg 20: [io  0xf100-0xf10f]
[    0.406176] pci 0000:00:11.0: reg 24: [mem 0xfeb4c000-0xfeb4c3ff]
[    0.406239] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.406258] pci 0000:00:12.0: reg 10: [mem 0xfeb4b000-0xfeb4bfff]
[    0.406351] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.406377] pci 0000:00:12.2: reg 10: [mem 0xfeb4a000-0xfeb4a0ff]
[    0.406469] pci 0000:00:12.2: supports D1 D2
[    0.406473] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.406479] pci 0000:00:12.2: PME# disabled
[    0.406514] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.406534] pci 0000:00:13.0: reg 10: [mem 0xfeb49000-0xfeb49fff]
[    0.406628] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.406673] pci 0000:00:13.2: reg 10: [mem 0xfeb48000-0xfeb480ff]
[    0.406766] pci 0000:00:13.2: supports D1 D2
[    0.406770] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.406776] pci 0000:00:13.2: PME# disabled
[    0.406807] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.406911] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.406940] pci 0000:00:14.2: reg 10: [mem 0xfeb40000-0xfeb43fff 64bit]
[    0.407017] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.407023] pci 0000:00:14.2: PME# disabled
[    0.407042] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.407141] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.407209] pci 0000:00:15.0: [1002:43a0] type 1 class 0x000604
[    0.407289] pci 0000:00:15.0: supports D1 D2
[    0.407328] pci 0000:00:15.2: [1002:43a2] type 1 class 0x000604
[    0.407405] pci 0000:00:15.2: supports D1 D2
[    0.407449] pci 0000:00:18.0: [1022:1700] type 0 class 0x000600
[    0.407494] pci 0000:00:18.1: [1022:1701] type 0 class 0x000600
[    0.407536] pci 0000:00:18.2: [1022:1702] type 0 class 0x000600
[    0.407580] pci 0000:00:18.3: [1022:1703] type 0 class 0x000600
[    0.407631] pci 0000:00:18.4: [1022:1704] type 0 class 0x000600
[    0.407673] pci 0000:00:18.5: [1022:1718] type 0 class 0x000600
[    0.407715] pci 0000:00:18.6: [1022:1716] type 0 class 0x000600
[    0.407756] pci 0000:00:18.7: [1022:1719] type 0 class 0x000600
[    0.408012] pci 0000:01:00.0: [14e4:4727] type 0 class 0x000280
[    0.408039] pci 0000:01:00.0: reg 10: [mem 0xfea00000-0xfea03fff 64bit]
[    0.408136] pci 0000:01:00.0: supports D1 D2
[    0.408140] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.408147] pci 0000:01:00.0: PME# disabled
[    0.413450] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.413466] pci 0000:00:04.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.413598] pci 0000:00:14.4: PCI bridge to [bus 02-02] (subtractive decode)
[    0.413613] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7]
(subtractive decode)
[    0.413618] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff]
(subtractive decode)
[    0.413622] pci 0000:00:14.4:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
[    0.413627] pci 0000:00:14.4:   bridge window [mem
0xc0000000-0xffffffff] (subtractive decode)
[    0.413698] pci 0000:00:15.0: PCI bridge to [bus 03-05]
[    0.413707] pci 0000:00:15.0:   bridge window [io  0xe000-0xefff]
[    0.413714] pci 0000:00:15.0:   bridge window [mem 0xfdf00000-0xfe8fffff]
[    0.413724] pci 0000:00:15.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
[    0.413833] pci 0000:06:00.0: [1b21:1042] type 0 class 0x000c03
[    0.413878] pci 0000:06:00.0: reg 10: [mem 0xfe900000-0xfe907fff 64bit]
[    0.414056] pci 0000:06:00.0: PME# supported from D3hot D3cold
[    0.414066] pci 0000:06:00.0: PME# disabled
[    0.420096] pci 0000:00:15.2: PCI bridge to [bus 06-06]
[    0.420118] pci 0000:00:15.2:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.420166] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.420464] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE20._PRT]
[    0.420525] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE22._PRT]
[    0.420597] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
[    0.420660]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.420667]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND),
returned control mask: 0x1d
[    0.420670] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.430633] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 14 15) *0
[    0.430747] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 14 15) *0
[    0.430861] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 14 15) *0
[    0.430974] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 14 15) *0
[    0.431067] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 14 15) *0
[    0.431138] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 14 15) *0
[    0.431210] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 14 15) *0
[    0.431287] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 14 15) *0
[    0.431412] vgaarb: device added:
PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.431412] vgaarb: loaded
[    0.431412] vgaarb: bridge control possible 0000:00:01.0
[    0.431412] PCI: Using ACPI for IRQ routing
[    0.442800] PCI: pci_cache_line_size set to 64 bytes
[    0.442982] reserve RAM buffer: 00000000a7b51000 - 00000000a7ffffff
[    0.442989] reserve RAM buffer: 00000000a7d0c000 - 00000000a7ffffff
[    0.442995] reserve RAM buffer: 00000000a7d10000 - 00000000a7ffffff
[    0.443000] reserve RAM buffer: 00000000a7f00000 - 00000000a7ffffff
[    0.443004] reserve RAM buffer: 000000013f000000 - 000000013fffffff
[    0.443235] NetLabel: Initializing
[    0.443239] NetLabel:  domain hash size = 128
[    0.443242] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.443265] NetLabel:  unlabeled traffic allowed by default
[    0.443293] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.443313] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.445341] Switching to clocksource hpet
[    0.445347] Switched to NOHz mode on CPU #0
[    0.445400] Switched to NOHz mode on CPU #1
[    0.454444] pnp: PnP ACPI init
[    0.454477] ACPI: bus type pnp registered
[    0.454778] pnp 00:00: [bus 00-ff]
[    0.454784] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.454788] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.454792] pnp 00:00: [io  0x0d00-0xffff window]
[    0.454797] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.454801] pnp 00:00: [mem 0x000c8000-0x000dffff window]
[    0.454806] pnp 00:00: [mem 0xc0000000-0xffffffff window]
[    0.454810] pnp 00:00: [mem 0x00000000 window]
[    0.454930] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08
PNP0a03 (active)
[    0.454996] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.455090] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.455097] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.456073] pnp 00:02: [io  0x040b]
[    0.456077] pnp 00:02: [io  0x04d6]
[    0.456080] pnp 00:02: [io  0x0c00-0x0c01]
[    0.456084] pnp 00:02: [io  0x0c14]
[    0.456087] pnp 00:02: [io  0x0c50-0x0c51]
[    0.456091] pnp 00:02: [io  0x0c52]
[    0.456094] pnp 00:02: [io  0x0c6c]
[    0.456097] pnp 00:02: [io  0x0c6f]
[    0.456100] pnp 00:02: [io  0x0cd0-0x0cd1]
[    0.456104] pnp 00:02: [io  0x0cd2-0x0cd3]
[    0.456107] pnp 00:02: [io  0x0cd4-0x0cd5]
[    0.456110] pnp 00:02: [io  0x0cd6-0x0cd7]
[    0.456114] pnp 00:02: [io  0x0cd8-0x0cdf]
[    0.456117] pnp 00:02: [io  0x0800-0x089f]
[    0.456125] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.456129] pnp 00:02: [io  0x0000-0x000f]
[    0.456132] pnp 00:02: [io  0x0b20-0x0b3f]
[    0.456136] pnp 00:02: [io  0x0900-0x090f]
[    0.456139] pnp 00:02: [io  0x0910-0x091f]
[    0.456143] pnp 00:02: [io  0xfe00-0xfefe]
[    0.456146] pnp 00:02: [io  0x0060-0x005f disabled]
[    0.456150] pnp 00:02: [io  0x0064-0x0063 disabled]
[    0.456154] pnp 00:02: [mem 0xfec00000-0xfec00fff]
[    0.456158] pnp 00:02: [mem 0xfee00000-0xfee00fff]
[    0.456161] pnp 00:02: [mem 0xfed80000-0xfed8ffff]
[    0.456165] pnp 00:02: [mem 0xfed61000-0xfed70fff]
[    0.456169] pnp 00:02: [mem 0xfec10000-0xfec10fff]
[    0.456172] pnp 00:02: [mem 0xfed00000-0xfed00fff]
[    0.456176] pnp 00:02: [mem 0xffe00000-0xffffffff]
[    0.456273] system 00:02: [io  0x040b] has been reserved
[    0.456278] system 00:02: [io  0x04d6] has been reserved
[    0.456282] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.456287] system 00:02: [io  0x0c14] has been reserved
[    0.456292] system 00:02: [io  0x0c50-0x0c51] has been reserved
[    0.456296] system 00:02: [io  0x0c52] has been reserved
[    0.456301] system 00:02: [io  0x0c6c] has been reserved
[    0.456308] system 00:02: [io  0x0c6f] has been reserved
[    0.456313] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.456318] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.456322] system 00:02: [io  0x0cd4-0x0cd5] has been reserved
[    0.456327] system 00:02: [io  0x0cd6-0x0cd7] has been reserved
[    0.456331] system 00:02: [io  0x0cd8-0x0cdf] has been reserved
[    0.456336] system 00:02: [io  0x0800-0x089f] has been reserved
[    0.456341] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    0.456345] system 00:02: [io  0x0900-0x090f] has been reserved
[    0.456350] system 00:02: [io  0x0910-0x091f] has been reserved
[    0.456355] system 00:02: [io  0xfe00-0xfefe] has been reserved
[    0.456361] system 00:02: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.456367] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.456377] system 00:02: [mem 0xfed80000-0xfed8ffff] has been reserved
[    0.456382] system 00:02: [mem 0xfed61000-0xfed70fff] has been reserved
[    0.456387] system 00:02: [mem 0xfec10000-0xfec10fff] has been reserved
[    0.456392] system 00:02: [mem 0xfed00000-0xfed00fff] has been reserved
[    0.456397] system 00:02: [mem 0xffe00000-0xffffffff] has been reserved
[    0.456403] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.456511] pnp 00:03: [irq 12]
[    0.456558] pnp 00:03: Plug and Play ACPI device, IDs SYN0a13
SYN0a00 SYN0002 PNP0f03 PNP0f13 PNP0f12 (active)
[    0.456602] pnp 00:04: [io  0x0060]
[    0.456605] pnp 00:04: [io  0x0064]
[    0.456614] pnp 00:04: [irq 1]
[    0.456660] pnp 00:04: Plug and Play ACPI device, IDs PNP0303
PNP030b (active)
[    0.456736] pnp 00:05: [dma 4]
[    0.456739] pnp 00:05: [io  0x0000-0x000f]
[    0.456743] pnp 00:05: [io  0x0081-0x0083]
[    0.456746] pnp 00:05: [io  0x0087]
[    0.456750] pnp 00:05: [io  0x0089-0x008b]
[    0.456753] pnp 00:05: [io  0x008f]
[    0.456756] pnp 00:05: [io  0x00c0-0x00df]
[    0.456799] pnp 00:05: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.456818] pnp 00:06: [io  0x0070-0x0071]
[    0.456895] pnp 00:06: [irq 8]
[    0.456938] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.456953] pnp 00:07: [io  0x0061]
[    0.457005] pnp 00:07: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.457256] pnp 00:08: [io  0x0010-0x001f]
[    0.457260] pnp 00:08: [io  0x0022-0x003f]
[    0.457263] pnp 00:08: [io  0x0062-0x0063]
[    0.457267] pnp 00:08: [io  0x0065-0x006f]
[    0.457270] pnp 00:08: [io  0x0072-0x007f]
[    0.457274] pnp 00:08: [io  0x0080]
[    0.457277] pnp 00:08: [io  0x0084-0x0086]
[    0.457280] pnp 00:08: [io  0x0088]
[    0.457283] pnp 00:08: [io  0x008c-0x008e]
[    0.457287] pnp 00:08: [io  0x0090-0x009f]
[    0.457290] pnp 00:08: [io  0x00a2-0x00bf]
[    0.457293] pnp 00:08: [io  0x00b1]
[    0.457297] pnp 00:08: [io  0x00e0-0x00ef]
[    0.457303] pnp 00:08: [io  0x04d0-0x04d1]
[    0.457307] pnp 00:08: [io  0x040b]
[    0.457310] pnp 00:08: [io  0x04d6]
[    0.457313] pnp 00:08: [io  0x0c00-0x0c01]
[    0.457317] pnp 00:08: [io  0x0c14]
[    0.457320] pnp 00:08: [io  0x0c50-0x0c51]
[    0.457323] pnp 00:08: [io  0x0c52]
[    0.457326] pnp 00:08: [io  0x0c6c]
[    0.457329] pnp 00:08: [io  0x0c6f]
[    0.457333] pnp 00:08: [io  0x0cd0-0x0cd1]
[    0.457336] pnp 00:08: [io  0x0cd2-0x0cd3]
[    0.457339] pnp 00:08: [io  0x0cd4-0x0cd5]
[    0.457343] pnp 00:08: [io  0x0cd6-0x0cd7]
[    0.457346] pnp 00:08: [io  0x0cd8-0x0cdf]
[    0.457350] pnp 00:08: [io  0x0b00-0x0b3f]
[    0.457353] pnp 00:08: [io  0x0800-0x089f]
[    0.457357] pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
[    0.457361] pnp 00:08: [io  0x0b00-0x0b0f]
[    0.457364] pnp 00:08: [io  0x0b20-0x0b3f]
[    0.457367] pnp 00:08: [io  0x0900-0x090f]
[    0.457371] pnp 00:08: [io  0x0910-0x091f]
[    0.457374] pnp 00:08: [io  0xfe00-0xfefe]
[    0.457378] pnp 00:08: [io  0x0060-0x005f disabled]
[    0.457382] pnp 00:08: [io  0x0064-0x0063 disabled]
[    0.457386] pnp 00:08: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.457390] pnp 00:08: [mem 0xffb80000-0xffbfffff]
[    0.457394] pnp 00:08: [mem 0xfec10000-0xfec1001f]
[    0.457397] pnp 00:08: [mem 0xfed40000-0xfed44fff]
[    0.457401] pnp 00:08: [mem 0xfed80000-0xfed80fff]
[    0.457405] pnp 00:08: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.457533] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.457538] system 00:08: [io  0x040b] has been reserved
[    0.457543] system 00:08: [io  0x04d6] has been reserved
[    0.457548] system 00:08: [io  0x0c00-0x0c01] has been reserved
[    0.457552] system 00:08: [io  0x0c14] has been reserved
[    0.457557] system 00:08: [io  0x0c50-0x0c51] has been reserved
[    0.457562] system 00:08: [io  0x0c52] has been reserved
[    0.457566] system 00:08: [io  0x0c6c] has been reserved
[    0.457571] system 00:08: [io  0x0c6f] has been reserved
[    0.457575] system 00:08: [io  0x0cd0-0x0cd1] has been reserved
[    0.457580] system 00:08: [io  0x0cd2-0x0cd3] has been reserved
[    0.457585] system 00:08: [io  0x0cd4-0x0cd5] has been reserved
[    0.457590] system 00:08: [io  0x0cd6-0x0cd7] has been reserved
[    0.457594] system 00:08: [io  0x0cd8-0x0cdf] has been reserved
[    0.457599] system 00:08: [io  0x0b00-0x0b3f] could not be reserved
[    0.457604] system 00:08: [io  0x0800-0x089f] has been reserved
[    0.457609] system 00:08: [io  0x0b00-0x0b0f] has been reserved
[    0.457614] system 00:08: [io  0x0b20-0x0b3f] has been reserved
[    0.457618] system 00:08: [io  0x0900-0x090f] has been reserved
[    0.457623] system 00:08: [io  0x0910-0x091f] has been reserved
[    0.457628] system 00:08: [io  0xfe00-0xfefe] has been reserved
[    0.457635] system 00:08: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.457640] system 00:08: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.457645] system 00:08: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.457650] system 00:08: [mem 0xfed80000-0xfed80fff] has been reserved
[    0.457656] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.457673] pnp 00:09: [io  0x00f0-0x00ff]
[    0.457751] pnp 00:09: [irq 13]
[    0.457797] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.457889] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.458133] pnp 00:0b: [mem 0xa8000000-0xbfffffff]
[    0.458232] system 00:0b: [mem 0xa8000000-0xbfffffff] has been reserved
[    0.458239] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.458553] pnp 00:0c: [mem 0xfed00000-0xfed003ff]
[    0.458629] pnp 00:0c: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.458643] pnp: PnP ACPI: found 13 devices
[    0.458646] ACPI: ACPI bus type pnp unregistered
[    0.470653] PCI: max bus depth: 1 pci_try_num: 2
[    0.470706] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.470715] pci 0000:00:04.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.470726] pci 0000:00:14.4: PCI bridge to [bus 02-02]
[    0.470744] pci 0000:00:15.0: PCI bridge to [bus 03-05]
[    0.470749] pci 0000:00:15.0:   bridge window [io  0xe000-0xefff]
[    0.470757] pci 0000:00:15.0:   bridge window [mem 0xfdf00000-0xfe8fffff]
[    0.470766] pci 0000:00:15.0:   bridge window [mem
0xd0000000-0xdfffffff 64bit pref]
[    0.470776] pci 0000:00:15.2: PCI bridge to [bus 06-06]
[    0.470783] pci 0000:00:15.2:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.470819] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.470827] pci 0000:00:04.0: setting latency timer to 64
[    0.470844] pci 0000:00:15.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.470851] pci 0000:00:15.0: setting latency timer to 64
[    0.470862] pci 0000:00:15.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.470868] pci 0000:00:15.2: setting latency timer to 64
[    0.470875] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.470879] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.470884] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.470888] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xffffffff]
[    0.470892] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.470897] pci_bus 0000:02: resource 4 [io  0x0000-0x0cf7]
[    0.470901] pci_bus 0000:02: resource 5 [io  0x0d00-0xffff]
[    0.470905] pci_bus 0000:02: resource 6 [mem 0x000a0000-0x000bffff]
[    0.470909] pci_bus 0000:02: resource 7 [mem 0xc0000000-0xffffffff]
[    0.470913] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.470917] pci_bus 0000:03: resource 1 [mem 0xfdf00000-0xfe8fffff]
[    0.470921] pci_bus 0000:03: resource 2 [mem 0xd0000000-0xdfffffff
64bit pref]
[    0.470926] pci_bus 0000:06: resource 1 [mem 0xfe900000-0xfe9fffff]
[    0.471065] NET: Registered protocol family 2
[    0.471412] IP route cache hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.473654] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    0.478517] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.479060] TCP: Hash tables configured (established 524288 bind 65536)
[    0.479066] TCP reno registered
[    0.479094] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.479151] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.479486] NET: Registered protocol family 1
[    0.479519] pci 0000:00:01.0: Boot video device
[    1.060555] PCI: CLS 64 bytes, default 64
[    1.060657] Unpacking initramfs...
[    1.125284] Freeing initrd memory: 2660k freed
[    1.126926] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.126937] Placing 64MB software IO TLB between ffff8800a3b51000 -
ffff8800a7b51000
[    1.126941] software IO TLB at phys 0xa3b51000 - 0xa7b51000
[    1.128261] audit: initializing netlink socket (disabled)
[    1.128286] type=2000 audit(1325395013.126:1): initialized
[    1.144593] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.179591] VFS: Disk quotas dquot_6.5.2
[    1.179861] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.180278] msgmni has been set to 7116
[    1.180961] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    1.181141] io scheduler noop registered
[    1.181147] io scheduler deadline registered
[    1.181275] io scheduler cfq registered (default)
[    1.181895] efifb: probing for efifb
[    1.182382] efifb: framebuffer at 0xc0000000, mapped to
0xffffc90022300000, using 1920k, total 1920k
[    1.182387] efifb: mode is 800x600x32, linelength=3200, pages=1
[    1.182390] efifb: scrolling: redraw
[    1.182395] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.185450] Console: switching to colour frame buffer device 100x37
[    1.188070] fb0: EFI VGA frame buffer device
[    1.188138] ERST: Table is not found!
[    1.188141] GHES: HEST is not enabled!
[    1.188507] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.397703] Linux agpgart interface v0.103
[    1.397852] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M]
at 0x60,0x64 irq 1,12
[    1.415675] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.415734] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.416160] mousedev: PS/2 mouse device common for all mice
[    1.417054] rtc_cmos 00:06: RTC can wake from S4
[    1.417281] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    1.417312] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.417328] cpuidle: using governor ladder
[    1.417332] cpuidle: using governor menu
[    1.417746] TCP cubic registered
[    1.417751] NET: Registered protocol family 17
[    1.417763] Registering the dns_resolver key type
[    1.418373] PM: Checking hibernation image partition
/dev/disk/by-uuid/2d71cb2c-018e-4b01-8e29-bf6014d85968
[    1.434436] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
[    1.445728] PM: Hibernation image not present or could not be loaded.
[    1.445766] registered taskstats version 1
[    1.461917] rtc_cmos 00:06: setting system clock to 2012-01-01
05:16:53 UTC (1325395013)
[    1.462032] Initializing network drop monitor service
[    1.464544] Freeing unused kernel memory: 712k freed
[    1.464908] Write protecting the kernel read-only data: 8192k
[    1.477716] Freeing unused kernel memory: 1968k freed
[    1.483516] Freeing unused kernel memory: 704k freed
[    1.506010] udevd[38]: starting version 175
[    1.517951] [drm] Initialized drm 1.1.0 20060810
[    1.551629] [drm] radeon defaulting to kernel modesetting.
[    1.551636] [drm] radeon kernel modesetting enabled.
[    1.551697] checking generic (c0000000 1e0000) vs hw (c0000000 10000000)
[    1.551701] fb: conflicting fb hw usage radeondrmfb vs EFI VGA -
removing generic driver
[    1.551733] Console: switching to colour dummy device 80x25
[    1.552371] radeon 0000:00:01.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.552382] radeon 0000:00:01.0: setting latency timer to 64
[    1.553195] [drm] initializing kernel modesetting (PALM
0x1002:0x9806 0x1043:0x84E3).
[    1.553316] [drm] register mmio base: 0xFEB00000
[    1.553320] [drm] register mmio size: 262144
[    1.553559] ATOM BIOS: AMD
[    1.553617] radeon 0000:00:01.0: VRAM: 384M 0x0000000000000000 -
0x0000000017FFFFFF (384M used)
[    1.553623] radeon 0000:00:01.0: GTT: 512M 0x0000000018000000 -
0x0000000037FFFFFF
[    1.553636] mtrr: type mismatch for c0000000,10000000 old:
write-back new: write-combining
[    1.553641] [drm] Detected VRAM RAM=384M, BAR=256M
[    1.553645] [drm] RAM width 32bits DDR
[    1.554374] [TTM] Zone  kernel: Available graphics memory: 1823436 kiB.
[    1.554378] [TTM] Initializing pool allocator.
[    1.554431] [drm] radeon: 384M of VRAM memory ready
[    1.554435] [drm] radeon: 512M of GTT memory ready.
[    1.554464] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.554468] [drm] Driver supports precise vblank timestamp query.
[    1.554517] radeon 0000:00:01.0: irq 40 for MSI/MSI-X
[    1.554524] radeon 0000:00:01.0: radeon: using MSI.
[    1.554570] [drm] radeon: irq initialized.
[    1.554579] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.556395] [drm] Loading PALM Microcode
[    1.569551] radeon 0000:00:01.0: WB enabled
[    1.586223] [drm] ring test succeeded in 1 usecs
[    1.586423] [drm] radeon: ib pool ready.
[    1.586539] [drm] ib test succeeded in 0 usecs
[    1.587369] [drm] Radeon Display Connectors
[    1.587373] [drm] Connector 0:
[    1.587376] [drm]   LVDS
[    1.587378] [drm]   HPD1
[    1.587382] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438
0x643c 0x643c
[    1.587385] [drm]   Encoders:
[    1.587388] [drm]     LCD1: INTERNAL_UNIPHY
[    1.587391] [drm] Connector 1:
[    1.587394] [drm]   HDMI-A
[    1.587396] [drm]   HPD2
[    1.587399] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448
0x644c 0x644c
[    1.587402] [drm]   Encoders:
[    1.587405] [drm]     DFP1: INTERNAL_UNIPHY
[    1.587407] [drm] Connector 2:
[    1.587409] [drm]   VGA
[    1.587413] [drm]   DDC: 0x64d8 0x64d8 0x64dc 0x64dc 0x64e0 0x64e0
0x64e4 0x64e4
[    1.587416] [drm]   Encoders:
[    1.587419] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    1.644041] [drm] Radeon display connector LVDS-1: Found valid EDID
[    1.654418] [drm] Radeon display connector HDMI-A-1: No monitor
connected or invalid EDID
[    1.664793] [drm] Radeon display connector VGA-1: No monitor
connected or invalid EDID
[    1.664836] [drm] Internal thermal controller without fan control
[    1.664914] [drm] radeon: power management initialized
[    2.123132] [drm] fb mappable at 0xC0141000
[    2.123138] [drm] vram apper at 0xC0000000
[    2.123141] [drm] size 4325376
[    2.123144] [drm] fb depth is 24
[    2.123147] [drm]    pitch is 5632
[    2.123509] fbcon: radeondrmfb (fb0) is primary device
[    2.130246] Refined TSC clocksource calibration: 1646.493 MHz.
[    2.130267] Switching to clocksource tsc
[    2.646995] Console: switching to colour frame buffer device 170x48
[    2.652753] fb0: radeondrmfb frame buffer device
[    2.652756] drm: registered panic notifier
[    2.652769] [drm] Initialized radeon 2.11.0 20080528 for
0000:00:01.0 on minor 0
[    2.802366] SCSI subsystem initialized
[    2.814800] libata version 3.00 loaded.
[    2.817253] ahci 0000:00:11.0: version 3.0
[    2.817358] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.817486] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 1 ports 3
Gbps 0x1 impl SATA mode
[    2.817493] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led
clo pmp pio slum part
[    2.818563] scsi0 : ahci
[    2.818782] ata1: SATA max UDMA/133 abar m1024@0xfeb4c000 port
0xfeb4c100 irq 19
[    3.303676] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.361000] ata1.00: ATA-8: ST9500325AS, 0003SDM1, max UDMA/133
[    3.361008] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.363725] ata1.00: configured for UDMA/133
[    3.364403] scsi 0:0:0:0: Direct-Access     ATA      ST9500325AS
  0003 PQ: 0 ANSI: 5
[    3.370875] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks:
(500 GB/465 GiB)
[    3.370977] sd 0:0:0:0: [sda] Write Protect is off
[    3.370982] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.371025] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    3.416505]  sda: sda1 sda2 sda3 sda4 sda5 sda6
[    3.418210] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.677371] PM: Starting manual resume from disk
[    4.677378] PM: Hibernation image partition 8:3 present
[    4.677381] PM: Looking for hibernation image.
[    4.678134] PM: Image not found (code -22)
[    4.678141] PM: Hibernation image not present or could not be loaded.
[    4.790961] EXT4-fs (sda4): INFO: recovery required on readonly filesystem
[    4.790970] EXT4-fs (sda4): write access will be enabled during recovery
[    5.784082] EXT4-fs (sda4): recovery complete
[    5.787541] EXT4-fs (sda4): mounted filesystem with ordered data
mode. Opts: (null)
[    8.080123] udevd[222]: starting version 175
[    8.285893] ACPI: acpi_idle registered with cpuidle
[    8.300728] powernow-k8: Found 1 AMD E-450 APU with Radeon(tm) HD
Graphics (2 cpu cores) (version 2.20.00)
[    8.300882] powernow-k8:    0 : pstate 0 (1650 MHz)
[    8.300886] powernow-k8:    1 : pstate 1 (1320 MHz)
[    8.300890] powernow-k8:    2 : pstate 2 (825 MHz)
[    8.727259] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    8.727274] ACPI: Power Button [PWRB]
[    8.727372] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[    8.732285] ACPI: Lid Switch [LID]
[    8.732425] input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[    8.732437] ACPI: Sleep Button [SLPB]
[    8.732527] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    8.732534] ACPI: Power Button [PWRF]
[    8.753929] thermal LNXTHERM:00: registered as thermal_zone0
[    8.753938] ACPI: Thermal Zone [TZ00] (72 C)
[    8.796999] wmi: Mapper loaded
[    8.920917] usbcore: registered new interface driver usbfs
[    8.921267] usbcore: registered new interface driver hub
[    8.921650] usbcore: registered new device driver usb
[    8.931220] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
[    8.931332] SP5100 TCO timer: mmio address 0xbafe00 already in use
[    8.983113] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    9.011331] xhci_hcd 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    9.011501] xhci_hcd 0000:06:00.0: setting latency timer to 64
[    9.011510] xhci_hcd 0000:06:00.0: xHCI Host Controller
[    9.011581] xhci_hcd 0000:06:00.0: new USB bus registered, assigned
bus number 1
[    9.018630] xhci_hcd 0000:06:00.0: irq 18, io mem 0xfe900000
[    9.018771] xhci_hcd 0000:06:00.0: irq 41 for MSI/MSI-X
[    9.018778] xhci_hcd 0000:06:00.0: irq 42 for MSI/MSI-X
[    9.018784] xhci_hcd 0000:06:00.0: irq 43 for MSI/MSI-X
[    9.019262] xHCI xhci_add_endpoint called for root hub
[    9.019268] xHCI xhci_check_bandwidth called for root hub
[    9.019340] hub 1-0:1.0: USB hub found
[    9.019424] hub 1-0:1.0: 2 ports detected
[    9.019552] xhci_hcd 0000:06:00.0: xHCI Host Controller
[    9.019575] xhci_hcd 0000:06:00.0: new USB bus registered, assigned
bus number 2
[    9.021721] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.021779] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    9.021835] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    9.021864] ehci_hcd 0000:00:12.2: new USB bus registered, assigned
bus number 3
[    9.021883] ehci_hcd 0000:00:12.2: applying AMD
SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    9.021921] QUIRK: Enable AMD PLL fix
[    9.021948] ehci_hcd 0000:00:12.2: debug port 1
[    9.021996] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfeb4a000
[    9.024122] xHCI xhci_add_endpoint called for root hub
[    9.024128] xHCI xhci_check_bandwidth called for root hub
[    9.024207] hub 2-0:1.0: USB hub found
[    9.024289] hub 2-0:1.0: 2 ports detected
[    9.030441] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    9.030944] hub 3-0:1.0: USB hub found
[    9.030958] hub 3-0:1.0: 5 ports detected
[    9.031318] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    9.031384] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    9.031402] ehci_hcd 0000:00:13.2: new USB bus registered, assigned
bus number 4
[    9.031417] ehci_hcd 0000:00:13.2: applying AMD
SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    9.031456] ehci_hcd 0000:00:13.2: debug port 1
[    9.031483] ehci_hcd 0000:00:13.2: irq 17, io mem 0xfeb48000
[    9.040175] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    9.040494] hub 4-0:1.0: USB hub found
[    9.040503] hub 4-0:1.0: 5 ports detected
[    9.045064] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    9.045429] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    9.045565] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    9.045595] ohci_hcd 0000:00:12.0: new USB bus registered, assigned
bus number 5
[    9.045645] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfeb4b000
[    9.076025] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    9.102115] hub 5-0:1.0: USB hub found
[    9.102198] hub 5-0:1.0: 5 ports detected
[    9.102351] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    9.102450] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    9.102476] ohci_hcd 0000:00:13.0: new USB bus registered, assigned
bus number 6
[    9.102513] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfeb49000
[    9.158609] hub 6-0:1.0: USB hub found
[    9.158622] hub 6-0:1.0: 5 ports detected
[    9.246546] ACPI: Battery Slot [BAT0] (battery present)
[    9.251241] ACPI: AC Adapter [AC0] (on-line)
[    9.266937] acpi device:44: registered as cooling_device2
[    9.269315] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
[    9.273943] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    9.279907] cfg80211: Calling CRDA to update world regulatory domain
[    9.330745] piix4_smbus 0000:00:14.0: SMBus Host Controller at
0xb00, revision 0
[    9.343144] asus_wmi: ASUS WMI generic driver loaded
[    9.350072] usb 4-4: new high speed USB device number 2 using ehci_hcd
[    9.358160] asus_wmi: Initialization: 0x0
[    9.358213] asus_wmi: BIOS WMI version: 0.9
[    9.358299] asus_wmi: SFUN value: 0x0
[    9.359001] input: Eee PC WMI hotkeys as
/devices/platform/eeepc-wmi/input/input7
[    9.362759] asus_wmi: Backlight controlled by ACPI video driver
[    9.382812] brcmutil: module is from the staging directory, the
quality is unknown, you have been warned.
[    9.496569] snd_hda_intel 0000:00:01.1: PCI INT B -> GSI 19 (level,
low) -> IRQ 19
[    9.496724] snd_hda_intel 0000:00:01.1: irq 44 for MSI/MSI-X
[    9.496760] snd_hda_intel 0000:00:01.1: setting latency timer to 64
[    9.511169] brcmsmac: module is from the staging directory, the
quality is unknown, you have been warned.
[    9.515135] brcmsmac 0000:01:00.0: bus 1 slot 0 func 0 irq 7
[    9.515213] brcmsmac 0000:01:00.0: enabling device (0000 -> 0002)
[    9.515227] brcmsmac 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.515238] brcmsmac 0000:01:00.0: setting latency timer to 64
[    9.536295] HDMI status: Codec=0 Pin=3 Presence_Detect=0 ELD_Valid=0
[    9.539157] input: HD-Audio Generic HDMI/DP as
/devices/pci0000:00/0000:00:01.1/sound/card0/input8
[    9.539654] snd_hda_intel 0000:00:14.2: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[    9.728159] hda_codec: ALC269VB: BIOS auto-probing.
[    9.741658] input: HDA ATI SB Mic as
/devices/pci0000:00/0000:00:14.2/sound/card1/input9
[    9.742209] input: HDA ATI SB Headphone as
/devices/pci0000:00/0000:00:14.2/sound/card1/input10
[    9.773540] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   10.199780] Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1c0b1,
caps: 0xd04733/0xa40000/0xa0400
[   10.273549] input: SynPS/2 Synaptics TouchPad as
/devices/platform/i8042/serio1/input/input11
[   10.909244] Linux media interface: v0.10
[   10.922466] Linux video capture interface: v2.00
[   10.928054] uvcvideo: Found UVC 1.00 device USB2.0 UVC VGA WebCam (13d3:5702)
[   10.947448] input: USB2.0 UVC VGA WebCam as
/devices/pci0000:00/0000:00:13.2/usb4/4-4/4-4:1.0/input/input12
[   10.947619] usbcore: registered new interface driver uvcvideo
[   10.947623] USB Video Class driver (1.1.1)
[   14.166378] EXT4-fs (sda4): re-mounted. Opts: (null)
[   14.373641] EXT4-fs (sda6): mounted filesystem with ordered data
mode. Opts: (null)
[   14.510240] Adding 2559996k swap on /dev/sda3.  Priority:-1
extents:1 across:2559996k
[   20.555527] ieee80211 phy0: brcms_ops_config: change monitor mode:
false (implement)
[   20.555618] ieee80211 phy0: brcms_ops_config: change power-save
mode: false (implement)
[   20.556192] ieee80211 phy0: brcms_ops_bss_info_changed: qos
enabled: false (implement)
[   23.322639] wlan0: authenticate with 00:25:9c:d7:94:a6 (try 1)
[   23.326415] wlan0: authenticated
[   23.330136] wlan0: associate with 00:25:9c:d7:94:a6 (try 1)
[   23.332375] wlan0: RX AssocResp from 00:25:9c:d7:94:a6 (capab=0x411
status=0 aid=1)
[   23.332388] wlan0: associated
[   23.333510] ieee80211 phy0: brcms_ops_bss_info_changed: qos
enabled: false (implement)
[   23.333525] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: associated
[   23.333550] ieee80211 phy0: brcms_ops_bss_info_changed: arp
filtering: enabled true, count 0 (implement)
[   27.315082] EXT4-fs (sda4): re-mounted. Opts: commit=0
[   27.702835] EXT4-fs (sda6): re-mounted. Opts: commit=0
[   28.533941] ieee80211 phy0: brcms_ops_bss_info_changed: arp
filtering: enabled true, count 1 (implement)
[   40.252355] fuse init (API version 7.17)
[  411.212622] NET: Registered protocol family 10
[  421.603323] wlan0: no IPv6 routers present
[ 1204.090421] efivars: Unknown parameter `i'
[ 1205.587060] EFI Variables Facility v0.08 2004-May-17
