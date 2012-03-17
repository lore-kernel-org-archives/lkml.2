Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2CQHdI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 03:33:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49529 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790Ab2CQHdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 03:33:05 -0400
Message-ID: <1331969567.3022.233.camel@deadeye>
Subject: Re: [ 10/41] CIFS: Do not kmalloc under the flocks spinlock
From: Ben Hutchings <ben@decadent.org.uk>
To: Pavel Shilovsky <piastry@etersoft.ru>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Date: Sat, 17 Mar 2012 07:32:47 +0000
In-Reply-To: <CAKywueTUH_Zrh7iD_zsyvtmLt9O2dbd_KNrzNWzFQm4z8ZtbcQ@mail.gmail.com>
References: <20120316233829.GA14022@kroah.com>
	 <20120316233811.484341257@linuxfoundation.org>
	 <20120317023740.GH12704@decadent.org.uk>
	 <CAKywueTUH_Zrh7iD_zsyvtmLt9O2dbd_KNrzNWzFQm4z8ZtbcQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-pG1Rf79OaotDTVJgA8SX"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pG1Rf79OaotDTVJgA8SX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-03-17 at 10:14 +0400, Pavel Shilovsky wrote:
> 17 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2012 =D0=B3. 6:37 =D0=BF=D0=BE=D0=BB=D1=
=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C Ben Hutchings <ben@deca=
dent.org.uk> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> > On Fri, Mar 16, 2012 at 04:38:20PM -0700, Greg KH wrote:
> >> 3.2-stable review patch.  If anyone has any objections, please let me =
know.
[...]
> > But we test this before flock->fl_flags & FL_POSIX, which means we
> > don't know whether this lock actually needs to be assigned one of
> > those structures.  So it appears that we might report a spurious error
> > if the lock list ends with a mandatory lock.  If so, this is
> > relatively harmless but does need to be fixed.
> >
>=20
> You are right here, thanks for the catch! I will repost the patch asap.

This has already been merged into Linus's tree, so you need to submit a
patch to apply on top of it.

Ben.

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-pG1Rf79OaotDTVJgA8SX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT2Q+H+e/yOyVhhEJAQppTRAAjIQkJB3/F1Nezw3K9W03ULbLqCvlw/Wq
h4dm1rcsakeBUt2K2ckvUe9PMUNpEy+BFHaIicvyWf/FkJGIzvux5BjokN+Cv7EQ
3soVrQ2SaVEKqPRJfWKxQeJ5JA2wxX5QAdpsLCYf63SPmiCcnDcUaJsYIdtDo3hL
OKcMIqcN7/VCVc+3QVrCn3cxvrsp6UeSaFGruUowztkPUy3oEeVCQqu+kMaqKMJZ
0SNbG8GyTVCwnDMxfFSN/Q4iO8SIvX5YCVO17JDlidUfF+4NgSK01Tv+pw5wW0YX
zFb3ZR5xygEXEr4yPmJl6bQPy75MDflM7p9q6Skxh7lCjdS1jzSaDNr1M55PxGRq
llbAkEXY+aAN3H+ZWT4UHkvGX7clIsiKvFuMBraqV5UPhEctfoaWOV7Ar+7ZpexN
GADxtHWqJFvlmXZt07Zqdi141eHtPJsbQPGB/YiNMgV00FUXkOXuHq7emVWSSjOT
JB+JPDO9OGQzpPOtoIqYZgPkEog8cvJ1MXgImyi9nYmA+OI38NuX6DcIYHijv6uj
RlFQ5b+os6Ku7KDtw8m9gsNjDZoKWXT8Zz9QjG17RkEYIWJ9xcE0VAGj8m0p2GyI
yRIp2IUY55uyNjunmvmcmrqwXFgJq4JYBXc+4IR+QwQ6AChA2Z0yF61Wd3ZZ8lby
24bU298ITgI=
=gsQz
-----END PGP SIGNATURE-----

--=-pG1Rf79OaotDTVJgA8SX--
