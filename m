Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2KIQtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:49:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51238 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932085Ab2KIQs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:48:57 -0500
Date: Fri, 9 Nov 2012 16:48:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121109164855.GU23807@opensource.wolfsonmicro.com>
References: <3455360.Z6cZSC3BtR@vostro.rjw.lan>
 <CAErSpo5xEO4M_Fb0dJ6w7Qxck-0RcKKwQjKj1QZgFxhof7X5Rw@mail.gmail.com>
 <1523215.Pon1eKPQDb@vostro.rjw.lan>
 <20121107095608.GX24532@intel.com>
 <CAErSpo5My6+ypp9zsxR8vh8k1px0otOWfAcacWaLNs2xjsc7UA@mail.gmail.com>
 <20121108200445.GC16012@intel.com>
 <CAErSpo7WT21rZ10vx9A4d8VtVaJB7FLeJqVAxKmZrZDy01FPZQ@mail.gmail.com>
 <CACxGe6v6zHcq=99JVvhNBe8DuWhyaZ_ojFai9=J2Yuu2TZw1MQ@mail.gmail.com>
 <CAErSpo4V-0Tnaf__fKUHM_69tBvfLySWzaoCWha9gimx0va1-w@mail.gmail.com>
 <CACxGe6vgYKv92x8qk5dbdA8UJNJPVxT_1p5Mn58NfBfVF3x+iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L2YZAWjVjAQ1Un1Q"
Content-Disposition: inline
In-Reply-To: <CACxGe6vgYKv92x8qk5dbdA8UJNJPVxT_1p5Mn58NfBfVF3x+iQ@mail.gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L2YZAWjVjAQ1Un1Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 09, 2012 at 04:43:27PM +0000, Grant Likely wrote:

> In the short term, yes but only because we don't have any other
> alternative. What I'd really rather have is a safe way to attach datum
> (ie. acpi_device or device_node) to a struct device and get it back
> later in a type safe way. It would actually be useful for all manner
> of things, not just ACPI/DT. I experimented a bit with trying to
> implement something a year back, but never spent enough time on it.

devres might already do what you need here if you are OK with the
performance (and frees things too for super bonus fun points!).  That's
how dev_get_regmap() is implemented, it's not awesome in a fast path but
it seems OK otherwise.

--L2YZAWjVjAQ1Un1Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQnTPsAAoJELSic+t+oim9fyAQAI6Tu3DDL2hj6T5GJWeGB3t7
BmoPiz8JsAg2seLowQmR6Su6dP4hia/TTvLQVNdT42iEcwBttWddF23qn75erTeG
iZWYmITg2f2h1ATTcw8POqcKeE7eG954iEU0VHit/QyjLPSTDN4AW+evnD0X8x3E
/sGGy8lGreeyDrtDUcoqEYWf4T1htrmRptDQEBkbP072M/byQQAmsNrCnWHub9ub
SbHmKo8kHkh+bz+Lk9EPKCsdTfXkrfrQh4ROQClY6KY65mx1L+Zq4JU4uMcHjo/s
lOjTzBDKz5+VTthL6KlPKEKBz1KtbXjzZQVNIYAp9laaokdXEJ4sQG8/agzSnH0i
oBFlmhim27yGI8mPQv774joFl/mJam2cVVst96KmNcgEBV3auqkv76t2O+pwUpA9
/tCty2ZLbKYJFs2xYWGe9aMmFkaqbrs/LZhouva/DZOuymQ/BnV4PlU6OBgS8GbZ
LaZdXuubmqgjVU2jczB7dgtNZ4ZzoN5z5LezxeTcVP21GDJ2SKEiXXD41/Cx/51t
KT8t9fMIetOgtg/GKVbi4Ql2JRB9NNUkYlq6tKBso0AcDwLS1mbaNEN2pyUS/k/4
oNRmeVIrbEe6xjyoS/Z+R3Dcv9dnok7sUGzR+j6EE7pP75pcFtmQrX7mbMxSkOw7
6OEPx9B4lgQwg7Dcyc4g
=KroO
-----END PGP SIGNATURE-----

--L2YZAWjVjAQ1Un1Q--
