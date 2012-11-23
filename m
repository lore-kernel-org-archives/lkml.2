Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab2KWBll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 20:41:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48658 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756648Ab2KWBlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 20:41:40 -0500
Date: Fri, 23 Nov 2012 10:41:36 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Qing Xu <qingx@marvell.com>
Cc: lrg@ti.com, haojian.zhuang@gmail.com, cxie4@marvell.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: max8925: fix compiler warnings
Message-ID: <20121123014135.GC4385@opensource.wolfsonmicro.com>
References: <1353550266-21330-1-git-send-email-qingx@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Content-Disposition: inline
In-Reply-To: <1353550266-21330-1-git-send-email-qingx@marvell.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 22, 2012 at 10:11:06AM +0800, Qing Xu wrote:

> -	int i, regulator_idx;
> +	int i;
> +	int regulator_idx = 0;

This sort of fix is rarely good without some analysis as to why this is
a sensible initialisation to do, just unconditionally initialising may
be masking a real issue in the control flow which the compiler has
identified.

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQrtQ8AAoJELSic+t+oim9t78QAJWyLIdWkjeYvCViIayUoTYQ
Fll2ic72SvCxN6RHQmmSXytIWChoQYh3WJnJxe+Ge15K1g/7HK01SUyzRZKFgeKS
ul83EC6dQDrVuRTgv21V/nIwwOv5yfmxEOpKFYrQ+THZKbw29lwDofSKBl81AsNl
/1YLA5nuSMcvCm/BrJLcdtC1BzhiwRUicK0yF3CzjnYX6MTnqu0y8EEDHby13n35
oi4zkO2cLTZGofTD++AqYrBWwJc1K0SXSMSoWIBWdyEXEs/svkANI67zcpIgu4jJ
NMi7ssJL9WEGDIxT3PFJgQJgV4dZDUzyVGVstf24TZ9jOan+0cSZg365iOCzIOrn
xkPIxBUEsasBZ2uA+Rw5cW9L3swB5iTm/9dB/VFGgfpZvoRxqerMeBioY53CCUlY
Br3F/+nsEtbCOpZSEr4HZahi9tJeslJSRCITcNWIOBLyHzlcol8aUnJC4GBKM57i
X6EeMTshBAhPatelhawhxBClHUAjapBsDVNJ+R9CNx4hW4MRPbzBp9AjRSj6ymrx
CGsBBpSsaHrl1BaGidecCYOAtSsbgxWWVDQ8OPizsNO9pFgm+3XR1T5IW+gfjEA1
EdEssxYxD3kFtxyLJpVVuS3WGO0ahxtgERtb49dTLeZFCrKHdpjenxFM3t78/jH+
sqKLl93f5Ax8xQcnfvlH
=x2xi
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
