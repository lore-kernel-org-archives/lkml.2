Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2AZLWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:22:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38481 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023Ab2AZLWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:22:46 -0500
Date: Thu, 26 Jan 2012 11:22:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add missing
 iounmap
Message-ID: <20120126112242.GA9401@opensource.wolfsonmicro.com>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr>
 <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net>
 <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6>
 <20120124202203.GD1135@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201242144580.1998@hadrien>
 <20120126110506.GB2611@pengutronix.de>
 <alpine.DEB.2.02.1201261220460.1851@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1201261220460.1851@localhost6.localdomain6>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 26, 2012 at 12:21:35PM +0100, Julia Lawall wrote:
> On Thu, 26 Jan 2012, Wolfram Sang wrote:

> >devm_request_and_ioremap() to save even more code?

> I didn't do that because apparently it is not yet in a release?  I
> have another for introducing those...

It went in during the merge window so patches using it should be good to
go now.

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPITd7AAoJEBus8iNuMP3dmPUP/3XKbJzwiK8Pb4Rt1oN8/y3z
53V0XE+KE44bFskBU+umgZnwBl4CxSLNOSzhlOHxeNJ0hp3BBHdGlbpkhrPmQ8sw
fFjU5r/Vwv7ocQY0fXDldGl+ld+Y0KGV9jxZaSwvhad4iU0JlH4ABUDlykkUGQbF
S+m2+JTjnQeKr1sB8ukDPCdQkEncPYZbCYAnC9n8QSNJedXehcK+iE5gyYUn9L8n
DX96W1ooJYsMq3vMybssazTP+RvBX15ZAHy7SGztzflbvh/ag6bQhnxYpWVMW+wh
TvLXQviBMaE8X7KrrN9I/WV2c0sCv0aqkdPkUGpGZz9f8NIYjKUE1XWNdvHgHA4W
QmFTRIrluCHTgdUVicw8ZBT/NFWYg7JvU5rlnaNkyfQvopxkLXJzMJbrO6myoGoM
Wzn7+J4zlcxhYWwywULq4nLjVUdRCvHzc0JrSkbN9mYn70i/xm6K+c/Y3S5No4lE
/TLGmBMuQkPCgbAtELaqfijqAvIPqgvW5tfFkDiFPK9G9aDk+muUaaVOsYFrgbXy
zYk8HEBig2iLq3EaU7HfmOrVe6iL2E+p/OKsVCGWFr1aOWTX8sofcNSZcolw7uzh
mSrGQqN4Sa66DOMZZ7ozPFIsY5QMiORqV1/wWm/Udw+54tGJ5p9OAtHEbhSn5zo1
aok1+U8ZI1pAWCU+CUnD
=3w+v
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
