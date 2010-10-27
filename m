Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760547Ab0J0AAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:00:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58122 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab0J0AAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:00:49 -0400
Date: Wed, 27 Oct 2010 11:00:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build warning from Linus' tree
Message-Id: <20101027110038.9f2ca56a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_Oct_2010_11_00_38_+1100_svuGtmATILk0pScz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Oct_2010_11_00_38_+1100_svuGtmATILk0pScz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

While building Linus' tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/char/pcmcia/synclink_cs.c:2194: warning: 'mgslpc_get_icount' define=
d but not used

Introduced by commit 0587102cf9f427c185bfdeb2cef41e13ee0264b1 ("tty:
icount changeover for other main devices").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__27_Oct_2010_11_00_38_+1100_svuGtmATILk0pScz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMx2umAAoJEDMEi1NhKgbsQ3UIAI59bXZhn4AeSyhr4LCH0647
kXVH8uK7UfHK/fAqGTP3sSAic4Xnl4DDAlcaLKVP6MhqzIhDh93Dld89He8DNFlz
/sNB+XoNVVnNKDgxBNaR9zwnfWgWxybb83nrnN19EW2+auRiX4ydy4sHVBrBlLD1
vvAtibbYzXqhfaBR7s+ss/VSfY6fKOI8lFKKrj27wSgDY0xI7860UyAysCzji2Uv
qmDTLtrK3dZX2o4boPbZlILW6VDcERcio9vhW3dMnyYNAQeNNSHH/99vrDUtDr8L
4HPDMJtbAC3jcsq6J1W1QbyHdh/MihWiCnsY2eoaiEptNWdubGEw0GaZYZtYkdo=
=3mq4
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Oct_2010_11_00_38_+1100_svuGtmATILk0pScz--
