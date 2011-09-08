Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab1IHDuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 23:50:24 -0400
Received: from home.keithp.com ([63.227.221.253]:54050 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163Ab1IHDuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 23:50:23 -0400
From: Keith Packard <keithp@keithp.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org
Subject: Re: [Intel-gfx] kernel BUG at drivers/gpu/drm/i915/i915_gem.c:3459
In-Reply-To: <CAJJYPd=g9LYqH3OCVA674=aTF2qJSZHzgqBck1nJ_WpqVV4iAw@mail.gmail.com>
References: <CAJJYPd=g9LYqH3OCVA674=aTF2qJSZHzgqBck1nJ_WpqVV4iAw@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 07 Sep 2011 20:50:18 -0700
Message-ID: <yunfwk7d75x.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Sep 2011 22:50:02 +0200, Zdenek Kabelac <zdenek.kabelac@gmail.com=
> wrote:
> Hi
>=20
> This happened to today probably in the moment, LCD was turned off by
> Xserver as a screenblank
> My hw is Lenovo T61  4GB, intel driver.

Can you describe what your desktop software environment looks like? Are
you running mutter, or compiz or some other compositing window manager?
Were you running a full-screen game? In other words, could you have been
hitting the page-flipping paths with a full-screen 3D application?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOaDt6Qp8BWwlsTdMRAuCSAJ9Q62MiDAbF99pq0Pp021o6lrZfzACeJtJi
tHQNK7Z9Y1m/Dmg4HyffRaQ=
=UEl4
-----END PGP SIGNATURE-----
--=-=-=--
