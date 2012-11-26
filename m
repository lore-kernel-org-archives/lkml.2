Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab2KZApq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 19:45:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56077 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753770Ab2KZApo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 19:45:44 -0500
Message-ID: <1353890730.4266.25.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] HID: hid-input: battery quirk for Apple keyboard
From: Ben Hutchings <ben@decadent.org.uk>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Ortwin =?ISO-8859-1?Q?Gl=FCck?= <odi@odi.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, stable@vger.kernel.org
Date: Mon, 26 Nov 2012 01:45:30 +0100
In-Reply-To: <CAHdPZaNmODLfRJoJ-vt8PEQT+3n8p1CqXsZf3TUJV7pBgA8jEg@mail.gmail.com>
References: <50B22662.4070503@odi.ch>
	 <CAHdPZaNmODLfRJoJ-vt8PEQT+3n8p1CqXsZf3TUJV7pBgA8jEg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-s1b09CRTnUNKd9Xf8Vsl"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-s1b09CRTnUNKd9Xf8Vsl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-11-25 at 09:13 -0500, devendra.aaru wrote:
> i think you should simply do a  cc: stable@vger.kernel.org just right
> above your signedoff-by, which is the way that stable patches gets
> into i think.

It's OK to cc stable@ when submitting a patch, but that line must be
included in the commit message to ensure it actually gets considered for
stable updates.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-s1b09CRTnUNKd9Xf8Vsl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULK7que/yOyVhhEJAQpk6g//f0w3XmMQdiStZ0un5cAurSqiOnLpHKun
NCTBHbEOrTbKMJCR2kDf4AEpNnItqt0U5SPUp0MlTfNqQ4OpsbKIB4ATy9bRwW7R
HwpHbfiaXvYFDtZupB1E6m+XAffsEyrP/Zn3rfVPaVNPykfgClVMK+YETDPNrsfF
qrVaKCLLyOxDI6hXmK0NexyrK+kPr6mEg5UaG3j50rrjzmkh1t9ZRlvpuLxiSgau
eRCcUiLEc0Q9bBVEcYeEVLh0nr1VC1wOqlnjc0z5C4n9njHnbJkt9ifUCuRysphP
y3o6Q179Ab6MlL+c8SUTMaia/rK9vOPaQqIZoUL7C7xcJeRFjM+JMmqbSfV2wqfX
tlKakMGNFztMmAXuqN8AJU/lazWoMx+U3kJPbIzwLgoD8bRQOwwzeqJwdQVr1xVh
3vl9pcZxeWos0PL0mlQO7wB8Stqhvj43dK/fCSl5mNq/dUGBAuuUgLGsDd5jnhji
s1iS/EBRQIgpNy2ni++LSNRzvPQQaaf/jQXTxmC6tS/O3IRDKH+yjnPKUCL0vEEt
meMsw5v8mRQflVVMIYn+1R9I6O5gsC/z2yvh8kpyJctsyM1irnd6mZYDw41Og3dp
v7ZpXVXSN11FCN3pJKZevEFbCzAN5KKKJDJJOpW4ujQe95ShrPLxhUVctP9rXsOJ
hNCEWKYNQRE=
=oLQb
-----END PGP SIGNATURE-----

--=-s1b09CRTnUNKd9Xf8Vsl--
