Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2FKMI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:08:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60812 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab2FKMI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:08:57 -0400
Date: Mon, 11 Jun 2012 20:08:27 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Message-ID: <20120611120820.GN11439@opensource.wolfsonmicro.com>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
 <1338353260-10097-10-git-send-email-lee.jones@linaro.org>
 <4FCDDE58.5010501@linaro.org>
 <20120605102900.GP23408@opensource.wolfsonmicro.com>
 <4FCDE0A4.8070107@linaro.org>
 <20120605104201.GR23408@opensource.wolfsonmicro.com>
 <4FD5D49C.6070106@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7VkxxUl3xUvPtoxk"
Content-Disposition: inline
In-Reply-To: <4FD5D49C.6070106@linaro.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 09/22] regulator: Change db8500-prcmu match names to
 reflect Device Tree
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7VkxxUl3xUvPtoxk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 11, 2012 at 12:21:00PM +0100, Lee Jones wrote:
> On 05/06/12 11:42, Mark Brown wrote:
> >On Tue, Jun 05, 2012 at 11:34:12AM +0100, Lee Jones wrote:

> >>Well without it all regulator requests from DT will fail.

> >Oh, ffs.  Why wasn't this mentioned when the patch was posted,

> I did. My 00 patch mentioned that these were all clean-ups/bug fixes
> destined for the for RCs.

You didn't CC me on that as far as I can tell so I never saw it, and
even if you had it's rather burying the lead with a large series of what
mostly looks like random cleanups from the bits I see in my archive.  I
think I assumed another patch in the series changed the names in the
device tree or added the device tree.

> Nevertheless, these two patches are required for a decent boot.

Fail.  Well, I guess I'll end up dulplicating the commits :/

--7VkxxUl3xUvPtoxk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1d9sAAoJEBus8iNuMP3dFB0P/R3mr2AkdROkA1INPdeR5Q/T
UOjFK+IWxtTzAt8cl3G8z76MJdQdSxIKrEjn3TXdEGLJzN2bRdDDNqGCX7cgf5Vw
0mnvs0AhxPhBjJhpknYSVSkbWoHy9EKTl1QacLbFYGyFfemHleiLBauPip741TD5
tufTFrZ+Iauw1ARNW7zJ72uQUetCgNa9JNi7B0If+SKyVvaAfwYbU0UroRdpX/Me
B0WcjRhB5o/wmOnvJ4J5DPs9rwI53UgKjreJ45haICe5pXxY5Ll84g5eNRXKKJ46
3hnwCdPrjcZEIz5xoeU6Zfvlyjrq1D42xzQBRGkNdL0dPJ+Fp1z6qcoQDbJYPmsd
XZQuhW9KEhrBnnMlCtcO5VuNa0dpnGnGXmaQoH3vk4JpSA7sCQ2cVkE3dxWiTUaP
NtquAjNnaaLoA5VRIodkscQbJ78ueZVG1bWlp/AxHNlCFEEON8BvzWCvUZlMN6am
jMiw0LL4Q+LLn9Ry37fhkkSRJ6Lg4D4FWiuFwJX12lBFjLdas9BoEY8ohH7OJFjD
4x6yPIFLxOK+rN839K1iXvrMhOt4lSi5czJwLfQox8yx/jrJvc8dH3H3NSoHkCyx
sAlkS3Y5aR+j+l6ZfWFXh6Hp+cNR5Az1JtXp/HoBOgZKPHaUdB36ShKycCRospRZ
936Efx1b+2+LghvfzCek
=y78G
-----END PGP SIGNATURE-----

--7VkxxUl3xUvPtoxk--
