Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab2EQN22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 09:28:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35812 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750942Ab2EQN21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 09:28:27 -0400
Date: Thu, 17 May 2012 14:28:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: wm831x: Emulate active low IRQs as well as active
 high IRQs
Message-ID: <20120517132824.GI26337@opensource.wolfsonmicro.com>
References: <1337260693-1768-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bO4vSxwwZtUjUWHo"
Content-Disposition: inline
In-Reply-To: <1337260693-1768-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bO4vSxwwZtUjUWHo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 17, 2012 at 02:18:13PM +0100, Mark Brown wrote:
> As with the existing emulation this should not be used in production
> systems but is useful for test purposes.

Sorry, left some debug in here - I'll resend with that removed.

--bO4vSxwwZtUjUWHo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPtPyLAAoJEBus8iNuMP3d2k4P/1N2u2/3FatmkwYE24H4l/bH
5dMPkGpKpzA9qb7LWcARvyG4azDFW0ttlMSx++kflfn9AZT4ofMBsatAaoz2m6b6
9GR1Z9vakdDZNQOvMTC61pjzRN7NfeRq4F8vJzQwCmZrFJBUmVRRYmjnJnX+A9s4
StYfqcwrPhonVTiRqnCmsSjG0jaGRls6WOTi3H0HGLO1/6bDJQfXFBNVRZ0nHJs8
SPEyy0uQPrFIBhG9/4FPyUs7SBWZKLPDTMPZChfkJzQTB+7tGneb5Mzv5ZCFM4ZY
X4jfQ1oMr48upsgs6SqOo0anHVlhjtOppxsZQ2eBbY0PMkQhfuW449NkMPo3JdLm
5UGC6UAAKdHMxoj/AbqgJdeufFn76n1KWB6wDbYfR3aSGECRVmR3uifDcOYVBq2F
OGec+y992bnfEz7WZOTS/xhnSGcaraWPYNfaoTsMpNyWbWsT1bwZ+nNKrqElYVec
+AdOKXpZTHb94HAATVayIGCAsPbusMOJ+cvenmHYWbBsroC74Nh/68l49CDxo2Ph
kzz7vtQOewpzP4jpcOSzwKJiw7Mq3q16hVeOmYHxWhptYMzbVG+aANDTmRiSRBlW
6aXo+t5L4U8Vu66I3diuh8LDN4kz3RQURgXL8K5Sn3jHT4f2Owo9QDCkmL2aoHS8
fY304XibXyz5Yl3pBXDe
=o0Uo
-----END PGP SIGNATURE-----

--bO4vSxwwZtUjUWHo--
