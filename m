Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab1FVN42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 09:56:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49874 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757942Ab1FVN40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:56:26 -0400
Subject: 3.0-rc3: kernel BUG at fs/inode.c:1368!
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Cc: 631255@bugs.debian.org, Johannes Wiedersich <debian@aktendiener.de>
In-Reply-To: <20110622063624.7374.9343.reportbug@johannes4.fritz.box>
References: <20110622063624.7374.9343.reportbug@johannes4.fritz.box>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-wGNEMUbpCHBgdgVklYMD"
Date: Wed, 22 Jun 2011 14:56:20 +0100
Message-ID: <1308750980.3093.470.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wGNEMUbpCHBgdgVklYMD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-06-22 at 08:36 +0200, Johannes Wiedersich wrote:
> Package: linux-2.6
> Version: 3.0.0~rc3-1~experimental.1
> Severity: important
>=20
>=20
> aptitude installing a package triggers a kernel oops. I have no idea,
> what part of the installation process is to blame, but could try to
> reproduce, if I would get further instructions.=20
[...]

I assume you haven't seen a similar crash in earlier versions?

Also, what type of filesystem where you installing on
(ext3/ext4/btrfs/xfs...)?

> Jun 21 17:13:24 johannes4 kernel: [  133.576370] ------------[ cut here ]=
------------
> Jun 21 17:13:24 johannes4 kernel: [  133.576401] kernel BUG at /media/dat=
a/mattems/src/linux-2.6-3.0.0~rc3/debian/build/source_amd64_none/fs/inode.c=
:1368!
> Jun 21 17:13:24 johannes4 kernel: [  133.576449] invalid opcode: 0000 [#1=
] SMP=20
> Jun 21 17:13:24 johannes4 kernel: [  133.576473] CPU 3=20
> Jun 21 17:13:24 johannes4 kernel: [  133.576484] Modules linked in: aesni=
_intel cryptd aes_x86_64 aes_generic cpufreq_conservative cpufreq_powersave=
 cpufreq_stats cpufreq_userspace acpi_cpufreq mperf parport_pc rfcomm bnep =
ppdev lp parport vboxnetadp(O) vboxnetflt(O) vboxdrv(O) microcode uinput ac=
t_police cls_flow cls_fw cls_u32 sch_tbf sch_prio sch_htb sch_hfsc sch_ingr=
ess sch_sfq xt_time xt_connlimit xt_realm xt_addrtype iptable_raw xt_commen=
t xt_recent xt_policy ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQU=
ERADE ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah nf_nat_tftp nf_nat_snmp_basic nf=
_conntrack_snmp nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h=
323 nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_sane n=
f_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp=
 nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns nf_con=
ntrack_broadcast nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_TPR=
OXY nf_tproxy_cor
>  e ip6_tables nf_defrag_ipv6 xt_tcpmss xt
> Jun 21 17:13:24 johannes4 kernel: _pkttype xt_physdev xt_owner xt_NFQUEUE=
 xt_NFLOG nfnetlink_log xt_multiport xt_mark xt_mac xt_limit xt_length xt_i=
prange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_connm=
ark xt_CLASSIFY ipt_LOG xt_tcpudp xt_state iptable_nat nf_nat nf_conntrack_=
ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip=
_tables x_tables fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ext=
2 loop dm_crypt joydev snd_hda_codec_hdmi snd_hda_codec_conexant uvcvideo v=
ideodev btusb arc4 media v4l2_compat_ioctl32 bluetooth i915 drm_kms_helper =
snd_hda_intel iwlagn drm snd_hda_codec thinkpad_acpi mac80211 psmouse snd_h=
wdep snd_seq i2c_algo_bit ac cfg80211 snd_seq_device serio_raw pcspkr evdev=
 i2c_i801 snd_pcm battery snd_timer power_supply tpm_tis i2c_core snd_page_=
