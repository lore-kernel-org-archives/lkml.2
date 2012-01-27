Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2A0Gg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:36:29 -0500
Received: from pyr75-3-78-192-68-46.fbxo.proxad.net ([78.192.68.46]:50419 "EHLO
	molly.corsac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2A0Gg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:36:27 -0500
Message-ID: <1327646199.2254.1.camel@scapa>
Subject: Re: [3.2+] BUG: scheduling while atomic: swapper/0/0/0x10000100
From: Yves-Alexis Perez <corsac@debian.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: balbi@ti.com, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Date: Fri, 27 Jan 2012 07:36:39 +0100
In-Reply-To: <87hazi56rw.wl%kuninori.morimoto.gx@renesas.com>
References: <1327587732.2296.25.camel@scapa>
	 <20120126161539.GA2098@kroah.com>
	 <20120126163130.GB8665@legolas.emea.dhcp.ti.com>
	 <1327595767.2062.7.camel@scapa>
	 <20120126164512.GD8665@legolas.emea.dhcp.ti.com>
	 <87hazi56rw.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-RoyUz6hNfZ3n1D4mkveB"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RoyUz6hNfZ3n1D4mkveB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On jeu., 2012-01-26 at 16:27 -0800, Kuninori Morimoto wrote:
>=20
> I was very much surprised at this issue.
> As Felipe explained, renesas_usbhs was for SuperH system.
> x86 can not use it,
> but, if your PC has "renesas_usbhs.ko" as kernel module,
> and loaded it somehow...

Then I guess I did something wrong at bisect time (wether the first or
the second). I'll try to redo it and report back.

Sorry for wasting your time.

Regards,
--=20
Yves-Alexis

--=-RoyUz6hNfZ3n1D4mkveB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJPIkX3AAoJEDBVD3hx7wuox2oP/2bPlPtZe8EVsHvayWIyPf+d
ol8vEQH3kAUFornOH2MBqb2IZ8+bESmufmVB6gaqhai2l3AaVrCiKFgWTBGpi4AN
cUOj0gKQCjTijXqa7OPZJ4fxI4fJIzOuieHBxW+tcY0QiqEewyVKU/WEHdhr5Ww5
RDkYZY+jonqPkCD2FW1NXSUsqaXkMouyQuAwJ8IyTeFezpBBy4CS9F+ISC7Hs1O3
dCf+CWguaSbC2i7+gCpInefAf3TYh5wdOuKU5meLZOGOiEVsCwQmHPObTGU3VPAI
+EC8g9THDQkvmr7VQG96GO1HRC1pWTiFAnuxbiYOq8X6OA4zehkEYg2yYpPcSGt6
Ehz+bcUYtSD6HZHQHvJ13scCBkoKKUBbejLNw6Cu5U/y41n1f/n7hyU/9tDQ0xJh
l2du0eXGiI7n4RFYUnX+cyAl7IjyosvTdHKbfSJncP2ERwkm+xok6dU4Oc8V1TlU
kJlo7pQafXwt7uVTsvYwRA+Hq7ms5ClZwDSAVYxvGJ4R3K0zDA4v1jn4fXN+ZnrB
VydbNu2PgShKcVgBcmx/rx5o+0jYrWUq0sSv6Va+m1QHsxM90eK+VsRxCubCD5oM
i7KW9Cx4seEUXt2Bf1s2BnpW4xHxMdNqgEKHoP24FYu6hGmFzpc5bSWthyti8/nf
/rV9yNC9Qv/6DjLJYeN6
=FgKx
-----END PGP SIGNATURE-----

--=-RoyUz6hNfZ3n1D4mkveB--
