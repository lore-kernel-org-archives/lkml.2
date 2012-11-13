Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab2KMGgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 01:36:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50952 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364Ab2KMGgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 01:36:01 -0500
Date: Tue, 13 Nov 2012 15:35:50 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] RFC: pinctrl: grab default handler with bus notifiers
Message-ID: <20121113063546.GD18224@opensource.wolfsonmicro.com>
References: <1352636539-6318-1-git-send-email-linus.walleij@stericsson.com>
 <50A15A54.3090803@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Content-Disposition: inline
In-Reply-To: <50A15A54.3090803@wwwdotorg.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 12, 2012 at 01:21:40PM -0700, Stephen Warren wrote:
> On 11/11/2012 05:22 AM, Linus Walleij wrote:

> > Another solution that was discussed was whether to move
> > the default pinctrl handle and state grab to the device
> > core as an optional field in struct device itself, but
> > I'd like to first propose this less intrusive mechanism.

> I think doing that approach makes a lot more sense; wouldn't it
> completely avoid the issues with deferred probe that this notifier-based
> method can't solve? It would also be very much in line with e.g.
> dev_get_regmap() - if every resource that a driver required were handled
> like that, then deferred probe could be significantly isolated into the
> driver core rather than in every driver...

I have to say that I agree with this, notifiers seem to make life more
complicated for limited gain.  Otherwise I guess we could enhance
notifiers so that they're able to trigger deferrals?

--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQoeotAAoJELSic+t+oim9xYUP/RjzXmLzAYPBCrqZYaZrDU5g
GrgUP2RRI+eDZWw+/m6ecJSIbokEPswNOgGSH7zT7bdjGeHVvcxN8I17F/Dyn6VZ
Kv5s/8r7gJ0XFUM99W2Ii9yjH92ALd6Y9T/bC5BX8yyyB2GuACC53yp3EBafNbOA
MNbPYnaj+msR2Vahz0GYwXzMcm1pnBtKV60hB3tzK6JpdHt9m0Wp/2KkOLE7Df/P
SArkClq+J4Ic5l8Ip2uiEHyiZSm4+L9Qy/4z5lue1mehALT4glsdYa1AruIoBakg
MFyGAZoYT+MwIdMjKSxpU+f4OfaLrdPQuMKsQG4b/H8nXh+F/+IOGblhXw25wGlt
3JuS9O8tZY0GdBCvvRoK/rBwKNuruhUB1t6pVrFzR4cg8p2wzcIBMKPyitOJCx3V
/dUX5/7b/kdegOXzo7PcpkAB240Pg510HG1WyOKKuEmzRTC5w/2zVXWnFdFKrLJS
64Sf56cKvKY6T8pn/mD9XqGHOgLcvIPVlt5eKmnyQ6E0TS/goDgLTTnN1knP61OY
HGQQ8R3byEvsk0nSwK9B3RQGXRzhzBDM5WtVZUcjTIpicCOd4NSxDOkBcNIGi1JU
Hp1kfR4PACxOOuFiRPH6YKwa8L/OXS1sK4KgvpY69I5Z6F0/vhj6Ab6MKJyAIhB2
FD6YClGk+VAnj190RSH6
=s9Cs
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--
