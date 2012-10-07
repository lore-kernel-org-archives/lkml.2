Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab2JGNqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 09:46:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34279 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753013Ab2JGNqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 09:46:14 -0400
Message-ID: <1349617561.16173.85.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Re: 3.4.10 i915 [GM45] regression
From: Ben Hutchings <ben@decadent.org.uk>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Andreas Sturmlechner <andreas.sturmlechner@gmail.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 07 Oct 2012 14:46:01 +0100
In-Reply-To: <CAKMK7uFm7YVMeUKUj4wmCeV4myYYODrp2XFDn5O8PHmjg3_U4g@mail.gmail.com>
References: <2372445.fuIXicT4H0@tux200s> <20120907011542.GA26688@kroah.com>
	 <2329337.9aFzn0oRxF@tux200s>
	 <CAKMK7uHqk1x4dM9ZA0usskNoArR6eTFmEtVw+_juzVq1NeYg+A@mail.gmail.com>
	 <20120910135803.GB2972@herton-Z68MA-D2H-B3>
	 <20120910140734.GC2972@herton-Z68MA-D2H-B3>
	 <20120926234223.GC26223@kroah.com>
	 <20120927185917.GC3211@herton-Z68MA-D2H-B3>
	 <20120927202553.GA19276@kroah.com>
	 <CAKMK7uFm7YVMeUKUj4wmCeV4myYYODrp2XFDn5O8PHmjg3_U4g@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cj+j6B2dtghxYcby5m/h"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cj+j6B2dtghxYcby5m/h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-09-28 at 08:16 +0200, Daniel Vetter wrote:
> On Thu, Sep 27, 2012 at 10:25 PM, Greg KH <gregkh@linuxfoundation.org> wr=
ote:
> >> I think the conclusion looking at the bug report
> >> (https://bugs.freedesktop.org/show_bug.cgi?id=3D54575) is
> >> that the commit 0d8957c8a90bbb5d34fab9a304459448a5131e06 should be
> >> reverted on 3.4, please correct me if I'm wrong.
> >
> > Daniel, do you agree with this?
>=20
> Yeah, seems like the sanest thing to do given the situation and lack
> of any understanding what's actually going on.

So presumably this will also need to be reverted for 3.0 and 3.2?  Or is
there something very weird about i915 in 3.4?

Ben.

--=20
Ben Hutchings
You can't have everything.  Where would you put it?

--=-cj+j6B2dtghxYcby5m/h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHGHmee/yOyVhhEJAQqUPA//ehGYd9+flVHCIVLgTCMIADLbw8X2lg4g
0uzuCfffpSN6XmhD9u6Uoa8kOA2SHi45tQP3Zb0FXyTDIzgANPUlBhnhU/OVkd0f
o66jGadqvMMBW2JMyo1AKQF0chqB+nrUG2QNysBaO6fqZqq1nn8vJPKqnXFZc8ar
iXiSbauu6h7ANk+TeSX9MzFqaF0Jw6Wt+shQrf9bL33bRakke559Tm0BCfF6L+hn
BlfW/DBTWetPUBZMfMMglFj2GLujn/eQZBAhdNDVH8QvUsGEkLzMN1GEtY4Ug/X9
zE7YlZrDlaqB0UouPb/UAgcRckAIYkA9XSY98NbvaqAf0nD23CVpuGA/13UIMQjy
cBPwoe08/iUUobEnzDq3DhApvHhDi8Bfeoc9mUaXvg4ot6JJgQXBxm2YLAbUCO11
WfjK2bK9x69R8xePVo6z/9q/rRw2ZclR5lZakA+3Deec3KWl1uT+g5GNzmXCcf9z
3+YYlf5+IU6u3ATXLf/3FwNQkBYD7KCSVcLreMAeEIu+8XEdJ5YEthORv8LjZLkg
Tujq7W9+OtJVWtWjYrps2JuEZTpAoEI38/YIAUfZE+xFW1d9y8U2b5E/RxPwOdt4
dkYXEZ2wdtH7hMRKFYTwWjTuZdn1ef/hisYMeHW1N6o+yR6rELghfSKp+x0zGVY7
QxONBsvziyY=
=l/k1
-----END PGP SIGNATURE-----

--=-cj+j6B2dtghxYcby5m/h--
