Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1HRV4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:56:05 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:47528 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006Ab1HRV4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:56:04 -0400
Date: Fri, 19 Aug 2011 00:56:00 +0300
From: Felipe Balbi <balbi@ti.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        James Nuss <jamesnuss@nanometrics.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ARM: davinci: da850, omapl138: share boot_params
Message-ID: <20110818215559.GC21064@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1313702401.git.bengardiner@nanometrics.ca>
 <4b305c5bad3d09ba46420ae9a440efb2c7fb88ba.1313702401.git.bengardiner@nanometrics.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hOcCNbCCxyk/YU74"
Content-Disposition: inline
In-Reply-To: <4b305c5bad3d09ba46420ae9a440efb2c7fb88ba.1313702401.git.bengardiner@nanometrics.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 18, 2011 at 05:50:48PM -0400, Ben Gardiner wrote:
> diff --git a/arch/arm/mach-davinci/include/mach/da850-reference.h b/arch/=
arm/mach-davinci/include/mach/da850-reference.h
> index d3beb13..6837a98 100644
> --- a/arch/arm/mach-davinci/include/mach/da850-reference.h
> +++ b/arch/arm/mach-davinci/include/mach/da850-reference.h
> @@ -9,6 +9,10 @@
>  #ifndef __ASM_ARCH_DAVINCI_DA850_REFERENCE_H
>  #define __ASM_ARCH_DAVINCI_DA850_REFERENCE_H
> =20
> +#include <mach/memory.h>
> +
> +#define DA850_REFERENCE_BOOT_PARAMS (DA8XX_DDR_BASE + 0x100)

why don't you define this at the same location where DA8XX_DDR_BASE is
defined ??

--=20
balbi

--hOcCNbCCxyk/YU74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTYpvAAoJEAv8Txj19kN1OwEH/RIzHtTe5MKT44TVckyXmfjT
xLwcFdt4ig8dkB7LZEGng1XQ/68Y5HCtIgDHzfgl+vRf/zMZRQ+wAujO+jdvBSlo
DKpmw3WlET5OGkUbPpUXCInYwkALuiyjbZeJw0BgaZodiV+Z2y0RX9rQ/zGEJqNu
3kjxKZzcYvN8iardc0g2rFqfacTKBrHjFSnvkjsD6rdVNhZblIiOrIasHHo5Ani6
7Ugm6H/hSsA4Gz1snsXH+5MGBwifUkS+rqoWHF3xkjjE2IDw345FMDa6EcYrdlWW
6DBOO4WnCdM4MPNg3D+HTW7aDqqS6qNrE3AlVBk8lYf+ijTwRCFCflPjSs45G2A=
=AxQA
-----END PGP SIGNATURE-----

--hOcCNbCCxyk/YU74--
