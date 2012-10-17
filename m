Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab2JQMce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:32:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40154 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377Ab2JQMcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:32:33 -0400
Date: Wed, 17 Oct 2012 21:32:27 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] regmap: default Y if REGMAP_MMIO is selected
Message-ID: <20121017123226.GM14199@opensource.wolfsonmicro.com>
References: <1350477076-27875-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JcvBIhDvR6w3jUPA"
Content-Disposition: inline
In-Reply-To: <1350477076-27875-1-git-send-email-p.zabel@pengutronix.de>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JcvBIhDvR6w3jUPA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 17, 2012 at 02:31:16PM +0200, Philipp Zabel wrote:
> The syscon mfd driver selects REGMAP_MMIO and uses struct regmap_config,
> which is only defined if CONFIG_REGMAP is enabled.

Already fixed by someone else, can't remember who now.  Will send to
Linus soon.

--JcvBIhDvR6w3jUPA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfqVUAAoJELSic+t+oim9uAoP/jzRCd1y/IswfHKFrCMDgais
8f2rAUufYNAGFH13lxQKAXiDQwSe3495yJa21JF+BOzaFo3EAd8GfI/xoYHj8gQ1
E2JZVCX1ulO1vedk2iod7w3R++SzzlR0vKcNA4KLvTntEctq3irWNrw3ui6h0cn5
CECiAn5G40HwMPZL7JUqO3IhJhpvCNM9rPnmskkub6I+I9XJULaayzpqRG8tPiuz
cTTdjsIB1qM3VCKs/Ql2HgYhKp1ULCC+OLfyoM5NRp7KBNulY0HAqft+yrpuJ9ig
VLtdFfeMm+pEKzBfrz88S2eo/OT33oOFqC5SIQx9BEAaWLq/C8MrVA/BycPyz2Fg
/KudCmTefUS7hHJNg7CaIC4VgKnoJAC4AHi38VthD/DEt/ZXiHwJ8llDSvaKWm7V
RsQIQsMt+BqpZu2CB4/htr0w14vb/znlmO+uac9Tu5vTjI+JxIP1C4scyAsX6Hhs
8+zuRxA/qtB+lhbMWEee9SpEnFMbjV5QThPxKFKH2Z7DQ4ZVX08El5M/N9HZzvn0
SsSoIfnKMVq1f8PVDRE1mk8KxdioCzeGZP64WTfgq/JA5LQVDEaG7Rt9mX18BqYl
ITM2AVP6eOKtRQgCfU9qcUpTJthQD2GFVW+Nfm6IqpwQDq/3KVukXxig79VimAdu
Dat9yowLwzYSC3eln4yT
=mOQG
-----END PGP SIGNATURE-----

--JcvBIhDvR6w3jUPA--
