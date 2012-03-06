Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030521Ab2CFMRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:17:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37950 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030439Ab2CFMRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:17:31 -0500
Date: Tue, 6 Mar 2012 12:17:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Mike Rapoport <mike@compulab.co.il>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: da903x: Use DIV_ROUND_UP macro to calculate
 selector
Message-ID: <20120306121723.GB24091@opensource.wolfsonmicro.com>
References: <1330988080.5328.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
In-Reply-To: <1330988080.5328.1.camel@phoenix>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 06, 2012 at 06:54:40AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVgBOAAoJEBus8iNuMP3dctYP/0Y7DAZTIQd7xgyA9C3zM27d
AgjvRnSSXwX3o4EZgX++OCGAuZuQl8zMOAkGjgugX2q3pSvVnJggOZqwaOw2Fv0z
MOT86bpbAzlg0YPcSUtrpdV0nu6QUH1wsMU252+FvzsUiUmiWz23Ou9CS+cPfNGG
Dl3mDF86WxFpl8d7DwubPdbPS6IFJq4n6PYRXgkwRO1zmSR9VCTyqEaOgc4N7Mi9
ChiOYGhtlGjMAoizgIrgeVKnUs5f9zjVTLRkzK6UG/65ktAm9Jwe5Efo8ZqCNs7G
0+F4JUySwseavR47EQI4iOS6VXWJZLPyBUTOyTNOtCQFkaDJx4QsuNDtU+vj2l75
nthGjkKVHn0XjnrOh0yBmVTsA+XZ4JF/vpi3sAX9fCXSADpv1FPRrHTRHu5CGJrQ
ZpBl3wkAL+UysQh8v8rLXVTkZyUDGEB5JKhKBdUKVJCMan4KWLVpQa2T09xAZWSE
aAh4098lpc6ULPOyG1h4fGnep2o+eskEauqsVKCS1+Kyg1IuYhR9t0WOWlGVh0v5
qWnGxF0I2+WeaPusGdS8bNvBIh9emg10fqgAhhSGf05PUw7brWnHJ0gT5qqbVN3p
AP8vNhRxMPtH/6DHoHa8M5q7BPHXMGP0RNypF28Z4/sZtLXFkkJo7/KgJuiMpI6+
MwmrNJ0Kg7w+OJqnlGKC
=wErW
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
