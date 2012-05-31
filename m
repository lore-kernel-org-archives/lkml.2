Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab2EaR5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:57:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46651 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753667Ab2EaR5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:57:53 -0400
Date: Thu, 31 May 2012 18:57:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <Krystian.Garbaciak@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: Re: [PATCH 1/4] regmap: Reorganise internal read/write functions.
Message-ID: <20120531175750.GC24139@opensource.wolfsonmicro.com>
References: <201205311607.q4VG7avr012901@sw-eng-lt-dc-vm2>
 <20120531164148.GK2666@opensource.wolfsonmicro.com>
 <751C305CD2876B4990194D0512DE8BF2441CA8CA@SW-EX-MBX01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <751C305CD2876B4990194D0512DE8BF2441CA8CA@SW-EX-MBX01.diasemi.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 31, 2012 at 05:53:16PM +0000, Krystian Garbaciak wrote:

> However, on next patch I need to pass *val for reading and writing to
> the same function. I will put casting there and comment it.

No, let's do something type safe for this.

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPx7EYAAoJEBus8iNuMP3drWUP/3OtSwTxw9HEeyjCVuT0gBEf
Jyr7Wl2kJXGKUdaNd8YKslKVII/S/yX+oDOb6rej14ne75liZ1ahrF76MASBXykk
AaE7i6fvwU3W5E7eQz8Na5mMlj9e4E2ATb7AaCjJ0UNC9Tw/CIdIZwVJdJ0PpJam
Rw8o+iIuksB6mZSeXrarsCb7RNk8hurGaUvlI++EhZjvOchUyzK6k+LUBi+gBJwX
WrsjciUyG66V+T/hqQLzl2YzyT0DWKKXrSCddJKTNqxUOTwG1Px9P7l7vBwGYbGu
/vm7hWtvQ2Y8loEAznT2TaKKFeNUoj3Vrv97yqsTen7HpnXYfx2KJzV30OJIypQt
a4I/mTTbnvfQN7YQpj4sTu5Rcizwtg1pKTJynlXPSLmTONikd9vCpHvV9RNjeX7n
tVyaitDVA7s4ESoRgV58sK+tA7I9FKfCF4Z1WfVhV/9ULpIBvP6zylGBhnC/6mDy
r9GTfy42NzOKYkeHbXbK0KXSp7o32OySF/XeYkbRg9tDgwSpR13ZOt11iQXRCp2h
kfqo5BjPIV4tdt4ybmYSCi3OhCqU5uEyg8BiG2qsYKF9p1cwNVxVv0njfN4M1j+U
CSmLWlSqRaDn0CRorco0uRhi82MRtrUKDi7ed11KXM0ImqBh1amDJqpFN6d0V2ZE
Y46lc0AtlEwqY3g5bDA+
=9QOg
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
