Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab2EHI6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 04:58:04 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:34253 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2EHI6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 04:58:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhEIAETfqE9bdWOb/2dsb2JhbABEhXKlAiKIDIEHgg0BBSMEQBIQC0ICAlcGiCWoCZMfj3GBGASmQIJr
X-IronPort-AV: E=Sophos;i="4.75,549,1330902000"; 
   d="asc'?scan'208";a="512209976"
Message-ID: <1336467480.3617.11.camel@fourier.local.igalia.com>
Subject: Re: [PATCH v3 2/3] Staging: ipack: added support for the TEWS
 TPCI-200 carrier board
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 08 May 2012 10:58:00 +0200
In-Reply-To: <20120508081549.GB18595@becoht-mvanga>
References: <1336463005-26234-1-git-send-email-siglesias@igalia.com>
	 <1336463005-26234-2-git-send-email-siglesias@igalia.com>
	 <20120508081549.GB18595@becoht-mvanga>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-YV8aIF88rZbId8JLgBJO"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YV8aIF88rZbId8JLgBJO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-08 at 10:15 +0200, Manohar Vanga wrote:
[...]
>=20
> Check whether the function exists or you could have trouble :)
> If you already added a check when registering to make sure this is always=
 non-NULL then
> ignore this. I would recommend wrapping this up in some function:
>=20
>     void tpci_slot_remove(struct tpci_slot *slot)
>     {
>         if (slot->dev->driver->ops->remove)
>         	slot->dev->driver->ops->remove(slot->dev);
>     }
>=20

OK, I agree that this is better and clearer.=20

I am fixing some minor stuff I saw (one extra newline in ipack.h,
convert to "static" some functions, etc)

I hope this will increase the code quality and readability.=20

Thanks a lot for your reviews,

Sam=20

--=-YV8aIF88rZbId8JLgBJO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk+o4BgACgkQWrfbyfmd9eJ5oQCfUFfWp0seLa/oR8BnxZTmAFR0
KjYAn3AT5FZcFzmihp78hwf0zE46p27I
=ypsz
-----END PGP SIGNATURE-----

--=-YV8aIF88rZbId8JLgBJO--

