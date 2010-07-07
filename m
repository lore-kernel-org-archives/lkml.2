Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0GGGZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 02:25:06 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:41935 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab0GGGZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 02:25:04 -0400
Date: Wed, 7 Jul 2010 08:25:52 +0200
From: Nico Schottelius <nico-linux-2010-07-01@schottelius.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nico Schottelius <nico-linux-2010-07-01@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       dri-devel@lists.freedesktop.org, netdev@vger.kernel.org
Subject: Re: Report for 2.6.35-rc3-00262-g984bc96
Message-ID: <20100707062552.GA4421@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-2010-07-01@schottelius.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	dri-devel@lists.freedesktop.org, netdev@vger.kernel.org
References: <20100701074052.GA3501@schottelius.org>
 <20100706194222.fcf16e13.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20100706194222.fcf16e13.akpm@linux-foundation.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.35-rc4 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Andrew Morton [Tue, Jul 06, 2010 at 07:42:22PM -0700]:
> On Thu, 1 Jul 2010 09:40:52 +0200 Nico Schottelius <nico-linux-2010-07-01=
@schottelius.org> wrote:
>=20
> > Good morning!
> >=20
> > A short report on what's broken in 2.6.35-rc3-00262-g984bc96 with
> > the Lenovo X201:
>=20
> So you see two post-2.6.34 regressions?

I'm not 100% sure whether the netdev issue was not already part of 2.6.34.

Just changed to 2.6.35-rc4, but noticed another issue on 2.6.35-rc3-00262-g=
984bc96:

After several (>=3D3) resumes, the system completly freezes. Used to happen=
 with
2.6.33 very often (always?), vanished with 2.6.34-something

Cheers,

Nico

--=20
New PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
Please resign, if you signed 9885188C or 8D0E27A4.

Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkw0HfAACgkQ19zI5DGHffAecgCgyoCZ7rW3KrpWCKkl2ibmRLwM
rDsAoIXudwXz3YZOuVaMge0nbGUQ9rh4
=7KsB
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
