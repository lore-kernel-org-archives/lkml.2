Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2GEOES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:04:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43434 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460Ab2GEOEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:04:15 -0400
Date: Thu, 5 Jul 2012 15:04:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
Message-ID: <20120705140412.GM4111@opensource.wolfsonmicro.com>
References: <20120703132447.GN29030@opensource.wolfsonmicro.com>
 <4FF58B68.5000703@linaro.org>
 <20120705124549.GD4111@opensource.wolfsonmicro.com>
 <201207051357.07195.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJmQ7d57n2fskpx3"
Content-Disposition: inline
In-Reply-To: <201207051357.07195.arnd@arndb.de>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJmQ7d57n2fskpx3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 01:57:06PM +0000, Arnd Bergmann wrote:

> The non-DT path for this is a huge mess, I'd rather focus on making
> it obsolete than trying to fix it. Other than that, I agree that
> we should be registering the ab8500 from the prcmu from both the
> DT and the non-DT case.

If that's the decision then we should probably have a comment in the
code saying that this is what's going on to warn off anyone who's
inclined to cut'n'paste.

--IJmQ7d57n2fskpx3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9Z7VAAoJEBus8iNuMP3dppUP/3JJS8fNuv15LKjaapoY+BEa
b+BCLH1nzksLbxorPlGdLOsjiDJWq9E0nMtSk6/K3m2GMB2KwbPXfTlksTfL1G+T
2uo1CdHv4rUzYd2un+BkAvOBT0qHJd4RWAxof92Acd+zUOIjTZtvIFXXodtaVgdx
IEhxSkSG8m6kjOgKmJ2Sv0v2TcKiL0Zntc9mFkuXyodEVscPD3yLUijPYb6W1nQm
CWlMYEJ+QwRNKCkYKDRKaalEzG8S6U7Z4bCghlU50f3llq1qKARoBX9KcWnpFDK5
vlT4WzZywd032KN1f6Fpo7zN6v8N3leou3fsddZHnCS2hmBlLvE8+ZvyKqZYAlHM
8Jq/037kYIBB9afMl0fvdww+cgUfea50BI3IrO/2DoNBgluW9USq4AVzwpZJfZCs
uqmi5La5W/wOdFh2ttDYnKMuFvV5VqM7EU3n8pWGOo/udp7lBDobp81gFEIboukO
E3yqVFuSKnByM5w0Ob/hbUjvmwRUsb+37Za0BpSF8Cdhjy8l9wSSOKlL0w6kVQAy
CSYn8OqU6TSNqoWuW2Fvgu3Vjtl0N1s37T814EIbt/EaL4q6futL8m7sdc6JUFcz
26bB6cWsw2fuPSNhG+51RSf4QNQHz31JmEgVjyC29y+18ya/VhHqMg6pexA+eBY8
a9R4f6QQ6esYFWZNKrIw
=YwYL
-----END PGP SIGNATURE-----

--IJmQ7d57n2fskpx3--
