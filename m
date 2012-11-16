Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2KPSPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:15:46 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38833 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab2KPSPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:15:45 -0500
Date: Fri, 16 Nov 2012 20:09:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: <balbi@ti.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        spear-devel <spear-devel@list.st.com>, <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/6] dma: dw_dmac: check direction properly in
 dw_dma_cyclic_prep
Message-ID: <20121116180918.GB20496@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1353074360-1903-4-git-send-email-andriy.shevchenko@linux.intel.com>
 <20121116135625.GA18920@arwen.pp.htv.fi>
 <CAHp75VcfF9pHCa9wv_2Qr_U1y+ubJEkRvpyiXOZL_7nbPHo8uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <CAHp75VcfF9pHCa9wv_2Qr_U1y+ubJEkRvpyiXOZL_7nbPHo8uw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 16, 2012 at 05:30:21PM +0200, Andy Shevchenko wrote:
> On Fri, Nov 16, 2012 at 3:56 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Fri, Nov 16, 2012 at 03:59:16PM +0200, Andy Shevchenko wrote:
> >> dma_transfer_direction is a normal enum. It means we can't usually use=
 the
> >> values as bit fields. Let's adjust this check and move it above the us=
age of
> >> the direction parameter.
> >
> > why above the direction parameter ? You need to explain why ? Is it just
> > because 'it looks nicer' or have you found another bug triggered by
> > that ?
>=20
> Many of current users do something like this:
>=20
> if (dir =3D=3D MEM_TO_DEV)
>  { ... }
> *else*
>  { ... }
>=20
> that potentially could trigger the bug.

looks like this deserves to go into commit log ;-)

--=20
balbi

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQpoFOAAoJEIaOsuA1yqREkVoP/2LsUZOhtqF4cVtnp7K6zPpC
g1TXQHpzY94+Qu++KbaKraktT1jNlt1yrA5X98OCukBBnbl+lp9ksD+im9tfTlCc
fM+D01qvSiHcN5ooxP5y9+QWNYxfBU5douKrD/doaZQbw90YOzkRdk6FOV5NpNhz
2Tqd6f2HCEnM9VgZS0vgu86Lk5kZWPSCXb/ZrArrzsNJM+WOnyMAxjvsKaqA6Ygo
ltgzCM4oI1Xy6oNl64v6T7dJ+O6YmvuaNgdUwN1kLxMdZnaufC9AnYC/aFMEiPGq
Fu+M35z1AAWqNzz3rJYrmK3bV4osfSdW/CEgiIk7llvt/HFd0x5Mkbj+s1U30BGZ
J7G23Z2oCNdw19PEvoTatb5dcg0hexdWtAzULopxEkMgbDfHAiQ4Kc2ZAiNNEIyg
tH9pa0RLXkxO7wv+jiy2uonMGy3yq5lTd97sk1mmqAjakIqR0oTBjd3SKcIHDe1b
p0Gr06bskn99lWTIR6XoRD3TntspFJEkwF1UEx5TKd+LyBiI075ZoaACyoouJygp
hC86EYEs7Ugsjf7a07RR9Cj4yKfk/elgpsR3sCKL1t0RhKkJ4YhXboUtxzUPoN5U
ptf1DKQQCwuNOp+3VI2MP+OxMJL77xxRwowzsLiPII7C5SOQF41RWXw2etNsCcgZ
GZu1ZNfkRYuc7yydpFbW
=xFh4
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
