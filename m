Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838Ab2GDKVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:21:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52375 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932623Ab2GDKVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:21:47 -0400
Date: Wed, 4 Jul 2012 11:21:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regulator: fixed: dt: support for input supply
Message-ID: <20120704102144.GE4111@opensource.wolfsonmicro.com>
References: <1341223645-7817-1-git-send-email-ldewangan@nvidia.com>
 <1341223645-7817-2-git-send-email-ldewangan@nvidia.com>
 <20120703191704.GE29030@opensource.wolfsonmicro.com>
 <4FF3EA70.307@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="47eKBCiAZYFK5l32"
Content-Disposition: inline
In-Reply-To: <4FF3EA70.307@nvidia.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--47eKBCiAZYFK5l32
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 04, 2012 at 12:32:08PM +0530, Laxman Dewangan wrote:

> In non-DT, the input supply is passed with the regulator_init_data
> through the fixed voltage config and it is filled in board files.

No, this is a legacy way of doing things.  All regulators should be
moving to specifying the name in their descriptor except for supplies
that are power roots (which are often fixed voltage regulators).

--47eKBCiAZYFK5l32
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9BkMAAoJEBus8iNuMP3dnwYP/2m7bkI+Pwvwt4baOJiH0NmL
s+A4QUk+gIbksP108IgD3SwcnIqGLy00hqtLNTl1Fw+KmPROwHa71saEIfPXf9bz
DXHT2PLBCumojGoMwIRWhaiehAgfXCJ2H3hqYKvwaOxE/k91OoPWWpH99tQ5WN5U
2zQElG1shq00qCxavDhETVf4j6zdqKfDPJDcI8hkJi3pNwMuGmO+gtkIhCsGKMh8
AkrP5buW2sBXa5SWuv1fcYyWqGe2NZg2lonz9KOSx53B2P4rowVlXwvfw9+HZwDJ
EzWofGhqk6DVFUV8JmlFa8pGT1FWaPG0d1ICTrHoT4TqeDbG483n54v3HcjXfWS1
sWSezYhu4PY3xi8JVXLBINcF453aeJAAbu/yycSiZBn6lSLfcDnrrvYPNhYk00PZ
IQIxsAGSAFAaYzl9GtvdcmoC6vtUoEmXcm5YCxhcb+Ice4dxQ8+WO8HpJ5gfNXWm
qI3IlJLbMznoOyq8AGOohMgIspQpceb51AD2rUYkpwcPxCfdLOqEOEazb/5j/Wva
MATpHcTVp+ph0fs8LE/TKt1ZAgl+ZSERmE2csnIMbFoXwtflrwWKeglf8JSMOi8I
u7rT114o5LMVzPFtXWOwLcfDIqH3Woh+KckYp9YHZx2GTN9r/Hvq6RJH8Mv1ezvR
uwR/86jxqAkt6ZMJZtge
=O9tq
-----END PGP SIGNATURE-----

--47eKBCiAZYFK5l32--
