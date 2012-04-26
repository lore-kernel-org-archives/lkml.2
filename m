Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab2DZOlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:41:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52105 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756609Ab2DZOlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:41:20 -0400
Date: Thu, 26 Apr 2012 15:41:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Olof Johansson <olof@lixom.net>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: Default Kconfig state for hw_random drivers
Message-ID: <20120426144115.GK3207@opensource.wolfsonmicro.com>
References: <20120426114229.GG3207@opensource.wolfsonmicro.com>
 <CAOesGMj2eZvWek86D2MKQMPY9qAsC0D2MsYyN-+RPUr5gDFn4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2WS97oupGEGbYNpW"
Content-Disposition: inline
In-Reply-To: <CAOesGMj2eZvWek86D2MKQMPY9qAsC0D2MsYyN-+RPUr5gDFn4A@mail.gmail.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2WS97oupGEGbYNpW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 26, 2012 at 07:17:25AM -0700, Olof Johansson wrote:

> Looking at other options in the same Kconfig, it would be appropriate
> to make it depend on ARCH_AT91 instead.

Possibly wants an || AVR32 dependency of some kind too?

--2WS97oupGEGbYNpW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPmV59AAoJEBus8iNuMP3dwYQQAI8Q9ImjUJNN2Zq0GKyP84Fr
sj//XVTzPjnFDU/jXn4j0hm0rPeDUW9COk8/jLtmbi4o4is1Tc5Faw8/iUygLUPF
cbeeaOzoNJl6jx7dR91cTM+ts+GLdG6ouxR5ywJkphYyz2oyDfETZoPGSl3q06ab
BiNZ83t2OFnTpyT1rStXSqKiJdazU3Advu0MnQc8LjNAXOFnxWvRcwl8AjYcQv81
5AUWNysXTP0jLL5RmFGTf9I6JECbUF0O+LLd/oM5Q8LyQH6l7NflfZaWbmTHAcjn
BV8c+CmN5IAk0asuxVdXkY3TdAw0sL13TT60N01bbfGUQnod2SYsS16sehAMf+vP
4/I9SJgjoeQrwWKo+URB8qWmE57ctY8OGdYIZbzJAqLBBTQU586MvoyCTj8YX+zO
IpUF6YI7Pedyots/2UXcJoI2sxeTS486aV7JoGYeq98vVerPT2ybJfd8SuLwkPXf
/P0+6HxsPulI5Nptgj5iucygxGUmegjBFdwXInSqqLJd2/Ny+UOmQkZ/MsIpi7i3
otcSk/ckf73B5kHb/bu/ps5cmshkKFSViFdpOwXGWLKs7OkLopWfNIYAZPBJ/oxi
BoRJx7UMRKdOM4vPlpgBsSpFCdt9aH9LCkJHHWOnvaf0cX4l1bSagxU+0TkCS/oS
pHpXrJeLIZFilaUpE/6f
=DLm0
-----END PGP SIGNATURE-----

--2WS97oupGEGbYNpW--
