Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab0IGWte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 18:49:34 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:37176 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab0IGWtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 18:49:32 -0400
Date: Wed, 8 Sep 2010 00:50:04 +0200
From: Nico Schottelius <nico-linux-20100709@schottelius.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
        Nico Schottelius <nico-linux-20100709@schottelius.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-rc3 suspend issue (was: 2.6.35-rc4 / X201 issues)
Message-ID: <20100907225004.GA2805@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100709@schottelius.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20100709170432.GA7691@schottelius.org>
 <201009062037.55898.rjw@sisk.pl>
 <AANLkTimhwCsxbRp3LgsH7zye4e1qEjC-4CRo+faS=D0r@mail.gmail.com>
 <201009072348.41344.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <201009072348.41344.rjw@sisk.pl>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.34 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Rafael J. Wysocki [Tue, Sep 07, 2010 at 11:48:41PM +0200]:
> On Tuesday, September 07, 2010, Jeff Chua wrote:
> > On Tue, Sep 7, 2010 at 2:37 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Monday, September 06, 2010, Jeff Chua wrote:
> > >> On Mon, Sep 6, 2010 at 3:17 PM, Nico Schottelius
> > >> <nico-linux-20100709@schottelius.org> wrote:
> > >> Same problem here. X201s. Haven't had time to bisect.
> > > Somebody has already done that:
> > >
> > > http://marc.info/?l=3Dlinux-kernel&m=3D128376394825563&w=3D4
> >=20
> > Rafael,
> >=20
> > Cool. Thanks for the short-cut! At least now, I can resume, but got a
> > lot of BUGS showing up upon resume after applying the patch.
>=20
> This also was reported IIRC, but there's no resolution so far.  It's a
> different issue.

Can somebody ping me, as soon as a git pull on linux-2.6
should be as "stable" (or more stable) than 2.6.34?

Cheers,

Nico

--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyGwZwACgkQ19zI5DGHffCpmQCg2HBLpiyQxRF/t40xs3Ruwsd9
FNsAoJBj0cZdcdNFe9+ndHeBxRxYYylz
=2xzk
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
