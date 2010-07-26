Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab0GZUxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:53:15 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:38168 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0GZUxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:53:14 -0400
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm-intel fixes since 2.6.35-rc4
In-Reply-To: <AANLkTi=T90D3KNpsVCkyLgEQK4XZ2D6YA6U7pjFNdCUK@mail.gmail.com>
References: <87eieqf453.fsf@pollan.anholt.net> <AANLkTi=T90D3KNpsVCkyLgEQK4XZ2D6YA6U7pjFNdCUK@mail.gmail.com>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.2.1 (i486-pc-linux-gnu)
Date: Mon, 26 Jul 2010 13:53:09 -0700
Message-ID: <87mxteezii.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Jul 2010 13:19:14 -0700, Linus Torvalds <torvalds@linux-foundati=
on.org> wrote:
> On Mon, Jul 26, 2010 at 12:13 PM, Eric Anholt <eric@anholt.net> wrote:
> > The following changes since commit 815c4163b6c8ebf8152f42b0a5fd015cfdce=
dc78:
> >
> > =C2=A0Linux 2.6.35-rc4 (2010-07-04 20:22:50 -0700)
> >
> > are available in the git repository at:
> > =C2=A0git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel fo=
r-linus
>=20
> Hmm. This seems to introduce a new warning:
>=20
>   drivers/gpu/drm/i915/intel_dp.c:744: warning:
> =E2=80=98ironlake_edp_panel_off=E2=80=99 defined but not used
>=20
> when I pulled it.
>=20
> And the warning appears to be due to a real bug: instead of calling
> ironlake_edp_panel_off(), the code calls ironlake_edp_backlight_off()
> twice. I assume that the _intention_ was to call both the backlight
> and panel "off" routines, rather than making doubly sure that just the
> backlight is off by turning it off twice.
>=20
> Tssk, tssk. Sadly, I noticed this too late, so now it's pulled and pushed=
 out.

And I managed to botch that while hand-resolving the patch that was sent
against the wrong tree instead of bouncing it.  I'm going to be more
strict on that in the future.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxN9bYACgkQHUdvYGzw6vchSwCfehP1Rp4O2dEbzeEIziG1GyNZ
SeoAn3Kgw9P7bLcygsQjGbHo1lpt+UQ7
=NZqj
-----END PGP SIGNATURE-----
--=-=-=--
