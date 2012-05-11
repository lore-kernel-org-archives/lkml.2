Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab2EKDA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 23:00:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58045 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932182Ab2EKDA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 23:00:26 -0400
Message-ID: <1336705215.8274.425.camel@deadeye>
Subject: Re: [ 074/167] [PATCH 14/26] tcp: fix tcp_trim_head()
From: Ben Hutchings <ben@decadent.org.uk>
To: "David S. Miller" <davem@davemloft.net>,
        Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        Vijay Subramanian <subramanian.vijay@gmail.com>
Date: Fri, 11 May 2012 04:00:15 +0100
In-Reply-To: <20120509081617.GD32230@burratino>
References: <20120509055029.588587017@decadent.org.uk>
	 <20120509055040.099618905@decadent.org.uk>
	 <20120509081617.GD32230@burratino>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HGcj6okPykMuZWM3d5OG"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HGcj6okPykMuZWM3d5OG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-09 at 03:16 -0500, Jonathan Nieder wrote:
> Ben Hutchings wrote:
>=20
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> [...]
> > [ Upstream commit 4fa48bf3c75069d636fc8830743c929a062e80dc ]
> >
> > commit f07d960df3 (tcp: avoid frag allocation for small frames)
> > breaked assumption in tcp stack that skb is either linear (skb->data_le=
n
> > =3D=3D 0), or fully fragged (skb->data_len =3D=3D skb->len)
> >
> > tcp_trim_head() made this assumption, we must fix it.
>=20
> Is this needed in the context of 3.2.y (which does not include
> f07d960df3)?
[...]

The code being replaced really didn't make sense, but unless there is
some other case that breaks the assumption described then I don't think
this meets the stable rules.  David?

Ben.

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n

--=-HGcj6okPykMuZWM3d5OG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT6yAv+e/yOyVhhEJAQqsww//erGULjXtIb7ItCHAXhHPsPp55HUtVCM2
3vq1jldGTXwZnyoJiYSARxSBIk6TEtyxl6pa1/2e0SSuksPsve010wQHi8hEbnRP
h/NTpxZSgwE7bC2+JsQTN1tRq1zs99h5H0E5vC4qcV5dR5OkH0o6Yl7zcYQGwO4j
yymiPNVKXrWzRSaA8Xze6RAZXTZWJzK8ERLBsFwg3m4IHVuNewC2+lBZ3uCFvYsx
GqyKfwMLT7EjrLPVV/EW9Xlq7t87nodq5lLigyhjY2Qp+tzFSbJoUjuIwN3DUoZ0
LKE+hcIFO59Lv3pMBOLxTAiPZACgXNsq1T2R0SUn9w77eKsq6tRd4adrzHbD3N5H
qpJCkP1H1r2v/IldzWFU9pR5GtpkvlMH0bFxJXtEze4kXdF8cQS/QiEJzZ9Epuma
Zth/lrJCRRwxKU12637ALtY9EwMvfJEoA5QmAgnL3z/dZcXxRBZTDUFA3gEB6yaO
alR5TlP5bndgRmeVE67xZ9ijQdrY5XNCgI9nXd60lcYmR/rx2ZK/aYkK1uelStTU
J+MOrfrWFP5YHK0flIDxCeSghxbic+lDuqF/AeYcSkw0Xsgsi4hsVA8F6TRFaFRK
ukxzVyWx/6xhBSaw8my3z3W6Enb2JwSP3NzDPonsW2HXslqEMxYYvlO9vTVEWFPo
+tcMZVEDj54=
=RN5s
-----END PGP SIGNATURE-----

--=-HGcj6okPykMuZWM3d5OG--
