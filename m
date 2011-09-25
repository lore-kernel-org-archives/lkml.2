Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab1IYU1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 16:27:18 -0400
Received: from home.keithp.com ([63.227.221.253]:35904 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab1IYU1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 16:27:17 -0400
From: Keith Packard <keithp@keithp.com>
To: Woody Suwalski <terraluna977@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: Regression: i915 blank issue on kernel 3.1.0-rc3
In-Reply-To: <4E7F3969.2050308@gmail.com>
References: <4E7A6CED.5000501@gmail.com> <yun4o05xkgl.fsf@aiko.keithp.com> <4E7F3969.2050308@gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sun, 25 Sep 2011 13:27:13 -0700
Message-ID: <yun62kgpdum.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Sep 2011 10:23:37 -0400, Woody Suwalski <terraluna977@gmail.com>=
 wrote:

> Anyway, for Eeepc reverting the
>=20
> aaa6fd2a004147bf32fce05720938236de3361d9
>=20
> seems to be fixing the issue. Which is not of course the way we want
> to go ;-(

That's better than something broken in the middle of mode setting.

Matthew - this is your most excellent patch which adds a native
backlight mechanism. What other info do you need to help figure out how
to make it play well on other machines? We've got a handful of
regressions about backligh in the 3.1 RC series, and I'd hate to have to
revert this...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOf46hQp8BWwlsTdMRAsjhAJ0YwsjrwPUsELR/TEyJF5M2l+GccACgoFcf
6vxPjwVTLToy6r1VgRYMi5c=
=9OFA
-----END PGP SIGNATURE-----
--=-=-=--
