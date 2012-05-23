Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab2EWJlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:41:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42279 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab2EWJlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:41:03 -0400
Date: Wed, 23 May 2012 10:41:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, lars@metafoo.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] sound/soc/lapis: add platform driver for ML7213
Message-ID: <20120523093857.GC4085@opensource.wolfsonmicro.com>
References: <1331275160-31757-1-git-send-email-tomoya.rohm@gmail.com>
 <1332158459-14880-1-git-send-email-tomoya.rohm@gmail.com>
 <20120321160913.GF3226@opensource.wolfsonmicro.com>
 <CANKRQnjoGN=uvej8B1BxPHAx7NQtOORD9yJRPUc134DrVmPzNg@mail.gmail.com>
 <20120326154009.GA17506@sirena.org.uk>
 <CANKRQnhn=ALR0ucv5gnvwnxwxBQX4ajm9Jo5qC0fL-EFjDdoZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LKTjZJSUETSlgu2t"
Content-Disposition: inline
In-Reply-To: <CANKRQnhn=ALR0ucv5gnvwnxwxBQX4ajm9Jo5qC0fL-EFjDdoZg@mail.gmail.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LKTjZJSUETSlgu2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 23, 2012 at 01:17:15PM +0900, Tomoya MORINAGA wrote:
> On Tue, Mar 27, 2012 at 12:40 AM, Mark Brown

> > So, I just said to the SPEAr guys that I really want to see support for
> > non-cyclic dmaengine added to the helper library rather than open
> > coding. ?We're seeing lots of platforms moving to dmaengine (as well as

> What is going on this ?
> Let me know this status.

Nobody seems to be working on it as far as I can tell, I've certainly
not seen any patches.

--LKTjZJSUETSlgu2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvLChAAoJEBus8iNuMP3dG+MP/jHYji4kkOe1M0pXlN84scSn
mlgEbih+4LcmU1uePa/nwotrnYc7ij5efZREYkcVegDGwkXptRvhEpAqqFi/FdIV
fffFjStbLQsiurDaG2P0IRFik6E8fDAxbMvR+NdK1aEoNnNIuYgdhKXe0aYbw2fW
7gOVxY8zKtZQt9vChsVPph8I0eQTIUq9ZJ8uoyGKJ/0VwPoAOb75so1GmqaRHoH0
R/rcuxNsm7TWohcOSKpu2W8RKUIjBkzMYQktyZVIvnKd/S9XtUYk3tGeYAwVaTwv
Ao/VgYQA0dQCPqDJwSJca0kcx/FZCtMatmKDzSRLSBNN0gObMEBrXxB97qX0sKRD
porUyJ/uzcMPKwxcGnF6ZYyFYgj+cnXYHujz6DX+1m8XpmCCuCrsZ41wO0fPnt/D
YhIEBpLr4i2jflYjliVcx3I2f8NNkbck+8vH6egeqnwDHs0iChc9Rase4zkUEOl3
5OHoyQN4EuCtfGe1DFvTsr/sN8V0+yIETXjkycoBwvp3xNSGTbe7XeqIJLX8OTys
wvrYj7cTT0kslrBEGnxFSRvs0MnZT5li84gqMgIxmvbsIKDgxw7STAHQ1r2xxxDc
hJ90q2tRF4c7m/8rv+e9ksnrt/MTcVJeaAZ3ArlrpDVqF2G6Wet7F26c1Ui9XMBj
oaRpfUc7IBRBF1j9q9nY
=Iy1I
-----END PGP SIGNATURE-----

--LKTjZJSUETSlgu2t--
