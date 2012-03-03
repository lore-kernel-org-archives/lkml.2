Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab2CCQhh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 11:37:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56136 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753022Ab2CCQhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 11:37:36 -0500
Date: Sat, 3 Mar 2012 16:37:34 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Estevam Fabio-R49496 <r49496@freescale.com>
Subject: Re: [PATCH 4/4] ARM i.MX 3ds debugboard: register a dummy regulator
 for the smsc911x device
Message-ID: <20120303163733.GC3071@opensource.wolfsonmicro.com>
References: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
 <1330774804-7310-5-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m51xatjYGsM+13rf"
Content-Disposition: inline
In-Reply-To: <1330774804-7310-5-git-send-email-s.hauer@pengutronix.de>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m51xatjYGsM+13rf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 03, 2012 at 12:40:04PM +0100, Sascha Hauer wrote:
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  arch/arm/plat-mxc/3ds_debugboard.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)

applied, though with at least this board you clearly do have a sensible
regulator setup already and are just adding in a few extra regulators to
fill out things which for some reason aren't supplied by the PMIC.  It's
quite surprising that things like what look like the I/O reference
voltage are supplied elsewhere.

--m51xatjYGsM+13rf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUkiQAAoJEBus8iNuMP3deWUP/12MYvwtHRXGmjd31hsBd6jF
gvnBY3sFbSy7KBzXrzIn7vpJHEDKFLsHXdme2lrq8Qzcu01mQfjbUetKANQ/anoj
Sk6N+lBhyFS343YHfFyOMQWZ3gHcfZYOR+5Mhj6nD74sS+NoUIZic/dUzAkP4VZS
rBftzuZgWyB3YUD2If7R1SBzIg3yWSLFwpgrC2ws80PqU8OkI+PT1JqxubM5exfg
wnB/6Art45I3BvhmYuF0Sy4YWPvADgUhNNFMH5SNqqvqAwxtkrQ6QgxcvqZ5tgwE
WGCt5IsVxx7jAP0TMhCmBqLwXc8JapyTPaTm2DUcs8MOt1kuV3/MQZUYdN9hwBo1
yNvppDavhEakfM1GNQJB0o8Fwc5RQX8kjNzujRrXz/RB72tultEZ4AY45C9jOQLV
6lo35R9XH9EOzC3xGE7p7klC1M+QMSl4pJU+O6Z6mjRizvXCGpWO/9GzxAeyUGwy
fnInPqNPxo1hdrdMpc/0PEMnZJmkp9GhQpdjMulZCH3Jn6kXTnUk7hdsQvTkDocE
TUAPe+f8YYXKk/dw8Vg/+lS7q7/wsFwsyL1mfcCnqTrm1hVxOYvKg+hcYq5VIMkr
pluuk7VhE0uc46XcziNN/5OkTE4ToldGlfm8LNGCGXLeBs6Bdbh8onJmCzdD8O+Q
EZv+uq3OtN0KIWxIwZTI
=sKo8
-----END PGP SIGNATURE-----

--m51xatjYGsM+13rf--
