Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0EKHst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 03:48:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58935 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab0EKHso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 03:48:44 -0400
Date: Tue, 11 May 2010 09:48:33 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: florian@mickler.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Stephen Hemminger <shemminger@vyatta.com>,
       Joe Perches <joe@perches.com>
Subject: Re: [PATCH] scripts/get_maintainer.pl: default to not include
	unspecified tags
Message-ID: <20100511074833.GC24844@pengutronix.de>
References: <30a2fd47565ff33d6f47d9a76746b56d923856ac.1273466698.git.joe@perches.com> <1273559797-6910-1-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0lnxQi9hkpPO77W3"
Content-Disposition: inline
In-Reply-To: <1273559797-6910-1-git-send-email-florian@mickler.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0lnxQi9hkpPO77W3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 11, 2010 at 08:36:36AM +0200, florian@mickler.org wrote:
> This changes the default of the option --git-all-signature-types to be
> disabled by default.
>=20
> The effect being, that only certain (currently  Signed-Off-By:,
> Acked-By: and Reviewed-By:) tags are used to get adresses of potential
> maintainers.
>=20
> Motivated is this change by the desire to not 'spam' people unnecessary:
> A Tested-By or a Reported-By is not ment as a hint that those people
> want to/are able to review patches to the code in question.
>=20
> In a quest to find resilient statistics for this i came up with this:
>=20
> I produced a list of all the tag-signers not already covered
> with a signed-off/acked/reviewed tag somewhere in the last year of git hi=
story.
>=20
> Those were 650 addresses of "assumed non-developers".
>=20
> And to check if those "assumed non-developers" are professional
> testers/reporters worth cc'ing, i then counted their total appearences
> in the git log:
>=20
> 469 were mentioned only once.
> 123 were mentioned twice.
> 38 three times
> 8 four times
> 5 six times
> 5 five times
> 1 eight times
> 1 fourteen times
>=20
> I believe this supports my thesis, that the ''non-maintainer-tags'' are
> not actively useful for patch-review. (except probably the guy
> mentioned fourteen times...)
>=20
> But of course one could also find arguments to poke holes in this
> statistics, for example does this statistic not include code-locality:
> A tested-by on a patch that touches some specific piece of
> code can be more worth than a signed-off in another part of the tree.
>=20
> But... let's play it safe and let's err on the "safe" side
> meaning to not spam those people when in doubt. We already have the
> signed-off's and Maintainers file. So this should be ok. And if need be,=
=20
> the maintainers can always forward the patch.
>=20
> [i probably could make a diploma thesis out of this changelog :)]

:D

>=20
> Signed-off-by: Florian Mickler <florian@mickler.org>

I second this reasoning:

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--0lnxQi9hkpPO77W3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvpC9EACgkQD27XaX1/VRsuQACeLyeANzNVSQJLbMgDXcbDJ872
IiMAn2wVoewGEl66d9hs+MtgpQojM6Du
=W2Xd
-----END PGP SIGNATURE-----

--0lnxQi9hkpPO77W3--
