Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab2CXBNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 21:13:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34022 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753799Ab2CXBNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 21:13:34 -0400
X-Sasl-enc: 9+f5/ktGNDHZLXFrNIxvm/XJCKjEL9xNqpVDQQttD+mV 1332551613
Message-ID: <4F6D1FBC.30700@imap.cc>
Date: Sat, 24 Mar 2012 02:13:32 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.27) Gecko/20120215 SUSE/3.1.19 Thunderbird/3.1.19
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: detected stall on CPU 1 (t=0 jiffies) - huh?
References: <4F3FAC6E.4020001@imap.cc> <20120221234744.GV2375@linux.vnet.ibm.com> <4F44CE2D.9030106@imap.cc> <4F611278.8070108@imap.cc>
In-Reply-To: <4F611278.8070108@imap.cc>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEF72E020286D7FB90249730A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEF72E020286D7FB90249730A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

And yet another one, this time with the machine not idle but very busy:
I was building a kernel and surfing the web at the time it happened, but
noticed nothing ill except the kernel messages. No noticeable hang or
anything. And still no sign of any "detected stall" with t!=3D0.

[1892888.493741] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on tmds =
encoder (output 3)
[1897904.097019] INFO: rcu_bh detected stall on CPU 1 (t=3D0 jiffies)
[1897904.097019] sending NMI to all CPUs:
[1897904.097067] NMI backtrace for cpu 0
[1897904.097083] CPU 0=20
[1897904.097088] Modules linked in: sha256_generic ansi_cprng krng eseqiv=
 rng cryptd crypto_wq aes_x86_64 aes_generic cbc cryptomgr aead pcompress=
 dm_crypt crypto_hash crypto_blkcipher crypto_algapi snd_seq_dummy nls_is=
o8859_1 nls_cp437 vfat fat ip6t_LOG xt_pkttype ipt_LOG xt_limit vboxpci(O=
) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) xt_tcpudp fuse af_packet edd ip6=
t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJ=
ECT iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf=
_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntr=
ack nf_conntrack ip6table_filter ip6_tables x_tables cpufreq_conservative=
 cpufreq_userspace snd_pcm_oss cpufreq_powersave snd_mixer_oss snd_seq sn=
d_seq_device acpi_cpufreq mperf capi usblp bas_gigaset gigaset kernelcapi=
 crc_ccitt snd_hda_codec_idt snd_hda_intel snd_hda_codec e1000e osst snd_=
hwdep snd_pcm snd_timer firewire_ohci st sr_mod sg ppdev tpm_tis firewire=
_core cdrom i2c_i801 snd tpm crc_itu_t pa
rport_pc snd_page_alloc iTCO_wdt pcspkr iTCO_vendor_support tpm_bios parp=
ort ext4 jbd2 crc16 linear raid456 async_raid6_recov async_pq raid6_pq as=
ync_xor xor async_memcpy async_tx raid10 raid1 raid0 nouveau ttm drm_kms_=
helper drm i2c_algo_bit mxm_wmi wmi video button intel_agp intel_gtt dm_s=
napshot dm_mod fan processor thermal thermal_sys aic7xxx scsi_transport_s=
pi ata_generic pata_marvell
[1897904.097424]=20
[1897904.097433] Pid: 17094, comm: mkinitrd Tainted: G        W  O 3.2.8-=
capigig #1                  /DQ965GF
[1897904.097451] RIP: 0033:[<000000000045a8a1>]  [<000000000045a8a1>] 0x4=
5a8a0
[1897904.097473] RSP: 002b:00007fffd4d62e30  EFLAGS: 00000246
[1897904.097483] RAX: 000000000000000d RBX: 0000000000000000 RCX: 0000000=
000000000
[1897904.097495] RDX: 0000000000000000 RSI: 000000000107c1e0 RDI: 0000000=
000000000
[1897904.097506] RBP: 000000000107c1e0 R08: 000000000107c1e0 R09: ffff000=
000000000
[1897904.097517] R10: 00000000010a4eb0 R11: 0000000000000000 R12: 0000000=
00000000d
[1897904.097529] R13: 00000000010a3b40 R14: 00007fffd4d62e50 R15: 0000000=
000000001
[1897904.097541] FS:  00007fcc74e09700(0000) GS:ffff8801a7c00000(0000) kn=
lGS:0000000000000000
[1897904.097553] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1897904.097564] CR2: 00007fcc742f1e00 CR3: 000000015c0e1000 CR4: 0000000=
0000006f0
[1897904.097576] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[1897904.097587] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[1897904.097600] Process mkinitrd (pid: 17094, threadinfo ffff88000f7ee00=
0, task ffff88000f031f50)
[1897904.097611]=20
[1897904.097617] Call Trace:
[1897904.097019] NMI backtrace for cpu 1
[1897904.097019] CPU 1=20
[1897904.097019] Modules linked in: sha256_generic ansi_cprng krng eseqiv=
 rng cryptd crypto_wq aes_x86_64 aes_generic cbc cryptomgr aead pcompress=
 dm_crypt crypto_hash crypto_blkcipher crypto_algapi snd_seq_dummy nls_is=
