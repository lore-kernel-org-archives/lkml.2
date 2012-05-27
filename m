Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab2E0Nis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 09:38:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46398 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111Ab2E0Nir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 09:38:47 -0400
Message-ID: <1338125924.20487.72.camel@deadeye>
Subject: Re: [ 10/94] iwlwifi: use 6000G2B for 6030 device series
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 27 May 2012 14:38:44 +0100
In-Reply-To: <20120527010425.194805088@linuxfoundation.org>
References: <20120527010425.194805088@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-YtSMsGYcscW4AqLlSkQR"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YtSMsGYcscW4AqLlSkQR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-05-27 at 10:04 +0900, Greg KH wrote:
> 3.3-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>=20
> commit 35e7adaaf6932c5ffb22c6ec521734434c65adc5 upstream.
>=20
> "iwlwifi: use correct released ucode version" change
> the ucode api ok from 6000G2 to 6000G2B, but it shall belong
> to 6030 device series, not the 6005 device series. Fix it
[...]

Again, I believe this and 11/94 'iwlwifi: use correct released ucode
version' are redundant.  Although in this series they cancel each other
out...

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption] would be
development of an easy way to factor large prime numbers. - Bill Gates

--=-YtSMsGYcscW4AqLlSkQR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT8IuZOe/yOyVhhEJAQqFwg//fM9s72Hj3E0dJ/mQidWAdoFS39yd1b6m
9aEEbVfzPt5i6rCy/ADC5HHcSJblWkK2DmhcDjZW8JKuPfF5iMx71J4MyqYYLPw/
8cFkZb/5/QiP7dNRqymM9Pcy8G+cRd6W7+1O1Z2Q6PkXLWkud0zpsxWSBgvb+Wen
ttpGihEHogSa6vzjGeApD1NqlupUmuy5E0920YBX0xh3gT8wvkCS9mn2NejKCN5r
veCQF6XCUsb27bjOwfKMb9mPJ71+wafsJt5AiA/aL7k5U1wePmwdt/aT60nTzlCD
PdC3BWBZOXGkwDW3NsrMYuhN1kW9xMXBCFHipi6GCnnKGWPPFTze00wPjGkn4G8d
uSqlprf4faVeKoPZvYacAcPdjwt0voltfUwS297CL2TYrHvQq3UgpsU9nbzTh+J7
psh7xBC8O0hhFmnhu6juy8GP3YqMdz62Ww1UB1s/AOaXkvBUADdZA/i8rUtGVleY
d+slEj37kaBLQpyt39QVbpV4xh1YZta2XqoWXZJ49RcDVk6FqK27SdMweBj6gVlR
hPiwJoftxlxYOUqQiBQMxBDeD9SgmSs45UNIsEQZJYJauNUlqVy4NAjYmOL4UhQc
c22euPmVEbDAbIzijE65MWfAfhZiyhojEtNaxAWYWK25g/MnYafq8VZrJoq+nMTz
1PxRBV5RKH8=
=DV3P
-----END PGP SIGNATURE-----

--=-YtSMsGYcscW4AqLlSkQR--
