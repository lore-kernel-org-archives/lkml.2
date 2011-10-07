Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965361Ab1JGDy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 23:54:27 -0400
Received: from home.keithp.com ([63.227.221.253]:44931 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602Ab1JGDy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 23:54:26 -0400
From: Keith Packard <keithp@keithp.com>
To: Emmanuel Benisty <benisty.e@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [GIT BISECT] 2c1756b12edc19fdd75c833699cb752e1bbb641e - Display corruption after blank screen state
In-Reply-To: <CA+i8gK+H4Y=+ZMr9QHh-1mn0wEdhDzf4iSqUgD322UhyXoruCg@mail.gmail.com>
References: <CA+i8gK+H4Y=+ZMr9QHh-1mn0wEdhDzf4iSqUgD322UhyXoruCg@mail.gmail.com>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Thu, 06 Oct 2011 21:54:18 -0600
Message-ID: <yun4nzllamt.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Sep 2011 23:33:13 +0700, Emmanuel Benisty <benisty.e@gmail.com> w=
rote:

(I'm sorry I missed this mail; I was preoccupied with family issues
that week).

> The following commit causes display corruption once the machine goes
> out from default X server power saving blank screen state. This is
> with an i3 330m.

Can you provide more information about which display is corrupted and
what the corruption looks like?

> commit 2c1756b12edc19fdd75c833699cb752e1bbb641e
> Merge: cf96e46 d74362c
> Author: Keith Packard <keithp@keithp.com>
> Date:   Thu Jul 28 16:30:41 2011 -0700
>=20
>     Merge branch 'drm-intel-fixes' into drm-intel-next
>=20

Can you provide the output of intel_reg_dumper from both working and
non-working kernels? Reverting this merge would be a fairly substantial
challenge at this point in the release cycle, so I'd like to see if we
can't narrow things down a bit and find the actual code change at fault.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTo536jYtFsjWk68qAQiTUA//VwmtMrwrvsPm+b4RZUIzdzW5qMUCE51C
EtPQC4TvtXb+6fo5wAxfJSOU/jdngfesFoGKccd0cNhG/g+qckxeJ4AbIi4Gs9tQ
oO7wuRXr2YP4d0czpgcoj+9aDQ67or0U310oovUE5f8Qphqsaghew6pqYDOvcxoj
isBphGphJ5hWxonhjqD+tNb/DzXPOE71PUStKTsMLTJiGptr9wh5a8HckPWWloWN
shWFrbbFk9fqizYpJgH2J5Pql5XzjmNySL49YdzW5Y35xa24oC7ydMlilY7fKrzd
OQmAbNb7Kq+3Al8ky/H1xrWjZA7q1LiejaJKdF+zRy3s5LnW/wygM3E2iCjfY8el
2D1AdnAWsiYVTD7gOMCcLGTN/aIKEzeizjOwAOz3Is+EApOs+thNbT4G+hrN5Ywe
2unRIDBG+PFfTMWCBXlq10haDWR/92sEjjOC79iRQOHV9E75nnzdZKtrWrIlfNuJ
6gJRKaPFfUIrG6TUtaoCO/LVKQ4whEDT5xOnhPZeLuuF3JGSeL5CFJoM9e3qEVQz
6WlTEIvwH8R9+ctmk2BSPpmGyX7yCojctBkjiCHrj0IWnFr3ffhr8ENbz1SnM3O9
7uJYWF7HFob1CwzTJFwRLPeJnF3Vn0jodai4RRw/Wi/4H2z5WjwxSpYjtxncQEWT
r2Uesh9ZgdY=
=tEln
-----END PGP SIGNATURE-----
--=-=-=--
