Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931Ab2FHDWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 23:22:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42413 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630Ab2FHDV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 23:21:59 -0400
Message-ID: <1339125708.21665.108.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 64/82] ext4: dont trash state flags in EXT4_IOC_SETFLAGS
From: Ben Hutchings <ben@decadent.org.uk>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tao Ma <boyu.mt@taobao.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date: Fri, 08 Jun 2012 04:21:48 +0100
In-Reply-To: <20120608031144.GA9722@thunk.org>
References: <20120607040345.775333506@linuxfoundation.org>
	 <1339124589.21665.106.camel@deadeye.wl.decadent.org.uk>
	 <20120608031144.GA9722@thunk.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-m1FqOId68pXS+1DMzHRV"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-m1FqOId68pXS+1DMzHRV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-06-07 at 23:11 -0400, Ted Ts'o wrote:
> On Fri, Jun 08, 2012 at 04:03:09AM +0100, Ben Hutchings wrote:
> > >  		ei->i_flags =3D flags;
> > [...]
> >=20
> > Shouldn't this last assignment have been deleted?
>=20
> Yes, I'm testing two patches to push to Linus.  One of them deletes
> the last assignment.
>=20
> The testing cycle should be over by tomorrow morning; in the mean
> time, this commit is harmless in its current form (although it won't
> fix the problem it was intending to fix until we delete the last
> line).
[...]

It's not harmless because the user is no longer restricted to changing
EXT4_FL_USER_MODIFIABLE.

Ben.

--=20
Ben Hutchings
I haven't lost my mind; it's backed up on tape somewhere.

--=-m1FqOId68pXS+1DMzHRV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9FvzOe/yOyVhhEJAQpGnxAAuQ5P6O9HPkV2OGpRfTa0p+dJX02KvxEm
/EWCyQww5H5Y7aJltuHga7lohQwVtRbupxkDbqn7ktKsSIKY0SKV6kWBdmNbsw70
8mgg9wQ2kJA74kE4B4U/tWsr9UvBITQHN344Iuonm5ugnGYdEgolI48Cydx0LPAI
rowVVVG8MDo4f+4CtW3dlBNB6ynkcNLqXxCxqISaf+dXrt3mQKmLe4Tha+Iptc4R
cs2uvvVeA6c3XXpNs8Rskij9/gfMA2lc6vSiCz1N01y0PUbFoupp9qDKd2FFhs2Z
Pek57ElHVUQrGMTe8vVx6wiadZCdaEFYbGTX1tuDbSG/HmzatnXPXNKdUoOFHUqm
hRJ0/dZJ5NQNLfXH1TjRAzwfPb1wMaGUSf/tSCygvq0yZZ/bcGvc5Ccl0wDvLylV
sTYC0QmatGnnqJzci5TFpko016ljNiRK0TIuhe/j3hUrs1fuwds/msTBzN1cZUtc
DOrkn5ALI1NXwJe5pwXGpOyhX0e7fWD3jnousJcXbiCFSJIk0ZAkJMkWIM1/PLRl
DMVAyf59edJMq1pD9QqEY+lXtrYqdgSkUp+vlQvgAsV/ymCJqjtQ/6JnRRYbJWw+
yyhY+HYpBoUeMu2RzH8XQIt2V2AahMllYqW/O6mfnWYOuNtFuCzt7yVF7/1/zRJQ
efhK5ikF5og=
=HPRW
-----END PGP SIGNATURE-----

--=-m1FqOId68pXS+1DMzHRV--
