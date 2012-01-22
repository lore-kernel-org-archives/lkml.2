Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab2AVJCM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 04:02:12 -0500
Received: from www17.your-server.de ([213.133.104.17]:51821 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2AVJCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 04:02:09 -0500
X-Greylist: delayed 1775 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jan 2012 04:02:09 EST
Message-ID: <1327221144.1434.20.camel@localhost.localdomain>
Subject: coccinelle: semantic patches related to devm_ functions - Fatal
 error/Parse error
From: Thomas Meyer <thomas@m3y3r.de>
To: Julia.Lawall@lip6.fr, mmarek@suse.cz,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 22 Jan 2012 09:32:24 +0100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-D12tWzGmGh/6aGgR821U"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-D12tWzGmGh/6aGgR821U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Again I wanted to run all coccinelle patches against the latest rc1, but
I got this error:
Fatal error: exception Failure("plus: parse error:=20
 =3D File "/home/thomas/source/linux/scripts/coccinelle/api/devm_request_an=
d_ioremap.cocci", line 32, column 42,  charpos =3D 816
    around =3D '\|', whole content =3D -                              \(res=
->name\|dev_name(dev)\))) {
"

I'm using version 1.0.0-0.rc4.2.fc16.

bug or feature?

kind regards
thomas


--=-D12tWzGmGh/6aGgR821U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPG8mZAAoJEK2Y/UtDbsHs0HYH/iMrhd6qQjclWoH9pxHSa0CH
Eovi3EcLcZD6UUcFAAC3up7O5Bx9GoIhQi+UTV5NVtK4wv01t6spBd34zE7BBhxq
MYhknKrklVguPksgfkVc8TIgPJJhHFq0rps/YaMlk3j7BnPWE1qCYv5ejV4fKE11
l3ZvYQ8Qoy8KzbOxTnFhiU8JtU+CwpNmw6cDnUiNR1C/Jw2n5XzzMxiLoTuO8L9F
oEdjwls7kjswZ9IiGwJWqZ9JrIN5zLzpROGfINYbHifcPMxmy1QYdeZp1zr2Vxlp
Gon+yztRrTslg9tMAPYBj7LzyhfQyef7TZ4wwAzLcwtquU+zrm8hVrZLmd/tKpI=
=BYl8
-----END PGP SIGNATURE-----

--=-D12tWzGmGh/6aGgR821U--

