Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab2CZRbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:31:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57905 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932996Ab2CZRbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:31:47 -0400
Date: Mon, 26 Mar 2012 18:31:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: Fix set and get current limit for wm831x_buckv
Message-ID: <20120326173145.GC3789@opensource.wolfsonmicro.com>
References: <1331797985.7129.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7qSK/uQB79J36Y4o"
Content-Disposition: inline
In-Reply-To: <1331797985.7129.1.camel@phoenix>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7qSK/uQB79J36Y4o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2012 at 03:53:05PM +0800, Axel Lin wrote:
> WM831X_DC1_HC_THR_MASK is 0x0070.
> We need to do proper shift for setting and getting current limit.

Applied, thanks.

--7qSK/uQB79J36Y4o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcKf6AAoJEBus8iNuMP3di6cP/3ckRs2WQOVUAwtpW+0mbuS8
9/4C3KKIW7Idu1crpywhTtNiHDwTD0P8LBuLdnKYUWn7CaaVT/w141tRzcKJR5KX
4Wh3hlxTSA0ac5cbBgPp8+wTxTowLsxXfMmr8JJhVTaQ3k8GpN1YDgdF6MqB4Hn/
9ZTDCV2Mj0xHrIEnnXygpvaY4a3f6LVz5gSBJi6cMYdS9b9mE8iA4aw0xSEEg8zV
5u1Es24gh4Tmxk9wgv75oaPWqtuM2HKwR04CKDAtmeqTaal0Y0vNzAbmvG4sups2
EFk0CdSz6y+fxMkEQthXq3GLn4V/SW5dCeq4ay+0K6k8vioXDO4PgIdg0fICC52N
EqE2V5/jIICI/3ohAFlwobQtCmtdWzxOo/WlPbx+Ltbcdumzt4zWhcD1OTQpZu/T
iHMsNJrNW3ZRxDCx4dOREv2VElQIjiQxnsBUmf7T7oZ9ofRFMB7sRXt4W+3vdV5M
CLb4U54vndH8m5OKUitOBFa65ksg3gawLnaMDUgvu2wqmBkT6gjuUohaPsxLLB8+
Z5X75MivHZVNy3sc4ICgQjjdP+QbbphpXAw/koJjSi163EATOWb0X00GLldtz3Da
XRKGchcAiaW4WDj2hxXUGgSQhx5MYm8wjM3dkhCknJbs6KlkqNfPR7M9xFhT1cMm
Rds4zlUtzei6k4A4E/CA
=oBJ4
-----END PGP SIGNATURE-----

--7qSK/uQB79J36Y4o--
