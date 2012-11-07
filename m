Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab2KGSc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:32:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54623 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab2KGScY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:32:24 -0500
Message-ID: <1352313131.2751.152.camel@fourier>
Subject: Re: Why Cypress does not upstream its trackpad driver?
From: Kamal Mostafa <kamal@canonical.com>
To: Ozan =?UTF-8?Q?=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, customercare@cypress.com,
        mario_limonciello@dell.com
Date: Wed, 07 Nov 2012 10:32:11 -0800
In-Reply-To: <CAFub=KTf2dWxM9=saG2JaNJpEioJM8rM3UBG9BkyxRN-+j0psQ@mail.gmail.com>
References: <CAFub=KTf2dWxM9=saG2JaNJpEioJM8rM3UBG9BkyxRN-+j0psQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-eGUy8kikrRFp8YNAMi7Y"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eGUy8kikrRFp8YNAMi7Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-11-06 at 17:47 -0500, Ozan =C3=87a=C4=9Flayan wrote:
> Hi,
>=20
> This driver [0] was written with a cooperation of Cypress, Dell and
> Canonical Engineers within the last 3-4 months. It is very nice that
> Cypress as a vendor cooperated with Canonical (Because Canonical works
> with Dell for their Project Sputnik and Dell XPS13 is used as the main
> hardware for that project and Dell XPS13 has this type of trackpad,
> Bingo!), and I am also glad that Ubuntu users benefits from this
> driver.
>=20
> The driver brings multi-touch scrolling, disable-while-tapping and
> makes Fn+Fx touchpad disable/enable work for not only Dell XPS13 but
> for all laptops having this trackpad (My Lenovo Ultrabook U300s for
> example, I tested the patches on fedora 17's 3.6 kernel and it works
> quiet nice)
>=20
> But what I am not getting that why NOBODY from Cypress/Canonical/Dell
> isn't bothering to push this driver to upstream?


In fact, Canonical is working on preparing the Cypress PS/2 trackpad
driver for submitting upstream.


> Is it too hard? I don't think so as the patches are quite non-invasive
> and small.


Your estimate of the work/risk involved not withstanding, I chose to
deploy this experimental driver in stages -- first in the oem-specific
"Sputnik project" kernel, then (recently) in the main Ubuntu kernel,
then finally (soon) upstream -- so as to minimize regressions while
shaking out the bugs.  For example, the version to which you linked does
include a regression (breaks some ALPS touchpads) which we discovered
only after deploying in Ubuntu.

I expect to submit the Cypress driver upstream within two weeks.  Of
course, my work on the driver is (and has been) publicly available[1].

 -Kamal Mostafa <kamal@canonical.com>

[1] The latest version of this driver is represented by the patch set:
    http://kernel.ubuntu.com/git?p=3Dubuntu%2Fubuntu-quantal.git&a=3Dsearch=
&h=3DHEAD&st=3Dcommit&s=3DCypress+PS%2F2


>=20
> Is the only distribution around is Ubuntu?
> Is the only laptop sold in the world is Dell XPS13 with an Ubuntu?
>=20
> I'm not trying to be impolite but it hurts me to see that a vendor
> produces an open-source driver for its device but makes use of it only
> through a specific distribution.
>=20
> If Cypress is just beginning developing open-source drivers for their
> devices, I hope that after this mail they will be much sensitive about
> the issue and push their drivers even before the release of their
> devices to make user experience flawless.
>=20
> (I googled and searched the archives of LKML and linux-input but
> couldn't find a discussion or patch series about the driver. If I
> missed it, ignore the whole stuff above)
>=20
> [0]: http://patchwork.ozlabs.org/patch/178903/
>=20


--=-eGUy8kikrRFp8YNAMi7Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJQmqkrAAoJEHqwmdxYrXhZBLoP/1N8Arw1pvjjLEkjJd2qbdCw
FSvaA5ThZqUBDas5exNHXBq6OBDw3fvGaNwhvdi4FHc4qZk2CZSiFhM6z2KPSTgw
YVfVJjj5n9ecclODSG8KU0r6McY/LnSRhItQcsB7qfT94yxdfNS+xkZJUc0ohQhc
y2isDtHo7aXYKp9C10K/0wPAQe1shVLftw9jYcjc6rAjph51ii/wWLwajgk9uZnQ
0Xr1sEnHDf+SwIXS+GBjNCxQZYl2v7MrTueZA8I8Z1NQY4xkBG5kidgP5IGNEWAw
C/x8ZctNrp+4OhEfVpiZyP4UTezz8mY0e7o0o+OBRvyPsih9ZjTWEYtJJQP86xFT
xeXMCxoFFlc6rwr5AfDJguhh5ZJ+7/j0JugFhJDMqxlIgYYoDwVj1bhWjm307ha1
+jF6WJMV8+JQr8QY78B3SMJbYDZ3n/f1nyQCeGs4h9YUTegUs1TpwiTQZ9Fr3gkh
s7d3GXG71vAK/WIvWxeNtLNa00mtfoqIAEWGuHQJ2LrRa4Oj9NtrI8yja5Fb11Xs
9iP5M3pBxSIm6BtPI3e6u3crfjGCg78tphpRZuAWSTVBGJ5i8UI+6zYp76bk19o0
kBEOvakdm/WFJFsI4Uk7p2RsHtOvYZVz76yWp3DCLAJxo4dxHA8Lns8/7okCYWZC
mIXn5WQf3rGYQAoiq+ke
=HrpC
-----END PGP SIGNATURE-----

--=-eGUy8kikrRFp8YNAMi7Y--

