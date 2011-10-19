Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab1JSK0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 06:26:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37059 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1JSK0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 06:26:34 -0400
Date: Wed, 19 Oct 2011 12:26:30 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch WARNING: patch prefix 'b' exists, appears to be a
 -p0 patch
Message-ID: <20111019102630.GE3217@pengutronix.de>
References: <4E9D9558.7040705@cam.ac.uk>
 <alpine.DEB.2.00.1110181643450.8149@chino.kir.corp.google.com>
 <1318982469.7569.1.camel@Joe-Laptop>
 <alpine.DEB.2.00.1110181819110.12850@chino.kir.corp.google.com>
 <4E9E89F2.2060103@cam.ac.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tMbDGjvJuJijemkf"
Content-Disposition: inline
In-Reply-To: <4E9E89F2.2060103@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Sorry, I missed one detail. This warning is firing on every patch includi=
ng
> any I pull off mailing lists or produce with git format-patch

So, I assume you have a directory named 'b' in the kernel-root-dir?

The p1-detection is heuristic and can always be fooled, so I don't think
extending the logic will help. If too many users think it is annoying,
it may be better to remove it. I do think, however, that it might help
users sending in their first patches, so I'd prefer to keep it.
Experienced users have the option to use something like "--ignore
PATCH_PREFIX" in their .checkpatch.conf. I vote for improving the error
message but won't oppose a removal if that is what is wanted.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--tMbDGjvJuJijemkf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk6epdYACgkQD27XaX1/VRvlewCgtNIneZmWavXiYx1MHvT03+x6
CisAoKwUHzNCmbnYt9C2owAQg0AXq0eb
=ehdW
-----END PGP SIGNATURE-----

--tMbDGjvJuJijemkf--
