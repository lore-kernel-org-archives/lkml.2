Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab2K2OLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:11:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33643 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681Ab2K2OK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:10:59 -0500
Message-ID: <1354198240.7995.5.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 09/11] asus-laptop: Do not call HWRS on init
From: Ben Hutchings <ben@decadent.org.uk>
To: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2012 14:10:40 +0000
In-Reply-To: <1354176759-630-10-git-send-email-corentin.chary@gmail.com>
References: <1354176759-630-1-git-send-email-corentin.chary@gmail.com>
	 <1354176759-630-10-git-send-email-corentin.chary@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FYGSVNe7XosKUN8aWf1H"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FYGSVNe7XosKUN8aWf1H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-11-29 at 09:12 +0100, Corentin Chary wrote:
> From: Ben Hutchings <ben@decadent.org.uk>
>=20
> Since commit 8871e99f89b7 ('asus-laptop: HRWS/HWRS typo'), module
> initialisation is very slow on the Asus UL30A.  The HWRS method takes
> about 12 seconds to run, and subsequent initialisation also seems to
> be delayed.  Since we don't really need the result, don't bother
> calling it on init.  Those who are curious can still get the result
> through the 'infos' device attribute.
>=20
> Update the comment about HWRS in show_infos().
>=20
> Reported-by: ryan <draziw+deb@gmail.com>
> References: http://bugs.debian.org/692436
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
[...]

Can you add a Cc: <stable@vger.kernel.org> to this?

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-FYGSVNe7XosKUN8aWf1H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULds4Oe/yOyVhhEJAQo7uBAAl1Y5FSCljxZ4MGLpZmVuj8tftg2FRCGN
RJeGePse7FwtQ0unOOR/bmwnpw45D+IuYPxt2IxdcKfYo4BMveEm/5d+EokLt/TC
VhoaRwWMHZNnysdSul+a/GRLt3i+JAnudmeyV1B8P9e5LqiYaxWMUT9R/kINtFRL
5cKnh4eh5dj8+Vu3nlvcvcdudo0OcPf9VU56h585wJTs78ll3AaHVs+ZDjkxYOuZ
1KfLRnHl2Av3RLLHaVSb0E9JdM1AtnI3WE3/gusIM8yIOd0+wHqICv95dqhILfTL
Q5+I5C1k2cjb+FzI/0BT967AFcC4LpFhEYkb07XQEjvEFzcrPRUrM/eQEDPPn+WI
RXQ02yuAR+W5aCY9b5Fs7ZZTEmfDyZPlm/IMu67X5h+steeMJmAYDIiRD/gW6xhb
8RPrxg0PcC1xRlamIH9ldDuY8JQxSc+jj5BQ23BRGFz1crfS8Ctl2/8q64sLDxTA
O2pZNpTsNSghUCsfzl64pl1fpj2wxOohhgIfQxu+oIVD+VL4BhIgCFZLLcMz9h/b
PQZWmxq7+h8NJ2sCthzs1Dr0hGdKtqvaIwIp4z2fBP96qyiZqGYdBUNmhYCf/7AJ
UyfZzuBMsg8SnMbieA0qRX7E/l9a8okxkBCVlN+Dj/zgMjDzT0Ebtlb0lOhMiPQJ
DDrxE6mup+k=
=Higd
-----END PGP SIGNATURE-----

--=-FYGSVNe7XosKUN8aWf1H--
