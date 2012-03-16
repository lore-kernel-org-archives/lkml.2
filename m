Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965021Ab2CPLtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 07:49:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:48443 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965200Ab2CPLta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 07:49:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="129719145"
Message-ID: <1331898704.3730.62.camel@sauron.fi.intel.com>
Subject: Re: [RESEND PATCH] mtd: fix section mismatch for doc_probe_device
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Ryosuke Saito <raitosyo@gmail.com>
Cc: dwmw2@infradead.org, robert.jarzmik@free.fr, mikedunn@newsguy.com,
        ivan.djelic@parrot.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Mar 2012 13:51:44 +0200
In-Reply-To: <CADTWAOL7aBi64yimwPubAJ22=4AQ1BRjzQCahUXUsbSa1oJ59A@mail.gmail.com>
References: <CADTWAOL7aBi64yimwPubAJ22=4AQ1BRjzQCahUXUsbSa1oJ59A@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-PIgDge2J9j8q/w/YxN42"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PIgDge2J9j8q/w/YxN42
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-03-15 at 19:19 +0900, Ryosuke Saito wrote:
> doc_probe_device() is only called from docg3_probe() which is in .init.te=
xt,
> so it must be in the same section to avoid a section mismatch warning.
>=20
> Signed-off-by: Ryosuke Saito <raitosyo@gmail.com>
> ---
>  drivers/mtd/devices/docg3.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
> index 25f688c..db9a4b7 100644
> --- a/drivers/mtd/devices/docg3.c
> +++ b/drivers/mtd/devices/docg3.c
> @@ -1846,8 +1846,8 @@ static void __init doc_set_driver_info(int
> chip_id, struct mtd_info *mtd)

The patch is line-wrapped and not applicable with git am :-(

--=20
Best Regards,
Artem Bityutskiy

--=-PIgDge2J9j8q/w/YxN42
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPYylQAAoJECmIfjd9wqK0z7MQAK0vOwKH5171J7L3DZxFUUnH
eFF0qFcU/8vNh+B74L0M9x/SDZpaAN/cF7vKOLn+0uXwkb2fmLg9FQNc9U69D1y1
6DCKWuehF7khJt0lfdY6JCQL242K1tHra+qfIG1a8U9ouNBkIimbdbLR3mGcK0X1
F782snlKCoEF6cFlbuJ5dfRMzr7SLeNAKwq0F3OBitHv7CkN7ZTOPkvFJpwNlYv+
EO+Pd/d+aqpbZO41PGcpt4D4xrLyxM4cBSfzedTr1CQ3jTE41L0TXpQ3WtyNvhCa
GCCsu1g6PmjKdV2kIQK05X+RRg88OMoEY8ZFDQc4gufVDHN5MYXK2cZ+TN4UNXKd
tzbOZ146p16eY45vwEM/rn3gHY7LJ7TFmmlcg9Y/gPtfhX6NUs1uo9PyDScyUSDn
1xvZ9Amtr5FKK/IdG6zTsFgknVABQ9EzF3I0ns/YGoFFKkDM83mufz4I/OlAO93c
Ca55nLymxUEj3WYZ3XkPgI7jmfMeF1p56OYfzeiUKU0IxAEInEFFfrIBlWKxpqZM
yUttLvLpkOWCV/kzQOOKuRtkmYRhZF/b/gfHJzTO5T5q2K7oGBD2oTTT/G4Y9aeJ
eJ5xjXOt9hvHBEMMGwca0f3wPnpodmLQd7OU+hxB/Y3iIaHmSbz56fyfo8nfa/0a
qCT2kOZG/FpyyNAs7B2e
=tZSE
-----END PGP SIGNATURE-----

--=-PIgDge2J9j8q/w/YxN42--

