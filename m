Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2BPVtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 16:49:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24291 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab2BPVtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:49:03 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=+gq+4NyxY4ats0t5moOB4g==:17 a=IPNGiyvqhlIA:10 a=wBbpsoFzC7RdDPdcjmMA:9 a=2iTOCR5_srSUlTaemx8A:7 a=QEXdDO2ut3YA:10 a=wxnO6ifex_hkg-L8:21 a=6XCabchNLG-nPo_b:21 a=hhP8bErPdFiY93KqNJEA:9 a=+gq+4NyxY4ats0t5moOB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.69.206.42
Message-ID: <1329428930.6062.4.camel@firefly>
Subject: Re: Kernel bug with btrfs on laptop with external hd and suspend
 and resume.
From: "Nathan A. Mourey II" <nmoureyii@ne.rr.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-fsdevel@vger.kernel.org
Date: Thu, 16 Feb 2012 16:48:50 -0500
In-Reply-To: <20120213144107.GC1573@shiny>
References: <1328990690.2464.6.camel@firefly>
	 <4F391B83.7080703@linux.vnet.ibm.com> <20120213144107.GC1573@shiny>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-vLdBDw9iQeghUasWLKj5"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vLdBDw9iQeghUasWLKj5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I booted up my laptop with my eSATA drives attached and mounted.  I then
closed the lid without logging in.  It then when to sleep mode.  I was
wrong in my first post about the computer suspending.  It didn't suspend
to disk, as I would have noticed the hd light.  The drives where not
unplugged at any time.  It looks like the problem occurred when trying
to stop the disks.  I was able to do a hard reboot and the disk came up
fine.  Once again I hope that this helps.


Feb 14 14:46:39 firefly kernel: [   96.374559] Restarting tasks ...
Feb 14 14:46:39 firefly kernel: [   96.375986] XFS (sdb1): xfs_do_force_shu=
tdown(0x1) called from line 1033 of file fs/xfs/xfs_buf.c.  Return address =
=3D 0xffffffffa05f18ba
Feb 14 14:46:39 firefly kernel: [   96.375993] XFS (sdb1): I/O Error Detect=
ed. Shutting down filesystem
Feb 14 14:46:39 firefly kernel: [   96.376017] XFS (sdb1): Please umount th=
e filesystem and rectify the problem(s)
Feb 14 14:46:39 firefly kernel: [   96.384244] sd 4:0:0:0: [sdb] Synchroniz=
ing SCSI cache
Feb 14 14:46:39 firefly kernel: [   96.384280] sd 4:0:0:0: [sdb]  Result: h=
ostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Feb 14 14:46:39 firefly kernel: [   96.384284] sd 4:0:0:0: [sdb] Stopping d=
isk
Feb 14 14:46:39 firefly kernel: [   96.384291] sd 4:0:0:0: [sdb] START_STOP=
 FAILED
Feb 14 14:46:39 firefly kernel: [   96.384293] sd 4:0:0:0: [sdb]  Result: h=
ostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Feb 14 14:46:39 firefly kernel: [   96.384318] ata5.01: detaching (SCSI 4:1=
:0:0)
Feb 14 14:46:39 firefly kernel: [   96.385322] sd 4:1:0:0: [sdc] Synchroniz=
ing SCSI cache
Feb 14 14:46:39 firefly kernel: [   96.385349] sd 4:1:0:0: [sdc]  Result: h=
ostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Feb 14 14:46:39 firefly kernel: [   96.385352] sd 4:1:0:0: [sdc] Stopping d=
isk
Feb 14 14:46:39 firefly kernel: [   96.385359] sd 4:1:0:0: [sdc] START_STOP=
 FAILED
Feb 14 14:46:39 firefly kernel: [   96.385361] sd 4:1:0:0: [sdc]  Result: h=
ostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
Feb 14 14:46:39 firefly dbus-daemon[1287]: ** Message: No devices in use, e=
xit
Feb 14 14:46:39 firefly kernel: [   96.385496] done.
Feb 14 14:46:39 firefly kernel: [   96.508182] video LNXVIDEO:00: Restoring=
 backlight state
