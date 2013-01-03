Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3ACRwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 12:52:11 -0500
Received: from mout.gmx.net ([212.227.17.20]:54596 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab3ACRwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 12:52:08 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+zdNpFIrCz1PT/b64Lx6Oi1iw3TpwMWbL5/2aOsV
	1pc30xyD+SrKgr
Message-ID: <50E5C416.8030104@gmx.de>
Date: Thu, 03 Jan 2013 18:47:02 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Oops: BUG: unable to handle kernel paging request at e8fc6b40
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got hits Oops at kernel 3.7.1 at a stable Gentoo Linux x86 - 
(BTW I do miss the "--- cut here] ---" line) :


2013-01-03T18:33:09.000+01:00 n22 shutdown[27425]: shutting down for system reboot
2013-01-03T18:33:10.000+01:00 n22 init: Switching to runlevel: 6
2013-01-03T18:33:12.028+01:00 n22 kernel: BUG: unable to handle kernel paging request at e8fc6b40
2013-01-03T18:33:12.028+01:00 n22 kernel: IP: [<c1237ade>] strnlen+0xe/0x20
2013-01-03T18:33:12.028+01:00 n22 kernel: *pdpt = 00000000015a4001 *pde = 0000000001b78067 *pte = 8000000028fc6160
2013-01-03T18:33:12.028+01:00 n22 kernel: Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
2013-01-03T18:33:12.028+01:00 n22 kernel: Modules linked in: cpufreq_stats loop ipt_MASQUERADE xt_owner xt_multiport ipt_REJECT xt_tcpudp xt_recent xt_conntrack nf_conntrack_ftp xt_limit xt_LOG iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables af_packet pppoe pppox ppp_generic slhc bridge stp llc tun msr arc4 iwldvm mac80211 coretemp kvm_intel snd_hda_codec_conexant iwlwifi i915 uvcvideo fbcon font bitblit softcursor drm_kms_helper drm fb fbdev intel_agp i2c_i801 cfbcopyarea snd_hda_intel snd_hda_codec cfg80211 i2c_algo_bit intel_gtt agpgart kvm videobuf2_core cfbimgblt videodev cfbfillrect i2c_core snd_pcm thinkpad_acpi snd_timer hwmon snd 8250_pci tpm_tis tpm acpi_cpufreq nvram tpm_bios mperf video battery button e1000e soundcore 8250_core snd_page_alloc usblp serial_core sdhci_pci rfkill ac wmi psmouse sdhci videobuf2_vmalloc evdev thermal processor mmc_core videobuf2_memops aesni_intel xts aes_i586 lrw gf128mul ablk_help
er cryptd cbc sha256_generic fuse nfs lockd sunrpc dm_crypt dm_mod hid_monterey hid_microsoft hid_logitech hid_ezkey hid_cypress hid_chicony hid_cherry hid_belkin hid_apple hid_a4tech hid_generic usbhid hid sr_mod cdrom sg [last unloaded: microcode]
2013-01-03T18:33:12.028+01:00 n22 kernel: Pid: 14551, comm: boinc_client Tainted: G        W    3.7.1 #2 LENOVO 4180F65/4180F65
2013-01-03T18:33:12.028+01:00 n22 kernel: EIP: 0060:[<c1237ade>] EFLAGS: 00210097 CPU: 3
2013-01-03T18:33:12.028+01:00 n22 kernel: EIP is at strnlen+0xe/0x20
2013-01-03T18:33:12.028+01:00 n22 kernel: EAX: e8fc6b40 EBX: f074c422 ECX: e8fc6b40 EDX: fffffffe
2013-01-03T18:33:12.028+01:00 n22 kernel: ESI: f074d000 EDI: e8fc6b40 EBP: c957be50 ESP: c957be50
2013-01-03T18:33:12.424+01:00 n22 kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
2013-01-03T18:33:12.424+01:00 n22 kernel: CR0: 80050033 CR2: e8fc6b40 CR3: 1e5ac000 CR4: 000407f0
2013-01-03T18:33:12.424+01:00 n22 kernel: DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
2013-01-03T18:33:12.424+01:00 n22 kernel: DR6: ffff0ff0 DR7: 00000400
2013-01-03T18:33:12.424+01:00 n22 kernel: Process boinc_client (pid: 14551, ti=c957a000 task=e982d940 task.ti=c957a000)
2013-01-03T18:33:12.424+01:00 n22 kernel: Stack:
2013-01-03T18:33:12.424+01:00 n22 kernel: c957be68 c12349e8 c1469209 c957bedc f074c422 00000002 c957beac c1235c3e
2013-01-03T18:33:12.424+01:00 n22 kernel: 00000000 0000ffff f118ffff c112140a f2ee000a c1120001 00000be0 f074c420
2013-01-03T18:33:12.424+01:00 n22 kernel: f074d000 c146920a ff0a0004 ffffffff e9a7c060 c1469206 0000002c c957bec0
2013-01-03T18:33:12.424+01:00 n22 kernel: Call Trace:
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c12349e8>] string.isra.4+0x28/0xb0
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c1235c3e>] vsnprintf+0x20e/0x3d0
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c112140a>] ? lookup_fast+0x25a/0x2f0
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c1120001>] ? __page_symlink+0x1/0xf0
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c11345c9>] seq_vprintf+0x29/0x50
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c1134606>] seq_printf+0x16/0x20
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c10a318f>] show_interrupts+0x24f/0x320
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c113499b>] seq_read+0x20b/0x380
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c1134790>] ? seq_lseek+0x180/0x180
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c1161d18>] proc_reg_read+0x58/0x90
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c11180bc>] vfs_read+0x8c/0x160
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c1238100>] ? copy_to_user+0x40/0x60
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c1161cc0>] ? proc_reg_write+0x90/0x90
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c11181d7>] sys_read+0x47/0x80
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c13c3f41>] sysenter_do_call+0x12/0x22
2013-01-03T18:33:12.425+01:00 n22 kernel: [<c13c0000>] ? cmos_do_probe+0x73/0x333
2013-01-03T18:33:12.425+01:00 n22 kernel: Code: 57 66 66 66 66 90 85 c9 89 c7 74 07 89 d0 f2 ae 75 01 4f 89 f8 5f 5d c3 90 8d 74 26 00 55 89 e5 66 66 66 66 90 89 c1 89 c8 eb 06 <80> 38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 5d c3 90 90 55 89 e5
2013-01-03T18:33:12.425+01:00 n22 kernel: EIP: [<c1237ade>] strnlen+0xe/0x20 SS:ESP 0068:c957be50
2013-01-03T18:33:12.425+01:00 n22 kernel: CR2: 00000000e8fc6b40
2013-01-03T18:33:12.425+01:00 n22 kernel: ---[ end trace 51c90f89f19bb9ff ]---

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
