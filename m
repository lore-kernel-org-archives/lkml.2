Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab2ENSMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:12:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51370 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932067Ab2ENSMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:12:42 -0400
Date: Mon, 14 May 2012 19:12:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Sebastian Hesselbarh <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Common clock framework for external clock generators
Message-ID: <20120514181240.GI25668@opensource.wolfsonmicro.com>
References: <4FAB15DB.5050702@googlemail.com>
 <20120513122946.GD706@sirena.org.uk>
 <4FAFE1BF.9050805@googlemail.com>
 <20120513164304.GB6381@opensource.wolfsonmicro.com>
 <4FAFEB2D.5010009@googlemail.com>
 <CAJOA=zOXh_+HbtSr8cXXNJWCWJroC2Cy+62y9nx7tdH4ZbhXKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="STPqjqpCrtky8aYs"
Content-Disposition: inline
In-Reply-To: <CAJOA=zOXh_+HbtSr8cXXNJWCWJroC2Cy+62y9nx7tdH4ZbhXKw@mail.gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--STPqjqpCrtky8aYs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 11:08:58AM -0700, Turquette, Mike wrote:

> Seems like the clk_unregister patch fell through the cracks.  My
> mistake.  I'm going to be sending another pull request to arm-soc with
> Orion/Kirkwood support.  I'll add your patch in at that time.

Ah, great.  I dropped usage from the wm831x driver I just posted, I'd
rather get that merged if I can, but I can easily add it back - I'll
either roll it in to the next version or send a followup if this version
is basically OK.

--STPqjqpCrtky8aYs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsUsRAAoJEBus8iNuMP3d6k4P/3Sc4NMb9jH5iWlcqh4AsJO4
jzjUNQHaJ7/W7A4JUxvX5iFhnvvvGBDy4pnd7BQnbbUCTrMlwWRwVu9A3TfEgP7A
7q1CMfyppNDV+IcmEqI5KlLKmQnPTZHtYKETxzQKIrjRaA2pQjU9yIJcUEFxcy8+
J5tcxy0ja3gqwUDVZS980d3FPv0MdJlYZFqlAmAKK64ebFNNdZV0xQNqPpBCgtcG
r3e5f1dNDLRl8OmERuIne4b0mKwhcLq8rG5t3a4CsZYuOjZo+nKHlYafM6JUn4jH
OyuQDWFd56+U6aJrB8VJFxd9H7+I6R+Uobx2RzJO/scCQGiXknRAWw2fGoV41ajY
XSWPjyYZjSemI/X1y2TKE/8c1fu/biXkC9HkrRoGQzDc0A1hNa4ecGEsEOdNS1kC
gc7qBQk1iAB9FQAO8hhce5rZKPQVAh/neAi6/LqdgW2bxSwVvD4Pc6+K6Z4gHq02
6F9ma86B9kPRJ7fLz8d1AN7jLlXMeMChDtqlQkM+ZCvUeY2oLD0j0cy/EagsFSC/
e4G+/mf8fHEGRWVaG6XKu/GaVbCZXshzh9UMkd2zYkrKgS3ZQjRojbbagDjEVyFM
X9mx1YCUso1ul3dOXzk4g8CubCXiXGZP+NUSrnp6nRTfq5/DYOeVRKycQsTT5Rpu
/0onv+kOks9Vq1SmwIin
=d7aB
-----END PGP SIGNATURE-----

--STPqjqpCrtky8aYs--
