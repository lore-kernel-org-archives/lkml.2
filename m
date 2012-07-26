Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab2GZOsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:48:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37432 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288Ab2GZOsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:48:14 -0400
Date: Thu, 26 Jul 2012 15:48:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: grammar fix in Kconfig
Message-ID: <20120726144812.GN3099@opensource.wolfsonmicro.com>
References: <1343311644-19739-1-git-send-email-michael.jones@matrix-vision.de>
 <1343311644-19739-3-git-send-email-michael.jones@matrix-vision.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YGQsgxOP0v8GKjPA"
Content-Disposition: inline
In-Reply-To: <1343311644-19739-3-git-send-email-michael.jones@matrix-vision.de>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YGQsgxOP0v8GKjPA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 04:07:24PM +0200, Michael Jones wrote:

> -	  constraints then the regulator core will provide an always
> -	  enabled dummy regulator will be provided, allowing consumer
> -	  drivers to continue.
> +	  constraints, the regulator core will provide an always-
> +	  enabled dummy regulator, allowing consumer drivers to continue.

This appears to be making the grammar worse, it's just removing a "then"
and inserting, random commas which don't make, much sense.

--YGQsgxOP0v8GKjPA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQEVh1AAoJEBus8iNuMP3drqMP/ROoWJuNi4CWrE8CFYOW0Jtu
/foiLCKVyzgR++dfVhrarEVF8YRjhggGFXywuaylbMlqsiwvlQYmAlpZavmdRYBY
vOh2UPGBUEq3l0QV+y9sEdSgYsPX4mHQfXs4fWc0npEBvJCuU0gscZB8umfjw+fN
4+nA/a1VOkA6j7eovklyMmOSn1K3nuP0gbi80ZDfhw7ual6A4STX3FDfRvcl+hbU
l/nmWUHeqK2OzUOBWXCIzScPEYfpiz+ux+lTE+uaZJHrFDtvZ7Q0UPMrTy2SW63b
edNitAyJI2lVS6wCWJiVbqrjXNsQ8pX7rrcElNWpa0ielayV2JFWNNdpWMOOYr0b
z8wQIQNUbQscpYBGaNbUJvQJvWJDAuvzd5QqxcvtqrWmbHpoW4ih3uMype7vjamc
aUrYhO3jdKi2jnUzqN1yVCakSGI3kqXjstoXg1mwqG4RWlj+gy1B8JMPW/haXnsc
S6OMT32PFvh64JDJ1D6vPw11708zVhZFS7Vsk/moqBSX/RyB7MhYMLnXly1C2NbC
L5buY9HFSEm/nmxgFUNJC3WO2LYi3i9EDBbbg+iwq9ljWk9khRg5w4JyrRiAcIXE
NE5NfJUcIhZE67fssBuEnuK+sZrw0X8NvT4DM4AWuOaCKciJoy9xOdU9fn2ws+P4
V3pLuUHciRA57to4d4PU
=uhV2
-----END PGP SIGNATURE-----

--YGQsgxOP0v8GKjPA--
