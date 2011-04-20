Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab1DTMe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:34:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56110 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754686Ab1DTMe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:34:57 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Dmitry Torokhov <dtor@vmware.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110420053925.GC16291@1wt.eu>
References: <20110419204119.285492847@clark.kroah.org>
	 <1303264924.3464.69.camel@localhost>  <20110420053925.GC16291@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-SJq+oT5fn7KIFUgRbsgZ"
Date: Wed, 20 Apr 2011 13:34:35 +0100
Message-ID: <1303302875.3464.96.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [24/28] USB: xhci - fix unsafe macro
 definitions
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SJq+oT5fn7KIFUgRbsgZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-04-20 at 07:39 +0200, Willy Tarreau wrote:
> On Wed, Apr 20, 2011 at 03:02:04AM +0100, Ben Hutchings wrote:
> > On Tue, 2011-04-19 at 13:31 -0700, Greg KH wrote:
> > > 2.6.32-longterm review patch.  If anyone has any objections, please l=
et us know.
> > >=20
> > > ------------------
> > >=20
> > > From: Dmitry Torokhov <dtor@vmware.com>
> > >=20
> > > commit 5a6c2f3ff039154872ce597952f8b8900ea0d732 upstream.
> > >=20
> > > Macro arguments used in expressions need to be enclosed in parenthesi=
s
> > > to avoid unpleasant surprises.
> >=20
> > Do you know of any specific uses of these macros where the missing
> > parentheses caused 'unpleasant surprises'?
>=20
> In my opinion, this type of fix should be backported even if the current
> code does not appear to be at risk, otherwise a later fix in the kernel
> could cause a serious regression when backported to -stable. For instance=
,
> if we later have to backport this patch (cut'n'pasted) :
[...]

I agree, but would like to know whether there is an immediate effect.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-SJq+oT5fn7KIFUgRbsgZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATa7S2ue/yOyVhhEJAQrTkA/+KIPa9aR21/KlFx9/3isoWJBwrUBVu5c+
liXgpiWNGmzGuiBfjJl4a+rfOb4k4yKBxzpBLZjLT0GCQBLZRrqXywgt99loXuc2
Rh2NqBKi1e55HiCdhzBgZrVxq3DtFWFxJSCPUy9kGsd3TXbl9bRwwe4dEdD/oYEA
7OgDjQu7A7QnCiZG4vuCQTp8GhTHN3O+TqAIsuxdZts3MpIJIG+wA4guTDIJeMzF
QgMzlKMj8GVAX0KB+CtFhjoQQVMZYC+i2Jf9T0YaFY4SA9k+juhC59n31siY4QGv
wFOsioy2qxMoGWMkMcPrGnnJOnNcx275l8ImK5yOQztNs49TMqg/iP4FTPm7Jbid
+/2t//aX7hSa028qf/t84ccI2zCaQ9dkcukxEk0YPEG5h3pik84LgnWUkQ6SmCyY
FiVNxpbs3G6mLCo5rfdtEkwMvysctpglOEMwIfGhbIkfl4UPfF/qjFlmd2BYp5wp
rj4fB1AhxGTzjPj/oBz0O8oZOUSQmK7CMT7cg576P++jM3PWrrXa0KXTIUPyosBZ
fIMybbfoGWK1u5a/1kSUFJEgM5mXqYLNHteOHiBmj96xBPaDc4Rr25esH28vN5fT
1Y6gbLX9fKVA6LyPTOESjh/4eo/yrnP+FXoJUxhj4jA75nefEancd+BsBa901rqt
Kkr6QsTtTho=
=bNBa
-----END PGP SIGNATURE-----

--=-SJq+oT5fn7KIFUgRbsgZ--
