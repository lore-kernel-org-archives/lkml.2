Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab1IIIEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:04:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49323 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758491Ab1IIIED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:04:03 -0400
Date: Fri, 9 Sep 2011 10:04:00 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        linux-pcmcia@lists.infradead.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Tejun Heo <tj@kernel.org>, Joe Perches <joe@perches.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, tglx@linutronix.de,
        mingo@elte.hu
Subject: Re: [PATCH 47/62] pcmcia: irq: Remove IRQF_DISABLED
Message-ID: <20110909080400.GE1912@pengutronix.de>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
 <1315383059-3673-48-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RpqchZ26BWispMcB"
Content-Disposition: inline
In-Reply-To: <1315383059-3673-48-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RpqchZ26BWispMcB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 07, 2011 at 04:10:44PM +0800, Yong Zhang wrote:
> This flag is a NOOP and can be removed now.
>=20
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--RpqchZ26BWispMcB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk5pyHAACgkQD27XaX1/VRvgZgCcC3uZk2kb/pnRz85dL35AOJiW
eucAn3om1aPWfBLAekfct0lIkOzvO4DC
=bbuB
-----END PGP SIGNATURE-----

--RpqchZ26BWispMcB--
