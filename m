Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab2ISFk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 01:40:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56233 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2ISFk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 01:40:57 -0400
Date: Wed, 19 Sep 2012 07:40:50 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] gpio: Add Avionic Design N-bit GPIO expander support
Message-ID: <20120919054050.GB611@avionic-0098.mockup.avionic-design.de>
References: <1347958630-19672-1-git-send-email-thierry.reding@avionic-design.de>
 <CACRpkdY9XK0mN30wk93BFhZ4yZgc-4=Ym5X108OeNQYNrQogQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <CACRpkdY9XK0mN30wk93BFhZ4yZgc-4=Ym5X108OeNQYNrQogQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:uMIxi0N0zI3tlIxz6xJ1IDw6VmSC/mI8yOTQf4sRcNL
 DVoqduTxAuXBXT5+1fl7JR5VdN52EcYUi/1Fvbyda4JlwAGlCr
 jg+Vq2gWiFFJLzKswdFpAvJ3itkAXkW3YLnFk1xuLxzpIlPHEs
 kAI0pH6Fy5KEZjCuljjNgdfBNyCHb+o0BxgTyXXKRoYbMo3HPN
 doMmFZ7ydW17EmmPwHpSji45B5Xr3lF8oUlMRaHsQFu0b5Ou8I
 gaxRaWbcb2iTJmDWiEoL3RfNTgUd+jUtbn6t1PJvkN/FZ3NLAI
 XPFU5o58qx6hbs5T46opbXt+2g/F5qdYa55vwBXFDHoHZO71vs
 jZsMH07O2UGBu25Yv7fdfMgVQuV+0hefBOHoRIAtVin5wWgczt
 5KlDqRfJ2Y0gEQqivQQDRaCOY2padd48lQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 18, 2012 at 11:29:46PM +0200, Linus Walleij wrote:
> On Tue, Sep 18, 2012 at 10:57 AM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
>=20
> > This commit adds a driver for the Avionic Design N-bit GPIO expander.
> > The expander provides a variable number of GPIO pins with interrupt
> > support.
>=20
> And you followed up on absolutely everything I commented so how
> could I resist this patch ... applied with Rob's ACK!

There's this one issue that was discussed in the GPIO binding update
that I posted earlier and I was going to send an updated patch and then
make this patch reference the documentation but I can just go and do
that in a follow-up patch as well.

Thierry

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWVriAAoJEN0jrNd/PrOhPpoP/irc+45R0dQMnNiW4iFbmUd3
yK9ADFhylnpyfEbtq9LdnxRybQ2bgvwz6IP6lWMPUT7jCsPx9Y4bU0hZNV7DJXuA
0EkYmfGSH8yXQOt0bT7CQGBS+bpKxP0Kt1rtZbHuxZUC8s9elJY5F6F3lHUFTpFQ
yYUPqN0INXrfK+JJLdFK+JDi7R6zxEuxTk/EQ0bUkzXTalE6BtupfFc4d8CdURsq
ad6ntRc4Gm/QlkmrHKxX7wM5+o7K+n1RwXqmuxsVqGApKDb41nLv61COJxxgUxoa
2qGvbpuvJ+W/ZPL5b1hkbmx5fMYVUxbM6z+zkJj5uwT0vKfdHNaZGTAxdfWcYEfA
yQzZlCpVv0bs0aWT3zG8I+5yFjNe7eBsjzLO74FwuBD2EjG/4SqZhN3GX3fd+R2b
lZSN7eQ9FogoulzoHa79dPU5RzBogG9g03JzVy/PjLcOomE+ISgUAC9gvATT3fMC
J8Qk7/9cFIue38ImePG4Mx1Wd8fW1f0gdLVwcbRqN7Qt1xK8IPFJiMwHX6V7GJBI
DQE2l0Dav2J4BzTn3cMtRGkvrxoEDvSmSCErYhUXhdCu4xBaw6UJdQbEmT3DwEme
CK1fcqN0y9/4Geu4rZdhUl4CIHz3TDP/QRja+qZYIuOMmgC9KEAuRfrkA1fzMK/A
SEhVRkrlwR9TNYje5PDt
=B6Km
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
