Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab2EDMOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:14:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45265 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755472Ab2EDMOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:14:53 -0400
Date: Fri, 4 May 2012 13:14:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anthony Olech <Anthony.Olech@diasemi.com>
Subject: Re: Linux 3.4-rc2 register mapping and paging on I2C device.
Message-ID: <20120504121449.GF14230@opensource.wolfsonmicro.com>
References: <CAEqHmAstczdi2seTHFE0-jLK9fJaKosHjJyo4AJ7E9UKYBrVsg@mail.gmail.com>
 <20120430214718.GB4414@opensource.wolfsonmicro.com>
 <CAEqHmAsyJntRMqX+7NbQN0OmDXz6ZGh0LzAMp5KB=-cAMgpsJA@mail.gmail.com>
 <20120504103358.GD14230@opensource.wolfsonmicro.com>
 <CAEqHmAv+KTrJdiTL=76taTmu5YLYjukEiqk9UPbqCc-fDpQASw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B0nZA57HJSoPbsHY"
Content-Disposition: inline
In-Reply-To: <CAEqHmAv+KTrJdiTL=76taTmu5YLYjukEiqk9UPbqCc-fDpQASw@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B0nZA57HJSoPbsHY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 04, 2012 at 01:40:18PM +0200, dd diasemi wrote:

> If you are asking about the details, I guess, comments may need to
> improvement anyway to give a clearer view, how the API could be used,
> right?

Well, it's more that I'm thinking about how this gets implemented - even
if things are nice and simple from a user point of view we have to make
sure that the implementation doesn't conflict with other features or
make the code too complex to think about.

--B0nZA57HJSoPbsHY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPo8cOAAoJEBus8iNuMP3daSwP/AsEqpt54t+l459g5m8etzRF
d/p7OmrYkhYDkRkaMyoDsY2T/OKYmlkmn+kPFCU1pM+MNDSR2T1G+7tMACiL9Ofx
qW4iIVPTh9UqgPleTl3TqKIGjT6vYHW13QKBPc/tCiV+pQk/Vq5GyvCi1QMj7Hq+
O0q9+w05TB1p98tD5BxaIJOTCj1kdv3pl3MuMlSt3JVXnPGVElB++Y0oIypVAf9U
TzY/XxWK6oTaNAq71TF2XhGHp5ZnDqurgGoU3+zb7uZcRF4GUZO/kq8UH9qGVyAM
ujp+8I9G8ul91gbqLSAb2sZAnzbJQV7t3rC9YJgboUIjTHWP33Whq6WTdSTBVW5v
5SZtip9XYK3zErr4AI/IcJR0pkGZB3K5Qz3CRE2zyhP54mMnd+hq4/Uzle+LEcZN
37XQeHDmFzUJ94p5H08Eo9f6LuinfqieRLKUlZeNo39nfmNVmk6SgbYi6sA8g884
XUUB0MgoXBRo+QpOLkbHdjjfRvVZ9zN7G9WQVmEJ0HpP4I0aYsdDrr6vC0FuoS4h
+HKFdj/HgFeFKS5VwARKkKXhDm0qo42dqVpZJ6MT0CG64gx6W4Y8RZPMqtMLBt8R
Kz3b8bbYPAKYFR+IxB2jU6mBniugfmY/kv5c7i/8H4vjtCntn+/sG5QkaqoPfRa9
9ePn85EXFcKO5CDLBIdj
=RB0n
-----END PGP SIGNATURE-----

--B0nZA57HJSoPbsHY--
