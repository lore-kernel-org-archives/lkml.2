Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873Ab0FBXdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:33:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:45568 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758161Ab0FBXdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:33:37 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX1+aUa98fGmaYUhCzV9w93g24VEfmJ4fNukxyVlmqN
	467drY/x7N5kXE
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: Joe Perches <joe@perches.com>
Subject: Re: [B.A.T.M.A.N.] [PATCH] drivers/staging/batman-adv: Convert MAC_FMT to %pM
Date: Thu, 3 Jun 2010 01:33:24 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: b.a.t.m.a.n@lists.open-mesh.org, devel <devel@driverdev.osuosl.org>,
       Andrew Lunn <andrew@lunn.ch>, b.a.t.m.a.n@lists.open-mesh.net,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
       Marek Lindner <lindner_marek@yahoo.de>
References: <1275509418.23599.42.camel@Joe-Laptop.home> <201006030123.25027.sven.eckelmann@gmx.de> <1275521522.23599.88.camel@Joe-Laptop.home>
In-Reply-To: <1275521522.23599.88.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1305233.EJFBN4lapa";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201006030133.25522.sven.eckelmann@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1305233.EJFBN4lapa
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Joe Perches wrote:
> On Thu, 2010-06-03 at 01:23 +0200, Sven Eckelmann wrote:
> > You've also changed the output. So you may partly broke batctl too (have
> > to check that first).
>=20
> There was no change in output.
> MAC_FMT output is the same as %pM

I meant the other patch :)

Best regards,
	Sven

--nextPart1305233.EJFBN4lapa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCgAGBQJMBupEAAoJEF2HCgfBJntG1L0P/0mAZue+5DvrGUv56VP1g8Rz
n96YngWzvBrLUdO3kc6y+Ie+hXz08ycoOiUD0skmbcwBj7vCIV+mmhzp3mKoerPh
DbH8NvOCfWzNWbz/pBq1HTCcVdh2gQJOvh1D/2GsWXFbsvpFrfYgNR/4lpQiCc+f
8WbK8yLqya7NQP1JOhiLv/m8khoMovIPYrmUQ4sfOYLwrBL7vRnoXWtViw3dlMYZ
ZiYkofj8OHWtitTt5dNqB3LfoQn/82yJYscVNRJZ2CoXXPLZUVPfppt+Fj8B9rpi
wMVfqYW+KujNJUoYSmIJS6ErydkOkoclU62V1etlbOug9fXKaybFHqT16zCtd+oR
mpCojJcg2aFyKNAUPl3zrWq4miPOJHQnJQU4JWbBAE87ZWS5oN+Eexui6P33CbXI
9XRIH55k3lc65YSZL5EZ/RAKg99QLyq7OVVvy/e3LpYYSrUZNWBTjODl/K87aA+c
hhJ5Xrk9BNHkxB7VMsxh1LTS75W2h/erciZDiO5Tlqld8gnfk7tLVR3E1bw/y2d6
hmGikyPVkJzw30MMxRrzOL2twoO65ktMZaFCrh8HZUaOnIlfq30HfLSwjqBNwIBj
LmsLGBpZ1mIdzixTN/ttBv6jqHa5/7Own77H0aKghxWsdDYiwHGkvRBFGPIuD7iw
s9P0rZoafE/xKSBJ6VQS
=JQ9Z
-----END PGP SIGNATURE-----

--nextPart1305233.EJFBN4lapa--
