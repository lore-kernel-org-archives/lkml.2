Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab2ANPJj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 10:09:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45819 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab2ANPJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 10:09:38 -0500
Message-ID: <1326553866.14299.0.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] ubi: Use UBI_LAYOUT_VOLUME_{TYPE, ALIGN}
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Sat, 14 Jan 2012 17:11:06 +0200
In-Reply-To: <1326214623-15938-1-git-send-email-richard@nod.at>
References: <1326214623-15938-1-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3/FcbhsEN29EQGTtC5+2"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3/FcbhsEN29EQGTtC5+2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-01-10 at 17:57 +0100, Richard Weinberger wrote:
> UBI_LAYOUT_VOLUME_TYPE and UBI_LAYOUT_VOLUME_ALIGN are currently
> defined but not used.
> Use them at least once. 8-)
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>

Hi Richard,

This will break backward compatibility - older and current kernels which
do not have this patch will error out when the find a volume without a
name. The right way to do this would be to change the UBI format
version, but you would need a really strong reason for this.

--=20
Best Regards,
Artem Bityutskiy


--=-3/FcbhsEN29EQGTtC5+2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPEZsKAAoJECmIfjd9wqK0fY4P/0g1HtmhvU7arCT/8wpQYFPT
28Jre5pVEG5ULI2/anuN9u8Ch2AsuhBn4jwAigQPSGQA3O9oqq8A88yLiXpjIQrv
JaukR3TTVbzg0Mu0yzPE9ol3OZo4Wzvgqff/YbbpuWEijP2z8HnoOZMWPfZkY2jd
LM++tVwiL0YiyK34yagKUKlz4ErcdFN9AXNqmPxQealoaVB3UDBmX+3M6JMeXFVN
8ZDqzTkBA79Vbu4nLwyT7+dZ9K7RASBQ2g5iCqE2WhxrjuqKGX6oFqcuVg2sIeh9
Y9j6qqkAlIFavw/UqLyzeKBzgZCqy0nBJaV5Qhp//B5E20c792HXL1nqwMDsnGjg
yB1/VEbEKVzZtLyCCcW1v7ecnOZ6q2XT/NM/vq0YUM1ra8MZFHwhVsNsI2PA76ZU
tJBZoEup3s15JN14L3Byv8HLD453RA6oaEt8R3UiVElbr3Z79qwnwHX4KEj7B92Z
qmTJXBFyvzffSi+KaIbjEtBpnNC7i3JUpcAfYADBi7rnMqYdcHeKiy3EMR9ZHR7B
9KeFgckpKaUPV114f/a3Wl2BvkWNWaFQsmUHoDUVatf6j5qblbqLjHVWyd8D3TOQ
HEJePjKSkTnSQ/mV/mw79eVwLs6pTSKH+ffrTqwT6UMOnz73XYPVVu5GnesGNShW
XVVIscXmun74tvfVOG3Z
=I31S
-----END PGP SIGNATURE-----

--=-3/FcbhsEN29EQGTtC5+2--

