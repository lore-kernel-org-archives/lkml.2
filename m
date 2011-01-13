Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab1AMWqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:46:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42201 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab1AMWq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:46:29 -0500
Date: Thu, 13 Jan 2011 23:46:27 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Tony Finch <dot@dotat.at>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] strncpy() will not \0 terminate result
Message-ID: <20110113224627.GA15000@pengutronix.de>
References: <alpine.LNX.2.00.1101132332430.11347@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1101132332430.11347@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 13, 2011 at 11:35:39PM +0100, Jesper Juhl wrote:
> Hi,
>=20
> Mpass() in scripts/unifdef.c has this code:
>   strncpy(keyword, "if  ", 4);
> this will fail to \0 terminate the destination.
> Following patch should fix that up.
>=20
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thanks for fixing those issues. If you could spend a few more seconds on the
subject line (missing sth like "scripts/unifdef"-prefix; I initially was
fearing the bug was in lib/string.c) and the commit-message (which reads li=
ke a
mail), that would be helpful for reviewers.

Kind regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk0vgMMACgkQD27XaX1/VRsS9gCfQS+lSesLm1K5JdGVNMBYeYzv
BIsAoLxXQ0MJf+K04XWZO6ciN9hOBwCR
=yB+W
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
