Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab2JQHlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:41:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56107 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111Ab2JQHlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:41:08 -0400
Date: Wed, 17 Oct 2012 16:41:03 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 1/2] regulator: gpio-regulator: Allow use of GPIO
 controlled regulators though DT
Message-ID: <20121017074102.GJ14199@opensource.wolfsonmicro.com>
References: <1350307020-5910-1-git-send-email-lee.jones@linaro.org>
 <20121016051401.GB8670@opensource.wolfsonmicro.com>
 <20121016072956.GF7662@gmail.com>
 <20121016074643.GA10323@opensource.wolfsonmicro.com>
 <20121016080109.GH7662@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Content-Disposition: inline
In-Reply-To: <20121016080109.GH7662@gmail.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 16, 2012 at 09:01:09AM +0100, Lee Jones wrote:

> I'm assuming it's just the documentation patch you're missing.

> Let me resend it as a single patch.

This should really be part of the patch adding the bindings...

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfmEHAAoJELSic+t+oim9VNYP/joh0cAd70hnP2lz1DIy1ghI
LFvoOqnplMb4mm8lSLCZdopWTCzoIAg5q/rIyNZfegtnttVl9FJf64FCa18QRu61
i1CDsfVfX1pDMq+XpDgQlCxezct10KI2zTEqdSsaF80LpJsTqZidNwfL/5G0j6/T
JfNbkijvIl25pt2BUs/H1uV4YkF/BVD4dzVVGyPe3nWE+tod8+/vyQg+jCE2DyNr
kq6eAW2WKpcYK6EAjL0XTDiEXveQQaJYfcnbwci+XI5GdWibbTRIlZVctXc0qT5b
QRFw8PWeWZs18zch3ffc//QrDD04t6+bVRjl0ziQKT510w2BHqiqxmMb1sEVY8jV
ZqiVBnoe9WbTs9aiiAmmaTyZKkSqfwFyJeWhXXrqZHWUtmHE1ZS736h5++YfKiJZ
DAkmcYnIXh5+BVbIPzppGg8dfKKQ0lEwYxGa4/PwKl0bmKPDgFS9vI3zm59Y4nBI
pm+nWTELdjPeDu0bdxl3StbmbRZeWQX9Wd6vCFayoQUqEhh9FggDHOddQOqeXEq0
MUowsDana+zrKVNTTYQZsjT+BU1cL9IMIGEY46dcEevnzWX05NXAJSl0xh9n2vnI
ZUf8/VtMBmKoG3MAGKXmCyvwCqBGDEXtzQW2HTZgHkm52e/LJfJaMWh+G/OvKVHz
CpwDClb9QnlCHHugDZve
=KIxl
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
