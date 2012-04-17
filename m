Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab2DQNn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 09:43:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45741 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932225Ab2DQNn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 09:43:57 -0400
Date: Tue, 17 Apr 2012 14:43:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v2] ASoC: da7210: Add support for PLL and SRM
Message-ID: <20120417134351.GD6652@opensource.wolfsonmicro.com>
References: <1334666046.32225.8.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UoPmpPX/dBe4BELn"
Content-Disposition: inline
In-Reply-To: <1334666046.32225.8.camel@matrix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UoPmpPX/dBe4BELn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 17, 2012 at 06:04:06PM +0530, Ashish Chavan wrote:

> +	/* Search pll div array for correct divisors */
> +	for (cnt = 0; cnt < ARRAY_SIZE(da7210_pll_div); cnt++) {
> +		/* check fref */
> +		if (fref == da7210_pll_div[cnt].fref) {
> +			/* check mode */
> +			 if (da7210->master ==  da7210_pll_div[cnt].mode) {
> +				/* check fout */
> +				if (fout == da7210_pll_div[cnt].fout) {

I've applied but this would be a lot clearer if it were writen as a
single if statement with &&s.

--UoPmpPX/dBe4BELn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjXOMAAoJEBus8iNuMP3dVYsQAIehPFi1mxlT8OW4FLq/amDY
8ax23R33vJlD48134rsbsVqYTgI7vXxmTCfNKTYgHYUkjdglHqqyQFSr+AJpxvF1
9P1+yEGnSPTlu0jFcbURwyZTDq1+Lq2Hdf3o+feQ5z/NvsyUhDr3iRnqdzK6zpsW
cmdYDpjHOCcqUCeZYPsLFzYG/wLk4Rgnm0bQyVCF49vMVFboxRiEBw+CfeUEznUY
vIF/YSXwCI1hoi5ML95nzfHW0VOpgLgIS7vos/ZohQ5iV7mKyp6a+S6MEy+SMEAv
6r6qsciqBmWozq7rEXhFscRTRJRKjVFUpZNcrBadIHPEuW21mNG3nfEIAphzuT8i
9cfK1Wc1CTAcR4+hAAkKEeFTypW0024GnW5p2fJLLryuT5mt8flCbhYv9rdcEblo
w/Jq0ppVFbUMwpVkj6QnK+m4J7o10j8CKpHHpGBKFYdOaIY5zmF2m2kQ2Bhm+UaZ
ngA8EXSJiQMI9TOPHckB0wHOuT4fVz/FL2sEWjWkK1sZm8rXgCt3BBx75PVoSAPL
J4n/BBwCfhElekdoqP7nPEfDR0TqS5nXqLuuU6ldbLEWF2fvBHoErFiDErbrbhAQ
PGTYDOFQHGvTNumsg156XcunrjF8RLsduqIWpJq3cP7kzNgzS+fAVCZeHJVuVOhP
F64dk4uDidDcL2fUJXUO
=7obX
-----END PGP SIGNATURE-----

--UoPmpPX/dBe4BELn--
