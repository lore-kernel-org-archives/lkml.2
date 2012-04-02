Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2DBV7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:59:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41644 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615Ab2DBV7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:59:32 -0400
Date: Mon, 2 Apr 2012 22:59:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clkdev: Implement managed clk_get()
Message-ID: <20120402215927.GG3160@opensource.wolfsonmicro.com>
References: <1333403385-24133-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120402215341.GL24211@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nqkreNcslJAfgyzk"
Content-Disposition: inline
In-Reply-To: <20120402215341.GL24211@n2100.arm.linux.org.uk>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nqkreNcslJAfgyzk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 02, 2012 at 10:53:41PM +0100, Russell King - ARM Linux wrote:
> On Mon, Apr 02, 2012 at 10:49:45PM +0100, Mark Brown wrote:

> > +CLOCK
> > +  devm_clk_get()

> devm_clk_put() ?

Yeah, I noticed that immediately after I sent when it turned up in my
inbox and have already fixed locally - it'll be in any future version
I send out.

--nqkreNcslJAfgyzk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPeiE2AAoJEBus8iNuMP3d01UP/30Q2IM7YDo1MYJ8digbXnYv
igMR9TunHdMaYk4vyDSIDU9rTww6htoG6xRSiqsYKHri/uO/T/7NzAZVnzo60ugV
BuXpKM8rkKMD0x1tkxCgFuF0fnqMqgjAFawGVwSv3wtnfuvf4MIRxg7LgT5dLovd
VmDxmtDkF88ZPn/sU0IzI8dgIpW0SInNIUcX647KblZuzFm02bXc4UUkYabI0g5k
a2BQv5sBUAASnqGLiFXbf+3YjHAi3YM0w7gNcnLA1MMD677TU+HUdu4UMM9KJGzH
zWQs+f5B3XGetLdS2hoXN4wlJnlufj/bSmtH7xIY+ZlmUGC30vfgZln2n2gwV3r8
Mk8EEr9fnN2TYSeEe4JVFet4UXoBZVFhznbVWUrNT5/QSBzD/S1BMfRCET1ZYFgT
MjhLE9ua2lvYACQGNeAkmHDLaXNi8tB9tiMaoTTAk9EzgVcfySvTHSUo0lDAreeK
u89JjrVu/+NAosAg+4NADglZjzAiuPUOKGS3TT+wcRmJxXRQ44r4hGxWssHQsYrk
Ftb/au6vXCSkQoNLnTALn9OZyeubJJu4l9bH4JZQDO+oAuJ1cRJHnH+IO9CL2+0U
cxOqf9TTXHijH4oQDeqULHAc+WDwddCU1Yh3v6UwGapXshD/8ATVGZlirrWQe0pq
czOwyl0P2S+XHFBiWspx
=hux8
-----END PGP SIGNATURE-----

--nqkreNcslJAfgyzk--
