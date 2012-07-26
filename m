Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2GZV06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:26:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48805 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872Ab2GZV04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:26:56 -0400
Date: Thu, 26 Jul 2012 22:25:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roland Stigge <stigge@antcom.de>
Cc: swarren@wwwdotorg.org, cjb@laptop.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rmk+kernel@arm.linux.org.uk,
        ulf.hansson@stericsson.com, linus.walleij@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        aletes.xgr@gmail.com, linux-arm-kernel@lists.infradead.org, lrg@ti.com,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] sound: tegra_wm8903: Adjust to of_get_named_gpio()
 change
Message-ID: <20120726212515.GH4560@opensource.wolfsonmicro.com>
References: <1340037743-12924-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N8ia4yKhAKKETby7"
Content-Disposition: inline
In-Reply-To: <1340037743-12924-1-git-send-email-stigge@antcom.de>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N8ia4yKhAKKETby7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 06:42:21PM +0200, Roland Stigge wrote:
> of_get_named_gpio() was changed to return -EPROBE_DEFER in case of
> gpios not probed yet. This patch adjusts tegra_wm8903 to this.

Applied both, thanks.

--N8ia4yKhAKKETby7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQEbW1AAoJEBus8iNuMP3dcZEP/RWkqLK6Fi2eQ3ziTyDfHNKj
cMC3zf4Eh3RyQKFyDZKlYubrYMeQYb1RlsKrfeD4JLj8YqKhLRQ1rzMFEbWqzhN9
cnDFeeeq18j2QX2noqRRfzwHvJaVcVpYrnxBy0v6EHTzEXKhZ4khpMh7opo80QRy
saawUlKdFpiiu0vgmDpEShAea6rI5ZPCQPVrdnmaZUC1OUMCBUnGoxJ7OHAuf5yO
asznIak+jN3FxAdjqRcQ/KMAu+sjKRHM1PqR4bSyc4yLX/sTC0W2MfqgINGKVi1y
dN6/Ycr+LrQIeWZYwHy5My248DbHpumjYubguz568k86WyogT8K+axlg+6F7oeuV
O7fnXFP9AtS+7Qv7sZUH6MOEar425Vq0qvLO964L1tGBypL7LNjn6YIM9cp85RFC
GE5qnv8dOMbRE0KtbKrVgAizqC7yQ1AJiMK2uY8Atg8r0u39O2DJSTZ6UQkeHu6I
z+sgO0GSqli0uV6COpdFPLDooDUHDKCzeMLjNygwSnBOS4rsjJN6ju0+CKmk6kpW
rc7tiLfArNYD2DNPXZNFuzyUydY9ZohBvPVNqHLfsA1j2pN0N/njHwy02HY9YMOJ
R6z9mzc2MB1tYfFsCrdKcuqb68NHX0yxqGkxLv/PnIie75rkW2pkOUjfvr02Umuc
Xr7MT53DvXZAPOS7G94G
=nyD7
-----END PGP SIGNATURE-----

--N8ia4yKhAKKETby7--
