Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2EWXfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:35:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54735 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924Ab2EWXfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:35:47 -0400
Date: Thu, 24 May 2012 00:35:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 1/2] regmap: allow busses to request formatting with
 specific endianness
Message-ID: <20120523233542.GC5361@opensource.wolfsonmicro.com>
References: <1337812434-7609-1-git-send-email-swarren@wwwdotorg.org>
 <20120523231641.GA5361@opensource.wolfsonmicro.com>
 <4FBD72A7.907@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZmUaFz6apKcXQszQ"
Content-Disposition: inline
In-Reply-To: <4FBD72A7.907@wwwdotorg.org>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZmUaFz6apKcXQszQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 23, 2012 at 05:28:39PM -0600, Stephen Warren wrote:

> I did briefly consider making this a property of regmap_config rather
> than regmap_bus, but as you say, it'd mean every MMIO user would have
> to specify the endianness value.

I didn't say that, that'd be appauling!

> Also, it doesn't seem right for a device to be able to specify
> register formatting endianness for MMIO; presumably we'd always want
> that native.

Depends on what's going on with bought in IP and register map standards
(and things like PCI) - you do get non-native IPs turning up often enough.

> I suppose we could avoid every device having to specify the endianness
> by introducing a fourth "DEFAULT" value == 0, and having the bus
> define what default means - that way, I wouldn't have to edit any
> drivers due to adding the regmap_bus field.

That's absolutely essential, there's already an explicit idea of this in
the current code's assumption that everything is big endian.

--ZmUaFz6apKcXQszQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvXRIAAoJEBus8iNuMP3dsTcP/iOokSZgt0ODckevg4ud8QgR
8ITNz9oJkPML94L7zvMeEiChg5ZkKa8pnfevNqMeLuJvO9s+z6YGG0PTnQWk4o4+
D+IeQcH7VuPrBIkjsSuNLJq1bH5G0aYBgy+5zPYbVF4orDcu6YgoDS/SA0Zj7/F9
+qhssPy9iwuhnIkpiYDE+XTHvkatTdQsSAzYs2fkYBhASwo2LNBtWDzRe/DNjR8f
wERBBv+m9dB3wbC2XciFWENI8WeoOPZ/zHWfNNnxDOZ5eWJwv7icTFJSwXZjsXEM
6dm+WFzO06I/SrTlScdAKcgHzpW7h1xJAqYvgaykq4XZ758IHkvlqqhSi6UJE7lH
JC+cwE1FD5P9DUsBsp1/E7qn6ChpDmnQ8cycwwpw+BWtjvFaT18Jve8nPX0qPgUV
bGBHH8XmBZtQwFVP8sZBM85ME4J5pYEoP1BJvWSkFC0VBz058SpvWU2h958oKTMr
6r474LRJA6NUwLILo5lW/5tkD/t95uJlKXoTWoFOK/0mlaJ+JPGNq6c1oWMljOyu
t38eHJ4vFf7egWO9Qbo0/nIipNmGXT6oiaIkF9OwyiDJMf4PMXRIi3KpRcUe/s6z
vdSJ9mR/+/dRQU+Bv/eoGBcIhviUYoWDex5rL0DYt8tKKRmpdfsXcIOq/cknnz6X
ALVSKSZzbU3w9UltYX/7
=LxTS
-----END PGP SIGNATURE-----

--ZmUaFz6apKcXQszQ--
