Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab2DWMYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:24:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50328 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754942Ab2DWMYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:24:03 -0400
Date: Mon, 23 Apr 2012 13:24:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Remove unneeded include of linux/delay.h from
 regulator drivers
Message-ID: <20120423122400.GK8318@opensource.wolfsonmicro.com>
References: <1334710348.3020.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ogUXNSQj4OI1q3LQ"
Content-Disposition: inline
In-Reply-To: <1334710348.3020.3.camel@phoenix>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ogUXNSQj4OI1q3LQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 18, 2012 at 08:52:28AM +0800, Axel Lin wrote:
> All the drivers that need delay for the regulator voltage output voltage to
> stabilize after being enabled or after being set to a new value has been
> converted to implement enable_time and set_voltage_time_sel callbacks.
> Then regulator core will take care of the necessary delay.

Applied, thanks.

--ogUXNSQj4OI1q3LQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlUnSAAoJEBus8iNuMP3duKoP/RSAEjnLUJEzI4A85oyIeb7r
s9BBIj8mpgae8bTpulJwag2W02iiF7G6e/iVqPxHLj7y6geglVvDfph/CeA/fWB/
Z2I019TLQ5IIgnErnUJ//wZL3Iq9QW20sELX33Iz31P4lRDwsJgNrwbdLn5z3tIb
ouyp1wo2d2J6xRlVpWZBAl56PpoM4W0CjMdhRwJLPYxy3d2FyOs90gzapLYjKsbP
Z2j46mscdT5xDytIkR6vbu6X35lDU6XzSI9XQ4zZ196IYolSwjzD8s1jsSa3HWEe
Uqp/mkdhxj9PnAVCQujFUdvwTAvw1z081t7s4Ckyq0tLpqxJzOt9AZDcyHbQRPwt
xt1HiuU8fhTah44iPD5P9ELPU3m3+h4ww4tT2X9kMEHnZ/dO/b/CX/z/hdVLOpOA
gFax5/kXoFll667nbbsYhgWaorx+dqAUAVtcpdsFKIhUXRyIXQhVw93ylGhVwW5H
SavdZ51Kq1KfrOEgCIs44J+gi6eqbKnk7L3OkgYlHsD8bHUUokalxfQHsFz/Hr0Q
BSHhspuXcEqn0mMuxINONedBx0fajKxJnef5gQCsDWtIytHl4UlLqJnh/U3cL/tS
8YQEO3MkdVv5dBF+knRFqQJR0rs3BUf2vnqEykAHTfCBJJ0vEDCr8wT1Ifb0vsyc
j4bRH9dNYIUtvL1f2CPW
=sCok
-----END PGP SIGNATURE-----

--ogUXNSQj4OI1q3LQ--
