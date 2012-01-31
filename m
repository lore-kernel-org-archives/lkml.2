Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab2AaN1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:27:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52552 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab2AaN1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:27:39 -0500
Date: Tue, 31 Jan 2012 14:27:20 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, Barry Song <Barry.Song@csr.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com
Subject: Re: [PATCH 0/3] platform: add platform_devm_request_and_ioremap()
 common API
Message-ID: <20120131132720.GP2471@pengutronix.de>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
 <1328008455.956.30.camel@sauron.fi.intel.com>
 <CAGsJ_4yVTaZQOE2dB4A3L6WCLE78b4eBPaOcDDJ7RH+0LN=R_A@mail.gmail.com>
 <1328015763.28171.2.camel@sauron.fi.intel.com>
 <1328016225.28171.7.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NwG7NuG0/W8LcLh"
Content-Disposition: inline
In-Reply-To: <1328016225.28171.7.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NwG7NuG0/W8LcLh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> To promote the idea further. If you manage to create a semantic patch
> for this, then you will just generate your patches automatically. You
> will also be able to make it more probable that people will use this new
> api by adding your semantic patch to scripts/coccinelle/api.

I'd think Julia is already at it [1], but the same issue has come up
there, too [2].

Regards,

   Wolfram

[1] http://lkml.org/lkml/2012/1/26/169
[2] http://lkml.org/lkml/2012/1/28/10

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--/NwG7NuG0/W8LcLh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8n7DgACgkQD27XaX1/VRt3XwCfQ+egjVYitwN3nezvDCpbqj1Y
2IUAni6IBt+SY+K80WjAl+ozwy6dLRbu
=erOA
-----END PGP SIGNATURE-----

--/NwG7NuG0/W8LcLh--
