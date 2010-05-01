Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0EAMc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 08:32:29 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:53521 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab0EAMc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 08:32:27 -0400
Date: Sat, 1 May 2010 14:24:41 +0200
From: Nico Schottelius <nico-linux-20100427@schottelius.org>
To: Nico Schottelius <nico-linux-20100427@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-2.6.34-rc5 suspend issues
Message-ID: <20100501122441.GA3273@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100427@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20100427074609.GA3261@ikn.schottelius.org>
 <20100427083202.GA3143@ikn.schottelius.org>
 <20100428160935.GA4010@schottelius.org>
 <20100429191241.GA3407@schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20100429191241.GA3407@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.34-rc6-NS-00063-gbe1066b x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Nico Schottelius [Thu, Apr 29, 2010 at 09:12:42PM +0200]:
> Nico Schottelius [Wed, Apr 28, 2010 at 06:09:36PM +0200]:
> > Nico Schottelius [Tue, Apr 27, 2010 at 10:32:02AM +0200]:
> > >=20
> > > Nico Schottelius [Tue, Apr 27, 2010 at 09:46:09AM +0200]:
> > > > [..]=20
> > > > - suspend & resume works once
> > > > - second time system
> > > >   b) suspends, but comes up with the bios screen after resume
> > > >      and hangs there forever (2.6.34-*)
> > >=20
> > > Just tested on latest linux-2.6, the
> > > same happens on 2.6.34-rc5-00211-gb91ce4d.
> >=20
> > Same happens on 2.6.34-rc5-00279-g1600f9d.
>=20
> Also with 2.6.32.12. I'm wondering if there's any kernel

Same happens on 2.6.34-rc5-00340-g79dba2e, now testing
2.6.34-rc6-00063-gbe1066b.

Cheers,

Nico

--=20
New PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
Please resign, if you signed 9885188C or 8D0E27A4.

Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvcHYkACgkQ19zI5DGHffAd6ACg66fEL6gRNCp7h2YNFcHOyYUN
V4AAnibT+nGlNhImadT+uOIyN2yD12R0
=p5aP
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
