Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab2EAQdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 12:33:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48435 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492Ab2EAQdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 12:33:07 -0400
Date: Tue, 1 May 2012 17:33:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-serial@vger.kernel.org, linux-pm@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Question:  How to power-manage UART-attached devices.
Message-ID: <20120501163303.GA4089@opensource.wolfsonmicro.com>
References: <20120501082209.0b560708@notabene.brown>
 <20120430223322.GA3951@sirena.org.uk>
 <20120501093559.5c14087d@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20120501093559.5c14087d@notabene.brown>
X-Cookie: You will inherit millions of dollars.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 01, 2012 at 09:35:59AM +1000, NeilBrown wrote:
> On Mon, 30 Apr 2012 23:33:22 +0100 Mark Brown
> > On Tue, May 01, 2012 at 08:22:09AM +1000, NeilBrown wrote:

> > The userspace consumer was added for users like this that live entirely
> > in userspace.

>  I assume you mean REGULATOR_VIRTUAL_CONSUMER (drivers/regulator/virtual.c)?

No, that's just for testing drivers in development.  I mean the
userspace consumer which is hidden away in userspace-consumer.c.

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPoA+KAAoJEBus8iNuMP3dECgP/RcaI324J21ggRHxNxgEsE5/
4Z1trO7mUivhfYmbvTFyW+H4pwM8qZeJe9boq91UXrS8jOBG+La7r/dnhc0l+mjk
3kLzmUhRpXBC+eEY9I3uzuTeDXjre68sMFBID4QpoBSBHU0wr36q3NqohiZhpcXV
ALxDWq8Gn4UqS4IeWoW5astovX4mJh0ZZ2Hlpr5nW0iMhnonOqZFh+kb7gWag9dT
hoY3bE/ythqq6w237nn+KFfvXPoxB6NQNSKEv4iTJAPOVAZoQmNQu411a6jYy0xx
/Ssq3CtzO8X974ym56o9f3fAdQzgEJx4nm6qoXHgZoYQEM7+Mjn09H80Ot/HJsxV
GaXIZ6afJcEzxcF+k7VYJoaIOk2p5SAJHmMimOzTgGDCJfue0wPzwZt6TZpSWvUh
iBtWLeD1g0DME3qnwpqsWV8KyaofwoYpBMdNtNGqha5DSF6Zk8R3tDfLKRBJd6ei
OHtvINRoTonI2RedjbIPf1DSHDjXNoMQaO3Yom4HqCIjDht4NQT7bfuC1Fm1zFY2
LK9PrB99iplj8o8LYvyqRZuuqIoy79w9hoBkohzkysRRN2poVJ04aBzYDIGpmH+t
pl4RYgYkv7cWrpQFDgWQBdV/v1JCZkTo9YJmZJpJ6IIO2D4YX2ZyUwoOCTWGjwwQ
a/vQibXLw4yenl0uohoq
=GqiH
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
