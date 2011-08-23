Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1HWMQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 08:16:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43820 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609Ab1HWMQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 08:16:10 -0400
Subject: Re: [PATCH] setarch: Add --uname-2.6 option for personality flag
 UNAME26
From: Ben Hutchings <ben@decadent.org.uk>
To: Karel Zak <kzak@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, util-linux@vger.kernel.org
Date: Tue, 23 Aug 2011 13:15:54 +0100
In-Reply-To: <20110823101601.GA23745@nb.net.home>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
	 <1314079201.12047.68.camel@deadeye> <20110823101601.GA23745@nb.net.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/2rU7xP1uclPPjTLxRS4"
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314101761.12047.70.camel@deadeye>
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/2rU7xP1uclPPjTLxRS4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-08-23 at 12:16 +0200, Karel Zak wrote:
> On Tue, Aug 23, 2011 at 07:00:01AM +0100, Ben Hutchings wrote:
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> > On Fri, 2011-08-19 at 16:15 -0700, Andi Kleen wrote:
> > [...]
> > > To use:
> > >=20
> > > wget ftp://ftp.kernel.org/pub/linux/kernel/people/ak/uname26/uname26.=
c
> > > gcc -o uname26 uname26.c
> > > ./uname26 program
> > [...]
> >=20
> > I would suggest adding this to setarch, as that handles all the other
> > personality flags.  The following patch to util-linux seems to do the
> > trick.
>=20
>  I have one simple rule: "Linus' tree first", and I don't see UNAME26
>  in include/linux/personality.h ...

Sure, I don't expect this to be applied until and unless Linus takes the
kernel patch.

Ben.


--=-/2rU7xP1uclPPjTLxRS4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATlOZ+ue/yOyVhhEJAQqPORAAgNPA34sZs5OrYHcAxSkF/qfRVOYr8X1R
sxcLGmSDotATB2uYbKxvS5XNKt3h+fUGaIjxXitDn3ub0No05zlSZIaKPoQffexF
t2zS0gmVUI6jkW6NR/QqA8YWgR0PGpWMWf68JeaY1D6xjHO19OJWQzl2fFkKoCKJ
RAVEzKUEt/tkZE+w401Osub85zToh8CuWhIQwFCIqAQwlpHE/IyStYndIvGlIu+E
7Yyi5xbTuvyQtpbukUYu88m1Yc1qDl2VJMD2KyiUnAumgoVj2RFhV0WQ3T7Kufmh
pTUuQiPFvsAt0uqmSAUfvTrT7wXYdRMDcGIxh/uL24gv+lh8J7WxC1vXob+WCkbz
DizognSldROVDc4eQV6HM5Vxw5wQIhsgiEwzurD3EGysYpS3S+EE6YSmwMrCclw3
S+QS4oVY2NQCQB8SIsvu8cFiQL4cYSFqfh8gkqng2Z4LAnPZ0UZj5Hx2cMsGCz90
QwGwrFsmbmciSdp1BUW1K8g8dZ7lEmWbo1qsmQYaQ8yRO1eE/Pth29OBPIXJDZjV
8iLN9gD7SZsqcatm8kPNdIUn9gXq3zb4aad+qWHnYSPT/q0WOLAY1CTolT/jObAE
g3M3NNj9JpHUbEoGTdiRhMWHWFlt2pZDA/CtKHtwBkrH8FcCwGTVKrW+gNNG7K+/
5gk75FPEwoo=
=Kc4d
-----END PGP SIGNATURE-----

--=-/2rU7xP1uclPPjTLxRS4--
