Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab2CZPhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:37:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51534 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932766Ab2CZPht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:37:49 -0400
Date: Mon, 26 Mar 2012 16:37:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marc.reilly@gmail.com" <marc.reilly@gmail.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
Subject: Re: [PATCH] mfd: mc13xxx: add I2C support fix building v3.3
Message-ID: <20120326153747.GY3098@opensource.wolfsonmicro.com>
References: <1332772370-13272-1-git-send-email-alexg@meprolight.com>
 <20120326144804.GU3098@opensource.wolfsonmicro.com>
 <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD17@MEP-EXCH.meprolight.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6Jy4/gb9ZgnsEOX8"
Content-Disposition: inline
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD17@MEP-EXCH.meprolight.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6Jy4/gb9ZgnsEOX8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2012 at 05:36:01PM +0200, Alex Gershgorin wrote:
> On Mon, Mar 26, 2012 at 04:32:50PM +0200, Alex Gershgorin wrote:

> > This patch fixes the compilation errors after the patches
> > from series mc13xxx-add-I2C-support-V4 were applied.
> > It was successfully tested on i.MX35 PDK  v3.3

> >> Nack, please submit any required changes properly.

> Do you mean, that this patch should be divided into two patches ?

I mean you should send the patch to the appropraite maintainers with a
sane changelog.

--6Jy4/gb9ZgnsEOX8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcI0/AAoJEBus8iNuMP3dnacP/Aw4C8tvGBVDTeQEWhc2UozY
qouazjhoPrrY7Xqpd67erHrDIEWVyGUSlzvhmE+YVFGeY708U0352295n/+xQNE3
3QAnoc/QinYrpnG0+H8ql7xng3YGVwR2zD4L7GQsMMffEPw69mNf2hxLP97HMmmZ
dboCo2yD494QmSM8Z+uDzZdFJMNvJThbSLeBBeGeJ/ZrnRjyVlahlLbRodV3cPbo
DmxzDtGhokCs2K43lWRArzSiQeDScRMjd0VvBQDvgRxV1tej6z75WoZluOgG9gyG
fqXAnvdSg+VjnFE79pjFmAijxIsxlnlaNEgjqYZRDsO4gbgNH5Lykuw05S2bPshp
/AQTTSPNFSm4KpEevPUCWCaP5SZM/8suE6k0coc3DVmW+euOBz2itsA2uZ9C5zgA
g18y7TgRZEVy3efplJwlgkCQSONAaFb4+T5N/yG5hXCMPqONQOECqnDtbixZ/jGB
XhmnWZ0G1+pntEWi6/7IuI/IQY9R98FRRqvasl3adJ99JozHiR4lcuPIxc6WccZ8
JR5O+CiNX+G50nUQxS3FDro9YOoyu1QHk2LF5vG+Ppv2NHrtmglrv1AKjhfama3v
pf2DoYBzlFVCKe/H156TC5/rBWhJIFXRIf9Jy2NRe4KHtfu/OSvtfo4bn610oblz
7ph6ak+EE3KrSQi7rwTJ
=mLcy
-----END PGP SIGNATURE-----

--6Jy4/gb9ZgnsEOX8--