o8859_1 nls_cp437 vfat fat ip6t_LOG xt_pkttype ipt_LOG xt_limit vboxpci(O=
) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) xt_tcpudp fuse af_packet edd ip6=
t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJ=
ECT iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf=
_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntr=
ack nf_conntrack ip6table_filter ip6_tables x_tables cpufreq_conservative=
 cpufreq_userspace snd_pcm_oss cpufreq_powersave snd_mixer_oss snd_seq sn=
d_seq_device acpi_cpufreq mperf capi usblp bas_gigaset gigaset kernelcapi=
 crc_ccitt snd_hda_codec_idt snd_hda_intel snd_hda_codec e1000e osst snd_=
hwdep snd_pcm snd_timer firewire_ohci st sr_mod sg ppdev tpm_tis firewire=
_core cdrom i2c_i801 snd tpm crc_itu_t pa
rport_pc snd_page_alloc iTCO_wdt pcspkr iTCO_vendor_support tpm_bios parp=
ort ext4 jbd2 crc16 linear raid456 async_raid6_recov async_pq raid6_pq as=
ync_xor xor async_memcpy async_tx raid10 raid1 raid0 nouveau ttm drm_kms_=
helper drm i2c_algo_bit mxm_wmi wmi video button intel_agp intel_gtt dm_s=
napshot dm_mod fan processor thermal thermal_sys aic7xxx scsi_transport_s=
pi ata_generic pata_marvell
[1897904.098009]=20
[1897904.098009] Pid: 1687, comm: Xorg Tainted: G        W  O 3.2.8-capig=
ig #1                  /DQ965GF
[1897904.098009] RIP: 0010:[<ffffffff8101d42f>]  [<ffffffff8101d42f>] fla=
t_send_IPI_all+0x49/0x4e
[1897904.098009] RSP: 0000:ffff8801a7c83de8  EFLAGS: 00003046
[1897904.098009] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000=
0ffffffff
[1897904.098009] RDX: 0000000000000000 RSI: 0000000000000c00 RDI: fffffff=
f8101d339
[1897904.098009] RBP: ffff8801a7c83df8 R08: 0000000000000002 R09: 0000000=
000000000
[1897904.098009] R10: ffffffff81a170c0 R11: 0720072007200720 R12: ffff880=
1a7c8d940
[1897904.098009] R13: ffffffff81a1ff00 R14: 0000000000000000 R15: 7ffffff=
fffffffff
[1897904.098009] FS:  00007f2d917d7700(0000) GS:ffff8801a7c80000(0000) kn=
lGS:0000000000000000
[1897904.098009] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1897904.098009] CR2: 00007f561ecce000 CR3: 0000000196880000 CR4: 0000000=
0000006e0
[1897904.098009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[1897904.098009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[1897904.098009] Process Xorg (pid: 1687, threadinfo ffff880194f7c000, ta=
sk ffff8801964f5df0)
[1897904.098009] Stack:
[1897904.098009]  ffffffff81a1ff00 ffff8801a7c8d940 ffff8801a7c83e18 ffff=
ffff81019f6b
[1897904.098009]  0000000000000001 ffffffff81a1ff00 ffff8801a7c83e68 ffff=
ffff8109fab6
[1897904.098009]  0000000000003092 0000000000000001 ffff8801a7c83e48 0000=
000000000001
[1897904.098009] Call Trace:
[1897904.098009]  <IRQ>=20
[1897904.098009]  [<ffffffff81019f6b>] arch_trigger_all_cpu_backtrace+0x4=
9/0x72
[1897904.098009]  [<ffffffff8109fab6>] __rcu_pending+0x86/0x3b8
[1897904.098009]  [<ffffffff81062ba4>] ? tick_nohz_handler+0xd6/0xd6
[1897904.098009]  [<ffffffff810a039b>] rcu_check_callbacks+0xe2/0x113
[1897904.098009]  [<ffffffff81048a45>] update_process_times+0x3c/0x73
[1897904.098009]  [<ffffffff81062c13>] tick_sched_timer+0x6f/0x8f
[1897904.098009]  [<ffffffff81058948>] __run_hrtimer+0x75/0xeb
[1897904.098009]  [<ffffffff810590c6>] hrtimer_interrupt+0xdf/0x1b2
[1897904.098009]  [<ffffffff813f8703>] ? add_preempt_count+0xa9/0xad
[1897904.098009]  [<ffffffff81019462>] smp_apic_timer_interrupt+0x71/0x84=

[1897904.098009]  [<ffffffff813faff0>] apic_timer_interrupt+0x70/0x80
[1897904.098009]  <EOI>=20
[1897904.098009]  [<ffffffff813fa4ac>] ? sysret_check+0x27/0x62
[1897904.098009] Code: bf fe ff ff eb 25 48 8b 05 97 9d a6 00 44 8b 60 34=
 e8 1c fc ff ff 44 89 e6 81 ce 00 00 08 00 09 de bf 00 03 00 00 e8 c9 fb =
ff ff <5b> 41 5c 5d c3 55 48 89 e5 53 48 83 ec 08 89 f3 e8 2b c7 ff ff=20
[1897904.098009] Call Trace:
[1897904.098009]  <IRQ>  [<ffffffff81019f6b>] arch_trigger_all_cpu_backtr=
ace+0x49/0x72
[1897904.098009]  [<ffffffff8109fab6>] __rcu_pending+0x86/0x3b8
[1897904.098009]  [<ffffffff81062ba4>] ? tick_nohz_handler+0xd6/0xd6
[1897904.098009]  [<ffffffff810a039b>] rcu_check_callbacks+0xe2/0x113
[1897904.098009]  [<ffffffff81048a45>] update_process_times+0x3c/0x73
[1897904.098009]  [<ffffffff81062c13>] tick_sched_timer+0x6f/0x8f
[1897904.098009]  [<ffffffff81058948>] __run_hrtimer+0x75/0xeb
[1897904.098009]  [<ffffffff810590c6>] hrtimer_interrupt+0xdf/0x1b2
[1897904.098009]  [<ffffffff813f8703>] ? add_preempt_count+0xa9/0xad
[1897904.098009]  [<ffffffff81019462>] smp_apic_timer_interrupt+0x71/0x84=

[1897904.098009]  [<ffffffff813faff0>] apic_timer_interrupt+0x70/0x80
[1897904.098009]  <EOI>  [<ffffffff813fa4ac>] ? sysret_check+0x27/0x62
[1897912.659520] mdadm: sending ioctl 1261 to a partition!


--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigEF72E020286D7FB90249730A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk9tH7wACgkQQ3+did9BuFtB8gCeOxW9ehfT3FvMCwF5IwRT0gUP
hCYAn1IvG61IhQoVP86IuT+7uUDhZggj
=Rgb1
-----END PGP SIGNATURE-----

--------------enigEF72E020286D7FB90249730A--
