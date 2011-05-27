Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1E0To2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:44:28 -0400
Received: from home.keithp.com ([63.227.221.253]:50454 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487Ab1E0To1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:44:27 -0400
From: Keith Packard <keithp@keithp.com>
To: Jason Stubbs <jasonbstubbs@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: fix regression after clock gating init split
In-Reply-To: <201105272344.20084.jasonbstubbs@gmail.com>
References: <201105272344.20084.jasonbstubbs@gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 27 May 2011 13:44:11 -0600
Message-ID: <yunaae8j5dg.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 27 May 2011 23:44:19 +1000, Jason Stubbs <jasonbstubbs@gmail.com> w=
rote:
> From: Jason Stubbs <jasonbstubbs@gmail.com>
>=20
> In revision 6067aaeadb5b3df26f27ac827256b1ef01e674f5, the function
> intel_enable_clock_gating is split up by device. drm_i915_display_funcs t=
hen
> gained a function pointer called init_clock_gating that intel_init_display
> sets to the appropriate function. However, there are some code paths, not=
ably
> IS_PINEVIEW(dev), where init_clock_gating is not set and not needed. Call=
ing
> it then fails. This patch fixes it by simply adding a null-pointer
> check.

Looks like Pineview should be using the gen3_init_clock_gating function.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN3/8LQp8BWwlsTdMRAtnTAKDYp5Atr/O36pBbr6rBzyJJI2JT+ACgsDOY
eaoih2Hkrb+ydIMliEAkQlQ=
=67/o
-----END PGP SIGNATURE-----
--=-=-=--
