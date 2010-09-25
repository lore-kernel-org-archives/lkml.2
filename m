Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab0IYP6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 11:58:51 -0400
Received: from imp03.mtu.ru ([62.5.255.20]:53168 "EHLO imp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755465Ab0IYP6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 11:58:49 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Sep 2010 11:58:48 EDT
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc
To: linux-kernel@vger.kernel.org
Subject: fs/fs-writeback.c to dump
Date: Sat, 25 Sep 2010 19:52:48 +0400
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5+; KDE/4.5.1; x86_64; ; )
X-Face: $dO4505L-bM3\Iz"(V=y.bL/75{5ys3:B[-aPBQvs*Z%fdBqFhvc85hmZN4j1kwRzwvY*R
	4	nvQ/#/+kWXH((aXWh\%mvG1V()Z0k:NwZAIu\S0d1%,nv`^
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1332973.if1GnN2117";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009251952.58749.pavel@pavlinux.ru>
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1332973.if1GnN2117
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

# uname -a=20
Linux suse64 2.6.36-rc5+ #66 SMP PREEMPT Sat Sep 25 00:47:38 MSD 2010 x86_6=
4=20
x86_64 x86_64 GNU/Linux

# git pull
Already up-to-date.=20

#gcc -v
=2E..
=2E..
gcc version 4.5.1 20100916 [gcc-4_5-branch revision 164333] (SUSE Linux)=20
=2E..

#dmesg
=2E...
=2D-----------[ cut here ]------------
WARNING: at fs/fs-writeback.c:87 __mark_inode_dirty+0x131/0x260()
Hardware name: S2895
Dirtiable inode bdi default !=3D sb bdi btrfs
Modules linked in: ipt_REJECT xt_hl xt_DSCP iptable_nat nf_nat=20
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 cpufreq_ondemand zram(C) nvid=
ia=20
evdev snd_intel8x0 snd_ac97_codec ac97_bus
Pid: 32127, comm: git Tainted: G   M    WC  2.6.36-rc5+ #66
Call Trace:
 [<ffffffff81037f3b>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff81038035>] ? warn_slowpath_fmt+0x45/0x50
 [<ffffffff810d79d1>] ? __mark_inode_dirty+0x131/0x260
 [<ffffffff810ccc4d>] ? touch_atime+0x13d/0x190
 [<ffffffff810c74af>] ? vfs_readdir+0xbf/0xd0
 [<ffffffff810c768f>] ? sys_getdents64+0x7f/0xe0
 [<ffffffff810022eb>] ? system_call_fastpath+0x16/0x1b
=2D--[ end trace fec92d861b8f03b8 ]---
=2D-----------[ cut here ]------------
WARNING: at fs/fs-writeback.c:87 __mark_inode_dirty+0x131/0x260()
Hardware name: S2895
Dirtiable inode bdi default !=3D sb bdi btrfs
Modules linked in: ipt_REJECT xt_hl xt_DSCP iptable_nat nf_nat=20
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 cpufreq_ondemand zram(C) nvid=
ia=20
evdev snd_intel8x0 snd_ac97_codec ac97_bus
Pid: 32207, comm: touch Tainted: G   M    WC  2.6.36-rc5+ #66
Call Trace:
 [<ffffffff81037f3b>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff81038035>] ? warn_slowpath_fmt+0x45/0x50
 [<ffffffff810d79d1>] ? __mark_inode_dirty+0x131/0x260
 [<ffffffff81197ce0>] ? btrfs_setattr+0x90/0x2b0
 [<ffffffff8103ca6d>] ? current_fs_time+0xd/0x50
 [<ffffffff810ce66f>] ? notify_change+0x12f/0x380
 [<ffffffff810dc49d>] ? utimes_common+0xcd/0x1d0
 [<ffffffff810dc673>] ? do_utimes+0xd3/0xf0
 [<ffffffff810dc72c>] ? sys_utimensat+0x2c/0x90
 [<ffffffff810b72af>] ? do_sys_open+0xbf/0x130
 [<ffffffff810022eb>] ? system_call_fastpath+0x16/0x1b
=2D--[ end trace fec92d861b8f03b9 ]---



--nextPart1332973.if1GnN2117
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyeGtoACgkQOqfDywN0JInSvgCeKW/ysiKhMYGictJSr6Ke08/8
nyYAoIFxsHdlbE3vdRAuDgWVtMHlALEb
=ohCL
-----END PGP SIGNATURE-----

--nextPart1332973.if1GnN2117--
