Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab0GZSX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 14:23:28 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:45334 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab0GZSX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 14:23:27 -0400
From: Eric Anholt <eric@anholt.net>
To: tim.gardner@canonical.com, airlied@linux.ie
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <kees.cook@canonical.com>, chris@chris-wilson.co.uk,
        jbarnes@virtuousgeek.org
Subject: Re: i915 boot regression on Q35 chipset with 2.6.35-rc4
In-Reply-To: <4C378B32.9060802@canonical.com>
References: <4C378B32.9060802@canonical.com>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Mon, 26 Jul 2010 11:23:23 -0700
Message-ID: <87wrsiw19g.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 09 Jul 2010 14:48:50 -0600, Tim Gardner <tim.gardner@canonical.com>=
 wrote:
> Dave,
>=20
> Please find attached a patch that fixes a boot time regression caused by=
=20
> commit f1befe71fa7a79ab733011b045639d8d809924ad. It has been reported to=
=20
> fix at least one user's boot problems.
>=20
> I think it is also likely the source of the problems reported in=20
> http://marc.info/?l=3Dlinux-kernel&m=3D127869783002454&w=3D2

Applied to for-linus.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxN0psACgkQHUdvYGzw6veaCgCdEgSDCBQiYkSugN2CnEzpRfIR
LEkAoJtOG/lf6cbNY4+ezhFVXAigfHnL
=o6a/
-----END PGP SIGNATURE-----
--=-=-=--
