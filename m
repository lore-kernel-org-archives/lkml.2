Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2LCNjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:39:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43139 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754188Ab2LCNjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:39:08 -0500
Message-ID: <1354541935.7030.20.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] stable: uio: Fix warning: 'ret' might be used
 uninitialized
From: Ben Hutchings <ben@decadent.org.uk>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitalii Demianets <vitas@nppfactor.kiev.ua>, Tux9 <tuxding@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 03 Dec 2012 13:38:55 +0000
In-Reply-To: <20121203074116.GB7723@local>
References: <201211271348.14603.vitas@nppfactor.kiev.ua>
	 <201211291836.59358.vitas@nppfactor.kiev.ua> <20121129235822.GA2590@local>
	 <201211301316.19217.vitas@nppfactor.kiev.ua> <20121130213906.GB2603@local>
	 <20121130234331.GD17353@kroah.com> <20121203074116.GB7723@local>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-WdumoBfeaFYtEZZe3os+"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WdumoBfeaFYtEZZe3os+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-12-03 at 08:41 +0100, Hans J. Koch wrote:
> In two cases, the return value variable "ret" can be undefined.
>=20
> Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
> Reported-by: Vitalii Demianets <vitas@nppfactor.kiev.ua>
[...]

This is not the correct way to submit patches to stable.  See
Documentation/stable_kernel_rules.txt

Ben.

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-WdumoBfeaFYtEZZe3os+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULyrb+e/yOyVhhEJAQrGAxAApljLL6PVWMJ1hwBEOtiF1CPOvSxmfn5x
q6TCHSZ8+XZ0hcZdRMJQ0wP7z/+oQ8A43Fv3VIyclYNChBrb/mnuJXUK6wDPNKia
Xk5btxShubLjD7eaVVdXVb7w16ywqsZ3Wtj/tLENVPtnNH2rBZqu5l3rjmLU6M+z
dtUBb+QxKB8J7zj47l17DiClN7tnRDJ09RGVuEX1Hpp90i6ymsSEvRZ5M9nD7T4s
3Oe7Q73ECENWoWlwV8R1I4IZBlnyjWsr73z6j0ulXf9y6Rj98Pw0P9hc+Krv7yl3
dbXxfDT74N/y/UOYqV+2M+VM0mi2G5cUVPmILDGcbctDzapJspYyC8OnIG3i/GBj
c+2O40Rnf5btwl/aNvwtBXERJ+Wl42AYotm3XYD1cHQq2b4egxekHAB6vhvIodJ4
ikhGLvHk4jWwOedAMq+2Omm8UGBJNdzySRQB0L06/BpRxuOSKAUQvnfnL4viN4Fs
0xZ+NFEPOp0bppXnaMkT0gKa3K2lOAvhwp7HxxiXRhAagAZdMqN5fi+4pLafVodG
GePIgIM56S3IU5smWHdku6B92SkixoSoDY6NFLjnjP6nPaYKu5tPtSc/WhquLYeD
6lLQyRSw8F39LhyqVG6GQpFVptPCh6q9ja8ZPyCHQUl519jJBKQ2tll2CCIbIloe
iDEYbFZL0ns=
=brz8
-----END PGP SIGNATURE-----

--=-WdumoBfeaFYtEZZe3os+--
