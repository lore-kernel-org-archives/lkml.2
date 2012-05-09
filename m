Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab2EIRMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:12:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39379 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758273Ab2EIRMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:12:37 -0400
Date: Wed, 9 May 2012 18:12:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Arnd Bergmann <arnd@ardb.de>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Igor Grinberg <grinberg@compulab.co.il>,
        linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Handling of modular boards
Message-ID: <20120509171233.GL3955@opensource.wolfsonmicro.com>
References: <20120504185850.GO14230@opensource.wolfsonmicro.com>
 <201205041934.08830.arnd@arndb.de>
 <CACRpkdb4LGXfJ72uODr841O7M4FGTYKa1X7y6ekeLUw9vaL=mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/0D4jGRsNl8cPNu/"
Content-Disposition: inline
In-Reply-To: <CACRpkdb4LGXfJ72uODr841O7M4FGTYKa1X7y6ekeLUw9vaL=mw@mail.gmail.com>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/0D4jGRsNl8cPNu/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 08, 2012 at 02:26:54PM +0200, Linus Walleij wrote:
> On Fri, May 4, 2012 at 9:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> > Thanks for getting the discussion started. I've seen the same issue come
> > up for arch/arm/mach-ux500/board-mop500*uib.c and for the beaglebone.
> > I'm sure there are many more, but we should make sure that everyone
> > of these can live with whatever we come up with.

> The same issue sort of comes up with any system that uses the idiom
> to have a few GPIO lines indicate in a binary code what version of the
> board we're dealing with and what devices are thus on it, right?

> We have this issue for the U9540 reference design and potentially
> on the Snowball as well.

Yes, I think that's basically the same problem.

--/0D4jGRsNl8cPNu/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqqV5AAoJEBus8iNuMP3dubkP/ig0bcbV70YSY3mW4Im8OwA6
nVbGILSoGgQMQS43bbNp+lnYc0QePA5QDn1U5CXMU5ZkU370Vq1qli9HyyXJ3whn
4B6wOmqfhaGwg66VDOdEpuFCN/rPg+dFVj1gUOZynCk7lg7AAekUw2coJ72EZcYi
hx9+mX7teLLTWXywV+Iyf0fSbvDcMllULEdrB6Nex28dAc27TnkY5DB+nj14lHIO
ZQMmN3nmFbcqrgZ1pqj3FICUnD1ioHvVspYVCqr2osCuDZLX1vgipxttxN8pWWT3
ZI1hhRwtGy/Pxg4NPy2fTVNnAnZlp9CPcz6r6ug9raWq6WcWdMDTNlmEcj5Oih5e
xU+6rapTyv3SKCk1rNpLxcp6Dprlot34kWIkHRxOFhw903jBUA8gJlToEMvfqCj8
cA/gF8EgrKgVjfEByWgHEVWzWBAhk/Uoz9bBd3goznBMgQO28VgtrBy66v0q/5Az
wrhs5jafVBjZ6uVP1Dopv9CF5rImjtQqpTSa/7GKqSoSIuHMctQxLSflhit179J1
0HC1QD5YuO2FTerTDK0JnsQ09Ih3OTE7RSRnZRJp0Edo8y80wztzUlPXFZy0Jt9p
UONT4+/bHTxobfG+msRiT7BPojPPWBZkPahI6+SCnCT8LFjxb5L6WO/SMKSSqp4I
fyhYYgDFiVYHhJwSd+Ru
=Q92r
-----END PGP SIGNATURE-----

--/0D4jGRsNl8cPNu/--