alloc snd rfkill tpm wmi tpm_bios soundcore nvram button video processor ex=
t4 mbcache jbd2 crc16 dm_mod sd_mod crc_t10dif ahci libahci libata thermal =
ehci_hcd thermal_
>  sys sdhci_pci sdhci mmc_core scsi_mod usbco
> Jun 21 17:13:24 johannes4 kernel: re e1000e [last unloaded: scsi_wait_sca=
n]
> Jun 21 17:13:24 johannes4 kernel: [  133.579533]=20
> Jun 21 17:13:24 johannes4 kernel: [  133.579566] Pid: 6764, comm: rm Tain=
ted: G           O 3.0.0-rc3-amd64 #1 LENOVO 4290W1B/4290W1B
> Jun 21 17:13:24 johannes4 kernel: [  133.579702] RIP: 0010:[<ffffffff8110=
f522>]  [<ffffffff8110f522>] iput+0x16/0x14c
> Jun 21 17:13:24 johannes4 kernel: [  133.579812] RSP: 0018:ffff88005de8de=
88  EFLAGS: 00010202
> Jun 21 17:13:24 johannes4 kernel: [  133.579883] RAX: 0000000000000000 RB=
X: ffff880075224c20 RCX: 0000000000000025
> Jun 21 17:13:24 johannes4 kernel: [  133.579975] RDX: 00000000ffff5da3 RS=
I: ffffffffa0153531 RDI: ffff880075224c20
> Jun 21 17:13:24 johannes4 kernel: [  133.580067] RBP: ffff880074c75840 R0=
8: ffff88005dc878d8 R09: ffff88005dc87918
> Jun 21 17:13:24 johannes4 kernel: [  133.580159] R10: ffff88005dc87918 R1=
1: ffff880075224c20 R12: ffff880075224c20
> Jun 21 17:13:24 johannes4 kernel: [  133.580250] R13: 0000000000000001 R1=
4: ffff88007521e3c0 R15: ffff880094501d50
> Jun 21 17:13:24 johannes4 kernel: [  133.580342] FS:  00007f7758f2e700(00=
00) GS:ffff88013e2c0000(0000) knlGS:0000000000000000
> Jun 21 17:13:24 johannes4 kernel: [  133.580447] CS:  0010 DS: 0000 ES: 0=
000 CR0: 0000000080050033
> Jun 21 17:13:24 johannes4 kernel: [  133.580521] CR2: 0000000001b98128 CR=
3: 000000005dc33000 CR4: 00000000000406e0
> Jun 21 17:13:24 johannes4 kernel: [  133.580613] DR0: 0000000000000000 DR=
1: 0000000000000000 DR2: 0000000000000000
> Jun 21 17:13:24 johannes4 kernel: [  133.580706] DR3: 0000000000000000 DR=
6: 00000000ffff0ff0 DR7: 0000000000000400
> Jun 21 17:13:24 johannes4 kernel: [  133.580798] Process rm (pid: 6764, t=
hreadinfo ffff88005de8c000, task ffff8800843a8870)
> Jun 21 17:13:24 johannes4 kernel: [  133.580899] Stack:
> Jun 21 17:13:24 johannes4 kernel: [  133.580929]  ffff88007521e3c0 ffff88=
0074c75840 ffff880075224c20 ffffffff8110cde5
> Jun 21 17:13:24 johannes4 kernel: [  133.581043]  ffff880075224c20 ffff88=
007521e3c0 ffff88007521e41c ffff880075224c20
> Jun 21 17:13:24 johannes4 kernel: [  133.581156]  ffff880075224c20 ffffff=
ff8110d531 0000000040000010 ffff880094501d40
> Jun 21 17:13:24 johannes4 kernel: [  133.581268] Call Trace:
> Jun 21 17:13:24 johannes4 kernel: [  133.581309]  [<ffffffff8110cde5>] ? =
dentry_kill+0x133/0x14f
> Jun 21 17:13:24 johannes4 kernel: [  133.581386]  [<ffffffff8110d531>] ? =
dput+0xdc/0xe9
> Jun 21 17:13:24 johannes4 kernel: [  133.581452]  [<ffffffff810fda76>] ? =
fput+0x1cb/0x1f2
> Jun 21 17:13:24 johannes4 kernel: [  133.581523]  [<ffffffff810facbb>] ? =
filp_close+0x64/0x6c
> Jun 21 17:13:24 johannes4 kernel: [  133.581596]  [<ffffffff810fad55>] ? =
sys_close+0x92/0xc6
> Jun 21 17:13:24 johannes4 kernel: [  133.581670]  [<ffffffff8133cc12>] ? =
system_call_fastpath+0x16/0x1b
> Jun 21 17:13:24 johannes4 kernel: [  133.581751] Code: c7 70 76 62 81 e8 =
85 42 f5 ff 48 83 c4 18 5b 5d 41 5c 41 5d c3 41 54 48 85 ff 55 53 48 89 fb =
0f 84 37 01 00 00 f6 47 28 40 74 04 <0f> 0b eb fe 48 8d 77 20 48 8d bf b8 0=
0 00 00 e8 da 40 09 00 85=20
> Jun 21 17:13:24 johannes4 kernel: [  133.582262] RIP  [<ffffffff8110f522>=
] iput+0x16/0x14c
> Jun 21 17:13:24 johannes4 kernel: [  133.582338]  RSP <ffff88005de8de88>
> Jun 21 17:13:24 johannes4 kernel: [  133.641760] ---[ end trace 7412f89dc=
bb91ce3 ]---
> Jun 21 17:13:25 johannes4 kernel: [  134.948259] ------------[ cut here ]=
------------
[...]

Forwarding this to LKML.

Ben.

--=20
Ben Hutchings
Editing code like this is akin to sticking plasters on the bleeding stump
of a severed limb. - me, 29 June 1999

--=-wGNEMUbpCHBgdgVklYMD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATgH0f+e/yOyVhhEJAQo06w/9EIzIEwvt2JsGEeiIBmG/M31FbtbLDulH
lwPocHm1q03UIMPrQLSFyPkmcegviqFjTutnxL1BuPa7Y13FeCUCsF465g2ionFN
B+0eWDO5pbR58mUtsQBPS6yrar1IMq5CtlkppPxiXOVeOdXmz+pbc/adRi0p4ZVV
YQtkdweUErPRspMv6/qWo7FGSqK4B8HJ1ttxlYJf8Tfy+0IrlRHxa7y8mbZxaA9j
3K/VWmiWDmmRTn9xqnBRrCoep2wBReSpC2eX+5L1UhXOEYNvWXrIl83B3LJecaBn
W/6p/K5MwjW7XAYcR3IMDFJ6L/pOcxQqqZrEQHl5WzgovDw6O9GrvH6aYQqai0Xj
5UnK6urXSh5T7f/zuTyeuNE6zi3i3j0aTL5LElly2nV9f25iDq4okWfqRol/8XTs
dZpiE5BomFLFkWYOCbb3NdieG5OZ/34/q/i5c2DoIr++tTe3wULGf8Dl7M4syfV4
IA96H2L3Bvb9vYyvp2FfB2UShZTVhPP/d2wPirOobUnc2Ci5Gugy8DpwQk3vWIWt
nK83zfXmqVmUDF6n7wmFvT+roR17HoIibsXoDod2MBteLNw5B1m0Fcjv4y3JQ56n
Hkesf8e7obarcjTaSDm5UEpfZyxXhgQU+SjVNoEiveoRlN4Zm+5wLjx9Oj8sh955
zF+6mIjlYD8=
=MStk
-----END PGP SIGNATURE-----

--=-wGNEMUbpCHBgdgVklYMD--
