Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0DSAMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 20:12:48 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:50261 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab0DSAMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 20:12:47 -0400
From: Eric Anholt <eric@anholt.net>
To: Karsten Wiese <fzuuzf@googlemail.com>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC PATCH] drm/i915: Don't touch PORT_HOTPLUG_EN in
 intel_dp_detect()
In-Reply-To: <201003272248.34294.fzuuzf@googlemail.com>
References: <201003272248.34294.fzuuzf@googlemail.com>
Date: Sun, 18 Apr 2010 17:12:43 -0700
Message-ID: <87d3xw2tc4.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 27 Mar 2010 22:48:33 +0100, Karsten Wiese <fzuuzf@googlemail.com> w=
rote:
> PORT_HOTPLUG_EN has allready been setup in i915_driver_irq_postinstall(),
> when intel_dp_detect() runs.
>=20
> Delete the DP[BCD]_HOTPLUG_INT_EN defines, they are not referenced anymor=
e.
>=20
> I found this while searching for a fix for
>         https://bugzilla.redhat.com/show_bug.cgi?id=3D528312
>=20
> Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>

Applied to -next, minus the removal of the bits from the header which
seem harmless and informative.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvLn/sACgkQHUdvYGzw6vfWGQCglGH5/82Ca9T6fbxnbIT/ZElj
98AAn0+fXnPMdEB4v5OacPIVNYmblc+v
=yyJL
-----END PGP SIGNATURE-----
--=-=-=--
