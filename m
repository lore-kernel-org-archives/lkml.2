Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab2KZL4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:56:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57790 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754136Ab2KZL4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:56:22 -0500
Date: Mon, 26 Nov 2012 11:56:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: alsa-devel@alsa-project.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, lrg@ti.com,
        perex@perex.cz, nsekhar@ti.com, sudhakar.raj@ti.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, rob@landley.net
Subject: Re: [PATCH 2/2] ASoC: Davinci: machine: Add device tree binding
Message-ID: <20121126115619.GF9411@opensource.wolfsonmicro.com>
References: <1353557099-21599-1-git-send-email-gururaja.hebbar@ti.com>
 <1353557099-21599-3-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0hHDr/TIsw4o3iPK"
Content-Disposition: inline
In-Reply-To: <1353557099-21599-3-git-send-email-gururaja.hebbar@ti.com>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0hHDr/TIsw4o3iPK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 22, 2012 at 09:34:59AM +0530, Hebbar, Gururaja wrote:

> +- dai-data		: A list of DAI data used by SOC code to register
> +			  DAI, Codecs platform.
> +			  The string index "should" be as shown below.
> +dai-data =
> +"<DAI Name>", 		"<DAI Stream Name>",
> +"<CODEC DAI Name>",	"<true if evm_aic3x_init is required, else false>",
> +"<evm ops required (evm_ops or evm_spdif_ops)>";

This continues to have the same issue as with previous versions, this is
all Linux internals (especially the evm_aic3x_init thing) not a
description of the hardware, there's not enough information to allow
someone to work out what the bindings for their system should be.

Do not post *ANY* further versions that have this evm_aic3x_init stuff
in them, it's very annoying that you keep on ignoring this feedback.

--0hHDr/TIsw4o3iPK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQs1jbAAoJELSic+t+oim9DmwP/AsAL9pNXNxmU/aCTCVHv1Kz
YFXb5dBpofd2qcbloEoLvYeZS0QWs8fdJYrplmKd57jZM5/ltBhm443fs6ltQ+vE
AFlIpDktosTZTvjk8LcDh3IVB1zstGglXJFnb4a2ceFPq+Qee5w0em0cigotNWfY
BadAv5gLDbhCKbg2XMrQU6Npv1bE79eAOu+4LTyrPieUtK/97Yncjd+nFZCrigr4
R7Oa5usgW94HQaWVzKajboOHQLSiYlkksmuSV6s5E89QVvmLV5eG08O9Vxlmc7ix
bwHl404B2t2OeUS6L40M12PrdqQ03nZJNkzOLgdrl/mAitCEPse0rOjGn46udUKy
VWUHczmETZc2Dp8ybgBr647iIPl1gQKy/um6c4V4h/og7MZwBK+i7yKj7NqFGdrN
hHIvQpEVpbSwbS6w+iGO5nwNu7qSRQGt80zHqeVTmg5ztbmHcELJ+7OGBtrp6VhF
nwPVkkJw4Q3w4G/Ui8uIN5sJJ6GefWop7R3NsZsljGKZkNWHj5gNW60YQsP90KBE
bjdXdUIN1Ofb0D4B6/x35yp8ETZ5myOVO8kMOPTMLteY46z2ZO0QUms2hR5RYQI0
nUZ5AQAuzGOFLjME/0e+rqNCLOT87Uemag9T8DkDgixwv8RABGkegqlqLdcRkpN3
8o0zXlSXwpt/L8SF4hx5
=OcxI
-----END PGP SIGNATURE-----

--0hHDr/TIsw4o3iPK--
