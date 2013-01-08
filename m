Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab3AHK70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:59:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53788 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755776Ab3AHK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:59:25 -0500
Date: Tue, 8 Jan 2013 10:59:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 03/11] spi/pxa2xx-pci: switch to use pcim_* interfaces
Message-ID: <20130108105922.GL4544@opensource.wolfsonmicro.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <1357555480-24022-4-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2EnvhqpWJq810sZn"
Content-Disposition: inline
In-Reply-To: <1357555480-24022-4-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2EnvhqpWJq810sZn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 07, 2013 at 12:44:32PM +0200, Mika Westerberg wrote:
> Instead of open-coding all the error management in the driver we can take
> advantage of the pcim_* interfaces that release the resources automatically.

Applied, thanks.

--2EnvhqpWJq810sZn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ6/wEAAoJELSic+t+oim9u34P/Rl9nOKevWbMrhXpRPotziEp
jVN4Rnxgz5dohF/9A3THs4kzdMKTs0s4pLY4oG7H84+2slnp5YhFu9cSNwIGxsGB
wtNjjS3fS/FKBWkEjkmRQ3zo+Odf0XiEt7BUQ9KVRbiRAyL/kTpzk7oADqyp3VHe
V41m/kte3LXA80QGQXsIhWn5BpwkjcWwjMB9e/vPHXjgOPJL9nUz2LQV+mu90yhE
D2z2qfDKxcEXuny5kF/RHvR5ZOkJHzEuYWFyweSnIeDuc+I/m6TraNsyLn9KdTO2
7vZl6hJRhVUTh6rCHXzNpYj9H7AlNRshvW6+Q/We9BSrh8VD2eBe/F85SHM4lNjD
gnaOVbWVShkMXTFCw4VFkEOxvUnMsqOHXqQy4U2aTGyruOJ5fj0agc0O43owONwc
+siyB0ylMilr3YtT5BnuNRs5enXYKhiw6XLIxI/Ptl5ZQy0yfTHAY2R/JM7XlYMa
uVUMLXDI5wRpZ6GijVFllnt06W/kNBP3rBwlLgVlKkyXvSWXS9I2TSMqROl2WQWv
PQMM8z9vRp5+wWa7ojdzLKtH6NugyqtTwsQEp3490wBkAvAe983OH0ABXNzVRqQR
NR/fTEKmwciFhJifa+8usSJZBfnksYOYdHVjH+wMQeR1jc1lxNIl1xVfaxTIUu8G
/5JywaC6ZaGvK0RG1Uww
=JGTq
-----END PGP SIGNATURE-----

--2EnvhqpWJq810sZn--
