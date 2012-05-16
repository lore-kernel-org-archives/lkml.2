Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab2EPObR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:31:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:16164 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab2EPObP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:31:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="141293985"
Message-ID: <1337178865.24809.62.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] ubi: add volume id and LEB number to struct ubi_scan_leb
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 16 May 2012 17:34:25 +0300
In-Reply-To: <alpine.DEB.2.00.1205161419590.27131@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205161419590.27131@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-0OWHzhopbHo/IzpuYDuv"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0OWHzhopbHo/IzpuYDuv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-16 at 14:20 +0200, Joel Reardon wrote:
> This patch adds the volume id and LEB number to struct ubi_scan_leb when
> scanning the LEBs at startup.  PEBs now added to the erase queue will kno=
w
> their original LEB number and volume id, if available, and will be -1
> otherwise (for instance, if the vid header is unreadable).
>=20
> This was tested by creating an ubi device with 3 volumes and disabiling t=
he
> ubi_thread's do_work functionality. The different ubi volumes were format=
ted
> to ubifs and had files created and erased.  The ubi modules was reloaded =
and
> the list of LEB's added to the erased list was outputted, confirming the
> volume ids and LEB numbers were appropriate.
>=20
> Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>

I've added this code to the joel branch. But please, test this and other
UBI merge candidates with all the UBI debugging checks enabled as well.
Similar to UBIFS.

Well, I mean, I am willing to merge this feature upstream as soon as it
is in good shape, even if your crypto code is never merged. So testing
with debugging enabled should be done. For various small patches you
send which will land in the joel branch - I do not care much - test with
debugging enabled just sometimes.

Anyway, this patch is in "joel", once the whole features is there, I'll
move it to "master". So you could give this feature more priority for
now.

--=20
Best Regards,
Artem Bityutskiy

--=-0OWHzhopbHo/IzpuYDuv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPs7rxAAoJECmIfjd9wqK0kkwP/0MSWfli5DqFwvNOqItu0igZ
5sJiUClvF0XTushxHblIRB/6tOh1VQ6RZzCz5/LyCJNcZn3qrKQN6lUS+9nJFkVV
5Mlv8iHMzp37PUAf8uDCbCKRrEfy2fTRm3S1G+x01ldi1S/cwfA47ptX/IxoODlD
lh0AGBtOgCd6Fm52pSviHIEaNQJb1qFYAu+dYOjZwJE2c+BCpTPnneZ790T0DQR3
9KihpjjtbY46Af6EbYT0yU+760F4VvW4WChtGL7yvL4LF/QZYEdvklo3oYSB5KBO
Op5Xog2R/I9dUY31I3CS7EpinOlw2KNIdW5iKBxrU66OVGt6oAQzlz97KjcfzqrJ
4leqaCxXnB56gvcQWMRfrCrMCs+weUh6Ve/G3QvAnoPKQn+G+b5aM/xSc7ikj+T1
gttfCn8wTPalXXDGyWMNOs29uJq4kcRaicxXapkFwYsVdBSB3lraccHaZ8Ox1FFg
Aiyd/kNiohI9OGrUI1xywU7SU+yc75G2ZQ1FHmdmYzEAMGc+5XasqtguXzqdIRB5
rgn/NzVLrxYGE7z56hfJtGe1FVCTj+Dw5ZGi1nejRkqjJ4tYxkCqbVmDCO/mhtX4
AkyswETkLD2zAwKfu+d5vEtaVX+zzaLrRqEVrCJ+0eYrw0GjSQxZ/xJfnbJlNHMk
j1rMSM+VQ/yvewWtLF2H
=ia8j
-----END PGP SIGNATURE-----

--=-0OWHzhopbHo/IzpuYDuv--