Feb 14 14:46:39 firefly dbus-daemon[1287]: dbus[1287]: [system] Activating =
service name=3D'org.freedesktop.PackageKit' (using servicehelper)
Feb 14 14:46:39 firefly dbus[1287]: [system] Activating service name=3D'org=
.freedesktop.PackageKit' (using servicehelper)
Feb 14 14:46:39 firefly kernel: [   96.637185] XFS (sdb1): xfs_log_force: e=
rror 5 returned.
Feb 14 14:46:39 firefly kernel: [   96.637191] XFS (sdb1): xfs_do_force_shu=
tdown(0x1) called from line 1033 of file fs/xfs/xfs_buf.c.  Return address =
=3D 0xffffffffa05f18ba
Feb 14 14:46:39 firefly kernel: [   96.637205] XFS (sdb1): xfs_log_force: e=
rror 5 returned.
Feb 14 14:46:39 firefly kernel: [   96.637212] XFS (sdb1): xfs_log_force: e=
rror 5 returned.
Feb 14 14:46:39 firefly kernel: [   96.638544] ------------[ cut here ]----=
--------
Feb 14 14:46:39 firefly kernel: [   96.638796] kernel BUG at fs/btrfs/trans=
action.c:1337!
Feb 14 14:46:39 firefly kernel: [   96.639014] invalid opcode: 0000 [#1] SM=
P
Feb 14 14:46:39 firefly kernel: [   96.639014] CPU 1
Feb 14 14:46:39 firefly kernel: [   96.639014] Modules linked in: ppdev par=
port_pc lp parport ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat x=
t_CHECKSUM iptable_mangle bridge stp llc be2iscsi iscsi_boot_sysfs bnx2i cn=
ic uio cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm =
ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport=
_iscsi ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tab=
les nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ftp nf_conn=
track_ipv4 nf_defrag_ipv4 xt_state nf_conntrack binfmt_misc xfs arc4 snd_hd=
a_codec_si3054 uvcvideo snd_hda_codec_realtek videodev snd_hda_intel snd_hd=
a_codec microcode media v4l2_compat_ioctl32 usblp snd_hwdep snd_seq snd_seq=
_device snd_pcm snd_timer snd soundcore joydev iwlwifi mac80211 cfg80211 rf=
kill jmb38x_ms iTCO_wdt iTCO_vendor_support snd_page_alloc i2c_i801 serio_r=
aw r8169 mii memstick vhost_net macvtap macvlan tun virtio_net kvm_intel kv=
m uinput nfsd lockd nfs_acl auth_rpcgss sunrpc btrfs
Feb 14 14:46:39 firefly kernel: zlib_deflate libcrc32c firewire_ohci sdhci_=
pci sdhci firewire_core crc_itu_t mmc_core nouveau ttm drm_kms_helper drm i=
2c_algo_bit i2c_core mxm_wmi wmi video [last unloaded: scsi_wait_scan]
Feb 14 14:46:39 firefly kernel: [   96.639014]
Feb 14 14:46:39 firefly kernel: [   96.639014] Pid: 2360, comm: umount Not =
tainted 3.2.5-3.fc16.x86_64 #1 System76, Inc. Serval Professional/Serval Pr=
ofessional
Feb 14 14:46:39 firefly kernel: [   96.639014] RIP: 0010:[<ffffffffa01c6f3c=
>]  [<ffffffffa01c6f3c>] btrfs_commit_transaction+0x81c/0x820 [btrfs]
Feb 14 14:46:39 firefly kernel: [   96.639014] RSP: 0018:ffff88011bd45d28  =
EFLAGS: 00010282
Feb 14 14:46:39 firefly kernel: [   96.648131] RAX: 00000000fffffffb RBX: f=
fff88011395ef00 RCX: 0000000000000000
Feb 14 14:46:39 firefly kernel: [   96.648131] RDX: 0000000000000000 RSI: 0=
000000001c67000 RDI: 0000000000000000
Feb 14 14:46:39 firefly kernel: [   96.648131] RBP: ffff88011bd45db8 R08: 0=
000000000002000 R09: 0000000000000010
Feb 14 14:46:39 firefly kernel: [   96.648131] R10: 0000000000000000 R11: 0=
000000000000000 R12: ffff88012fd48800
Feb 14 14:46:39 firefly kernel: [   96.648131] R13: ffff88011395df78 R14: f=
fff88011395ef78 R15: 0000000000000000
Feb 14 14:46:39 firefly kernel: [   96.648131] FS:  00007ffcd6272800(0000) =
GS:ffff88013fd00000(0000) knlGS:0000000000000000
Feb 14 14:46:39 firefly kernel: [   96.648131] CS:  0010 DS: 0000 ES: 0000 =
CR0: 000000008005003b
Feb 14 14:46:39 firefly kernel: [   96.648131] CR2: 00007f1f50094a90 CR3: 0=
00000011bc6a000 CR4: 00000000000406e0
Feb 14 14:46:39 firefly kernel: [   96.648131] DR0: 0000000000000000 DR1: 0=
000000000000000 DR2: 0000000000000000
Feb 14 14:46:39 firefly kernel: [   96.648131] DR3: 0000000000000000 DR6: 0=
0000000ffff0ff0 DR7: 0000000000000400
Feb 14 14:46:39 firefly kernel: [   96.648131] Process umount (pid: 2360, t=
hreadinfo ffff88011bd44000, task ffff880109cb8000)
Feb 14 14:46:39 firefly kernel: [   96.648131] Stack:
Feb 14 14:46:39 firefly kernel: [   96.648131]  ffff88011bd45d58 0000000000=
000001 0000000000000000 ffff880109cb8000
Feb 14 14:46:39 firefly kernel: [   96.648131]  ffffffff81090440 ffff88011b=
d45d50 ffff88011bd45d50 ffffffffa01c7394
Feb 14 14:46:39 firefly kernel: [   96.648131]  7fffffffffffffff 0000000035=
684400 ffff88011bd45d78 ffff88012fd48800
Feb 14 14:46:39 firefly kernel: [   96.648131] Call Trace:
Feb 14 14:46:39 firefly kernel: [   96.648131]  [<ffffffff81090440>] ? remo=
ve_wait_queue+0x50/0x50
Feb 14 14:46:39 firefly kernel: [   96.648131]  [<ffffffffa01c7394>] ? star=
t_transaction+0x94/0x2a0 [btrfs]
Feb 14 14:46:39 firefly kernel: [   96.648131]  [<ffffffffa01a221c>] btrfs_=
sync_fs+0x6c/0xf0 [btrfs]
Feb 14 14:46:39 firefly kernel: [   96.648131]  [<ffffffff811a56b3>] __sync=
_filesystem+0x63/0x90
Feb 14 14:46:39 firefly kernel: [   96.648131]  [<ffffffff811a575b>] sync_f=
ilesystem+0x4b/0x70
Feb 14 14:46:39 firefly kernel: [   96.648131]  [<ffffffff8117ae2b>] generi=
c_shutdown_super+0x3b/0xd0
Feb 14 14:46:39 firefly kernel: [   96.648131]  [<ffffffff8117af56>] kill_a=
non_super+0x16/0x30
Feb 14 14:46:39 firefly kernel: [   96.648131]  [<ffffffff8117b30c>] deacti=
vate_locked_super+0x3c/0xa0
Feb 14 14:46:39 firefly kernel: [   96.648131]  [<ffffffff8117bd7e>] deacti=
vate_super+0x4e/0x70
Feb 14 14:46:39 firefly kernel: [   96.648131]  [<ffffffff811967d5>] mntput=
_no_expire+0xb5/0x100
Feb 14 14:46:39 firefly kernel: [   96.648131]  [<ffffffff8119755c>] sys_um=
ount+0x6c/0x350
Feb 14 14:46:39 firefly kernel: [   96.648131]  [<ffffffff81183912>] ? path=
_put+0x22/0x30
Feb 14 14:46:39 firefly kernel: [   96.648131]  [<ffffffff815e9782>] system=
_call_fastpath+0x16/0x1b
Feb 14 14:46:39 firefly kernel: [   96.648131] Code: e9 9b f9 ff ff 0f 0b 0=
f 0b 0f 0b 0f 0b 0f 0b 0f 0b be fc 04 00 00 48 c7 c7 93 a0 21 a0 e8 5d 6e e=
a e0 e9 4d fb ff ff 0f 0b 0f 0b <0f> 0b 66 90 55 48 89 e5 53 48 83 ec 08 66=
 66 66 66 90 48 8b 77
Feb 14 14:46:39 firefly kernel: [   96.648131] RIP  [<ffffffffa01c6f3c>] bt=
rfs_commit_transaction+0x81c/0x820 [btrfs]
Feb 14 14:46:39 firefly kernel: [   96.648131]  RSP <ffff88011bd45d28>
Feb 14 14:46:39 firefly systemd[1]: Unit build.mount entered failed state.
Feb 14 14:46:39 firefly dbus[1287]: [system] Successfully activated service=
 'org.freedesktop.PackageKit'
Feb 14 14:46:39 firefly dbus-daemon[1287]: dbus[1287]: [system] Successfull=
y activated service 'org.freedesktop.PackageKit'
Feb 14 14:46:40 firefly kernel: [   97.346410] iwlwifi 0000:06:00.0: L1 Dis=
abled; Enabling L0S
Feb 14 14:46:40 firefly kernel: [   97.349434] iwlwifi 0000:06:00.0: Radio =
type=3D0x0-0x2-0x0
Feb 14 14:46:40 firefly NetworkManager[1208]: <info> wake requested (sleepi=
ng: yes  enabled: yes)
Feb 14 14:46:40 firefly NetworkManager[1208]: <info> waking up and re-enabl=
ing...
Feb 14 14:46:40 firefly NetworkManager[1208]: <info> WWAN now enabled by ma=
nagement service
Feb 14 14:46:40 firefly NetworkManager[1208]: <info> (wlan0): now managed
Feb 14 14:46:40 firefly NetworkManager[1208]: <info> (wlan0): device state =
change: unmanaged -> unavailable (reason 'managed') [10 20 2]
Feb 14 14:46:40 firefly NetworkManager[1208]: <info> (wlan0): bringing up d=
evice.
Feb 14 14:46:40 firefly NetworkManager[1208]: NetworkManager[1208]: <info> =
wake requested (sleeping: yes  enabled: yes)
Feb 14 14:46:40 firefly NetworkManager[1208]: NetworkManager[1208]: <info> =
waking up and re-enabling...
Feb 14 14:46:40 firefly NetworkManager[1208]: NetworkManager[1208]: <info> =
WWAN now enabled by management service
Feb 14 14:46:40 firefly NetworkManager[1208]: NetworkManager[1208]: <info> =
(wlan0): now managed
Feb 14 14:46:40 firefly NetworkManager[1208]: NetworkManager[1208]: <info> =
(wlan0): device state change: unmanaged -> unavailable (reason 'managed') [=
10 20 2]
Feb 14 14:46:40 firefly NetworkManager[1208]: NetworkManager[1208]: <info> =
(wlan0): bringing up device.


On Mon, 2012-02-13 at 09:41 -0500, Chris Mason wrote:
> On Mon, Feb 13, 2012 at 07:47:39PM +0530, Srivatsa S. Bhat wrote:
> > Adding some Cc's.
> >=20
> > On 02/12/2012 01:34 AM, Nathan A. Mourey II wrote:
> >=20
> > > I just installed the new kernel with yum update.  I have an external =
eSATA hard drive that is=20
> > > formatted with btrfs.  I closed the lid once it had booted up, I had =
not logged in yet.  Latter I opened
> > > the lid and had the following message on the screen.  Hope it helps.
> > >=20
> > >=20
> > > Feb 11 14:39:03 firefly kernel: [  253.236050] ------------[ cut here=
 ]------------
> > > Feb 11 14:39:03 firefly kernel: [  253.236066] kernel BUG at fs/btrfs=
/transaction.c:1337!
>=20
> This crash corresponds to:
>=20
>         ret =3D btrfs_write_and_wait_transaction(trans, root);
>         BUG_ON(ret);
>=20
> Which basically means we were not able to write all the metadata for the
> transaction (EIO during writeback).  Do other messages from the kernel
> tell you if the crash happened before or after the suspend?
>=20
> What happened when the machine rebooted?
>=20
> Since the drive is external, I'm going to guess this is related to the
> device going away at the wrong time.  Was it plugged in the whole time?
>=20
> -chris

--=-vLdBDw9iQeghUasWLKj5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPPXnCAAoJEOUCa8Z9qnavNqcP+gNXiH4pYOUoxNiPNfm+xUPy
DvENVCa5NrBx+kUFahyqJxivhuVld3OKgaBuc9kCWLQYUxNzvvoonFuUZk5iPNtK
qCyDiIjwwQJHBq3HdH5KcDpkrtWiNDv8BvkkJfCW1tpR9RUo3xpMEGzdMdTfJJLb
EDhr9+o/soK8Yn9dLMUj08XY4JtSXZ8W5KOaeYY6I8SCV0oMrbdTZt4KXk7d68L8
B7n9mad2dYG7K07m9limmc08mb0DsqaDxT0/8upG9yUj0CJBCbAZjadLTCGoP7I4
OQNVNZFcHaoPMpe2gn79nWiEapUYu0qPEwLf/L9JwXiX5MFa/3JXZoI4m4r0scbr
u3fTUOlMon/hSOUIBVVG8Ydp28sPLAwohORgg7J3U2iinlKjVR9nTOdTcC58XZXf
f7oIOL7v8GGFOKPNmlFH0yi3WGeCtHZ4OKDsdm/apx0LAFqkcHxGai/XK49DYsr6
AP6hYgzd4qXerkW3/P/p9d7t/roApEvyXZcIjNvL1bWPJD5XF+Qz3UcPbjr9w1h+
TIzxn0q1z3z3P7iyT/rc/dF3+aGU3JkuCkdllDv6Vke4VQeq87pKDgeGG/ZOXvYt
V5aBJ7Z4lgnOmTr4KRSifxzdXDgxBH8maBq0NrGA79fTfOkPs9sOdrENtRravQto
5H5XDGDAJVadmFOqTZRM
=rh3T
-----END PGP SIGNATURE-----

--=-vLdBDw9iQeghUasWLKj5--

