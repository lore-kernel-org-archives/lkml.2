Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612Ab2KAO0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:26:01 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:42576 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761388Ab2KAO0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:26:00 -0400
Date: Thu, 1 Nov 2012 15:23:25 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: BUG: enabling psacct breaks fsfreeze
Message-ID: <20121101142325.GD20752@pcnci.linuxbox.cz>
References: <20121023094351.GC27919@pcnci.linuxbox.cz>
 <20121031121517.GD18424@quack.suse.cz>
 <20121031124600.GM20752@pcnci.linuxbox.cz>
 <20121101093723.GC6584@quack.suse.cz>
 <20121101111957.GD6584@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jYUWvSWTDpDT74zJ"
Content-Disposition: inline
In-Reply-To: <20121101111957.GD6584@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 7972265 records (last update: 20121101)
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jYUWvSWTDpDT74zJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

here it goes:

Nov  1 14:23:25 vmnci22 [ 1075.178123] SysRq : Show Blocked State
Nov  1 14:23:25 vmnci22 [ 1075.180555]   task                        PC sta=
ck   pid father
Nov  1 14:23:25 vmnci22 [ 1075.180592] fsfreeze      D 0000000000000000    =
 0  4215   4195 0x00000000
Nov  1 14:23:25 vmnci22 [ 1075.180599]  ffff8800090b9b28 0000000000000046 0=
000000000000000 ffffffff00000000
Nov  1 14:23:25 vmnci22 [ 1075.180606]  0000000000013780 ffff8800090b9fd8 f=
fff88000f716170 ffff88000f715e80
Nov  1 14:23:25 vmnci22 [ 1075.180612]  ffff88000f715dc0 ffffffff81566080 f=
fff88000f716170 000000010002f405
Nov  1 14:23:25 vmnci22 [ 1075.180619] Call Trace:
Nov  1 14:23:25 vmnci22 [ 1075.180693]  [<ffffffff810e2dbb>] __generic_file=
_aio_write+0xbb/0x420
Nov  1 14:23:25 vmnci22 [ 1075.180729]  [<ffffffff81079290>] ? autoremove_w=
ake_function+0x0/0x40
Nov  1 14:23:25 vmnci22 [ 1075.180736]  [<ffffffff810e317f>] generic_file_a=
io_write+0x5f/0xc0

I obtained it using networked syslog, so it shouldn't be truncated..


--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--jYUWvSWTDpDT74zJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlCShd0ACgkQ3xdJJrLygV7mVQCeN6VsePgRg6WdUJcCldfBr6qn
16IAnROZAO2s9LTP1upCPrzR+fNIGGhN
=wpKQ
-----END PGP SIGNATURE-----

--jYUWvSWTDpDT74zJ--
