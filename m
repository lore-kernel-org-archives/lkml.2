Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab2AIPMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:12:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:20934 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598Ab2AIPMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:12:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="96102060"
Message-ID: <1326122067.6755.104.camel@sauron.fi.intel.com>
Subject: Re: [GIT PULL] UBI/UBIFS changes for v3.3
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 09 Jan 2012 17:14:27 +0200
In-Reply-To: <CAFLxGvy7MPfBp=prAqELwcWuHFjB0qnNrTRzmoGBN39==G76Dg@mail.gmail.com>
References: <1326118036.6755.101.camel@sauron.fi.intel.com>
	 <CAFLxGvy7MPfBp=prAqELwcWuHFjB0qnNrTRzmoGBN39==G76Dg@mail.gmail.com>
Organization: Intel OTC
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-nmKd1irK8i6L/UKkaNLp"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nmKd1irK8i6L/UKkaNLp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-01-09 at 16:00 +0100, richard -rw- weinberger wrote:
> On Mon, Jan 9, 2012 at 3:07 PM, Artem Bityutskiy
> <artem.bityutskiy@linux.intel.com> wrote:
> > Hi Linus,
> >
> > please pull UBI and UBIFS changes for v3.3.
> >
> > The following changes since commit cfcfc9eca2bcbd26a8e206baeb005b055dbf=
8e37:
> >
> >  Linux 3.2-rc2 (2011-11-15 15:02:59 -0200)
> >
> > are available in the git repository at:
> >  git://git.infradead.org/ubifs-2.6.git linux-next
> >
> > Artem Bityutskiy (1):
> >      UBI: fix use-after-free on error path
> >
> > Bhavesh Parekh (1):
> >      UBI: fix missing scrub when there is a bit-flip
> >
> > Thomas Meyer (1):
> >      UBIFS: Use kmemdup rather than duplicating its implementation
> >
>=20
> Where is "ubi: Make vid_hdr non-static"?
> http://marc.info/?l=3Dlinux-kernel&m=3D132456978023418

Oh, forgot to merge it, but just picked it. I'll send a separate pull
request to Linus with this patch a bit later. Apologies.

--=20
Best Regards,
Artem Bityutskiy

--=-nmKd1irK8i6L/UKkaNLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPCwRTAAoJECmIfjd9wqK0lVUP/jv6ra4ANM8PK9Zn8YwLCxXd
1XQj+fV8qy2F0mFxkmwdHAtkEkT/HyO+mIwX1hWpX3qCbqI5hdklaR7YguwXy8IB
13VoLwOiPjntZLHr3tH/m8K4vMAx7MxoDJ9U/p4/S50tnP87JQNuNEPKLfDvl+F9
v8k5YaTjPoacHUc3OIHevMVe2CNxgbHbtQw6VagcaFtOuDt0COGMKeztdWdv5/5Y
Hk6q1Q/v27+QpJxB6bgFtGdrgL98mQzjalTHf8DxMVrlvbEbeiHQQ1lRJUlD3uEM
r8RVeGBkyIsWJ9dtP2ogJnDJbXqRD8c42C3jEdg07QgdUE8Mv2bb0miXGSOly2CJ
w77Cu6jV6IehGD46ZY6gNg8t4Ket4wrXuEWRBUrjXEWtJu0s+VUR8ZH/Byl6sXbS
y4gKscx2BMCjUYBVrlGl1HI4GWvTFKWowpFSgx6td3lmVwCijdp4nI9YsWGEToPm
zdSHCXfpKzPm+rpqVqLjmA6BiOn5RsBOqSADeOP8dKFAF/TGz+rpB8b1YpK+qEsx
92z9Z0wUpbTJZLL02Qj28IdpIaO5AGxnt6XSeclO4Ds7fmnpT/YiuX6GTD7WgEc3
bTw5OzB534VfCX0hlIRa5racY2cP0ASGL3sXHPtRdZuTZp4cm3zQkcwjVw5Fp7i0
2UhzSIEOaLKYTYuzOlAV
=fFDJ
-----END PGP SIGNATURE-----

--=-nmKd1irK8i6L/UKkaNLp--

