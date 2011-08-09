Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab1HIPI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:08:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59461 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab1HIPI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:08:57 -0400
Date: Wed, 10 Aug 2011 01:08:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] regmap: Use int rather than size_t for lengths when
 logging blocks
Message-Id: <20110810010847.77e916a7780ffddd98d91f68@canb.auug.org.au>
In-Reply-To: <1312876805-460-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1312876805-460-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Aug_2011_01_08_47_+1000_KNcZq9lAS1xGZKYt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Aug_2011_01_08_47_+1000_KNcZq9lAS1xGZKYt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Tue,  9 Aug 2011 17:00:04 +0900 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> x86_64 warns as size_t is not an int.
>=20
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Stephen Rothwell <sfr@canb.auug.org.au>

Reported-by?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Aug_2011_01_08_47_+1000_KNcZq9lAS1xGZKYt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOQU1/AAoJEDMEi1NhKgbsB2gH/1827uNCpTmzzPUfnkQelCIX
q8lD3PWqEeWKgzjpBs3OFEhnmm9du9Tk00mP5lJGJRTz7JBBbt+JrUkHIiSJKyg/
8DpbzK282tzBFjq9Ifuz2/l1h8Me9sJO1Ji+YF/4FgB0VAh0o7M93/EMloYGJruY
nl1wqA3N7Z61QWS+3LJ4kXOxslmCrFbejC8FjHoUuIefUv3LuXj+8QO0/ULRjlnd
zJL1vr4kqfGgD5q6vaB3bCfDWbUq1r864azZOeLNPn+uxYY9IPntUFxqfkeQwNZ2
iU6eiLd2XjBWBLMmcI7ApComhKpe36Rn6ti5AOuXWYWhbuSEEouUuWAOiRS+SJ4=
=dJlT
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Aug_2011_01_08_47_+1000_KNcZq9lAS1xGZKYt--
