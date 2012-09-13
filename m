Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2IMG6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:58:22 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:53354 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab2IMG6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:58:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtQDAHqDUVBbdWObgWdsb2JhbABFhgetVCKHcyIBARYmJ4IgAQEFI1YQCw4KKgICVwaIJKhskx6QNYESA6hm
X-IronPort-AV: E=Sophos;i="4.80,416,1344204000"; 
   d="asc'?scan'208";a="950892753"
Message-ID: <1347519565.4539.204.camel@fourier.local.igalia.com>
Subject: Re: linux-next: manual merge of the staging tree with the tty tree
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Jens Taprogge <jens.taprogge@taprogge.org>
Date: Thu, 13 Sep 2012 08:59:25 +0200
In-Reply-To: <20120913161417.e863926832ccf8a2e1ca1f2a@canb.auug.org.au>
References: <20120913161417.e863926832ccf8a2e1ca1f2a@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-eHl5SjLDu0NzvaWtd2qW"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eHl5SjLDu0NzvaWtd2qW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-13 at 16:14 +1000, Stephen Rothwell wrote:
> Hi Greg,
>=20
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/ipack/devices/ipoctal.c between commit 734cc1783816
> ("TTY: use tty_port_register_device") from the tty tree and commit
> 2afb41d9d30d ("Staging: ipack/devices/ipoctal: Check tty_register_device
> return value") from the staging tree.
>=20
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).
>=20

Thanks Stephen.

I don't see tty_port_register_device in any header file in staging.

Is it defined in tty tree and it is not merged into staging tree?

Best regards,

Sam



--=-eHl5SjLDu0NzvaWtd2qW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlBRhE0ACgkQWrfbyfmd9eJnagCbBjiZFwVBJlm2CP3O/oOdBoFu
izIAniZbwm892Djx6prAfJyObVNh5lKl
=wora
-----END PGP SIGNATURE-----

--=-eHl5SjLDu0NzvaWtd2qW--

