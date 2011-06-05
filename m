Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1FEGWf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 02:22:35 -0400
Received: from home.keithp.com ([63.227.221.253]:60249 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1FEGWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 02:22:34 -0400
From: Keith Packard <keithp@keithp.com>
To: Scott Ashcroft <scott.ashcroft@talk21.com>, jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops in i915 intel_init_clock_gating
In-Reply-To: <327832.31822.qm@web87014.mail.ird.yahoo.com>
References: <327832.31822.qm@web87014.mail.ird.yahoo.com>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 04 Jun 2011 23:22:31 -0700
Message-ID: <yunboycol08.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 5 Jun 2011 01:02:35 +0100 (BST), Scott Ashcroft <scott.ashcroft@tal=
k21.com> wrote:
> Looks like the following commit:
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dco=
mmit;h=3D6067aaeadb5b3df26f27ac827256b1ef01e674f5
>=20
>=20
> didn't cope with the pineview case so dev_priv->display.init_clock_gating=
 is=20
> NULL causing an Oops.
>=20
> The old code didn't seem to do anything for pineview so I wrapped the cal=
l with=20
> a simple NULL check but I'm not sure if that's the correct fix.

A fix is on its way to master through drm:

95e0ee92d3a605de75a633dd2360700595d5a8ad

    drm/i915: fix regression after clock gating init split
=20=20=20=20
    During the refactoring in revision 6067aaeadb5b3df26f27ac827256b1ef01e6=
74f5,
    the intel_enable_clock_gating was split up into several functions that =
are
    then called indirectly. However, which function to call was not specifi=
ed for
    the IS_PINEVIEW() case. This patch specifies the correct gating functio=
n.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN6yCnQp8BWwlsTdMRAoStAJwPw/LDgDhQWg/zgBDtJg0GkP7/5gCgieSg
MJb5a/cm5y/ryOkl+08eXO0=
=Bv8p
-----END PGP SIGNATURE-----
--=-=-=--
