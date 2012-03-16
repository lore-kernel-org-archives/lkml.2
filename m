Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2CPT1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:27:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54413 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755213Ab2CPT1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:27:03 -0400
Date: Fri, 16 Mar 2012 19:26:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix up a confusing dev_warn when
 regulator_get fails
Message-ID: <20120316192654.GK3158@opensource.wolfsonmicro.com>
References: <1331893221-14426-1-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tv3+oRj6D9L8lW+H"
Content-Disposition: inline
In-Reply-To: <1331893221-14426-1-git-send-email-rnayak@ti.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Tv3+oRj6D9L8lW+H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 16, 2012 at 03:50:21PM +0530, Rajendra Nayak wrote:
> of_parse_phandle() returns NULL either if the property name
> itself does not exist or if it (exists and) does not
> reference a valid phandle.

Applied, thanks (tweaked the subject line to say DT instead).

--Tv3+oRj6D9L8lW+H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPY5P4AAoJEBus8iNuMP3do7YP/26qD2d479iIiD1a5fdgiC05
YPi13P7mDJKuk4H0rSAzSXP8kPPjch8Yyn6ARB7Qstzy2K/Rp9sFaUuy8Hh9sCJH
apZeDqlX4OsGyt+KTwb1b8WAARIT/os9U+betTTg4MNwIiy8HCx+Q4l3gPZKPflk
xzQs/faejuCEavzgOjYMucKyuYV2hXwaQAuqXHuhEi5sO9DemyYn7EzYe62Mmnrz
vtZwdGD8aO6hF6Js+3JNR5fnfBzOFy0HKihI8TOOlubl6mHOAn/rPAjz74ZO5wER
LXNrgU98CFLJzevno1ZvlEJuoz/bceayNkoQAnFV7Ga33Yf/r7AFXJnV8yJVSqlv
PSxEdSz9EccUQ1n7GglAmnK56Qs2hM+QZhvDNJ3pEJuUAOSVrU6aq8BOuIDI+yoI
x/vcS0ksohO8ihjKF51w2SOelYcVUPWF4RaO5Ad/uYf0mDfyt7tTgAZTqsdEQ5eQ
49Z6hLfHN/VaqwrWvh04irzj+Tai+l0HlnVGtHgfaMKP20IxZDgdRAkAmgBd0hK0
MqR/1qUYrrfTw8LJ04gNX8IQ0vVxbRXoTEyUcXgm/4ixqy+uggNLOz8l+4zMXi9W
pUBCBqTQSYX4VcLvUQT42texg8rxk1N9uDFa+Wmur0OXmrwuhN9j/3kXqrdsygUk
o0nJv4hLA/8t9X6FVh5Q
=KSll
-----END PGP SIGNATURE-----

--Tv3+oRj6D9L8lW+H--
