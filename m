Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab2AZQRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:17:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41089 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358Ab2AZQRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:17:47 -0500
Date: Thu, 26 Jan 2012 16:17:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 2/2] regulator: add device tree support for max8997
Message-ID: <20120126161744.GB19703@opensource.wolfsonmicro.com>
References: <1326353738-26864-1-git-send-email-thomas.abraham@linaro.org>
 <1326353738-26864-3-git-send-email-thomas.abraham@linaro.org>
 <4F1FD1A5.1060305@samsung.com>
 <20120125112602.GB2991@opensource.wolfsonmicro.com>
 <4F1FEF55.8030604@samsung.com>
 <20120125133254.GJ3687@opensource.wolfsonmicro.com>
 <4F217100.6020105@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline
In-Reply-To: <4F217100.6020105@samsung.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 26, 2012 at 04:28:00PM +0100, Karol Lewandowski wrote:
> On 25.01.2012 14:32, Mark Brown wrote:

> >Well, they're different things.  Device tree isn't Linux specific at
> >all.

> There is no official platform-agnostic regulator API, nor DT-bindings
> document I'm aware of.  Thus, I don't see why, while transitioning to

The binding for the regulator API is supposed to be the one true
platform agnostic binding, none of the device tree stuff is supposed to
be Linux specific.

> DT, should we lose ability to describe certain hardware configurations.

We don't loose anything, a single voltage constraint that didn't set
apply_uV was always meaningless.  I keep meaning to make the core
complain about things like that and people specifying voltage ranges
without SET_VOLTAGE.

> On 25.01.2012 12:22, Mark Brown wrote:
> > The big problem there seems like specifying voltages in the first
> > place, if we know what device it is we should already know what's
> > going on.

> Driver which handles said regulator might know what's going on, but
> that might not be case for its consumers.  Should we limit ability to
> query given parameter just because its value is hardcoded in hardware?

I'm sorry, this makes no sense.  Setting a value in the constraints is
not going to have any impact on the value reported by the driver, it
never has.

> Consequently, if it's property of hardware that it provides fixed
> voltage somewhere shouldn't it be possible to describe this fact
> in DT?

If the device has a fixed voltage output the driver should just know
this without having to read the information from device tree, device
tree is for configuration.  If the device has some hardware fixed
configurability it should define this in a sensible fashion in the
bindings (which may for example be a case of specifying the values of
the passive components for ease of use).

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPIXyhAAoJEBus8iNuMP3d38wP/3jUE+mCpEE+txlP06zNwDRb
lg0DZnvNhH3UkcCrnDTwWDp2T1TW6vDr6PcA/iELuvXutyeC3eYCQgIu/LhIkcYt
Qc6yJjSpFQho44/QUzKX5kPXgVlfoz90M1mKcwlMw0vw6Jbqt1b6uufcTJSz341n
TVu43IMSl1WElBQkUEI8t/xUomF6bM2KTnx+7+32xUXRcFMh+kZZk7eLTcgJObl2
n07q00MLu5IMJoa7D6FG9/t+YPZdHAkNzcJwIFvKnkMhnf590Dm9bi3aPdfoQbAC
iTXx70R2lGOf5BSpZDmLVCfGzkQwtTdxVdXKwMJCowzJUux3UnQXteUKYpxhkpf7
Ks5/mdfbEECRag2XDqzks8OQ1xDYg0n3CDKP8+Vt+My5h4hAeFmoCLE1jTyzQQh4
KMd/jExT1Buc6tQUo18DAC0iIi/S8a3qjnsD+CJz9ynEOk0h4uzHfOhdbznKjzbw
1/kFC/dGwXTArtaCUMkLea/knrMxTzTw6YnPcIFG2I8v09np6UFIndVqjlLX8k4Z
oRgRjLi6Y+6YzUKH7wAsfY2isAex7lfa0DwR1Vi+ugvAaPRsCemD5GYEgP5W8OQo
ViH8+gSmb7V9k6iCGrkvv3QMnNaQCGDZqt3DoSFXfSUgAGpwz2cGfu25uJ444Xnw
lP7nPiywa1AV446G/+uw
=L/Vv
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
