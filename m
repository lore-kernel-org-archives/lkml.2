Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2ETRXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 13:23:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40662 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755525Ab2ETRXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 13:23:22 -0400
Date: Sun, 20 May 2012 18:23:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps62360: dt: initialize of_node param for
 regulator register.
Message-ID: <20120520172319.GC9337@opensource.wolfsonmicro.com>
References: <1337530730-16605-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zCKi3GIZzVBPywwA"
Content-Disposition: inline
In-Reply-To: <1337530730-16605-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zCKi3GIZzVBPywwA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 20, 2012 at 09:48:47PM +0530, Laxman Dewangan wrote:
> Initialize config.of_node for regulator before registering.
> This is needed for DT based regulator support.
> Regulator stores this of_node value in rdev->dev.of_node
> and used for lookup when client ask for regulator_get().

Applied, thanks.

--zCKi3GIZzVBPywwA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuShrAAoJEBus8iNuMP3dz9kP/1wS/k+3MTf4zE/SKFBXRHeH
Tgyom5sS8p9PkjWxH76PWKKmyPOsl9O4Z3WSEp9pDPsmKvIfIE5T7saj/ak1djyr
Og7KiyxChOjTK6N7l6nyNDyKSVbNbsYT+Zu+O5Zai7Sl23DSO0AT8/8m4v9ju2HM
D3YCCDRr8/o0nW94HEFUUy7kzbK0bPAO8o5OiyuQfU6d1t0UtB7eYaQ5fcyY4XPj
WuQz6le0HPLhufvGjndQ7AlzqcP5LvYy/Uhrj0JkLM0dm88pVI9ORlUNYILCx40z
WLmz8nSo1i0y+HEG/GNLwEVldJcmP6Dra8r5if2Bx7C22onXv/epOrRNCeFw24o+
QjAcS2sBrBfduxNLKKiNwdLeXnLSKcMRQMPZo+zXQMewjf+nyIkBBfC/tpJ2p+t/
BVrlr7MdLpo21aigz02uKY5lRrrYDr1EHzubmO83HsNiirzfd7JFUS8xerpJlfT1
WrE780gKoMtZfWOHKWtpMC40Ksx8gm3+xdjPbYVoEoCCYQTix1MyM0aupz+7/whb
FZddmiu910/inTu4DkN3miVM+QSdrpJMxbjtNIAg2lYJ/IhH9dKzuMKmy+0GnyyK
Ysl5uGKVCmK3eiLfnt+pTL3GnJ1jEe7Snsapb/ZSKeFDV1ZeF2A+zh/6pD8UcUJA
9y7TD9CNGUfnuAKdtDFs
=mkwk
-----END PGP SIGNATURE-----

--zCKi3GIZzVBPywwA--
