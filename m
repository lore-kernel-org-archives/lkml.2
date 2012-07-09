Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab2GINDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:03:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32978 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753155Ab2GINDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:03:11 -0400
Date: Mon, 9 Jul 2012 14:03:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, sbkim01@gmail.com
Subject: Re: [PATCH V2 3/7] regulator: s5m8767: Modify function and variable
 name
Message-ID: <20120709130309.GD3934@opensource.wolfsonmicro.com>
References: <0ff001cd5c24$793ab100$6bb01300$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HWvPVVuAAfuRc6SZ"
Content-Disposition: inline
In-Reply-To: <0ff001cd5c24$793ab100$6bb01300$@com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 07, 2012 at 06:39:58PM +0900, Sangbeom Kim wrote:
> As function and variable name of Samsung mfd driver is changed,
> This patch modify s5m8767 regulator driver.

This needs to be squashed down into the patch doing the rename in the
core to avoid build breakage.  Otherwise looks good.

--HWvPVVuAAfuRc6SZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP+tZ/AAoJEBus8iNuMP3dCEAP/jpKyKJeZNzsSCf1k9f1cfhd
4ot3YXWZP/d++H7sHW5osu6XPoqtsJ/HkZD8YZqDEXYmIBCOCXIr5MkpL7vpuea7
2+JHtQsF2qxnmZtfldtfpp4Ag9cxgJNBMDXbpwq9/WoFERZgmlcVaM3HKBMh+ezh
0+fUSz9KKWdjwMvwgyU/bEdw9CFPGDUjsXzHwCS5uPz8GoI6TwF2opI8EOMsFQuu
ANjfjeXkkEuyjaD9Dfe7lpmnQGeIJPA7Bd/1kliqPS3YDLN3OMoGhFkncsFofhG+
8aFoHHLi+Lt41pCE6I+9vCqqjjX9/cYxeKrx/1tABcXmk9rJZVuPyRViTyTgGeyI
PWKTKMjGnPQW28sInCFxHOlssuKd2IpMF9xNLS0sjus/ouQuHAoGHBsbPHqG8d6g
C/2GA13nwdPe6MDAHqDWrPsCIcCxJuvSwtla0brNAcekvllATr60jgOLWk1FZIB6
3ZfRDPSncnnbmqEedyFwwByF2g9BiQCFDsgvtXUtbtFvXY7V4KORgdWF4n7rdH/v
5Qb3Jk4Z0PXbXg1fNLtOedVCOyeT2RFuiNcFFAcocq9LOy7Klwm83i2Qf8CyVhYM
/Dka47TxiDQZEcX1f57n7vDV3eQRG4r8VO9FLZAshJWOOPxLo7nvKjSaS7egTI8g
Gkh7P90vRyEe8EbRwHPr
=t5pF
-----END PGP SIGNATURE-----

--HWvPVVuAAfuRc6SZ--
