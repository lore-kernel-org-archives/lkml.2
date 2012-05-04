Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab2EDLWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 07:22:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44462 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755603Ab2EDLWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 07:22:08 -0400
Date: Fri, 4 May 2012 12:22:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, devicetree-discuss@lists.ozlabs.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/3] MFD: twl6040: Allocate IRQ numbers dynamically
Message-ID: <20120504112204.GE14230@opensource.wolfsonmicro.com>
References: <1336049665-27777-1-git-send-email-peter.ujfalusi@ti.com>
 <1336049665-27777-3-git-send-email-peter.ujfalusi@ti.com>
 <20120503132004.GB14296@sirena.org.uk>
 <4FA2881B.6010902@ti.com>
 <20120503145248.GJ3955@opensource.wolfsonmicro.com>
 <4FA2A08C.5000403@ti.com>
 <20120503152643.GM3955@opensource.wolfsonmicro.com>
 <4FA3958A.4080206@ti.com>
 <20120504090856.GA14230@opensource.wolfsonmicro.com>
 <4FA3B182.5060001@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d8Lz2Tf5e5STOWUP"
Content-Disposition: inline
In-Reply-To: <4FA3B182.5060001@ti.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d8Lz2Tf5e5STOWUP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 04, 2012 at 01:37:54PM +0300, Peter Ujfalusi wrote:
> On 05/04/2012 12:08 PM, Mark Brown wrote:

> > You're not understanding the issue at all - the issue is that if
> > some driver outside the twl6040 driver is using an interrupt in that
> > range based off the irq_base that they supplied then you'll break them.
> > The most common case here is using GPIOs on the device as interrupts.

> The OMAP platform related drives has been already converted to use
> irq_alloc_descs(-1, 0, nr_irqs, 0); to map their range (including GPIO,
> twl6030, etc).

How does this work for interrupts on things like SPI and I2C devices?

--d8Lz2Tf5e5STOWUP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPo7vSAAoJEBus8iNuMP3dBhAP/RbMkG03AYo1nlN3pH8ksL0x
9Ru9bbxKcrv6Hh6eVwMUvQHqonnoujT9EwgH0iQDdxjQV9GLLUWgrKJoz0n9v+RR
C7B2ZIY7cE6RXxoprx5FKz//ATtTF40DXsX5XAydoSffn9UEdiIQlRsxvO2xwkDV
J9cSd+kmJI6qN6H0oMkaSsRRZSywcg2aQN4LbIenSzM7//uNbCobXy1c9/aBqc5i
zFrNyVYHmM8mEV6L+WeCFnwj7Rjj6i/voJncmItgroxMCYMxUsnHHHOeOMP0Y01c
EE4UxPIXv8Ol6NMPKd27hQq5t3vlFBGkI18d4hEzPb0o3JnWPUhIDhoPlqzL+9A4
rjgnO5QJ6CwO4dfl8yQ2mzLoEIectej+IqLqZlRQRQIariqHW4RHo0R6bhtVD5kn
whBVCaVpmCZOovku/c8UeZEIdNLDXvv0JlTpBy2mpaNYDfJTzNeBCGw6PQ49kz4Q
aS8/qIpNC86XxAe8O9DEfHfHDlc3YKHQ0EIXXowNtQD7sLffwXHdluqFrJjDFTf8
+xFIl1srZ9OkZc1fH68+jFIxeQqQ7eAzo339aA37lLyN4H/eLsA/PFDuIU3W4Thh
OO5Yequl0T4S0iVVm9n/NhNJnfGCD6tzQXeqRzHIXoLu7U68jw6DSx28tosB5KIi
u6IPPJWoPOijKp8xNu35
=+G23
-----END PGP SIGNATURE-----

--d8Lz2Tf5e5STOWUP--
