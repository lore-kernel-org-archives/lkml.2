Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab2I0H5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:57:12 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:34371 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095Ab2I0H5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:57:10 -0400
Date: Thu, 27 Sep 2012 10:45:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: Re: [PATCHv3 4/7] dmaengine: dw_dmac: amend description and
 indentation
Message-ID: <20120927074522.GJ12592@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348731121-2515-5-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CxDuMX1Cv2n9FQfo"
Content-Disposition: inline
In-Reply-To: <1348731121-2515-5-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CxDuMX1Cv2n9FQfo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 27, 2012 at 10:31:58AM +0300, Andy Shevchenko wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>=20
> The driver will be used as a core part for various implementations of the
> DesignWare DMA device. The patch adjusts description on the top and corre=
cts
> paragraph indentation in few places across the code.
>=20
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index bbb2a82..9f0129d 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1,14 +1,15 @@
>  /*
> - * Driver for the Synopsys DesignWare DMA Controller (aka DMACA on
> - * AVR32 systems.)
> + * Core driver for the Synopsys DesignWare DMA Controller
>   *
>   * Copyright (C) 2007-2008 Atmel Corporation
>   * Copyright (C) 2010-2011 ST Microelectronics
> + * Copyright (C) 2012 Intel Corporation

I'm not a lawyer, but I'm not sure the few changes done to this driver
is enough for Intel to hold a copyright here... dunno, though.

--=20
balbi

--CxDuMX1Cv2n9FQfo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQZAQSAAoJEIaOsuA1yqRExPIQAJORxJveVl9ANkfwcZHgne1a
03ux5B9TkqYVZVuSkQs6mXh2HuFgN2hANxSfzwBRZX2yKtSIijQeFumYm1HTQfnu
Bs0YRLJ+Rocd4eH5qsTXKXQn8wVOEwwVjYn5ptOMJ9wyshQAV2QlzRmy6ICcLb+v
W99dglTVOvz2ilsXsoxVFPPpMn0aVkxV7MzpICY+olOBr71P5wL1I22/yWIjcnEN
UdYu/RwD5HdqllZCIjHKPmCdJ/9S/xJFWTEgscqJV4mbYir1vsUwUNUtBdJJiNJJ
l5a0ztoESEbB17AU21XiDNQ8bCIoN8FHVMI6Ys2EAhQUpbM3yDqkfOC9lVdH/yEj
aZGpgpma4/oToHs7U8BAeExVdg8RKmGUXsRLNqd5G+1C3+PPXo/il2T56jlX7lb0
2tROW9o/uraOF/rmLOng+b50voUR/F+zZT0i/N6hedqDUCPq8ulRIuaPoTQScary
M55/TK9OGR5V3C7clC0w0muTwy3jsnXwh+z2YJ+xlFAZFf6/LcqOOALk45fBOWZW
HjecEAfM5Km2QU1mxPvsdXSpkoCtCmYSDLKBzZFokdTws7dsxsjIEc1nuU9czdwq
/FXp948Da3oC3XwbIOwhOD6etE+7BIsZDgrtDB/QuD91TmE0HMkW8xPuYohPjPQJ
0ssl2NIykRWr1sFMO20h
=I+Qz
-----END PGP SIGNATURE-----

--CxDuMX1Cv2n9FQfo--
