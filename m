Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2CEV2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:28:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60901 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753812Ab2CEV2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:28:44 -0500
Date: Mon, 5 Mar 2012 21:28:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Dilan Lee <dilee@nvidia.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-ID: <20120305212842.GB15382@opensource.wolfsonmicro.com>
References: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
 <201203051915.45197.arnd@arndb.de>
 <CACxGe6ujqF3st0y5jbWxx=amr534NY3RHdUzmVVdjqt=fJMJmA@mail.gmail.com>
 <20120305212442.GA8908@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <20120305212442.GA8908@kroah.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 05, 2012 at 01:24:42PM -0800, Greg Kroah-Hartman wrote:

> Or, as this really is a bus-specific thing, have you converted any
> busses to use it?  If so, I'd like to take that patch at the same time,
> I'm leary of infrastructure changes without any users.

It's not bus specific, it's more subsystem and/or driver specific.
There was a patch to the regulator core which would add at least one
user.

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVS/eAAoJEBus8iNuMP3dkYUQAJs/Q7F5A2xExKZ4a/Er1+lN
BYHK2sH6X68e72zYAV7URdO5iu+gLaOunoSbucu+g/C8PB5b+boRRcuQQ2cnDeO5
pmiN4e0oWe8aX1xGuiXwIu3Pom5SCtmJMG9fuq6iw9qaqCA9CF1kmObzh65KQr2E
KFZTc3Pir6QUxSxm9PRH7ifd1BhkAy19OBZrFlS3CmqVUu2gBZGezWLod600H1X8
5Hzw1Flr9VpVIGsBCpzhFPObDhLvGjUgde1rT6FpfW2YxwoooRjjYtlJJ1y9VPA4
+QnwgB9s4hyt9g1kaHh3j05XbKJtIJ8ipKGXeBWIzJqDB8vAuMkCqJF7uoOlnwVp
kL/uBjwbS1gsvEIetops9hzuJp8XVuBaja1D9ZCf4EldWlflJ+DTKbDBzyPoqrKv
xbJUVs+GsxonX3Giu3mJT4FM4BrpUJQ36Ce3ib2M6tSTXewy3fWSfwVJ0Hg02cFT
IKHLHy/magn7dhSPAE1hQjjFTzpi3vkOBsYTFsiJd6HiX7oHjrMCoo+iXM9imN0B
mg+QFpc0f+qR6+smCIrKy9a0gP8+P6HWMgnXqNsruOdJY72dgP6lnSqsfUSIMdB+
5HA7Lp2dFrO1HiieV2MCa5CljuzpdPu7mQ2OnLp/HXsgkSW4utcOBQ65SFoZ/F6H
SpgARl6VczVQjVKAQih1
=vopQ
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
