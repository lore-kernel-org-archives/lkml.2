Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab0IWQ61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 12:58:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38450 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab0IWQ60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 12:58:26 -0400
Date: Thu, 23 Sep 2010 18:58:21 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH 2/5] Add mkcis - a program that can create .cis from
	text description
Message-ID: <20100923165821.GA1343@pengutronix.de>
References: <1285255197-9262-1-git-send-email-dbaryshkov@gmail.com> <1285255197-9262-2-git-send-email-dbaryshkov@gmail.com> <1285255752.10687.20.camel@i7.infradead.org> <AANLkTi=eZEAt4EW6TjHE+YBYNtXcX3uPbUbdL2uNjS6=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <AANLkTi=eZEAt4EW6TjHE+YBYNtXcX3uPbUbdL2uNjS6=@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > We should be concentrating on the linux-firmware.git repository instead.
>=20
> Should I redo this patch serie against linux-firmware.git (probably with
> just putting .ct files near .cis)?

\o/ That was on my todo-list for "somewhen", too. Thanks!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkybhy0ACgkQD27XaX1/VRseNgCgot0HBhkY8M/pxtFbRGSLV3Ws
NaQAn2i65dctcS++sk5jqCPn0kpdx8Cf
=h2Yn
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
