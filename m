Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2H1O4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 10:56:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45988 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752396Ab2H1O4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 10:56:13 -0400
Message-ID: <1346165758.15747.7.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Hardening debugfs (Was Re: [PATCH] debugfs: more tightly
 restrict default mount mode)
From: Ben Hutchings <ben@decadent.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Ludwig Nussel <ludwig.nussel@suse.de>,
        Alessandro Rubini <rubini@gnudd.com>, linux-doc@vger.kernel.org
Date: Tue, 28 Aug 2012 07:55:58 -0700
In-Reply-To: <20120828144110.GA23035@thunk.org>
References: <20120827203215.GA16637@www.outflux.net>
	 <20120828144110.GA23035@thunk.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-y79bO+dXAfrUTi8nhRWP"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 12.105.246.2
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-y79bO+dXAfrUTi8nhRWP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-08-28 at 10:41 -0400, Theodore Ts'o wrote:
> On Mon, Aug 27, 2012 at 01:32:15PM -0700, Kees Cook wrote:
> > Since the debugfs is mostly only used by root, make the default mount
> > mode 0700. Most system owners do not need a more permissive value,
> > but they can choose to weaken the restrictions via their fstab.
> >=20
> > Signed-off-by: Kees Cook <keescook@chromium.org>
>=20
> I agree with this patch, but it would also be good if we could try to
> harden debugfs in general.  Some ideas that might be worth discussing,
> for example?
[...]

The problems are apparently larger than specific modules:
http://lists.linux-foundation.org/pipermail/ksummit-2012-discuss/2012-July/=
000894.html

Ben.

--=20
Ben Hutchings
It is a miracle that curiosity survives formal education. - Albert Einstein

--=-y79bO+dXAfrUTi8nhRWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUDzb/ue/yOyVhhEJAQpnLBAAjrdUSgUEgsXaHR25arAYn9RrAqfq4ya/
wGqRToa4LvIHfmBk3pX5j3/locH3Ir+eW79euVxiZ/HuVZv+HeRMJXm5leEECmGe
mQfhDBn4rzBIcLQ64U5RMTNB2oVpQie146/NQfZunfkwXTaX/YJsK/6K/IcAQbxX
gwaGO4Hj0rXZhaUnz6hOVUWjXkR0/2VoEHozSqr8RU3kUvHTyLyHk1CodorndEEe
RVaec01c7UCc+873hK1vqhsDk1x+jHacfNQl6QnyCxXZFa0sJ9G1s4tit45xtoah
7s6uCuVY2grYR8iMZMBgk3QMZasVPaaj018XmysfPTbofJ47S6r/Gu/Id9Fak0m5
cS2XgsboG/GoevmlgFjU1xo8XqLyK/MwI5epZjCsrhZ2fhHEcU5a3/nWE51E5pdq
4urnWhHGBKWV5Mq6I2Y9+8DHSaBX1p6erWZC02Amow7kGJzHS6NVUbndQYwEC19l
RJ37ynKDIHBI4hI7WKmA7se8FDRrXpY98T2uk1drFfJ156V5IaKbVS9xQ6Kxx0xs
A1/3emR8pjgF2Uj9/DFZNHpR0F91U3FkbBYQCy2P6hnGjjzQrkvJy/UVXCrnWOto
rhzkw2ewfXeMewN0oA6c8E+/ScdJ+9QR+/hpoTB86af5CZXuITxiJVJ8n68Y5O+a
BoPvNQi012c=
=MgRg
-----END PGP SIGNATURE-----

--=-y79bO+dXAfrUTi8nhRWP--
