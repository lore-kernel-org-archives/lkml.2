Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136Ab2CZReU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:34:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57924 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933106Ab2CZReT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:34:19 -0400
Date: Mon, 26 Mar 2012 18:34:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Make max8997_get_voltage_register always
 return correct register
Message-ID: <20120326173417.GE3789@opensource.wolfsonmicro.com>
References: <1331608961.11322.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J4XPiPrVK1ev6Sgr"
Content-Disposition: inline
In-Reply-To: <1331608961.11322.5.camel@phoenix>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J4XPiPrVK1ev6Sgr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 13, 2012 at 11:22:41AM +0800, Axel Lin wrote:
> Check max8997->buck[1|2|5]_gpiodvs status in max8997_get_voltage_register
> and return correct register accordingly.

Applied, thanks.

--J4XPiPrVK1ev6Sgr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcKiPAAoJEBus8iNuMP3dunMP/3gnWP6u5kPEXQ4jtQ2Pxvao
yNiXavVOo8RF6U371pYt4KNZJD68uHifwv/rcefJsJ2vSH+pBgJ6Vk0MQNGF4JAf
BV/C99r/hjYQzOOEJXfjKKsvKcpL5SQG86iENhc6OaN3Fi2wTjkH7NrgdQwRfrWn
CZrrODcVvLEtHPjYgjKNUAaZKisla8z6uqGE8n7bo/Civi9tW8DTH76GYLzPZDTX
m03/2d+stifaBi6vbyLqoUPUBdHZEtGAkdCJWGBbOwhigvXbp1q0qlucYoKSTXxh
gE+PXLhE1nXT3ZJPCxXDYkRHZvzhNUzAfgXztiP0wkG/458B2SNLIWHoNjM6DOI1
7W774rDbb1XR3r8bVHDjaPWypbC+NSnaZGuMEjLP/gUK5r0gRFPv+dinspzYvywp
enGN8u02xfLZUWJRenMCdi1wkZl5kevhNdp92WCK1UJNrfxjtGWA4omzzdi7K523
of9SXmgfoK3DLovoxkT5qdHsjcSnJDNC4t/uq/lgTPT1iLHoJefJuyYLnva3t/mK
R8PKxla3w/Z6D2ywTJGZTE71Ecrc8LhRZ+61WjyrCbe3EYfydspQ7veA+TTgqhHn
EwOX4d4v1QdPXbs4yqvcIY5AnMThRLsEwSoxAnSo1OdLvcFSZ2cDVw4sqMNKXWn6
YF/ElUMB4l4+KFSaz4GV
=yfu4
-----END PGP SIGNATURE-----

--J4XPiPrVK1ev6Sgr--
