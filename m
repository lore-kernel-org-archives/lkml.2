Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab0IYHdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 03:33:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40747 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab0IYHdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 03:33:45 -0400
Date: Sat, 25 Sep 2010 09:33:42 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH 4/5] Add an utility to parse CIS files to readable form
Message-ID: <20100925073342.GA31947@pengutronix.de>
References: <1285346965-23499-1-git-send-email-dbaryshkov@gmail.com> <1285346965-23499-5-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <1285346965-23499-5-git-send-email-dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 24, 2010 at 08:49:24PM +0400, Dmitry Eremin-Solenikov wrote:
> Import from pcmcia-cs project a dump_cis utility. It reads
> machine-readable CIS file and output text representation (which can be
> processed by mkcis utility).
>=20
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

pcmciautils also include dump_cis ("make debugtools"). As this version is
probably better maintained, we probably should not introduce a split here?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkydpdYACgkQD27XaX1/VRu2IgCfQPo52k1W2Hnrbt0OsxBb/UC4
2NwAn1tcCXayVnC5Vi9WLkgRHxHFYu2m
=OMH6
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
