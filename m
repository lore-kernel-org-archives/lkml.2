Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab2LMKro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 05:47:44 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49681 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab2LMKrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 05:47:42 -0500
Date: Thu, 13 Dec 2012 12:40:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <paul@pwsan.com>, <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>,
        <bjorn@mork.no>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 00/23] OMAP USB Host cleanup
Message-ID: <20121213104018.GE1916@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1355134833-5199-1-git-send-email-rogerq@ti.com>
 <50C9B186.1020603@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gMR3gsNFwZpnI/Ts"
Content-Disposition: inline
In-Reply-To: <50C9B186.1020603@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gMR3gsNFwZpnI/Ts
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 13, 2012 at 12:44:22PM +0200, Roger Quadros wrote:
> Hi Samuel & Felipe,
>=20
> How can we proceed with this patchset?
>=20
> You can use the below pull request.

there are patches under arch/arm/ which need Tony's Acked-by, if we get
those, then sure, go ahead ;-)

--=20
balbi

--gMR3gsNFwZpnI/Ts
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQybCSAAoJEIaOsuA1yqRESbUP/0b5ktOnNIEZvTSYW3PWraWG
6fzqFBnVdQHHvCz+l85TY3PqMPkr5V5l4yJYU4AADYRToqMoKGLPPafPHzjVw/Zg
j9WNKM93/PdVbfwb9mf639nljd+elMoLpgExNIAeSuQ1lhXZhaTl4QxbbwnW+j2S
0UjCzEVx08rEbih8f4NSdDeQvpNEQRrVkTqqQRsKL2Gt2YiKEYWASbX0GwK+Aywj
tZcf7iE14SuCxQqi/QKJ0UZpo1LYd0+XxbqaREWhd0uOlJpbD4nBAqvA/vDbhnRY
6G0Z4YX8CcMcB2wZM1QGsbCDMIzYQbmlBxg4ID/1LMNRdQtO+gbKDBwFHgbaSlh3
Zrmj7HFtMxLoysooxxymV/GWAmToEWumIUljlxWcxSCDMCqK9rNBAUTSj1Taojw0
VCO4Z3IhW+1eIZAg2O8uA/nNk+U6SValUCFYgLSNKAEeOX8SPNRoiMToHzhE61tF
YG+Vndl9KljEppAB0p0YHQjET4N9LQ8Z16Lo5ccD2A3Qa7WGrQFNIC4VuWZry+Rf
SKNFD5KH3a025GxqhKyayaMU1UtBKUXyK6ZtcK+whRWGsR9mqSoGv+74CJSWocH9
F29g16QiLGm1VGsG7AmJINXit75HmdbYO6GzBd8xUxV6XfTxJd1BjVyzjXP2xcmF
DHvG1XBBwqxc5Q5Rxf8v
=ZSn2
-----END PGP SIGNATURE-----

--gMR3gsNFwZpnI/Ts--
