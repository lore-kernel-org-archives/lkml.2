Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab2CERuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:50:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47455 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757253Ab2CERuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:50:03 -0500
Date: Mon, 5 Mar 2012 17:50:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        Dilan Lee <dilee@nvidia.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-ID: <20120305174959.GZ3224@opensource.wolfsonmicro.com>
References: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qD80nKKiJWXm4UaL"
Content-Disposition: inline
In-Reply-To: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qD80nKKiJWXm4UaL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 05, 2012 at 08:47:41AM -0700, Grant Likely wrote:
> Allow drivers to report at probe time that they cannot get all the resources
> required by the device, and should be retried at a later time.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

In my copious, copious free time I'll try to replace the ASoC code with
this for test.  I did a regulator parch against one of the previous
versions which has acks and so on, if you don't get that merged along
with this (the external interface didn't change I think) then I'll do so
myself as soon as this hits mainline or somewhere mergable.

--qD80nKKiJWXm4UaL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVPy9AAoJEBus8iNuMP3dhEIQAJrAMxobzT7HYOPewvbMB+8g
ax9mm4prY/Gin0aT56c4M8WhDDSA/Uk0Vdn5SjnAKKMuwPyPWqUsXFGcT7kqD31M
a1b75RKwOKUTU3eywRmeeXejVPEdVgtDT9YvxDfZrGzcv1X56S1YQYd/JGAkzlUK
8sBOwAIQ1cVmFfh8BW8KKzpTZWiFyBrgBJgO2AaRatYZuA7X4u5bslpv+rvxjzYg
mlB9up7Zu9NI6/sk9C8hY6QMykBBjg87Ags9hhmxhhqwr7f6RuY9Br1AMxjemZG8
INCIq0GOzi+5b7mVDkEkPBwDR4gy9yNT3NRyoHF032svAPTUI8jm8LB1RMXsZddx
TbmHST/GAT16MfIgSJpdRSgqLXdgTfWXy/mham5KEgcPcJmDP0ymNidBmNe75Tg4
KloV1847V9PEukT9leED+xvzGqlrwt3FCVRgrJ5Ujiq7GE46vG98evJVLOxIXm9r
nWosWaH2AuGWV/NhtUWzta8keAq5kb0C7zd/8gS0cKRmwI/j+eVCeJXm0Vrg1+Yp
4nf8Gdnvjg3OgiaPvcD3+wHNmRmjAcvW6eCYJDufMX0iLwfBuwSocID586hjY7c7
kBG0qW/XD0jgFmjcFBEJDgdEixvLlbNwmTk09n8aTeremoTIGRrmASJqAYbgm/3b
HLsnUN8CqeJk6MjIczfI
=fAZ9
-----END PGP SIGNATURE-----

--qD80nKKiJWXm4UaL--
