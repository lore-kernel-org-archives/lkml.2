Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab2JWTYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:24:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50705 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932223Ab2JWTYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:24:51 -0400
Date: Tue, 23 Oct 2012 20:24:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        perex@perex.cz, tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/6] Add a codec driver for SI476X MFD
Message-ID: <20121023192448.GB18814@opensource.wolfsonmicro.com>
References: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net>
 <1351017872-32488-7-git-send-email-andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
In-Reply-To: <1351017872-32488-7-git-send-email-andrey.smirnov@convergeddevices.net>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 23, 2012 at 11:44:32AM -0700, Andrey Smirnov wrote:
> This commit add a sound codec driver for Silicon Laboratories 476x
> series of AM/FM radio chips.

I already merged a driver for this.  If there are any changes you should
send incremental updates rather than a full new driver.

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhu74AAoJELSic+t+oim9ZhIP/1PnsA60QsrOkXOK0fl3hyJQ
8H3IDs+hKaCKPq9boNH5NWzmRt3cC2d85zHbHhTpdrYlUgeVwqLH53efBDLsvHUY
7PmroDehG9eQXMS37fqg03gcEDPtn1hwMQpusCb5iasNMVDyJPoW2kANdFaCY5tZ
fFgqqchoqtKYkG7S8cMUlj//pGoXMtSlHJJmkIjalkG0DD0LbHsUY/9SWExpxaEs
KC94HRd6J/xKZ4rDSneA7cw7AqgaYD41jcYtAcZaz9tyu37x0tL2ifogGPsEUH8p
dJMORptLciaX1OEUBHymEeANn2V/UM/kzHg2HgDDrJgT10A8oMRz7gIdx58V5Zik
aj/7FPwruK1NdmcazlZUa49p8GMNFxapHQIzLsLP+jEDAhjZrZNAZw/ZbdmvHB6d
CzqnF4Mi7fm31gNlizgirijJ/g+5XjSVS21jgsV4sOV3WJziPVJQx5X/XT/oetKt
1O8vS3oFOTCbSvQV7ETo4Lj9RJ7EFcs1ep7b9kO1U9CgbdHiN9rosdOU8oYLvH7C
N/LqdJCZy96yTBj5nYeDXF811lonnZNHD13hnBpE7nIyo3ZfzremTfXZ2VPmNapC
1TSGmFCbPgcEw21mF/OlDQe4IMn61TJoq+9LiiOkUEUYfa/KhNF5UQ42TlH5fox9
pZIEz9MxkbBjlYnBIMEC
=0V4D
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
