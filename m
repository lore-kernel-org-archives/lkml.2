Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab2EJIyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:54:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43865 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756428Ab2EJIx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:53:58 -0400
Date: Thu, 10 May 2012 09:53:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: linux-next: manual merge of the sound-asoc tree with the regmap
 tree
Message-ID: <20120510085355.GC3908@opensource.wolfsonmicro.com>
References: <20120510142552.35f8e15042053707a2086905@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="adJ1OR3c6QgCpb/j"
Content-Disposition: inline
In-Reply-To: <20120510142552.35f8e15042053707a2086905@canb.auug.org.au>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--adJ1OR3c6QgCpb/j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 10, 2012 at 02:25:52PM +1000, Stephen Rothwell wrote:

> Today's linux-next merge of the sound-asoc tree got a conflict in
> drivers/base/regmap/regmap.c between commit 6560ffd1ccd6 ("regmap: fix
> possible memory corruption in regmap_bulk_read()") from the regmap tree
> and commit edc9ae420f98 ("regmap: implement register striding") from the
> sound-asoc tree.

That's the right fix - it's already included in the regmap tree itself.

--adJ1OR3c6QgCpb/j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPq4IYAAoJEBus8iNuMP3dyS0P/3XrFuG/PUVjRN8ZZ+C0TPno
Y01mek8qftz+wfgoPOmlKh+oK1vIedPww0yoNd6kjEgJm4IftPSD4uxP4yaSqw3o
9muDsxBRNjppeLZNa2kd0SaSUSU5tnpWPD6Oo34CCtSVqEXEhqiZ70IHeKS0mCOd
/vv76StzACvaeEVEsDulPT329Jj4rWaHbA7tomBV0kcj92quspDSmlZKZEiv/Iru
57Gzw3QzB5Zlgn9df2QnWonoTrP7oFKAjb/Xf3bUh3yLbKtohY1Vmtn7/kKrJIps
RF8fLj2a0YUwjMbKpbuppsfBDIixORPh3wWd7vL24wgKiArAfYeF2nbSXkVskqyl
faJYbH8bWIFdKULgy/4oxup9xouHaqjVM+bw2zVa/e+i81dj9oGrDvVwQr4QGRuS
wfJ0eAPywxjVU7IbRpLdhY0SumUHXoaVvMTWzWIgQipmlHqwf+yzcC3WFCGhi4we
SRWUi3hxl319x8XYkWd60p06G4VxBOJQ5sSsF0cShnuROVP++s+yCqmqiPP58MzN
h2EB8kB6pLhI2T8AVAFapGrd/JjjJUWTpCsUPI/7Iq2nySpBiWxzvPNOtA0UUOYt
Ff9fOMkf9qfpjdGFO1wBgRLsKED2qOS5f0nf92te31vTeMFH+QffU/x3JqCbJBo7
4lHk8RudfYPz0cgcAHMO
=o3L8
-----END PGP SIGNATURE-----

--adJ1OR3c6QgCpb/j--
