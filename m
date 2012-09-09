Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab2IIXmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:42:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51872 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755469Ab2IIXmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:42:43 -0400
Message-ID: <1347234149.5134.3.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 25/95] mutex: Place lock in contended state after
 fastpath_lock failure
From: Ben Hutchings <ben@decadent.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Chris Mason <chris.mason@fusionio.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 10 Sep 2012 00:42:29 +0100
In-Reply-To: <alpine.LFD.2.02.1209091930530.28681@xanadu.home>
References: <20120909224154.303617964@decadent.org.uk>
	 <alpine.LFD.2.02.1209091930530.28681@xanadu.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-LwjlKWLzgUE9NrdONDBk"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LwjlKWLzgUE9NrdONDBk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-09-09 at 19:34 -0400, Nicolas Pitre wrote:
> On Sun, 9 Sep 2012, Ben Hutchings wrote:
>=20
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
>=20
> Once you have this patch included, could you pick up commit a76d7bd96d=
=20
> as well please?
[...]

That was already applied in 3.2.27.

Ben.

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-LwjlKWLzgUE9NrdONDBk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUE0pZee/yOyVhhEJAQqtbBAAsnTctsF1n/EQMjosSIG57dTw3kyRt5Cz
4mDeKBR+PORbwTearumai3fAeB2ageyc+Ekg4x8QDlkxPNdVJJ2vPA86f26ftBtT
06sD2QuJBmxExLpd+8h4cLrB6i3AzVkZArE5zpHZzk7wgao8U1aa80JRqOvj98N+
GAE1wOl4huSHB2ghR8aBYr5mNkUILx1Gc1N5YiTlOzUzrImS2UkZIi9EC/wfta8J
iDhwIMS2p33jfGIu35zhFAT2ZP6gMlMqrb8jjYf0tZZSZQhYaQ1kmSE6nvZQO/k/
I64uEl8AAywZHFm1S/BcB3BrRwKMN0qchqDjfHBRumTflPy+18fNYuZhtqZlDRxj
iBIExpnuERSZlwp+0wQpcvBVc/JnRHmSxnZN3ViYLiZX4JOYOTyWkCAP26thgGmi
59GjW43vOl7/xMz0hy5llRbySJMgV44qtZ6FqiIlFp1G+VoN6ZD1/eq5dJ0ArsDN
FQieZZrx6zXXrJkf4dthQOD9c6Rgj9fNZzSNt20I5wAwz9fXgs9Jdd42yXxl2DPm
dD4Fae12Avwx0KWYYTiI4F9wIajSxuyj+9ZxOKG3ibC+3EIK+gfSTYCGOhEyKNr2
Gjln9k/pjPSQq/8vO1Fgb5aRmJWeXUx4xsWBAnEFWUHAHl0nw6/WzGhmIh97jK8J
+rD59/ZKd/k=
=CpKn
-----END PGP SIGNATURE-----

--=-LwjlKWLzgUE9NrdONDBk--
