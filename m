Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab2JQH4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:56:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57852 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504Ab2JQH4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:56:45 -0400
Date: Wed, 17 Oct 2012 16:56:35 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ciminaghi@gnudd.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regmap : make lock/unlock functions customizable.
Message-ID: <20121017075633.GK14199@opensource.wolfsonmicro.com>
References: <1350395819-31108-1-git-send-email-ciminaghi@gnudd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W5WqUoFLvi1M7tJE"
Content-Disposition: inline
In-Reply-To: <1350395819-31108-1-git-send-email-ciminaghi@gnudd.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W5WqUoFLvi1M7tJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 16, 2012 at 03:56:59PM +0200, ciminaghi@gnudd.com wrote:
> From: Davide Ciminaghi <ciminaghi@gnudd.com>
>=20
> It is sometimes convenient for a regmap user to override the standard
> regmap lock/unlock functions with custom functions.

Applied, thanks.  Please use changelog entries matching the subsystem
and fix the formatting of your changelog to have blank lines between
paragraphs.

--W5WqUoFLvi1M7tJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfmR2AAoJELSic+t+oim9H0IP/35z0/xY54tfjHSa8SZyKzMd
7I4ekhgkgEUQUhF913hOiJCPGi7jFfeO8pBdRejTIDyPqbKThBS7GX/U0PzhgmO5
44vDXvyH4ighGFWDAxpPID+4krp2q/FWn+o9MsUAD4Dvyma7KdLbw0M6/qzwe+Yb
SfB97wNTprXq3dhPoq5IsPs1gFxhdElS15kHMOb54XpbiE/r4uj1ChEbd6uTFXds
SwIVVfCiWQ6lGShYFeyvBlXdy6RPh+VCveNx5wgJfC+NGfpTxrv8iSJrAipL8ot3
DMVEYW3OWqXTQXvfoj3N7KYfAmzGFnsqSnK6V+OT3GK0aVs4r5eRrJY+7Ee9A8HS
hitSC8lxQPtZfaj6Tpc9D8humPAXO/BvDsLQtHAHiDb6aYMZ6E8xQgc8+Olqx1Ml
uZOnHXz6M84cYQVSuG/UeNtTi0FBpAbPtpAa3XKyFcCoGPKl+45QZAokypVy1cdB
5W7rPg8BOHzOYfu4t4WQV7XOIY1M3v+SbQT2wV9pYVPaNVU71LHg3n/ys0lwc2o8
y5u8NP5BXsQXwSgCzLbBdYxt6M9hjB+hApUjoJ5yqh+WWYfqREz4XIqeH/OjLY4g
sbGP0sDZo7YkWdExNlXoVzSxu/6Dij2S+LBXNvVA8ZgVmutQvWcmdYX7WygDCWGD
B6LWb1YXHJyGPM99+H4y
=g9UR
-----END PGP SIGNATURE-----

--W5WqUoFLvi1M7tJE--
