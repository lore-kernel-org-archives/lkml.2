Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2KXR4j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 12:56:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34333 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751864Ab2KXR4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 12:56:38 -0500
Date: Sat, 24 Nov 2012 18:56:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        myungjoo.ham@samsung.com, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, t.figa@samsung.com
Subject: Re: [PATCH 1/3] regulator: max8997: reorder buck1/2/5 dvs setup code
Message-ID: <20121124175635.GG4719@opensource.wolfsonmicro.com>
References: <1353657795-1725-1-git-send-email-thomas.abraham@linaro.org>
 <1353657795-1725-2-git-send-email-thomas.abraham@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eMnpOGXCMazMAbfp"
Content-Disposition: inline
In-Reply-To: <1353657795-1725-2-git-send-email-thomas.abraham@linaro.org>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eMnpOGXCMazMAbfp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 23, 2012 at 01:33:13PM +0530, Thomas Abraham wrote:
> The BUCKxDVSx register programming is now moved prior to setting up of the
> gpio based dvs mode. This will ensure that all the BUCKxDVSx registers
> are programmed with appropriate voltage values before the gpio based dvs
> mode is selected for buck1/2/5.

Applied, thanks.

--eMnpOGXCMazMAbfp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQsQpHAAoJELSic+t+oim9Nl4P/1HISLgVpKVm30nI5UNf7yoR
JF05xKoTs8Kw1iARS+MA6bR06p5GXJ9NA1X22jQHscm0J/QdxO9HzJxvEJYAJ/Py
0NwMuuoOepQNfY+6o5oPmcWbVClhi1888uBVo3UTHw1oLQaxj2tDM6812+l6mp5h
fr4cA2E85INozMPfoTaNZGDRAV8RE/+Q0lws+9+nIcypIw+gcYWKu7iM+cL4NWuu
eQPrEN3NVKmCmKbWOZWr7BBuhHxqSE4a8ddcozRY9mUy+/pniCmjbpqBkDcXE7TT
8bnsZcoC/gCFiDVtocOm0OZydpmGH71GwV8BWNXrv5XwM/5fF+i7Bia1LUyMWJi7
N9Dt2iYf4iyTNNpNClcV31qvQ6ae0ImkfOyPR82TW4kqFI2WOdG/xBhOEyMXIbBu
NEgBTY0bIT7WOSZym9i8LBMa60Q6XsH48zrRc0qkqHkppDYIvNxs+1sR4/NnS8z6
hHhAJG03RIqSc46pFwujX+3UR+xE7wDg6PaEZ2kaI4ZbNuZK5/ytcWX8zynxmlQD
9ha58aW6euUDK1yDOvROaSPkWEZ9m3nttOCX/8qzFermwDXIL9A0/igufJmzyH1C
7dkZnK1xalKXkhgHbEgSxmc7e6wzqANFH08VKq5rUTL6hzhkc4NoCGuhtF2d31Dd
QAn93ULCxvPVcEyShRVG
=EZXe
-----END PGP SIGNATURE-----

--eMnpOGXCMazMAbfp--
