Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2DKJTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:19:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45480 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754885Ab2DKJTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:19:45 -0400
Date: Wed, 11 Apr 2012 10:19:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Cyril Chemparathy <cyril@ti.com>,
        Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Convert tps65xxx regulator drivers to use
 devm_kzalloc
Message-ID: <20120411091941.GE3163@opensource.wolfsonmicro.com>
References: <1334126418.21963.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qOrJKOH36bD5yhNe"
Content-Disposition: inline
In-Reply-To: <1334126418.21963.0.camel@phoenix>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qOrJKOH36bD5yhNe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 11, 2012 at 02:40:18PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

--qOrJKOH36bD5yhNe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhUwNAAoJEBus8iNuMP3diDMQAIeZBTON2T+aRVyXAiem6Tml
J1tbZtDApxkkAkeiuSiRzSjt9OlZOPG6Kxl5tjc7yv58xm6thp+DUI6M7CCCCI2i
az6EJA+52VbFKSZel2ehVJTVtXyVhrNEHRDAvmQDhrDY8jefdfUJouMzzQaEvteX
rgxv8Vbx4mwSY8OywcvAms2q3BRJiBvYTXOjE7oiX3PgeOW7EQBPONbw/ahQKBcJ
9K/MmVc+xYuH1Uit0piKF6JnjRbC3MEnvs1POhVAJGYcnuZbLALvHBjKhGLf2ouF
V4UrxMm9sLKCQKZPKBIEipzfm1sb+bUAvIPA8StORnxhNh5tcdZ8+ImiFJ2m6UNi
ftR8T4PZyUdTEU7kl+dHndpNLF/rQ6SpQB2jaP0v5NuWHm7mHybrg2pq0ppRNVR8
5aXAwU/39fLM2ptde1TIWhsMEqpkA1vIos8YodK+seXbp23o4ZWCKcUpeL0YOWjU
UNvxUeIbrGE63Be6PXHD3sKRN8M+NMPfUpNO1LrTnzdT1P2inl903OYMNr0kC0MS
eZxmS4dS0l2AMt8sKItiLm34ZgNAEGso47QsseEdZfMw0PkkxRG85W9HXhE0dSCg
XmM2ZhXoR8md3xdJP/EkXEzLY6FfDZMpOzrTgyshZ4W8AYMdASZpFbHQa71rB4V5
8/eVDd9TzcyelWaDHJ4d
=eHq/
-----END PGP SIGNATURE-----

--qOrJKOH36bD5yhNe--
