Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab2BMQhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:37:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37735 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755282Ab2BMQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:37:16 -0500
Date: Mon, 13 Feb 2012 08:37:12 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regulator enable/disable delay based on board design: How to
 handle?
Message-ID: <20120213163711.GD3494@opensource.wolfsonmicro.com>
References: <4F38D55A.5020208@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/3yNEOqWowh/8j+e"
Content-Disposition: inline
In-Reply-To: <4F38D55A.5020208@nvidia.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/3yNEOqWowh/8j+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 13, 2012 at 02:48:18PM +0530, Laxman Dewangan wrote:

> We observed that some of the rail enable/disable settling time
> depends on the board design specially based on external capacitor
> connected on
> rails.  This is observed mainly on VBUS regulator rail where
> difference on the capacitance value which is connected on rail makes
> the on/off
> time to vary.

Usually this would be handled via regulator driver platform data as the
regulator will typically be designed with particular external components
in mind and (especially in the case of DCDC convertors) may need to be
configured differently depending on the choice of passive components.
Many regulators also have some software control for the ramp rate,
mainly intended to limit inrush currents on system startup, which can be
varied at runtime if desired.

--/3yNEOqWowh/8j+e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOTwsAAoJEBus8iNuMP3d/Z8P+waZR6/ICB6RvF8nUrQpGZlq
XFvmMIFdYYwNroMH7CeCylOeDnXgw8lc6sofQNck0c+4/PhYvGkfe2X1B06hJzu4
wA3kS2StC5fKJmU3gWmbZsVoXXRcyUZ6vFdvkFH81KLLZohsvgTcXCNZApIdil2a
NI4R9YrU5byrAh8Z8LbVD2ms1tOfyEFfULlsjkSgG4bDbL4BMe64/T47j9qEI5L5
200jAiAHAZlQXnQP8qg9+boT4fIXc7ueq1WEiriJ7KkDw+PZzdeHqKolR12o+1yD
oRB+Yvx0769IKV4nyIGgEZPBNmuYSaTBFRNOdnaiG9hGLksm26/UHgaayoB20Soj
vvaAYI4lCPLub+M2IBJUjio2cQ3zgPIsiw1Ncd1xJrBFGKDE7bZIRmfSo2PRqIvt
+xB34h7QqITuEx2X8e6/NXqT+Ci15BiddpSFnuYfpSNe3Eus603ygEYZ6Z25WMX5
g00IVhhDEhsO/LJb+v4NXsJhS/SKMWCsWTmHvyN2Fws6pvb5H4DkrUNuyPl5mg5/
BUC9DrxSHWokMF6AXXIrcPPAyWnjFal20zlLzg9e17Q1XUyfEGosiovq2C19yLjY
1dv1MhSE5gRw8xdqwHanlsA84XYfSr/dtnq5mCkifrZKrSwyhdj9W3Ue0pGEB8+B
lkSSa+BQm5dj4R+Hfzge
=7PzK
-----END PGP SIGNATURE-----

--/3yNEOqWowh/8j+e--
