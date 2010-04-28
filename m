Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab0D1SqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:46:14 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:34486 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab0D1SqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:46:13 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Apr 2010 14:46:12 EDT
Date: Wed, 28 Apr 2010 18:09:36 +0200
From: Nico Schottelius <nico-linux-20100427@schottelius.org>
To: Nico Schottelius <nico-linux-20100427@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-2.6.34-rc5 suspend issues
Message-ID: <20100428160935.GA4010@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20100427@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20100427074609.GA3261@ikn.schottelius.org>
 <20100427083202.GA3143@ikn.schottelius.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20100427083202.GA3143@ikn.schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.34-rc5-NS-00279-g1600f9d x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Nico Schottelius [Tue, Apr 27, 2010 at 10:32:02AM +0200]:
>=20
> Nico Schottelius [Tue, Apr 27, 2010 at 09:46:09AM +0200]:
> > [..]=20
> > - suspend & resume works once
> > - second time system
> >   b) suspends, but comes up with the bios screen after resume
> >      and hangs there forever (2.6.34-*)
>=20
> Just tested on latest linux-2.6, the
> same happens on 2.6.34-rc5-00211-gb91ce4d.

Same happens on 2.6.34-rc5-00279-g1600f9d.

Nico

--=20
New PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
Please resign, if you signed 9885188C or 8D0E27A4.

Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvYXb8ACgkQ19zI5DGHffDIaQCg3zE/dxsRQZ/zr8iQhl2Ajr+L
V0UAnRMJyxQ4OQ6CQTcgQ1zMWBr6bbHV
=Vx7M
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
