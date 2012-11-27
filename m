Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab2K0UVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:21:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60432 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756226Ab2K0UVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:21:53 -0500
Date: Tue, 27 Nov 2012 20:21:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] regulator: da9055: Select maximum current in
 specific range for set_current_limit
Message-ID: <20121127202151.GD32691@opensource.wolfsonmicro.com>
References: <1353914801.11550.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SO98HVl1bnMOfKZd"
Content-Disposition: inline
In-Reply-To: <1353914801.11550.3.camel@phoenix>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SO98HVl1bnMOfKZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 26, 2012 at 03:26:41PM +0800, Axel Lin wrote:
> Selecting the minimal value is only true for voltage regulators.
> For current regulators the maximum in the given range should be
> selected instead.

applied, thanks.

--SO98HVl1bnMOfKZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtSDZAAoJELSic+t+oim9PXUP+wUNItye+gBLgXPjkakSp0Ab
fdVyboXeyaSVYYx/VnsOMneZH5EKzyqBJGRL0OlvqdMQa+TImCkL7ynIUqo7CrgR
cdztRrM8+mDF4jUczHxvA4zJl5KNikG7qgnawEXy1VKSRtYQO9gCa4mE/2JlbeOg
2lGXvSnlZkBrPP4ScOOHD5xdsTH6wfJYx4q8GKSffRUmJ0pmdfbpsmHaUDkUflzd
uZvtlggsZS1ols/3oYiQF3EewfVhLwnGNDvcInnUmMllIta4SQeNzHiaw8nqDbIm
iw8G1Pz+1Ml7+NOq+GWj6deUGPtwCee3zZV8F5sYEkIvaBPACDwK+fVEvXDwkITT
IVoQnQN1ATgF4nSDVjp0qtUY56CF2sjLlS90C0bCSaURcxax2jHfbfMYDOBwQOO+
Wc2sdzaajYUayH2iU6/GI61UAeqvMjAT1WpuDx59JG8gJF8Eh+V0dXF1sXT2HQHl
rD9yOjYuSyow1z72046bXULatNJ+6XMLAr9VUX/MwgdsiNDl8v/r+520mhiecy48
i5IIODvxvnRqS+PTfzYBNtVXBRpTcjPKMDBqsow8aYFr0n+8qELaJhG0tQzXLPGH
dYOiNv0XnKbv5Wv/shOmrlQfrD9xIVageJj4HzVibg24ilLJHu+dhK1FXNsOwQKv
rWc4BBONGuVON3q0riEa
=mOKW
-----END PGP SIGNATURE-----

--SO98HVl1bnMOfKZd--
