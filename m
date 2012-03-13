Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab2CMXRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:17:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48480 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753640Ab2CMXRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:17:51 -0400
Date: Tue, 13 Mar 2012 23:17:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Use simple equations to get register address
Message-ID: <20120313231748.GS3177@opensource.wolfsonmicro.com>
References: <1331592048.5392.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VdnGiXwuH6t1Tqzo"
Content-Disposition: inline
In-Reply-To: <1331592048.5392.1.camel@phoenix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VdnGiXwuH6t1Tqzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 13, 2012 at 06:40:48AM +0800, Axel Lin wrote:
> The address of ctrl and sel registers can be calculated by simple equations.
> This patch simplifies the implementation in tps65912_get_ctrl_register and
> implements tps65912_get_sel_register to replace tps65912_get_dcdc_sel_register
> and tps65912_get_ldo_sel_register.

Applied, thanks.

--VdnGiXwuH6t1Tqzo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPX9WLAAoJEBus8iNuMP3dznsQAIz/dteFzqt4imLt+KFsG3Ij
f3G5LRkmo6J9OF4VQp1pW8M/PZrZVKqMljxkxDO5+e9g6lV+7IiJh6fdETEM3jac
vHNmu3DskmaH/AvknHQ+OCOW25/qZKRBXQrx/pEaRuSuKsfhm6L4/MNBqz8Sc/Q9
X0+K9MO7ulhKcrzMIoZyN05RCoGZJCu5qUC//V1TZxIxuoKnY9uSdbtm58aFEA9f
uGQ05G0D57uPki7g2JR92EKFIDKCfg7S6nUN84c6muTnnB58Lhfv24CAs+Th1MrR
2qVedfZGO+R62Tys/9MBKVhOsnfT7rs+3o3FSb7uIIzKTtvK8obWUKiqO6zqALKY
kdfpMCFX0GnUxJwmsgXZEQFID67ERb2XTi7qwPIw32IdKGDmcXcMtggjPj9ii0HJ
Hhcr99orkKGrsLU6R8FMCpSGzT5ITGIgPtI27gDQ7gN1lFCDe2olQwtWV1xrBiq/
DXkgKiTGIsRkFlbcXivmxCgcxzLBH5HxYoCd8zOl2P21gadf/m1DL60QAsqKCfLW
1JqJzEPnTn/MoXVDTMrdPlp7s1oZPSZBZT/tAM32xybT0bDs4JY+z2P6LFxFSvVE
dOe1Dp+0MsE+309/KWxqf7F08U+pQs/M9xJbIGl6W+AO1t2n7LBKZJjDNchxk7O5
ec04I7tRKoO5HKEqGNiK
=T+zh
-----END PGP SIGNATURE-----

--VdnGiXwuH6t1Tqzo--
