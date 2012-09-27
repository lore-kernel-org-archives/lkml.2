Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab2I0H04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:26:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46911 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab2I0H0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:26:53 -0400
Date: Thu, 27 Sep 2012 17:26:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20120927172644.2b11bcd63ab35b5664126a0c@canb.auug.org.au>
In-Reply-To: <20120926133335.b012417e.akpm@linux-foundation.org>
References: <20120926160127.c34cb6d3e5dcc9ab32e8b573@canb.auug.org.au>
	<CAGXu5jJJPLXP1cjtWAwHNmYQ6ZxtVu=Oo6vh=NkowzT+26RWPg@mail.gmail.com>
	<20120926133335.b012417e.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Sep_2012_17_26_44_+1000_ARXb6PIvutS1Wgoy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Sep_2012_17_26_44_+1000_ARXb6PIvutS1Wgoy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 26 Sep 2012 13:33:35 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Wed, 26 Sep 2012 13:15:58 -0700
> Kees Cook <keescook@chromium.org> wrote:
>=20
> > This is weird -- my original patch doesn't touch audit_get_sessionid() =
at all:
> > http://git.kernel.org/?p=3Dlinux/kernel/git/kees/linux.git;a=3Dcommitdi=
ff;h=3D7bbfec58ed33d5e74043530b87992f16da718ba2
>=20
> That patch has been broken multiple times as things change under its
> feet.  I've just repaired my most recent attempt to repair it.
>=20
>=20
> From: Kees Cook <keescook@chromium.org>
> Subject: audit.h: replace defines with C stubs
>=20
> Replace the #defines used when CONFIG_AUDIT or CONFIG_AUDIT_SYSCALLS are
> disabled so we get type checking during those builds.
>=20
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

OK, so I replaced the old version of this patch in the akpm tree in
linux-next with this one (with the kuid_t patch mashed in).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__27_Sep_2012_17_26_44_+1000_ARXb6PIvutS1Wgoy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQY/+0AAoJEECxmPOUX5FENs8QAJepM3hrzOWU93Snrl2cBu5E
0VVT5Mahvzhs+Zm/qQN1fLpUvk2IGJ0h/xqrwcdc0oNNckkea3sSjJDvv5GDmrBy
RW69uxFaqc9Rcg8F1daudXim16HRDpiKbEyCpV3pSShzV+4xgE3IVJwIc29SRWZy
GNdGtonhSSOJqzoSzusP69RBipQA9Ms/U8Y82RYzNfL+UqhNUH5Y1wX5rvAqcH54
su5Nzco+VZWcvptS2OxXbbmLzdnnGWIi0/ZxMraqnBcjOI6XVf4+fgnYfIa/9Qog
Ff/3tetYjZx454LSbLy9AznJZZav4r8YZZagNaCZClFny8ul2DBQ3L9Mg8A1YeaA
3plrzwuoquI7FNkZSKnHLp/JnpUymj56riuw8j8EUwkE7yspeQfT4BHMeUOL78az
PxZbZ6IKyVzdTNfRRUs8Y3sh5TqRCmdgqijwq6SoSrBWQPdX5whNog7nWmOumKmm
5AG2M5pULCqiBahYsbsv18riTo6bqOfJPmoR5T8vt4uptD65YuCQqp3eQRIRk9E8
m/5Ej743sVd3nangKh9mTmN9N8XKcFwLGqFSzYYEanZJqa6s0//V59GUS936V1/G
rn0e8pdMFUdrtP0NIuuG3tcTLEbOj3V6zZD4kZWxuN6zB5u42xcTBzndADPy0hUm
HgRTTYAnIcrEoG9zGWfi
=ZDYn
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Sep_2012_17_26_44_+1000_ARXb6PIvutS1Wgoy--
