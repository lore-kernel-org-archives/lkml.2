Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab1EPVeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:34:31 -0400
Received: from home.keithp.com ([63.227.221.253]:35740 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555Ab1EPVea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:34:30 -0400
From: Keith Packard <keithp@keithp.com>
To: Knut Petersen <Knut_Petersen@t-online.de>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [BUG][2.6.39-rc7]
In-Reply-To: <4DD0D4CC.9070401@t-online.de>
References: <4DD0D4CC.9070401@t-online.de>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 16 May 2011 14:34:21 -0700
Message-ID: <yunei3y1g9u.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 16 May 2011 09:39:56 +0200, Knut Petersen <Knut_Petersen@t-online.d=
e> wrote:
> Hi Chris, Linus!
>=20
> https://bugs.freedesktop.org/show_bug.cgi?id=3D36246
>=20
> is NOT fixed  in mainline (eed631e0d741d1a1067cfc6d709fdf2363126f9c)
> although it is fixed in drm-intel-staging
> (7b6685b35b69e19d6e3298706c12faf016f20117)

The fix for this bug is still under review and was not ready in time for
2.6.39. It is planned for merging in the 2.6.40 time frame, and should
be suitable for a stable backport when merged to master.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN0ZhdQp8BWwlsTdMRAj15AKDf3+1X4Iko2rvyIJ4TlIRg+Yw/dQCgtTkT
K211LhLEFmTVBHaVHT2aIFM=
=Nxap
-----END PGP SIGNATURE-----
--=-=-=--
