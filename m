Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760338Ab2EDWJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:09:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49142 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760322Ab2EDWJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:09:50 -0400
Date: Fri, 4 May 2012 23:09:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfgang Denk <wd@denx.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Arnd Bergmann <arnd@ardb.de>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: Handling of modular boards
Message-ID: <20120504220944.GT14230@opensource.wolfsonmicro.com>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com>
 <201205041934.08830.arnd@arndb.de>
 <20120504203357.6B79B206451@gemini.denx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z4IKABJTiQIqPwmW"
Content-Disposition: inline
In-Reply-To: <20120504203357.6B79B206451@gemini.denx.de>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z4IKABJTiQIqPwmW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 04, 2012 at 10:33:57PM +0200, Wolfgang Denk wrote:

> On the other hand, some of the issues we're trying to solve here
> for the kernel are also present in the boot loader, so this needs to
> do this anyway - whether by inserting new or modifying (enabling or
> disabling) existing properties in the DT is not really relevant here.

FWIW if the bootloader can usefully handle this stuff I think that's a
good approach but there is substantial variation in quality of
implementation between bootloaders and even when the bootloader is a
good one it's not always practical to update it or the data it relies
on.

--z4IKABJTiQIqPwmW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPpFOhAAoJEBus8iNuMP3dNGgP/RHKJm8DcKwJty4RYxiBAS0s
TvjEl2N9XJCR7CGrgWbnHJdOxKPsBNpXkcUnIACGZUWuGH+zge+P4SvVOIXIAjGz
gjL+n6LfHHxC6hMjAjRR2ricKeHbA/ufBJRW7IwpaTmLTqPcw7sYSRPTe4jVLCgV
kkRZhMqxZ3MgVwFECQLdZhSWe56zr0tE3v8j1LrO1XKP3AUXNnqD9GsPdHKJd1RF
lVRkzBbVidl06WAuvy858Ps033orXciQMyFPJDpBqDDdjr1Na7UeuHPCgYDmdszB
FvFSRATQZ+T6fDxOKLtlznXc+gRhY5m+E0o3xdO00GmEre5QQWeQbZvi0qyxeg2/
zB+2FaTrHIDpWGjka6l5lT8dZnAwE+J9h0B/MLOFcDgfn0/7zqcEfquiFrHou/BN
8xvniqKyCpzoRks8Cr+ZGkgGJUy2+mMC7ncpY9MnxTRbWFWAX/Nuh3YmQ24doW2N
osl/M+vK1Aq5k6xUFtgOVjmbBzQSixpzv486WwbxW3N4RueeRHOgV17isCdDEhg1
Z7AwG1OPenENs+Wx33z8Jykk+XgR6whlUaJFbmxiGQyuwjCMBb22vjODc9eLHjlg
gzmRHh0i/O1orFb8ZGoC/ZM2m5vDXFXFG/rfu+E25HHZ+1zT9C2u0ZmhI1QEy8X4
dMoj3if58WZeE6lhgeeQ
=HT04
-----END PGP SIGNATURE-----

--z4IKABJTiQIqPwmW--
