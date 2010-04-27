Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab0D0Mub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:50:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39900 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0D0Mu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:50:27 -0400
Date: Tue, 27 Apr 2010 14:50:14 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Nicolas Palix <npalix@diku.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk
Subject: Re: [PATCH 0/4] Add a Coccinelle front-end script
Message-ID: <20100427125014.GD1775@pengutronix.de>
References: <1272316279-12042-1-git-send-email-npalix@diku.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OaZoDhBhXzo6bW1J"
Content-Disposition: inline
In-Reply-To: <1272316279-12042-1-git-send-email-npalix@diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OaZoDhBhXzo6bW1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 26, 2010 at 11:11:15PM +0200, Nicolas Palix wrote:
> New targets are added (coccicheck-<mode>) to call the spatch front-end
> in the 'scripts' directory with the <mode> argument.
>=20
> Four modes are defined: report, patch, context, and org.
>=20
> 'report' mode generates a list in the following format:
>   file:line:column-column: message
>=20
> 'patch' mode proposes a generic fix, when possible.
>=20
> 'context' mode highlights lines of interest and their context
> in a diff-like style.
>=20
> 'org' mode generates a report in the Org mode format of Emacs.

So, as I understood all semantic patches have to support 'org'?
I think this makes submitting slightly more complicated...

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--OaZoDhBhXzo6bW1J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvW3YYACgkQD27XaX1/VRsSlgCfYD2bj8JIAuDUIiTXRJzAKjbU
GEYAnjqaz2+6sP88PDvngiaDg4N0jAG8
=ogT9
-----END PGP SIGNATURE-----

--OaZoDhBhXzo6bW1J--
