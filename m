Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1BIR1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:27:45 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:64819 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab1BIR1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:27:44 -0500
Date: Wed, 9 Feb 2011 09:26:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.38-rc4 (tty/ifx6x60: BUG)
Message-Id: <20110209092633.d26c5553.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D52CE5D.0022:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64, nearly allmodconfig.


[   86.956907] BUG: unable to handle kernel paging request at ffffffffa062c5d8
[   86.958336] IP: [<ffffffff814461b1>] spi_register_driver+0x15/0x6c
[   86.958349] PGD 1a14067 PUD 1a18063 PMD 6f558067 PTE 800000006ed06161
[   86.958359] Oops: 0003 [#1] SMP DEBUG_PAGEALLOC
[   86.958364] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1.3/devnum
[   86.958370] CPU 0 
[   86.958372] Modules linked in: ifx6x60(+) af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table mperf binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod mousedev joydev evdev mac_hid snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq usbmouse usbkbd snd_seq_device usbhid hid snd_pcm sr_mod tg3 pcspkr dcdbas 8250_pnp snd_timer rtc_cmos cdrom i2c_i801 sg rtc_core iTCO_wdt snd 8250 iTCO_vendor_support rtc_lib processor serial_core soundcore thermal_sys intel_agp snd_page_alloc intel_gtt hwmon button unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_class ehci_hcd usbcore nls_base [last unloaded: microcode]
[   86.958466] 
[   86.958471] Pid: 2523, comm: modprobe Not tainted 2.6.38-rc4 #1 0TY565/OptiPlex 745                 
[   86.958474] RIP: 0010:[<ffffffff814461b1>]  [<ffffffff814461b1>] spi_register_driver+0x15/0x6c
[   86.958480] RSP: 0018:ffff88006cd63ef8  EFLAGS: 00010286
[   86.958483] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88006cd63e98
[   86.958487] RDX: 0000000000000000 RSI: 000000143f08b654 RDI: ffffffffa062c5a0
[   86.958490] RBP: ffff88006cd63ef8 R08: 0000000000000000 R09: 0000000000000000
[   86.958493] R10: 0000000000000000 R11: 2222222222222222 R12: ffffffffa01c2000
[   86.958496] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   86.958501] FS:  00007f71c311a6f0(0000) GS:ffff88007c400000(0000) knlGS:0000000000000000
[   86.958504] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   86.958507] CR2: ffffffffa062c5d8 CR3: 000000007033a000 CR4: 00000000000006f0
[   86.958511] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   86.958514] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   86.958518] Process modprobe (pid: 2523, threadinfo ffff88006cd62000, task ffff88006cfa8000)
[   86.958521] Stack:
[   86.958523]  ffff88006cd63f18 ffffffffa01c2133 ffff88006cd63f18 ffffffffa062e140
[   86.958529]  ffff88006cd63f48 ffffffff810020e3 ffffffffa062e140 0000000000000001
[   86.958535]  000000000061b470 0000000000000000 ffff88006cd63f78 ffffffff810d6674
[   86.958541] Call Trace:
[   86.958551]  [<ffffffffa01c2133>] ifx_spi_init+0x133/0x1000 [ifx6x60]
[   86.958557]  [<ffffffff810020e3>] do_one_initcall+0xa9/0x1ef
[   86.958564]  [<ffffffff810d6674>] sys_init_module+0x12b/0x307
[   86.958569]  [<ffffffff8100e942>] system_call_fastpath+0x16/0x1b
[   86.958571] Code: e1 10 00 48 ff 05 e8 b9 94 01 41 58 5b 44 89 e0 41 5c 41 5d c9 c3 55 48 89 e5 0f 1f 44 00 00 48 ff 05 34 bb 94 01 48 83 7f 08 00 <48> c7 47 38 70 75 cb 81 74 0f 48 c7 47 58 f4 50 44 81 48 ff 05 
[   86.958613] RIP  [<ffffffff814461b1>] spi_register_driver+0x15/0x6c
[   86.958617]  RSP <ffff88006cd63ef8>
[   86.958620] CR2: ffffffffa062c5d8
[   86.958625] ---[ end trace 99fc207b918ffa02 ]---

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
