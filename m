Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab2BKUFE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 15:05:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45883 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2BKUFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 15:05:01 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=+gq+4NyxY4ats0t5moOB4g==:17 a=06EuFv-E9xkA:10 a=NEAV23lmAAAA:8 a=_6mn9VYxFGCKsexczaEA:9 a=My364oo2Eo-kChwq_8AA:7 a=QEXdDO2ut3YA:10 a=ALG4wj2oFoG64wuw2XIA:9 a=+gq+4NyxY4ats0t5moOB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.69.206.42
Message-ID: <1328990690.2464.6.camel@firefly>
Subject: Kernel bug with btrfs on laptop with external hd and suspend and
 resume.
From: "Nathan A. Mourey II" <nmoureyii@ne.rr.com>
To: linux-kernel@vger.kernel.org
Date: Sat, 11 Feb 2012 15:04:50 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-IJj6TKtBAPo/sszBCjny"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IJj6TKtBAPo/sszBCjny
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I just installed the new kernel with yum update.  I have an external eSATA =
hard drive that is=20
formatted with btrfs.  I closed the lid once it had booted up, I had not lo=
gged in yet.  Latter I opened
the lid and had the following message on the screen.  Hope it helps.


Feb 11 14:39:03 firefly kernel: [  253.236050] ------------[ cut here ]----=
--------
Feb 11 14:39:03 firefly kernel: [  253.236066] kernel BUG at fs/btrfs/trans=
action.c:1337!
Feb 11 14:39:03 firefly kernel: [  253.236073] invalid opcode: 0000 [#1] SM=
P
Feb 11 14:39:03 firefly kernel: [  253.236081] CPU 1
Feb 11 14:39:03 firefly kernel: [  253.236084] Modules linked in: ebtable_n=
at ebtables ppdev parport_pc ipt_MASQUERADE iptable_nat nf_nat lp parport b=
e2iscsi iscsi_boot_sysfs xt_CHECKSUM bnx2i iptable_mangle cnic uio cxgb4i c=
xgb4 bridge stp cxgb3i libcxgbi cxgb3 llc mdio ib_iser rdma_cm ib_cm iw_cm =
ib_sa ib_mad ib_core ib_addr nf_conntrack_netbios_ns iscsi_tcp libiscsi_tcp=
 libiscsi scsi_transport_iscsi nf_conntrack_broadcast nf_conntrack_ftp ip6t=
_REJECT nf_conntrack_ipv6 nf_conntrack_ipv4 nf_defrag_ipv6 nf_defrag_ipv4 i=
p6table_filter xt_state ip6_tables nf_conntrack binfmt_misc xfs snd_hda_cod=
ec_si3054 snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_hwdep =
iwlwifi snd_seq snd_seq_device uvcvideo snd_pcm mac80211 jmb38x_ms cfg80211=
 videodev media iTCO_wdt memstick usblp snd_timer snd soundcore snd_page_al=
loc i2c_i801 iTCO_vendor_support v4l2_compat_ioctl32 r8169 rfkill mii serio=
_raw microcode joydev vhost_net macvtap macvlan tun virtio_net kvm_intel nf=
sd kvm lockd nfs_acl auth_rpcgss uinput sunrpc btrfs
Feb 11 14:39:03 firefly kernel: zlib_deflate libcrc32c sdhci_pci sdhci mmc_=
core firewire_ohci firewire_core crc_itu_t nouveau ttm drm_kms_helper drm i=
2c_algo_bit i2c_core mxm_wmi wmi video [last unloaded: scsi_wait_scan]
Feb 11 14:39:03 firefly kernel: [  253.236312]
Feb 11 14:39:03 firefly kernel: [  253.236316] Pid: 2469, comm: umount Not =
tainted 3.2.5-3.fc16.x86_64 #1 System76, Inc. Serval Professional/Serval Pr=
ofessional
Feb 11 14:39:03 firefly kernel: [  253.236329] RIP: 0010:[<ffffffffa01c2f3c=
>]  [<ffffffffa01c2f3c>] btrfs_commit_transaction+0x81c/0x820 [btrfs]
Feb 11 14:39:03 firefly kernel: [  253.236355] RSP: 0018:ffff880104789d28  =
EFLAGS: 00010282
Feb 11 14:39:03 firefly kernel: [  253.236361] RAX: 00000000fffffffb RBX: f=
fff880113cf9f00 RCX: 0000000000000000
Feb 11 14:39:03 firefly kernel: [  253.236367] RDX: 0000000000000000 RSI: 0=
000000001c11000 RDI: 0000000000000000
Feb 11 14:39:03 firefly kernel: [  253.236373] RBP: ffff880104789db8 R08: 0=
000000000002000 R09: 0000000000000010
Feb 11 14:39:03 firefly kernel: [  253.236380] R10: 0000000000000000 R11: 0=
000000000000000 R12: ffff8801324ebc00
Feb 11 14:39:03 firefly kernel: [  253.236386] R13: ffff880137378f78 R14: f=
fff880113cf9f78 R15: 0000000000000000
Feb 11 14:39:03 firefly kernel: [  253.236393] FS:  00007f003c745800(0000) =
GS:ffff88013fd00000(0000) knlGS:0000000000000000
Feb 11 14:39:03 firefly kernel: [  253.236400] CS:  0010 DS: 0000 ES: 0000 =
CR0: 000000008005003b
Feb 11 14:39:03 firefly kernel: [  253.236405] CR2: 00007f4113b74000 CR3: 0=
000000103e51000 CR4: 00000000000406e0
Feb 11 14:39:03 firefly kernel: [  253.236412] DR0: 0000000000000000 DR1: 0=
000000000000000 DR2: 0000000000000000
Feb 11 14:39:03 firefly kernel: [  253.236418] DR3: 0000000000000000 DR6: 0=
0000000ffff0ff0 DR7: 0000000000000400
Feb 11 14:39:03 firefly kernel: [  253.236425] Process umount (pid: 2469, t=
hreadinfo ffff880104788000, task ffff880138b14560)
Feb 11 14:39:03 firefly kernel: [  253.236434] Stack:
Feb 11 14:39:03 firefly kernel: [  253.236437]  ffff880104789d58 0000000000=
000001 0000000000000000 ffff880138b14560
Feb 11 14:39:03 firefly kernel: [  253.236448]  ffffffff81090440 ffff880104=
789d50 ffff880104789d50 ffffffffa01c3394
Feb 11 14:39:03 firefly kernel: [  253.236459]  7fffffffffffffff 0000000032=
4eb000 ffff880104789d78 ffff8801324ebc00
Feb 11 14:39:03 firefly kernel: [  253.236470] Call Trace:
Feb 11 14:39:03 firefly kernel: [  253.236478]  [<ffffffff81090440>] ? remo=
ve_wait_queue+0x50/0x50
Feb 11 14:39:03 firefly kernel: [  253.236494]  [<ffffffffa01c3394>] ? star=
t_transaction+0x94/0x2a0 [btrfs]
Feb 11 14:39:03 firefly kernel: [  253.236508]  [<ffffffffa019e21c>] btrfs_=
sync_fs+0x6c/0xf0 [btrfs]
Feb 11 14:39:03 firefly kernel: [  253.236516]  [<ffffffff811a56b3>] __sync=
_filesystem+0x63/0x90
Feb 11 14:39:03 firefly kernel: [  253.236524]  [<ffffffff811a575b>] sync_f=
ilesystem+0x4b/0x70
Feb 11 14:39:03 firefly kernel: [  253.236531]  [<ffffffff8117ae2b>] generi=
c_shutdown_super+0x3b/0xd0
Feb 11 14:39:03 firefly kernel: [  253.236539]  [<ffffffff8117af56>] kill_a=
non_super+0x16/0x30
Feb 11 14:39:03 firefly kernel: [  253.236546]  [<ffffffff8117b30c>] deacti=
vate_locked_super+0x3c/0xa0
Feb 11 14:39:03 firefly kernel: [  253.236552]  [<ffffffff8117bd7e>] deacti=
vate_super+0x4e/0x70
Feb 11 14:39:03 firefly kernel: [  253.236559]  [<ffffffff811967d5>] mntput=
_no_expire+0xb5/0x100
Feb 11 14:39:03 firefly kernel: [  253.236566]  [<ffffffff8119755c>] sys_um=
ount+0x6c/0x350
Feb 11 14:39:03 firefly kernel: [  253.236573]  [<ffffffff81183912>] ? path=
_put+0x22/0x30
Feb 11 14:39:03 firefly kernel: [  253.236581]  [<ffffffff815e9782>] system=
_call_fastpath+0x16/0x1b
Feb 11 14:39:03 firefly kernel: [  253.236586] Code: e9 9b f9 ff ff 0f 0b 0=
f 0b 0f 0b 0f 0b 0f 0b 0f 0b be fc 04 00 00 48 c7 c7 93 60 21 a0 e8 5d ae e=
a e0 e9 4d fb ff ff 0f 0b 0f 0b <0f> 0b 66 90 55 48 89 e5 53 48 83 ec 08 66=
 66 66 66 90 48 8b 77
Feb 11 14:39:03 firefly kernel: [  253.236680] RIP  [<ffffffffa01c2f3c>] bt=
rfs_commit_transaction+0x81c/0x820 [btrfs]
Feb 11 14:39:03 firefly kernel: [  253.236698]  RSP <ffff880104789d28>
Feb 11 14:39:03 firefly kernel: [  253.296027] usb 2-4: new high-speed USB =
device number 5 using ehci_hcd
Feb 11 14:39:03 firefly kernel: [  253.301277] ---[ end trace b10e35848f70f=
893 ]---



--=20
Thanks,
        Nathan A. Mourey II

-----------------------------------------------------
Have You Ever wondered what kind of Sheep Steel wool=20
comes from?

        -- Unknown

-----------------------------------------------------
GPG ID   : 7DAA76AF
Projects : https://github.com/nmoureyii

--=-IJj6TKtBAPo/sszBCjny
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPNsniAAoJEOUCa8Z9qnavYUcP/REqkO8S/ivOkU9QdQhm+3HN
8HkQ2Eb67IbNDEz3UAfTZETGS4sWDoDDKcZVCVU+8fkgGvambljmFLP2+0exnh4n
07hAkuOHPXAbkSeUZf+6ZoH+Jh0SntmOSxz+wNjFTLz//u+vWbTc2XPHwjdNLy2W
gwU9D15Es8MIDSXxUByR51V4qZ8Rue4i0da9hzIblwzorDvIZCBhd97AxR20LA2v
HJMKbk0Cm8c8ApeSGpGMVP6OWqCUnwAjvoy77SWnuaQWj88v0jzbthJrpYEy8fc4
pkfFwQuQXv5KWMPOr59gYgcPBQBjUnOG5xtWJG4PfmfF+dCWueq/cQTtlKGrdvRA
hYKhKdYgNn21SPNgssDCsbbGiAr1qhLJzX54tQDTHlvLXj0ppGCe2rttAqHqBih2
Gqx1ofrJJz6irP1DiAoq2YaZG/d+JvEVhbScNE9AQ9UbkFKdTayZTe/wBtBBRFBO
oiEi+PKSUUVS0F6FZoo1SolMH8DMrS3XTapna0xbkCZoGxB6LIphL1MDJVg5Tr/s
1eIMq4bTLenxmibVo7FVFl24XI9hZSdBFpkpaee+XYsy1NZVcnEBAXWv8heOdub3
x0bAKZ9CqAtxmmTf44c8w3volcv+zP1GVU0eJ0XV1L3XFNTn0J38NwGB4gZmXSux
7ToXUy2nOUnA5o6cMPYt
=9VRx
-----END PGP SIGNATURE-----

--=-IJj6TKtBAPo/sszBCjny--

