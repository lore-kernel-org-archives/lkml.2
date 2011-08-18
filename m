Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab1HRVzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:55:07 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:41623 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337Ab1HRVzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:55:05 -0400
Date: Fri, 19 Aug 2011 00:55:02 +0300
From: Felipe Balbi <balbi@ti.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        James Nuss <jamesnuss@nanometrics.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ARM: davinci: da850, omapl138: introduce shared
 da850 reference components
Message-ID: <20110818215501.GB21064@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1313702401.git.bengardiner@nanometrics.ca>
 <6650d6c73c2f5a8c4825c91cd8940fe88e46ba03.1313702401.git.bengardiner@nanometrics.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
In-Reply-To: <6650d6c73c2f5a8c4825c91cd8940fe88e46ba03.1313702401.git.bengardiner@nanometrics.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 18, 2011 at 05:50:47PM -0400, Ben Gardiner wrote:
> @@ -0,0 +1,15 @@
> +/*
> + * TI DA850/OMAP-L138 reusable elements of the da850 reference design.
> + *
> + * Copyright (C) 2011 Nanometrics Inc. This file is licensed under
> + * the terms of the GNU General Public License version 2. This program
> + * is licensed "as is" without any warranty of any kind, whether express
> + * or implied.
> + */
> +
> +#include <mach/da8xx.h>
> +
> +void __init da850_reference_map_io(void)
> +{
> +	da850_init();
> +}

if it's for this oneliner... just initialize .map_io with da850_init.

not sure it's worth to add another file.

--=20
balbi

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTYo1AAoJEAv8Txj19kN1rqQH/jp/BM7nqjht05w3K8H4UGcI
DlYs7TphdXfopHK1VYC7bMaBMDd6xuPrCfFkqdLesSFyHFjM7zOSm85Kx0g9p2jU
r5l4Mw8UCSIlZssUv9U7c+ofwtRgGyHGUvntkpEMVvegWAjW5/awt8w8EiufEKUK
zEt524Mthrbbovruq0cuZLjlp36MMP3Ioa7701gA5w7P8+wi40kbi5uJGn0VzNMM
8ZqCey7TdJpHzQeNrKnNe7nz1A2hFSnW8EWme0x6tqVkme8NbZ674Sj46JDO7kFW
lN/FIOz/r3mNpeD/kjT8Yg1ff/yozUY8NO/qyCqknSkQYTu2crE901rr8+2MXH0=
=gH1T
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
