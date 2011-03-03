Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1CCIMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:12:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39338 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1CCIMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:12:00 -0500
Date: Thu, 3 Mar 2011 09:11:56 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jinqiu <crindy646@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] Fix bug #13853: dereference pointer 'dev' before null
 check
Message-ID: <20110303081156.GA14163@pengutronix.de>
References: <4D6EFAE5.4000400@gmail.com>
 <4D6F01DA.3040307@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <4D6F01DA.3040307@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> Don't ever mention "bug #13853", because this number makes no sense
> for everyone except you. A proper subject may be:
>=20
> [PATCH] ariadne: fix possible null dereference.

I agree for the subject line. Still, in the body or maybe after the "---" I=
'd
think it makes sense, so it is known there is a bugzilla entry to close? Al=
so,
using search engines, one will be able to dig up the patch.

> And please send your patches to proper maintainers and mailing list,
> David Miller and netdev@vger.kernel.org in particular.

Yup. Using scripts/get_maintainers.pl is the way to go here.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1vTUwACgkQD27XaX1/VRtL8QCbBLdYFJWdScq4NH5wfa08kOIP
IW8Anj/zjrh2eSGxHpnT18ces1Z3fUdl
=UV2v
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
