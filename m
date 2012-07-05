Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab2GEN5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:57:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47427 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645Ab2GEN5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:57:23 -0400
Date: Thu, 5 Jul 2012 14:57:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
Message-ID: <20120705135719.GK4111@opensource.wolfsonmicro.com>
References: <20120705120600.GT4111@opensource.wolfsonmicro.com>
 <4FF58571.2090807@linaro.org>
 <20120705122947.GY4111@opensource.wolfsonmicro.com>
 <4FF58B68.5000703@linaro.org>
 <20120705124549.GD4111@opensource.wolfsonmicro.com>
 <4FF58ED6.40106@linaro.org>
 <20120705130306.GI4111@opensource.wolfsonmicro.com>
 <4FF592A9.5050706@linaro.org>
 <20120705132021.GJ4111@opensource.wolfsonmicro.com>
 <4FF59C7C.5020406@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m699nQIRt8EJjqXo"
Content-Disposition: inline
In-Reply-To: <4FF59C7C.5020406@linaro.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m699nQIRt8EJjqXo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 02:54:04PM +0100, Lee Jones wrote:
> On 05/07/12 14:20, Mark Brown wrote:

[Moving registration to the MFD]
> >But surely this would, if anything, remove code?  You already have the
> >code to do the registration in the MFD so all you're going to be doing
> >here is removing the code from

> No, it will add platform code if we were to register the ab8500 from
> the platform area.

Why would this be the case?  You've already got registration code in
there for use in DT...

> >Hrm, the usual pattern for this stuff is that the DT is parsed into
> >platform data so the DT code is isolated to the parser.  It sounds like
> >you've got a very different structure here?

> Yes we do. Ref that commit ID I sent you you a few days ago:

> 5f3fc8adeec9bb12742fbfa777fa1947deda21a2

This doesn't appear to reference the platform data?

> >Well, it also introduces code into mainline which is likely to be used
> >as a template by other people - I'd be especially worried about the next
> >ST platform ending up repeating the same mistakes.

> There are no mistakes. It would work for other platforms. :)

Working and good idea aren't the same thing!

--m699nQIRt8EJjqXo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9Z05AAoJEBus8iNuMP3do6QP+gIxSki4ElN2hS/GZdCDHv+t
F+jqjZjuJhianWek10dFwJywbWSOxQbUbWCbwLlyMzCk2vfloBYH17c4b3ivi3/7
W6MklO8aIof/mRsxFtp2GkaMPRWsaPNVyamAKy/kKSqqMgg49kC3nVVl946Lnzyp
EPPoMozirEttf9V4uowga7MxUYHpD5ARhgrJjjCmHHuCOdmkukRfSpA63isQmWLb
HvcNTivVESqv/BJG8McYpYPEvg7UJSg5tV/SULqPTAQgz7GGqvPqlVlarFRODlh8
OlfGX6NXUdwaQBtsSb7/0jZXjxSVkAZahowSG9oCtBrw6qVGNjIdbShHyNiPjIdQ
RV0dVSc2fAtiHmP7zRrdmJcvRcW/V0sXzOEa5Q9qPDOA4DjbdAvJ2Ps3BdLpqz8/
yQuxYC9zGiFC5fbwvv0S7tqZ+phcbZYUv5x+3Lxa7YGcY8W7snlaGTtjEpEWCaQd
YypbfzGHww93OaDiWRsuOdozCG26ZdSYW1qnmCBiK9vIgV/N2abC4YcEbwyhCXZ8
Bj8eyb5uULRUzvgiunL06rwiNgUYGmJHkElLLuT1y5ff6+xlcI5N1k8kOG9fO85u
XhKzPCoKb9HHzqI1b19bLOJsuNx34XcraRxYnFcg72zuwQYwEr2Q0f4sYdU+Sk5T
+RhD+TgKdKWwV1TVM3TQ
=0OEa
-----END PGP SIGNATURE-----

--m699nQIRt8EJjqXo--
