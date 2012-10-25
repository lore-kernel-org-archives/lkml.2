Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935710Ab2JYQCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:02:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45489 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946101Ab2JYQCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:02:11 -0400
Date: Thu, 25 Oct 2012 17:02:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: arizona: Use correct array for ARRAY_SIZE in
 mfd_add_devices call
Message-ID: <20121025160208.GM18814@opensource.wolfsonmicro.com>
References: <20121025141244.GA31078@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HVCoas+krw6dou6l"
Content-Disposition: inline
In-Reply-To: <20121025141244.GA31078@opensource.wolfsonmicro.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HVCoas+krw6dou6l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 25, 2012 at 03:12:44PM +0100, Charles Keepax wrote:
> wm5102_devs array was used for ARRAY_SIZE whilst adding the wm5110
> devices. This change corrects this to get the size from the wm5110_devs
> array. As both arrays are the same size no issues should have been
> caused by this bug.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--HVCoas+krw6dou6l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiWGjAAoJELSic+t+oim9sU8QAJP/oXqUO8eHXImo3zfuYYV/
+vIySP+WfPjEnU6MrzSK57D5EeIv+HPgKwMNKJVNOOwoqWrZoeX6wY2Rz7E8v4e3
UlFoqSGEl96U53wtpKHxnjdetqg7GaK/f0YRurNp2GJRsNubbwLCj/uLH/S4IXom
qevDyhxQG8V7ShpsENg03NR0hN9YA+br9qlTHhXG9Pjf1KvhKEniTTiGw0haixic
M3JlOunGO0qs+9VWy2O6nAXg65IwsODtbD8png8pQrAQFHNBQ3pS/86+12Z54Y6r
W6PmIWMmAhDlL//4mN8gVLW6RS/idaPgavX+doJTRgcv/fEiGt8olR46pMJryEBt
F8j5sGBwCxul35EcP5y01B27xL1T6q4M8QeBD5v5OIDQKPDj+vnD30HAAppBNXKG
um+0bGM9O1DZY5uvQLAgV/t3bLUHnSNFKxZd7h0zKWeeQEaQLjGxj9St7XeMWmaB
VNveh4T0uWiT/NErB8hy6x//4fooBzqxQYEL9BPN5VqdTQbADtH9AwBI82IYIUeh
i6wa2Z0BkPwpYpnArUdhL7i/ekOnXpHLTrgOS/a1KAj8PzlPMJNdWBvjclsAIKL6
Yd43D7RHWCjdnA+3zQMslGRGis8om7ycpM9TY67VUrvPtlvO7WP7Qx3rjfQcXjaG
pqnnGk936vv03JPawCOI
=mrqx
-----END PGP SIGNATURE-----

--HVCoas+krw6dou6l--
