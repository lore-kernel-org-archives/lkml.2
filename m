Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab2CHSIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:08:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36767 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753966Ab2CHSIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:08:11 -0500
Date: Thu, 8 Mar 2012 18:08:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Simplify the implementation of
 tps65912_get_voltage_dcdc
Message-ID: <20120308180809.GV3638@opensource.wolfsonmicro.com>
References: <1331179657.4048.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KRJ4yArSHF8vY7I3"
Content-Disposition: inline
In-Reply-To: <1331179657.4048.1.camel@phoenix>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KRJ4yArSHF8vY7I3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 08, 2012 at 12:07:37PM +0800, Axel Lin wrote:
> Call tps65912_list_voltage_dcdc instead of duplicating the same code.

Applied, thanks.

--KRJ4yArSHF8vY7I3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWPWDAAoJEBus8iNuMP3dSPUP/i9oFUdKy6DTQuzt9Vnvk7dF
hvPjpnvhxmR0mo9u+d3RFwq8MQJ+g27UKiCQzGAU+7q8Jf0gHfoYjpcf/BbInse9
8+uL3f3jXleQP39P5KArcWqGSibnHmkDUrlCzcYVWJg0cxmsXGTw4Xb1DxfR3b/H
bqlv3NnNpz1kyOz0x4Kr6ZORIO4QMESEfwSZNPHjy1lI3AjfI3DOcTCd+UkB9zu9
1CcW1SybLBzYADE8n34iVAIBjEBkTPflxPy9h2EdIqulm7Q1f1iol9UErp+wMjfA
dKlOQDVTTQM0EU1EZssOaYhoyMNIzy87CZulOJS2zeuZsjIU1iV+SkUs9/9FYxZA
BQikI7i85Zbqgh6o+7PAjsyT7cjVhHZ1g1OykHbLMf67p46IMqlWIPWTTxfB34Km
dEVQVHiBqNruS3cNdyeKoXgMeQh3lBlYTvAuXGqYY1OTT4YibPBbgkCMEaafhN6o
B9xba1ND4i+XZc5hp5gyeWX6otoGplyxeOFfUssNPUxBA573TbRN2TwzAOidH8Y2
B25WbKLi880LHnb/6OMCnkO/mEoKYkz8WUQlfZ6dK3Ao6Sg+he+FeGKW1I0Ew3IH
1xqew1w/uMp8Bzo/u+9+LJLTMz2e0Vle/ZMX5yM3BxrOEqjPQAH1erOJchl7dL+x
3YCtWQed/7iUrTymvRXC
=1iBV
-----END PGP SIGNATURE-----

--KRJ4yArSHF8vY7I3--
