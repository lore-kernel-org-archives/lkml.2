Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab1ALUQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 15:16:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47119 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab1ALUQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:16:10 -0500
Date: Wed, 12 Jan 2011 13:16:02 -0700
From: Eric B Munson <emunson@mgebm.net>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, mel@csn.ul.ie,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Rename struct task variables from p to tsk
Message-ID: <20110112201602.GA25957@mgebm.net>
References: <1294845571-11529-1-git-send-email-emunson@mgebm.net>
 <alpine.DEB.2.00.1101121205120.3053@router.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101121205120.3053@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Jan 2011, Christoph Lameter wrote:

>=20
> Use t instead of p? Its a local variable after all.
>=20
>=20

I don't find t any more informative than p.  As a newcomer to most of this =
code
informative variable names, even for local variables, is a huge help.

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNLgwCAAoJEH65iIruGRnNFa0H/3ZQiWcKF+2PSoaff+RcZc/S
5vQExEgie4Sslctp5DQ4a7R1x1Q/9Jg65wooAqbN3muCYSrIqdTppravZM3tB/v3
d8f2/UV6ESDmNavp8AD13gDB+OSupR4gAnZdqTrnqK3Ay8BTT6LID499+s5ojbsL
4aoJZF8vQwwz7nuED29b/zUps5vBCO27S9NOwGRyyEFokvnFd07HHS7DFTY/CiP9
OMf5n+SqQtAYjIbZqQx4QCOkh7arZguHxaXx8nXI8yNlGctaf/k71cKb5Bv8yh+f
m57HJSkKtYvL5BB/QnHHSlQkx27UEstSuNr9sWQ5UrC5t+CS/w517iypTgb3B8o=
=XVtQ
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
