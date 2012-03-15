Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761735Ab2COMJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 08:09:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34086 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305Ab2COMJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 08:09:51 -0400
Date: Thu, 15 Mar 2012 12:09:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        linaro-dev@lists.linaro.org, Samuel Ortiz <sameo@linux.intel.com>,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [PATCH v9] mfd: Add anatop mfd driver
Message-ID: <20120315120948.GG3138@opensource.wolfsonmicro.com>
References: <1331797421-23731-1-git-send-email-paul.liu@linaro.org>
 <201203150907.29895.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gvF4niNJ+uBMJnEh"
Content-Disposition: inline
In-Reply-To: <201203150907.29895.arnd@arndb.de>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gvF4niNJ+uBMJnEh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2012 at 09:07:29AM +0000, Arnd Bergmann wrote:

> Very broadly speaking, I wonder whether we could use the regmap
> infrastructure for these things in the future, but I would first
> need to understand whether that is actually in the scope of regmap.

> It seems that you just need a subset of what regmap provides,
> so it could work, but it might not actually be better than what
> you have now.

> Mark, can you comment on that?

There were some other mutterings about using regmap for memory mapped
devices, mostly from the point of view of building framework features
like this on top of it.  regmap currently makes some assumptions that
the I/O is going to be slow so approximately any amount of CPU time can
usefully be spent on avoiding I/O but we can probably do something about
that.  It also uses mutexes to lock I/O which might not be the most
sensible thing for memory mapped devices, but again that's solveable.
Right now there's no memory mapping support but there's no reason that
can't be added.

In short, it does seem sensible to want to have some support for this
for devices that use appropriate idioms.

--gvF4niNJ+uBMJnEh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYdwFAAoJEBus8iNuMP3dR3AP/Rnm5XrEoeZxitAxN9ZrNtQB
LtFFyQlHErbWnw0eYZ1Sjr4P/GqIrW1ljXS+KbOI0Ax17PG77uxJlGvZazwb/mqD
TCJn+TQzD6ExlsVqXKZB23NwgAQpqAY38iz9BTeK8JFNNpGlAanQ2gzrluBHopEP
vnr4L/Q21JR/Y7bXKpA0awAyufu9wxzOA0VT/4uq5exOweUSzoal6v5HsASwgxx8
CNefquwr5EEFceh/+cDxWRF/05LuZUs4BgeNpKvJznAacPGriHxUCJVXnFpBsXQg
dwt+h3RpmmwuRgqbfoJc0nSebHzxuNH7SIfi1nPhxJLH2S/DMeUYnNqBvT6qBIb7
18y0rXqbi4/CPefunV8AqRaAfAL89qMBSFPN3Lg0vyqrK/eFgoxQkT0KkiJc0TYB
9D+ypfncJ6ChTAQq2H14z6YP2cP8KoO/teymCLbefpjSP3PeuRn29x/zEYzP33rr
9kjPVgoMMxClzP7f7aVY0gakQVeCyxjS2CyYtVM+UM/vZlZVrmVv5TEV5UbXlxRh
RC8ZuN5pZHCiHOD1Cr/5Rf08n98ZqOTgP3ODwVVvHWKPuSofHsiMfIHqxOSQi0Mu
SCi0t5mA8ZgeLTK/1GSt+ejjSBmD64br/bJ1zzjI6pH7MvewbJ/k9UY9ddjK5fAW
jgDH7zcBXQRIPRMizPD/
=ubka
-----END PGP SIGNATURE-----

--gvF4niNJ+uBMJnEh--
