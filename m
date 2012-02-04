Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2BDAoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 19:44:46 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab2BDAop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 19:44:45 -0500
Message-ID: <4F2C7F7A.1090605@nod.at>
Date: Sat, 04 Feb 2012 01:44:42 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: Cleanup headers files
References: <20120130192552.GL23916@ZenIV.linux.org.uk> <1328311063-17630-1-git-send-email-richard@nod.at> <20120204001431.GY23916@ZenIV.linux.org.uk>
In-Reply-To: <20120204001431.GY23916@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC1B1077BEADEE446D1B8FFA9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC1B1077BEADEE446D1B8FFA9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 04.02.2012 01:14, schrieb Al Viro:
> On Sat, Feb 04, 2012 at 12:17:43AM +0100, Richard Weinberger wrote:
>> Many header files can be replaced by generic variants.
>=20
> Umm...  I suspect that for auxvec.h the right thing is to simply
> remove it - it's never used on uml builds.
>=20
> FWIW, I've rebased my local queue to current and pushed it to kernel.or=
g
> again; it's on git.kernel.org/pub/scm/linux/kernel/git/viro/um-headers.=
git

So, I pulled your work and merged it into my shiny new UML tree:
git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git

Thanks,
//richard


--------------enigC1B1077BEADEE446D1B8FFA9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPLH96AAoJEN9758yqZn9eelkH/i+o581d6cS9yymbIJolfdBk
rBNeJaVslpBOC+A1w40MfAkgaDX2XjEs5h/9pH8+CQlahEgpXYPCFeT9etmdt2Me
23jAFT9J1fscATUM1Tgd5SmNYg/wmqDmo35ks9Pbvs0KBIccVOT5d170fE3oSWjz
tgb5yCqOAQ2Hnedjdnv0+HfrXJO3oJGTnNVPo2NN5B7aOjR44BiNKi1PeMta4V0z
Da7eKbQ9xzs39Fz4MdL1g71gnMCYxu93x+eEg6qEVJGqdBIdMk+z4/+Y3UAPpXFZ
xYosGzMoEGkEUqcpH1yauuauEdvfzYXDGEhnXbVIe80Q1NwLR1oy7oxTbNpQlOI=
=Sxpv
-----END PGP SIGNATURE-----

--------------enigC1B1077BEADEE446D1B8FFA9--
