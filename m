Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713Ab2FUWgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:36:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42832 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755662Ab2FUWgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:36:36 -0400
Date: Thu, 21 Jun 2012 23:36:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mitch Bradley <wmb@firmworks.com>
Cc: Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, Laxman Dewangan <ldewangan@nvidia.com>,
        lee.jones@linaro.org, lrg@ti.com
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by
 regulator-compatible
Message-ID: <20120621223632.GA4037@opensource.wolfsonmicro.com>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
 <201206211450.35713.arnd@arndb.de>
 <20120621161459.GY4037@opensource.wolfsonmicro.com>
 <201206211717.46142.arnd@arndb.de>
 <20120621194544.GZ4037@opensource.wolfsonmicro.com>
 <4FE397E5.1070707@firmworks.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hk/xWDG3xnLTY+FR"
Content-Disposition: inline
In-Reply-To: <4FE397E5.1070707@firmworks.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hk/xWDG3xnLTY+FR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 21, 2012 at 11:53:41AM -1000, Mitch Bradley wrote:

Whatever mail program you're using appears to be generating HTML mails
and isn't doing an awesome job at formatting them, the plain text
version is mangled too with most peculiar word wrapping which is quite
hard to read.  I've reflowed.

> On 6/21/2012 9:45 AM, Mark Brown wrote:
> >On Thu, Jun 21, 2012 at 05:17:45PM +0000, Arnd Bergmann wrote:
> >>On Thursday 21 June 2012, Mark Brown wrote:

> >>>I'm not that big a fan of moving all the data into device tree as it
> >>>means that you need even more parsing code and you need to update the
> >>>device trees for every board out there every time you want to add
> >>>support for a new feature which doesn't seem like a win.

> Maybe I'm missing something, but in general it's not necessary to
> update old device trees to support new features.  The trick is to
> define a new property that describes the new possibility.  Absence of
> that property implies that the default - the thing that used to happen
> across the board, before the feature existed - applies.

Which is not a success in terms of deploying the new support, or indeed
in terms of deploying bugfixes.  It increases the overall complexity of
the system and I'm having a hard time getting at all excited about any
benefits.

--hk/xWDG3xnLTY+FR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP46HoAAoJEBus8iNuMP3dQDMP/j1W4ktbFyGq0xgJWlp/7mT6
HE9gK/E6DiGNNK9sNvfxuN/JF4sDrPFtCjTc/7Uib+PT61RVPoFej17sxA5FZSG6
jxuhfluMBZ1s3zDjFH9qKUhnqea77Uhkz+shF33aYHILDGBv/wrftcvsluQ6Bzdt
H3rsmb9wajLywfy9+6ZgVXHCj1xmTQfAS85Fhc09QcVlDK/xYIPHQ9GQgYb7EV5K
OQQhULAEkLk6OQB0SLOsBAz9xrRFqbdF9oHJCIuAeXQcvWXEVwdT0SuZHUg2G3Of
UXUPj7mOAY28emrZXAJ3lh34t2ZStA3tGMEVJcXSMSTVJ/8AbzmsdeoIoyFujEr0
z5mZPXNEsicAmKN44FbQDyxbnq1++OlL3GCD7+pgcDFbGQYbQncNxgz9zLvzGRTR
sOvfukDYsG+0SSCme88b8zRng24pqOT0U7avsoVl2y6lJv9+LVTkuyX5QYO8Qd7w
pI3CqoKvci+lECgkh/1yZ2DSGfE6hRqKb5+LOuoci0tuPPRAK+bHVzwOgqIh5UvF
NnV9dRxvfI7++Aa5N2FikavUTGxPEIm7N9X1IWeor37PzkVWNMujaqu2NhNogy6q
IPQ76vqycuZ+cjoj5NEj3ySOEeg/t2f+4KP3fXuqVu5fgQ9T+lMKDrm6nQk3A6rf
OAhPs6vMXF8cKMB8Anwg
=Fwmn
-----END PGP SIGNATURE-----

--hk/xWDG3xnLTY+FR--
