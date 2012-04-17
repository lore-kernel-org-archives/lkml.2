Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab2DQPUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:20:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58871 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752987Ab2DQPUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:20:11 -0400
Date: Tue, 17 Apr 2012 16:20:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: da7210: Minor update for PLL and SRM
Message-ID: <20120417152006.GM6652@opensource.wolfsonmicro.com>
References: <1334674858.13279.9.camel@matrix>
 <20120417145618.GL6652@opensource.wolfsonmicro.com>
 <1334676602.13279.13.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YIwHDYD8sUXtBKvt"
Content-Disposition: inline
In-Reply-To: <1334676602.13279.13.camel@matrix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YIwHDYD8sUXtBKvt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 17, 2012 at 09:00:02PM +0530, Ashish Chavan wrote:

> To do that we will have to use spaces instead of tab for indentation. I
> am not sure if that is fine. You mean something like below, right?

> 		if ((fref == da7210_pll_div[cnt].fref) &&
> 		    (da7210->master ==  da7210_pll_div[cnt].mode) &&
> 		    (fout == da7210_pll_div[cnt].fout)) {

Yes, that's totally fine.  8 character tabs and spaces below that.

--YIwHDYD8sUXtBKvt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjYoXAAoJEBus8iNuMP3dKrwQAJj9n2b4Y3HEPqVfCwezZEhk
VUwqg87v770JLxMrMFCJ4KUPsKXLxvRl0iawMNli2j+/jAtv3TgXGn9s/T6joTuq
3g0pVlsOgJjCh8tx24vWhfhSsBm5qD44LEq81fQ3hCwV+dyl4zH/U7QIWUWfFs7P
MZsDhJwhnELndedJWz56RSz/luRs6arZe8EC0s2ANj2kXZsogMPodW17zwKzBVfJ
sYTO8NYrgyXKXllCs7m9Xchyxi5dh29E8q64anEHK4Ud4RYoYu+UCn6J6myLNXuC
IzszYkBZK+QIdzz5Jij8VYT5qPVzH5iBH8ZQIi5AKonLl17cKLGH5cWl5Ufjtx8B
QkXL9vI4O3JoDQva/lRrmRL8PVkz38wR1JP2N6PwRjb7HBbpUF/6JCIsqZPG8aqJ
6CoD5xJ4PA5C1X9N7bMGSxXDte5HR5xCqwzoOzphsQwi3BmZ1dSw650XlXhDaWtX
7HIivP5H2MGt0P43CpG91SCkRhQ1ACF78167qwAvM0BAkZn7CAi1qYJPhEq4ui6q
WbDz86uvrdCkO+C11fdlatSLvH2371vywaBonKtfP4F4uP6QJPOlsyZup9JRrfRs
djAFxet5Ls0NJc1rK7j+Qbwqm3A8NKnYf7/PMcF6l8ucA+msAHKdBxQvRZfGNJo3
Px4N4V2WzpK2wk+hibQP
=GUMY
-----END PGP SIGNATURE-----

--YIwHDYD8sUXtBKvt--
