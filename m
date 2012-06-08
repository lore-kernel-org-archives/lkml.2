Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433Ab2FHXB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 19:01:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50991 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748Ab2FHXB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 19:01:26 -0400
Message-ID: <1339196476.21665.130.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 64/82] ext4: dont trash state flags in EXT4_IOC_SETFLAGS
From: Ben Hutchings <ben@decadent.org.uk>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tao Ma <boyu.mt@taobao.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date: Sat, 09 Jun 2012 00:01:16 +0100
In-Reply-To: <20120608200553.GA1704@thunk.org>
References: <20120607040345.775333506@linuxfoundation.org>
	 <1339124589.21665.106.camel@deadeye.wl.decadent.org.uk>
	 <20120608031144.GA9722@thunk.org>
	 <1339125708.21665.108.camel@deadeye.wl.decadent.org.uk>
	 <20120608200553.GA1704@thunk.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kvygyiOPzBs1juBwfL/F"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kvygyiOPzBs1juBwfL/F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-08 at 16:05 -0400, Ted Ts'o wrote:
> On Fri, Jun 08, 2012 at 04:21:48AM +0100, Ben Hutchings wrote:
> >=20
> > It's not harmless because the user is no longer restricted to changing
> > EXT4_FL_USER_MODIFIABLE.
>=20
> Um, very good point.  So we should either drop this commit and wait
> until the next stable release, or also pull commit b22b1f178f6 in as
> well.  Basically, this commit and b22b1f178f6 should appear in the
> same stable release.

I've (re-)queued them both for 3.2.20.

Ben.

--=20
Ben Hutchings
I haven't lost my mind; it's backed up on tape somewhere.

--=-kvygyiOPzBs1juBwfL/F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9KEPOe/yOyVhhEJAQqVFxAA0AjGP42CYCc5WEmHB6UzeC9gltc8m9Za
bPSr3+peIjE1UiSGtIEysOeUFFn72nAUZx8xWG/nMZH7klzjwYb4KyDdJSB6v+vi
LK0bUJGHTIJDEKezg53UAPYZX6pM9XZ2E82s6V3k1fMsSX4FCGaMmz2ezEvh9KOG
aRW8VHITyN/2SNPH3Z2rFe5eaCRPzkc5iZd562ToNIBkn41NOmi9ZsyL2zM6+FCi
yS+l3qdG4jp0ZYjWc6vVDPB/3KaaeV4go5JNCj3hYFUOsl+RfplDC05a5m8BfOzx
vY/eqgoAqsmP4Xoq7GwzG5jmOF+N1DlJGt0Ii9O4pdGttNaGcMD8LBcXnIaljFXV
GjniUgBHTn0FRmdLHUGcr+af1EITW3XTh995R6C3f2ED6HnsYIRqBSlohg8jW7yT
/+drtAjl3qdCpHJx799wRNP/y6cZWl95gXj55JdpzRgqlxWhQOoGph3CjL0gdVGG
VAmHqiOiEN4QV+MzhvbR/n+1uU1wBWTJeaFBbq4hQmYUr8YsuoTU93Fn3j416qcZ
+TrW6HL/ObIabKa7bCydQbSm8an0nN6O14nkYpeb6jMMdqZbF0rbbKeIbysKuwjK
iKjUNbeHFaZVn/fAZ6E/cqRdji6mJuBDuceL02HeNba8UTr57LQtK4Xeq+NK9Lrp
y/SPYm7iBu8=
=C/9k
-----END PGP SIGNATURE-----

--=-kvygyiOPzBs1juBwfL/F--
