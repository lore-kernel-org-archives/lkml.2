Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3AHKn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:43:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58531 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574Ab3AHKn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:43:58 -0500
Date: Tue, 8 Jan 2013 10:43:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT] regulator: lp8788-ldo: Use ldo->en_pin to check if
 regulator is enabled by external pin
Message-ID: <20130108104356.GK4544@opensource.wolfsonmicro.com>
References: <1357371223.22227.1.camel@phoenix>
 <20130107110818.GB4544@opensource.wolfsonmicro.com>
 <CAFRkauBBHtjR+GYogpVPxBwGnoJD2==MUaqhZ6KOC7TJE4SpAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDymnuGqqhW10CwH"
Content-Disposition: inline
In-Reply-To: <CAFRkauBBHtjR+GYogpVPxBwGnoJD2==MUaqhZ6KOC7TJE4SpAA@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDymnuGqqhW10CwH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 08, 2013 at 12:06:44PM +0800, Axel Lin wrote:

> In this driver,
> There is a case that one gpio controls more than one regulator.
> e.g. ALDO2, ALDO3, ALDO4 are controlled by the same pin.

> It looks like current regulator core does not support this case.

Then the code to cope with this should be ported over to the core
instead of being open coded in the driver.

--qDymnuGqqhW10CwH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ6/hkAAoJELSic+t+oim9KKMP/2my2Pu5/QiMsL1DRCvZ4HY9
2DUtmLtFNV8I5wVujHcxQucH5CRXFJb/Fv1CXPbtfc0UPdzeMjf97xN40kkjxJ+M
YSxUcWgOHAn+ZAlakNDXXU03ZtJVy0J3wt7jmxQQo4ZfrE5K6cjThESX7mkpyJoS
Xy253RlpIgrBFTIgHPUpFzS9MV2nSSCtkLleBOpZPvaFIms9HRU4RN7R6tucqdWr
vhdm1+ICRro8mK4qMgadIiITkSEoLenMHNH0qU/spa7QNr9PW2U6ELd3qGuHRGU8
Ft4aHpWsb9bAogsr876zwPtgXefFmIic6IkZO9UQmd+edzBot2p77kHx0S2FSSSY
6iRPmnSqiCqC+IcjCRypQEUfOnSD6YUWzCubmlJ98ER9MB3UEcMK5MuxOhv9YHiq
J6lxSzLqo4hYwcIvwfwBlQ+h9Em9GwSNzMo7M6ctqIt21nUxoYG5KpOfF8VA7DM4
GbJC4UusgUIKduyNnNult6IhGatSQfJFQ25AdEBh0+D/5FdFb9m9Pu24UEOyu5qs
Tcn0SXiEbyAtjENhnjjskebkymvfcplmTlhFXHzFEiAFkTiJ/aMx50z2xoEZ/xTM
N1T7GCQMhMQi2zCSQRlNSwO0Hv9LH2oggjzmGtwdbTr4+Mcm5kbohfW4VJAweAa+
+ee8gYh4Av7qjARYLX4e
=jTEy
-----END PGP SIGNATURE-----

--qDymnuGqqhW10CwH--
