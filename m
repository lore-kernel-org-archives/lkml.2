Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118Ab2C2LMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:12:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47499 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759048Ab2C2LMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:12:15 -0400
Date: Thu, 29 Mar 2012 12:11:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: rnayak@ti.com, lrg@ti.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
Message-ID: <20120329111159.GJ3668@opensource.wolfsonmicro.com>
References: <4F6BCF47.4090200@codeaurora.org>
 <20120326130005.GQ3098@opensource.wolfsonmicro.com>
 <4F726B96.8070508@codeaurora.org>
 <20120328100957.GD3232@opensource.wolfsonmicro.com>
 <4F736451.8020900@codeaurora.org>
 <20120328193341.GD3232@opensource.wolfsonmicro.com>
 <4F73A798.6030607@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ah9ph+G2cWRpKogL"
Content-Disposition: inline
In-Reply-To: <4F73A798.6030607@codeaurora.org>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ah9ph+G2cWRpKogL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 28, 2012 at 05:06:48PM -0700, Michael Bohan wrote:

> Are you aware of any other examples of submitted drivers with Device
> Tree support that implement regulator devices that optionally have
> an upstream supply? I looked at your tree recently and couldn't see
> any such cases.

No, pretty much any drivers which optionally have an upstream supply
would be buggy and should therefore run into trouble during review.

--Ah9ph+G2cWRpKogL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPdEN1AAoJEBus8iNuMP3dG4EQAJWbMAT84Dl+PAf2w0i3Vo/Q
LPJcl2DwiO3NQL9MnkcQ4vpmHrKxvkzw/JYoiGHX56uEepALmrE23P9oE5TXE1g7
FftP5AdMICF64Ud+xmeabq5ayewBPTgKFJ+VypNZSlDFTbxekdlHtOUcJI3DYXoK
CS5d3IpPnUTDxGGiB991beGQuRpeY5HpUQZzCLjBhFPHckp3egQQYGm082kgs3eV
epzLEZxqhQr7Q0BwesrfcQnltB4W00Pj4HywSJFmuoujslB3+ZakIMceiqyJ4Dd/
zGY3upmzEVb2eivOAumOuG7jeIC0UvfeBzephtok5XwuLzijCUNkmWHGj543uK4l
ZebzOFY4OI4L9D4KH/Sq9eoN0R2FLhQRtpGb03ffa77Dw+zPJ+Lzh6vpEoWkoxrD
lSJNK5N6HKxOBfBiGv7O2DdaHQH+/NSewA0a6DgDGdZDNVHTofJYUyeTMYXx9YJ7
SLyE9OVG5zv6NfLOA9SOpKXHMr6YOKOaXbjEgzR8iBc6e0VJ9Zkd0uZ0GjYJrPln
bPkR1xaiQloH0PJxDDyxqGddCtF4fArDbA6ozG7GXfJHkOaHDbo6VzL5mS1nkmFb
K5BUPqUdJvotA8gJ1dKtrJn4WryM5KnwBhht+pJvXjKbX3DVKsqoveAa2oDN55u6
4Kf65mRxC18yuzgeZ/0Q
=tFKS
-----END PGP SIGNATURE-----

--Ah9ph+G2cWRpKogL--
