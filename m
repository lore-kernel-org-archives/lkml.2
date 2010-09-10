Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab0IJJqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 05:46:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49124 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab0IJJqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 05:46:43 -0400
Date: Fri, 10 Sep 2010 11:46:33 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
        "Stephen Hemminger (role:commit_signer)" <shemminger@vyatta.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100910094633.GD3865@pengutronix.de>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
 <1284111767.1783.35.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9dgjiU4MmWPVapMU"
Content-Disposition: inline
In-Reply-To: <1284111767.1783.35.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9dgjiU4MmWPVapMU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 10, 2010 at 02:42:47AM -0700, Joe Perches wrote:
> On Fri, 2010-09-10 at 11:33 +0200, florian@mickler.org wrote:
> > The script get_maintainer.pl is a very useful tool for deploying changes
> > made to the kernel. Among others it searches not only the MAINTAINERS
> > file but also the git history for people to send patches to.\
> []
> > By appending a  a note of the reason for the cc in the name, the reason
> > becomes clear and the receiving side is relieved from feeling obliged to
> > check the patch  while the sending side has a chance to adapt the
> > cc'list to their liking.
>=20
> I don't like reading annotated email names myself.
>=20
> As the coverage of file patterns in MAINTAINERS is
> now pretty good, the --git results are less useful.
>=20
> I'd much rather turn off --git as a default, or change
> get_maintainers to add git signers only when there's no
> specifically listed maintainer for a particular file.

+1

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--9dgjiU4MmWPVapMU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyJ/nkACgkQD27XaX1/VRstmACgyMXegFu6uQlsxg75lFPoCkZj
ZCcAoJotCZ+ndBidO20roxBm08RSE+e2
=ex9o
-----END PGP SIGNATURE-----

--9dgjiU4MmWPVapMU--
