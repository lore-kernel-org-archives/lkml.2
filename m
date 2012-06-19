Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2FSLK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:10:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33448 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751532Ab2FSLK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:10:29 -0400
Date: Tue, 19 Jun 2012 12:10:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>, Axel Lin <axel.lin@gmail.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: Re: [PATCH 1/2] regulator: max77686: Convert driver to use
 regulator_set_voltage_time_sel.
Message-ID: <20120619111026.GI3974@opensource.wolfsonmicro.com>
References: <1340092423-10073-1-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MRqhvNSJsMAynmoC"
Content-Disposition: inline
In-Reply-To: <1340092423-10073-1-git-send-email-yadi.brar@samsung.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MRqhvNSJsMAynmoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 19, 2012 at 01:23:42PM +0530, Yadwinder Singh Brar wrote:
> This patch converts the driver to use regulator_set_voltage_time_sel() as
> .set_voltage_time_sel() callback. It also sets ramp_delay as 100000 uV/us for
> LDOs & normal BUCKs and 27500 uV/us(default/reset value) for BUCKs[2/3/4] in
> regulator_desc[].

Applied, thanks.

--MRqhvNSJsMAynmoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJP4F35AAoJEBus8iNuMP3djuoP9iQTFyE4w9YAYjQgc3GGqccZ
qfC6JXrcSIhIMyqQfRhFeF7D9cA4rdWS+h7KdQJNHzMXcLpleOY/kZOtzfOUR3BN
av40RAqV03x1QV3STYDomRmnT6LE1A7HmowIogD+15/1PjqHDsei1aAHycBiYMV3
FMP60EpHN7hFMuqVkFLBrcbOeFo9hG4KuAi0sh75rdJ4ZAeFMckeWulqzVsMTc4H
49zJ58j76FEmYdvz3joITJDLYhM0nUeXtfJH53515Ze9IU7tVPxsK7WugPxrK8+u
xkRyETvc5K03NHyIvpN5b4LAk41bFKCYeYIHRVxaOO0uJNE1NUlje1NXPWUudDBu
WC1UAQbY/lAU+3E9PCydbyybiHMdCo1iFqjPufuH5WmS+AiukEjfkRihm4WALI+K
nlc1Lhc3CV75lTKeoFQ4S6OVJ4iAeVHtxpHc/ShrTbQma1YUYKGv5izfILms9GeO
FNllcnV261rihvj8Za4upIT+VQZWlzZD1+eXq17EQzqQPnd3x2TbC+LLz+++7WOg
F/wrDAUuWy662vsKAmaHOC4LOYKD1v+MWdqJ1sCqc8bWLk0e7DK6JhZo5Dg6W0Fu
GvlTYqQy0Qt5MsWjZhYBEVUWoozNtJclvaX9IRXsF8lNitGsgivQ1dah+WJa6tEp
7aFC7NmMqIiUmvkmQ24=
=9Crd
-----END PGP SIGNATURE-----

--MRqhvNSJsMAynmoC--
