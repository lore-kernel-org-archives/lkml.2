Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525Ab1IIH7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 03:59:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59062 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899Ab1IIH73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 03:59:29 -0400
Date: Fri, 9 Sep 2011 09:59:18 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@linux.ie>,
        linux-i2c@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Joe Perches <joe@perches.com>,
        mingo@elte.hu, "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Magnus Damm <damm@opensource.se>, Simon Horman <horms@verge.net.au>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Jiri Kosina <jkosina@suse.cz>, Paul Mundt <lethal@linux-sh.org>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 36/62] i2c: irq: Remove IRQF_DISABLED
Message-ID: <20110909075918.GB1912@pengutronix.de>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
 <1315383059-3673-37-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <1315383059-3673-37-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 07, 2011 at 04:10:33PM +0800, Yong Zhang wrote:
> This flag is a NOOP and can be removed now.
>=20
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk5px1YACgkQD27XaX1/VRvOjACgttZ90BqhcNyMx8my4xlcxVRm
7boAn13j1KJrQm6+6XbO8kaneMaUubgx
=WW0l
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
