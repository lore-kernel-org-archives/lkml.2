Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab2CZKwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:52:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53767 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757222Ab2CZKwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:52:24 -0400
Date: Mon, 26 Mar 2012 11:52:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Venu Byravarasu <vbyravarasu@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: tps65090: Use IS_ERR to check return
 value of regulator_register
Message-ID: <20120326105221.GG3098@opensource.wolfsonmicro.com>
References: <1332557760.10528.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Iq5ULCa7nGtWwZS"
Content-Disposition: inline
In-Reply-To: <1332557760.10528.0.camel@phoenix>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9Iq5ULCa7nGtWwZS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 24, 2012 at 10:56:00AM +0800, Axel Lin wrote:
> regulator_register never returns NULL.

Applied both, thanks.  In theory it may return NULL but that's not an
error code.

--9Iq5ULCa7nGtWwZS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcEpXAAoJEBus8iNuMP3dRUsP/2XH/Vnuy1JDtot+F8GqhCAL
rM6TAD57i86QH25G+pp9bT7d1nF7luZzhd5a894fvAbFiheXjKivRVJaSIJmfC/y
Fv+PfBubVormR40ZA2R/Df827kG7vh/elkd70LY6nnCavcaorxr/DjnerPCxuwL4
7SJVGUyBBkM1f6ao3VFWSoCbKWY/FW60S1jzEHQG9QNzw/30lSVAzvzB6DjTPpiD
FKGpVZofnnYpIPFB3fsnnMvPqMGiv1o+Oz476N1Z54o52kynlJL7wTJ76nNZq0Za
BksOpIhm8iVH2CfH3u3AyP9f3E4x3S6ThP8ybsp4rItne2jo2w3//N8+SdTCTYpE
heWhBmCRkmwCA1sBvvjCzI6SqehxiUEcsLud81hGKTd7O+v+CrB3O2OflMNFNZiV
K9Qr3KP5FHGlPZTO+fnEjpubMIMkWnwZ7lB+Ry/Yhnu+D0QQ+8pLC5hItV/Yn/jk
mJA1TuZGr9KQUHllx1Zc8AWum48o5/CNPKLIruIyBj3M49eJghwoGYFO9w/36Ecn
mGXv+RESrCdXSKU9IbyTRxAf0x6bKl098rw6kC+I6GkkEQbtwKT9iost2Mud8mpE
58jFIU9K6D2BAxuXxb5q29uHLqZbbmETCyqZFg3PC+VhodKwvvrp+XBiJEHMcJuu
97M3SP7ngA59d/UEc/GY
=r8/t
-----END PGP SIGNATURE-----

--9Iq5ULCa7nGtWwZS--
