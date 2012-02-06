Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab2BFWKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:10:25 -0500
Received: from home.keithp.com ([63.227.221.253]:49151 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab2BFWKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:10:24 -0500
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@gmail.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: Force explicit bpp selection for intel_dp_link_required
In-Reply-To: <CAPM=9tyg6Ju8qi+Qy0XP-23wApGA3+12jDfd7KQRoZ_bqSH=4g@mail.gmail.com>
References: <1327508186-26704-1-git-send-email-keithp@keithp.com> <1327508186-26704-2-git-send-email-keithp@keithp.com> <20120127103010.GB3901@phenom.ffwll.local> <CAPM=9tyg6Ju8qi+Qy0XP-23wApGA3+12jDfd7KQRoZ_bqSH=4g@mail.gmail.com>
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: Daniel Vetter <daniel@ffwll.ch>
Date: Mon, 06 Feb 2012 14:10:21 -0800
Message-ID: <86ty33boky.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Feb 2012 12:12:16 +0000, Dave Airlie <airlied@gmail.com> wrote:

> Please get this into -fixes and too me asap.

It's in -fixes; will be on its way to you soon.

This patch is sufficient to make machines work again; the second patch
serves to improve things a bit, and (as such) should probably wait in
drm-intel-next for another release.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTzBPzTYtFsjWk68qAQhcSBAAoT4TdP3UiLknS4IQl23g0FjGEZhy2xrk
uZhGw2fej7EUvMYMb7GK50r8mFaJKA9MvRLBsvYy3mboB+bU6us7F2MgyQ42QgVn
C91+XZoTIP3qv1cwx87YLU5kKJqrlQ3KbJUtgWs7MA6B0sumCm3o5fyKxfPhOROR
EqkKX6pS5IEgtpeFgOhxyqNHAi3r5KWyw5OLZ0r407V5/1taDVg+pkkjDFGt54jK
FU1zCdHLgd0wJoaUIPsLkO3ElS+WSdrSeyQF81BYN1oqruVbqHgw73zZ3ZzSHQXb
i5ljzJS39hKE0vB9TLNhWzKo3lFMX8oau7zU0dbiVIMmEODUTWjFHebGtewx1Sg/
ghsr9IMdxrofM+7rK7KyPubiF76WT/H3J2pubMSCq9fxQ2OQ5rKs+wNhAScRYO2k
9pfGRWfCgvf01i5kL6SK/AJhv6Jvqpp5grgVWvBRIjto/L2kU4pdQjMChT+w7W71
6zHs0FyrEi6t/ycwKfN/+i/8qCr+vcDMIGU0CkmGM0FAVffGwpYqx2M5RJDVLJnJ
+8LXFGloR3W84zuEt4dwBvevZYVjZhn2XnPX0u9GsofocWMxVnzUNaR03LfGeFzu
czTHoEUXSf24swd1zbLJLks6qU0SKw+gQ6nWuHKyHlYEczHqiJpulAqUoIu79oBO
kWM2FKKmrp8=
=Kaxi
-----END PGP SIGNATURE-----
--=-=-=--
