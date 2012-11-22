Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2KVSmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:42:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36159 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370Ab2KVSmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:42:24 -0500
Date: Thu, 22 Nov 2012 10:36:29 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, w.sang@pengutronix.de,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, khali@linux-fr.org, ben-linux@fluff.org,
        bhelgaas@google.com, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 0/3] ACPI 5 support for GPIO, SPI and I2C
Message-ID: <20121122013627.GG4371@opensource.wolfsonmicro.com>
References: <1353407384-26880-1-git-send-email-mika.westerberg@linux.intel.com>
 <1353435212-15325-1-git-send-email-mika.westerberg@linux.intel.com>
 <79636467.nuLQX2FqW5@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tvOENZuN7d6HfOWU"
Content-Disposition: inline
In-Reply-To: <79636467.nuLQX2FqW5@vostro.rjw.lan>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tvOENZuN7d6HfOWU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 21, 2012 at 10:31:15PM +0100, Rafael J. Wysocki wrote:

> I wonder if the GPIO / SPI / I2C maintainers have any objections against it or
> would like the patches to be modified somehow?

> If not, then I'd like to take it for v3.8 into the linux-pm.git tree, because
> the patches depend on some changes already in that tree.  Hopefully, that's OK.

Honestly I stopped reading these patches as there were so many patch
revisions and incremental versions mixed in to one big thread that it's
very hard to follow.  Will go back and check...

--tvOENZuN7d6HfOWU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQrYEQAAoJELSic+t+oim9SUAP/jGwP5YJ+TaQge37p4m6WuFh
wBtsmh7FoSsDlD/GuXz8xJtF4JXoUXRZZ5uYRe3fzCXOtZZoCJF+qOLJ7tIME5rz
cXnmGiZ+nT1jJuzHGEWxI0xNPwqBd0LSh04w9xE5rusbraNIj55rIECbXg5MBqEW
3YZumTwTL9WlrojsMGZa1CCyESElsubJ3E9xsH1Sgwpqr/tCik4fTSbxbWLBOvDg
op7Ss2SMbagGevALyerfeJGE0ThmDP96knarSm7b0OHG0p31PJOFCyZesJDZ3XPC
/JM3oXXAIFIH09f9a187jqB/efgWokw6J8X0ZqcTv3wxsoT3YwQwtwP6bC5SYlr1
DJ96lTr0jJE0Gi5icjMGtDL1kQxvlVYYcfdTYD8mpTTUyINOfk/PrSD0LebLyKJ3
tgxA/gbC2iPWXA5afsD44fbZ+ISDPWJd5dd1PHKdh4ycsea4FVVR/V5G7fnbuO66
71KhwVDBlZY+rK2FR/LJI0lKfYZjIEB6M9rIDq3sQJkj1NTqwEsfJl/X5h4khT4A
0/zQ9VEwgNgpjX4DKBBmz9BeSVIXVvYukeDzP7wul9pTFLAfx/Bmpn0VlEexT455
J0f1/Btg112CP+Ff6m5yTiDg/vthk7BrIHQiBSb/9/CkC2uMpUZJUlc1vNCakgZS
tElGJPFzTj6EJxppGY2n
=ET8i
-----END PGP SIGNATURE-----

--tvOENZuN7d6HfOWU--
