Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2ENINI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:13:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43626 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754149Ab2ENINF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:13:05 -0400
Date: Mon, 14 May 2012 09:13:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: core: Ensure simple linear voltage mappings
 falls within the specified range
Message-ID: <20120514081301.GE31985@opensource.wolfsonmicro.com>
References: <1336962817.24732.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LSp5EJdfMPwZcMS1"
Content-Disposition: inline
In-Reply-To: <1336962817.24732.1.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LSp5EJdfMPwZcMS1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 14, 2012 at 10:33:37AM +0800, Axel Lin wrote:
> Integer division may truncate the result.
> Use DIV_ROUND_UP to ensure simple linear voltage mappings falls within the
> specified range.

Applied, thanks.

--LSp5EJdfMPwZcMS1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPsL59AAoJEBus8iNuMP3dXK0QAIptLa9l2bOfgCi4jkkAMDoX
3f+oUkeHhwVwAfEcQCm3jLpEWATLB4Utw/3agZeyZcWuNU49NCPg+3Be7jMGEBQp
3+5F7Pvd6cRJAnZx1zyzeo3e8gmPa3fLelL3ug4b6dXBwKwTU9pLW+Sj3i5dBcKO
kwab3NgKbmUbwQzW9uhOGAaBLL89dHw0WPMPLh5wN9XZ1zDN7TiosvaekNLzG5uL
mm09o3+gNucSA94L547YRgQ2Q4oU/UmHc4hXHk3yD/MLJs3rn67mY3Ot1F6DwtF4
FUH0rPTfciKKFqiJLcke6kmCl3ZW2gHal8GQ/Q7M0RGm5m/poDOiKEkOeKqLBlGY
vdrlVra4RG6tFTFqHTt7Jm/lkskGmZcq+0bDAbnbftFwUPRi+Nyb1SCpXWFDIgMV
bdmxFfLEolvTs89w6jy5vJNI3FlrTuiTjn/2qzZjkmmbIcrRsT56PhvQa8I/ZF79
jVJ1vEStFzwjQiBQ0EsDlcdSiCSODu+Bkh6iYqnVz3DIexukV1csEY2kBHimfjBQ
/ZREYZG4sPMnhnVrtJ3vabD/+O60a9RBxHVRRojOkOzSlVp8keD1+GIH82s/PE5J
cnrExLLl3h/w3jvgKMYm2jZFi4ZyJK49VFnlbp5WrXOnzji4M6yQn9B/hfZ/IlXZ
nO20BmPKE5kv9DILC3FR
=cmFj
-----END PGP SIGNATURE-----

--LSp5EJdfMPwZcMS1--
