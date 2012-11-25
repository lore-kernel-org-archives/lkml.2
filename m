Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab2KYNHk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 08:07:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51385 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752811Ab2KYNHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 08:07:39 -0500
Message-ID: <1353848853.4424.3.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Missing signoff for 'module: fix out-by-one error in kallsyms'
From: Ben Hutchings <ben@decadent.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 25 Nov 2012 14:07:33 +0100
In-Reply-To: <87ip9a0wi6.fsf@rustcorp.com.au>
References: <1352775711.16264.96.camel@deadeye.wl.decadent.org.uk>
	 <87ip9a0wi6.fsf@rustcorp.com.au>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HW8CuMCDc2qaJc5pBzK8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 163.5.223.200
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HW8CuMCDc2qaJc5pBzK8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-11-13 at 18:23 +1030, Rusty Russell wrote:
> Ben Hutchings <ben@decadent.org.uk> writes:
>=20
> > This doesn't have anyone's Signed-off-by:
> >
> > commit 59ef28b1f14899b10d6b2682c7057ca00a9a3f47
> > Author: Rusty Russell <rusty@rustcorp.com.au>
> > Date:   Thu Oct 25 10:49:25 2012 +1030
> >
> >     module: fix out-by-one error in kallsyms
> >
> > It's a bit late to fix it now, but maybe some kind of an automatic chec=
k
> > for this would be a good idea.
> >
> > Rusty, can I have your signoff for stable?
>=20
> That is weird, but you're right.  I changed workflow recently, and it's
> had a few nasty side-effects :(
>=20
> That was supposed to read:
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks, I added this in the commit message for 3.2.34.

Bne.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-HW8CuMCDc2qaJc5pBzK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULIYFee/yOyVhhEJAQofVRAAiFvo3675QO1QKVX0oZSsxiX4ZZnOo6Qc
BRPFK46X3BVxTTfu8X2foCSvyqbs7Z2UIIfrxLCQ7X5o+KL/ieME6rpXHfC4LQSc
Bh+RfhtcAPKscYg/xO70PAkOuLhpFxrwKrKXYX9m18Kkw2g6oRTLZ5EoujvMsg47
BX+OWUbMnqDeT/fwGY5lKnkce+mdDJY+b/3MjNUVmDb5vx07u7VEZmsVQkU6LkUb
XvIi6KlFhL0R6IDMDMPL6eFW63BE1ZjgisY8X4fnMFlmONqAlejQbZB1t/0FbuLW
dW7beeWWEtI8GpEkMCrq1MnOa0QDrWkG2w6WM7onBDU4jkXuPZ2vvZbG5guYgdNn
ygnJmUGdprwV5X54NVytZeygAjowsxglXhLBOr8UBnC6hgZuMVY/knBlSS86MuUk
Sgd12HGy9Xj7eBMipW6Md98zQFfKRgBKRdbl3BLUKS0mp2zdBS9uhvmWXZjktSW3
A8nenlus4Obks8rsFvMTHEx6mqeCA7hVMMTUpYOVTRPilABPS8mJArtl3da002ta
RPS07nOQZWQQmVtS8MpAFrTA9m9148r3X9dZGuGMEC9H/Tpetdl/cMUGMvXbQEiN
bcwLwej375h/4Zd6LTr7SFUa6p+B4Di+uKaGfocrDoZ+MR5KiLTfWax4VDmyITYI
oQTMfJP1gbs=
=3ujM
-----END PGP SIGNATURE-----

--=-HW8CuMCDc2qaJc5pBzK8--
