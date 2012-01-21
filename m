Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab2AUU5I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 15:57:08 -0500
Received: from home.keithp.com ([63.227.221.253]:39104 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab2AUU5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 15:57:04 -0500
From: Keith Packard <keithp@keithp.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Intel HD Graphic QM57 chipset: Dell U3011 monitor turns to power saving mode
In-Reply-To: <20120121185621.GA31106@Krystal>
References: <20120121185621.GA31106@Krystal>
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 21 Jan 2012 12:57:00 -0800
Message-ID: <86ehuskc4j.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jan 2012 13:56:21 -0500, Mathieu Desnoyers <mathieu.desnoyers@ef=
ficios.com> wrote:

> Dell U3011 monitor turns to power saving mode when resolution set to 2560=
 x 1600
> (intermittent)
>=20
> Reproduced with:
> Linux 2.6.38-1-amd64 (Debian kernel)
> Linux 3.1.0-1-amd64  (Debian kernel)
> Linux 3.2.0-1-amd64  (Debian kernel)
>=20
> The computer is a Lenovo X201 Tablet (Intel QM57 chipset), on a X200
> docking station. The docking station uses a DisplayPort cable to connect
> to the monitor.  I tried upgrading my Bios from 1.34/1.13 to 1.38/1.14
> (latest), which did not fix the problem. I cannot use anything else
> than DisplayPort in this case to connect the monitor at 2560 x 1600,
> because this resolution requires either the bandwidth provided by a
> dual-link DVI (which I cannot connect in my docking station), or
> DisplayPort.

I use this same monitor, and have run it with an X200 in the past.

Can you capture a dmesg output with the kernel parameter drm.debug=3D0xe
set? That will let us see the DP link training adventure and see what's
broken. If you can, separate traces of working and non-working tries
would be nice.

And, of course, trying 3.3-rc1 would be helpful as that's what any
test patches would be developed on top of.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTxsmnDYtFsjWk68qAQjuzg/+PkF/rIf7yOHM0dhPZ0/R1ikxvAHEJr7N
pUZ8W2XbPsEHY4bC/6iGcu2NlCIjoAsNK6j+6i0gDC9DCVUbd/Z9M1z2LftgHbBM
CT/m0F76YzWhbB59Cfsbr1vmmf/92YLcgHONsn69XrTna7K2envGoNyNIyuWoJci
Z4QLaw7NObvpRoQ6ckiAbW1hB3XbXcobKyG/cGdWoDiJw+CK6WqGVjoJ3d8Iecse
+UONd9nUIV8H10HslyavxjOBU0r4XFPf7t6G8+Q4Awv/OHYhva+JUsgUgLCB3Sze
fKjURyXL/IPq5BnpMi0FSSkMvV4RQlH4f28hZOPQ0I4OYE6myMKtFRl4QwdHnCsn
oKp0uZF7JrEAT3Fl/s7mVoCZlbHOX4kfiKpZE8lA1WHT6xC1gRHKG+6/nqwy7spI
tcdjDnxw8cosFDM9jteQQXHdSaOdnxv6fn9S7nLcqLN93Lzr2Lo0H/UnM46g2Jgz
ZmE9eOaaRtssHwHG4jZw95A5pI1sYY8syqvnTjGLihvJPiaqf3WVu2OqcGZ1NVXe
uRwDLczMd3lChBCLmUw8GYcrl6Kgmr+yx28AKfE0J3JiILLmhhZQzYzWVUEUTqfe
ZuTijJpu+jE3aMuKKk525l5YQFBZevIAqtvWu6rklvxTmtnrFdk+T5jsVTcL6F47
Mo6jk6xOPw0=
=7T7Q
-----END PGP SIGNATURE-----
--=-=-=--
