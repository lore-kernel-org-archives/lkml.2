Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab0DKRfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 13:35:52 -0400
Received: from k66.ru ([87.224.128.21]:28434 "EHLO k66.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab0DKRfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 13:35:47 -0400
X-Greylist: delayed 1801 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Apr 2010 13:35:46 EDT
Date: Sun, 11 Apr 2010 23:05:42 +0600
From: Andrey Rahmatullin <wrar@altlinux.org>
To: linux-kernel@vger.kernel.org
Cc: lxc-devel@lists.sourceforge.net
Subject: OOPS on lxc-stop
Message-ID: <20100411170542.GA5745@wrars-comp.wrarsdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
X-Operating-System: ALT Linux Sisyphus
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.
When I run lxc-stop for my Debian container, my system OOPSes. This is not
100% reproducible, though. I could catch only a part of the OOPS report
using netconsole:


[ 9243.740626] Oops: 0000 [#1] PREEMPT
[ 9243.740648] last sysfs file: /sys/devices/platform/w83627hf.656/fan1_inp=
ut
[ 9243.740655] Modules linked in: veth netconsole configfs cdc_acm nf_connt=
rack_ftp iptable_mangle radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core=
 vboxnetadp vboxnetflt vboxdrv w83627hf hwmon_vid aes_i586 aes_generic af_p=
acket ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt ppp_generic slh=
c sit tunnel4 bridge stp llc ipv6 via_rhine mii ipt_LOG xt_limit ipt_REJECT=
 xt_tcpudp xt_state xt_mac iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_i=
pv4 nf_conntrack iptable_filter ip_tables x_tables nls_cp1251 nls_cp866 vfa=
t fat ext3 jbd mbcache arc4 ecb rt61pci crc_itu_t rt2x00pci snd_via82xx snd=
_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_r=
awmidi snd_seq_device snd rt2x00lib sr_mod cdrom processor fan thermal mac8=
0211 thermal_sys usb_storage usb_libusual serial_core soundcore hwmon hid_a=
4tech button pata_via cfg80211 uhci_hcd eeprom_93cx6 fuse via_agp agpgart e=
vdev usbhid hid ehci_hcd usbcore nls_base dm_mod [last unloaded: nf_conntra=
ck_ftp]
[ 9243.741009]
[ 9243.741009] Pid: 22287, comm: init Not tainted 2.6.34-wrar-2 #1 KT600-82=
37/KT600-8237
[ 9243.741009] EIP: 0060:[<c011e8a2>] EFLAGS: 00210086 CPU: 0
[ 9243.741009] EIP is at set_next_entity+0xd/0x117
[ 9243.741009] EAX: eeb050c0 EBX: 00000000 ECX: 00000000 EDX: 00000000
[ 9243.741009] ESI: eeb050c0 EDI: c04734ac EBP: ed625df4 ESP: ed625de4
[ 9243.741009]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 9243.741009] Process init (pid: 22287, ti=3Ded625000 task=3Df36818c0 task=
=2Eti=3Ded625000)
[ 9243.741009] Stack:

This is 2.6.34-rc2, though I IIRC I had these crashes on .33 too.

--=20
WBR, wRAR (ALT Linux Team)

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJLwgFmAAoJEOih81koZvPBdoMH/2cpRQCWtJpRKdZJqYBfwSEB
l4CYelBsjDIDVkdTor4LZ4rlIJOezq46Nv5ggZ3desqR5sd4elKpdlfwsCBC0BqO
S8/PM4yxJiTc735EU96umaPgTbm5WgY0YwSsLGbCc5tGvGGuxIVZNFPjTyd9pWpT
W/W8jmNzfnAscnTaZcDmlobpYHKbyjj3jvCwPqiDJNwsNuclcqe/vQLXxPMDWoAW
KC1YsxQXRVP44wUd6bJ3Gys5khKRmqJFiyy+ncIILEr4Rj4LRluZrMBFDLoFhojR
ywzxfE8BKHQLnZF9LUjdGBPgk5oUmhsQBHIJ7NLPgozt7bVREWe16P8IDBYd4Ds=
=hP4y
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
