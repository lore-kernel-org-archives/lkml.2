Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1DDRb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 13:31:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51341 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab1DDRb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 13:31:57 -0400
Date: Mon, 4 Apr 2011 19:31:49 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, Michal Simek <monstr@monstr.eu>,
        devicetree-discuss@lists.ozlabs.org, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
Message-ID: <20110404173149.GB12200@pengutronix.de>
References: <1301574600-4861-2-git-send-email-monstr@monstr.eu>
 <20110331124925.GA2202@pengutronix.de>
 <4D948189.9070606@monstr.eu>
 <20110331170321.GA2734@local>
 <4D94C09B.4070506@monstr.eu>
 <20110331192302.GD2734@local>
 <AANLkTin6iSVQtKo602hceod+4=cVUMG=GR7cCZvHg4nO@mail.gmail.com>
 <20110331203024.GE2734@local>
 <20110402103550.GA21760@pengutronix.de>
 <20110404170437.GA4830@local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <20110404170437.GA4830@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

> > If the generic driver is not sufficent for a user and he
> > patches it, he can simply patch the version string, too?
>=20
> Or better write a dedicated driver. Patching a generic thing like uio_pdr=
v_genirq
> can only be done in specialized drivers in a project. That's hackery that=
 won't
> make it into mainline anyway.

I exactly meant that, maybe didn't make it clear enough. Of course, a seper=
ate
driver would be better, but guess what will happen in most projects.

> > Or can we use the notifiers to set up an individual version? That could=
 also be
> > the place to do special board-setup connected to the selected version.
>=20
> How could that look like? If you have an idea for a generic solution, you=
're
> welcome.

That was more a brainstorming question; there are notifiers which help
populating function-pointers which also can't be expressed in a device-tree.
I just wanted to make sure this approach doesn't get overlooked.

So, the solution for now is to simply add a default value and we can check
later if it can be modified at runtime?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk2aAIUACgkQD27XaX1/VRu0awCgnnzK4TUgwhEAe7Th3/bXgCsK
WX8An1NKfgL9LYBuF2x03RQdrlItgGzf
=05Sm
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
