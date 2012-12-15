Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab2LOOVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 09:21:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36280 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756314Ab2LOOVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 09:21:41 -0500
Date: Sat, 15 Dec 2012 23:21:36 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, grundler@chromium.org,
        devicetree-discuss@lists.ozlabs.org, w.sang@pengutronix.de,
        ben-linux@fluff.org, khali@linux-fr.org, naveen@chromium.org
Subject: Re: [PATCH 1/2] i2c-core: Add gpio based bus arbitration
 implementation
Message-ID: <20121215142135.GB22033@opensource.wolfsonmicro.com>
References: <1355464254-12768-1-git-send-email-ch.naveen@samsung.com>
 <1355464254-12768-2-git-send-email-ch.naveen@samsung.com>
 <50CB4E99.9060506@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <50CB4E99.9060506@wwwdotorg.org>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 14, 2012 at 09:06:49AM -0700, Stephen Warren wrote:
> On 12/13/2012 10:50 PM, Naveen Krishna Chatradhi wrote:

> > +The first should be an output, and is used to claim the I2C bus,
> > +the second should be an input, and signals that the other side (Client)
> > +wants to claim the bus. This allows two masters to share the same I2C bus.

> I'm confused why this is even needed; the I2C protocol itself defines
> how multi-master is supposed to work, just using the regular SCL/SDA lines.

Practically speaking essentially no systems actually do that - mostly
Linux will treat failure to get the bus as an error for example.  You
also get things like read operations which appear as multiple
transactions on the I2C bus so require something higher level than what
multi-master provides.

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQzIdaAAoJELSic+t+oim9ziYP/3Xec5OTpdhalJ/3xknDDvHI
FhaH4Lk8Fdl3pRAuqJFUdR+4feutuVv+Gii95Wde76uw9Kp4/q6PlKCjrBZ+m4Cb
GXFpODwvHwOdk8f0MqxaL88KBbUBgq6Psl1lOW8xww898r7M/+2auq+QvLM0IpZt
sgVOD5qUwfpl5jgyNjEdsTtU2XinhputoGj0IFa4Fc3GPmsmC35F/ttiB+QMnHlC
vO8ucntVom7Y5UecCD4+eh4iR5Xs6s7x7BH7FxeaLCSsEYH1B8EKrn5v3q4hMmjk
2tKrhXeHtkxO2+Am1WAC95lrutHxYNPnaNJxE114/eba2d2YKqqHd40028V2twsy
BT9VlaV0IG9bZTPmXnl2dqFSHj7NYZ8s9LcWkS4AEmo7K+wzQRo7SYdfCOZJed80
8qWRo3zA5umUn0zW6Jy6aWqFH8EhUZWSXOTTDuAAxgpIS/QjQO/evVtHqg4UQy4V
4jIpK48FWEC411pPVRTKEKo6d0micOv0GoWv8nvRInBGFxB0wXBrJHSLA7TbnT+t
oiloBdi3uXvmweLRpg8n+4vbsQHgpdHucpai9u3eUQKU6HuRiJREypphUa3o3/uM
V8XafhCb5RasXaDKkHCYCeolTzWlVMKnV0bgEYMfifbjvnroQTmYHitQsZf4t95f
fFQiq2aSuoSJdL8oal5/
=cduo
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
