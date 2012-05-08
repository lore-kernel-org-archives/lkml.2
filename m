Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab2EHLk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:40:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59477 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151Ab2EHLkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:40:24 -0400
Date: Tue, 8 May 2012 12:40:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2 2/3] MFD: twl6040: Allocate IRQ numbers dynamically
Message-ID: <20120508114019.GJ15893@opensource.wolfsonmicro.com>
References: <1336476810-26945-1-git-send-email-peter.ujfalusi@ti.com>
 <1336476810-26945-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vJguvTgX93MxBIIe"
Content-Disposition: inline
In-Reply-To: <1336476810-26945-3-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vJguvTgX93MxBIIe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 08, 2012 at 02:33:29PM +0300, Peter Ujfalusi wrote:

> The client drivers will receive their interrupt numbers via pdata which
> is configured based on the received IRQ range we got from irq_alloc_descs()

The idiomatic thing is to use resources and have mfd_add_devices() do
the fixup, which actually appears to be what the code is doing so no
problem.

--vJguvTgX93MxBIIe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqQYcAAoJEBus8iNuMP3dJlgP/RWWSfHsx8VM0T4BKwEUuOsV
nFsaQ9obGST7xn8tOk+DMJm8YLdwzmErFKchRpjSAbv0loSxobJIHoW4lsFj4itf
uKnQrOPIXr1TqYVJ77kF/tLtEMzVE5R7zI4hLvuoy74k0uarHhSqDslDf9dcaDRV
4hm1+TgMEfQgdAtYrcsf9fmzK9voZacZ1YKf7Xh1lDRFo36DpqE43KaUdITfgpvf
lE5JMZYHtckkH/aLMFm3qzJPM1EPspljjO4NniQxzvGv6wW7tMwkCOcCNOkAQoWU
8dgZvDIV6j9EuQ2gJj0bIKastLw92eD7TvyWvcwKGsMiPd0z6TOn+iWefUBYdNds
oyvuDmDYBWmvgHv6IF+YOSasjbhgxKTc34YmDDSu5xheYYQXuF6SPf//14El89bf
uwiLbj9QX6PN0LbS6U/2AegNyzxxd+4j3T5Q4Jyrb2Q06yNnP/Ev0XiUlMhBxdQ8
eykjze1crbx0MKn0Xmec9n532fmOvKWlw90o/eex1WmHFET8rrUrvzBovKor0f0y
nda98u8l1qCMdrcu2jddiJvXIfvRQHUCDJ3iu/N1raiPda/Cw5ETRU2l7jI+q5L0
lDrT1e1nrwzfP6+SxUG3bauex/1zWZTfNzydWyZVo+co21CZSSaUj9QfZEq5zWuP
3rq2GNDF6uxtTbw72mNM
=TOL2
-----END PGP SIGNATURE-----

--vJguvTgX93MxBIIe--
