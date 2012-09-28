Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030251Ab2I1WvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 18:51:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59444 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030210Ab2I1WvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 18:51:20 -0400
Message-ID: <1348872664.6858.7.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 094/127] md: make sure metadata is updated when spares are
 activated or removed.
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Date: Sat, 29 Sep 2012 00:51:04 +0200
In-Reply-To: <20120928203056.912250649@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
	 <20120928203056.912250649@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-yqbdpGpJi29VJMAq8kou"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 77.203.67.142
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yqbdpGpJi29VJMAq8kou
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-09-28 at 13:34 -0700, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: NeilBrown <neilb@suse.de>
>=20
> commit 6dafab6b1383e912cd252fa809570b484eb6e0dc upstream.
[...]
> This is suitable for -stable as out-of-data metadata could lead
> to data corruption.
> This is only relevant for 3.3 and later 9when 'replacement' as
> introduced.
[...]

Assuming Neil hasn't changed his mind about this, it should therefore
not be applied to 3.0.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-yqbdpGpJi29VJMAq8kou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUGYp2Oe/yOyVhhEJAQrkxg/+LeyzQcefYD7j51KfoJDzi/zruDh1KNBx
c5B3KZPCQoCvVSEt/hFrGfbYxNAxNavasyUetncCjHAn8NtnDaKr2h+qwsdAVUIC
k3rB+fZyKrcib8TUxxQNsDsMzRw6PaYi70EVLNa9Xl/PoIfA5m/4RQV6dDZi5hld
zbpw4mefc3IfTJHPAkkZhZmuSAF1tAhtd3d8RdhDOgvUFe1WRhTF1fdMhNm86WGp
98QcGckUjBWRlmndQ9pOYcEWgD9MAsi9InXh5TlpHiZAQ1SMtlmp1VU70hyey+M/
h3lBse7h9q9YeFcItyYMY4CxDVAI9Df6sLbroTIKehtdEWB2u1Kdmyo75CAaUQH2
uJmCfCzDMI63JE8cXkWCkjiUhzLATUIw+IPanviDaanzO8Vuku4bpbv/lweI7aT4
ri0iCXFOezpPbgpJ51b40sZk7FSTFPswjZH3HHViJCj4KugEAYncjBTMGx30NTru
ILcJmjzeVCUURs69lpRYddrEVsKF05jDlVUzC4wx35qrHPV/Mtc75sp9r1gS1EIJ
NyveE3CPsyE2kcTK4ViijbUjw5umcY/SX6WBaOlQGD4fIpajWmm4iTKdL/taY9Vi
FvkZASUjJM0ACpDti+O4r3jOICSAtEji2i4MG+uasYPiUn4cfTl4ItT7K0PpCCz2
umPdwcFnYPI=
=/OWB
-----END PGP SIGNATURE-----

--=-yqbdpGpJi29VJMAq8kou--
