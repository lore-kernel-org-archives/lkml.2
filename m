Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab2GQPUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:20:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58558 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754163Ab2GQPUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:20:07 -0400
Date: Tue, 17 Jul 2012 16:20:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@gnudd.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 i2c-embedded tree
Message-ID: <20120717152001.GF4477@opensource.wolfsonmicro.com>
References: <5003FB7C.4030509@linaro.org>
 <20120717130650.GB27595@sirena.org.uk>
 <500568D9.10805@linaro.org>
 <20120717133550.GC4477@opensource.wolfsonmicro.com>
 <50057058.2060002@linaro.org>
 <20120717142222.GE4477@opensource.wolfsonmicro.com>
 <50057C1A.80606@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hUH5gZbnpyIv7Mn4"
Content-Disposition: inline
In-Reply-To: <50057C1A.80606@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hUH5gZbnpyIv7Mn4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 17, 2012 at 03:52:10PM +0100, Lee Jones wrote:

> I think it would be okay to take the 3 patches due for the v3.6
> merge window, which target the nmk-i2c driver. If any consolidation
> happens in the mean-time/future I will personally do the work to
> bring the nmk-i2c into line to use any generic bindings which
> result.

> No one else is ever going to use these vendor specific bindings, so
> I'm sure no issues will arise. It also means that we have a fully
> enabled driver which is capable of receiving a new configuration via
> minor changes to the dts, which is important for the current (only)
> user of this driver for an upcoming project.

So, this is pretty much what vendors always say about this stuff...

Looking at what's specified in the platform data in the current kernel
it seems like there's a mixture of things in there that are board and
silicon specific.  We've got parameters like the the speed mode and
timeout which are reasonably board specific but we've also got things
like the FIFO sizes which shouldn't be at all board specific and slsu
which really looks like it's something that that the driver ought to be
able to figure out for itself.

--hUH5gZbnpyIv7Mn4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBYKOAAoJEBus8iNuMP3dQPgP/i14QVmEVzfiikhATrJOg4bW
4dkAqqzsSGoiPXDvLWshMzvN8d1wKwRQcFdELNc8aIvy5bpZSnvjxTASpM5HRv4D
1l6ph901olMmqwkYUG2iPo2RP2DrOK9gF+fgVSIpj2vsxpH3JGuba1O9E486DenM
Wn7ciWXA6nmeJW0XlDQYl7Ln7Glth4hy+aZDFW1svkqUNT7dfXWZLbA21bjDuDW4
NLAcAfSx23snXXlQi2gY1CNnIHOP+CKGmICbRUhG5MbfLWC61V015V3rnlmu9/a/
Z9wav3yF9m8bCUal27oIIWyeyGyz4HxAkQNlRziWUcsJTHhgyhT6x2XU1puRNARh
EVIveMqo2WmZ2eAzom2jg7BkP065BnH1392j4UbaHGv3TWXPz+zmS/ypCdpfi5mp
CvcBSZSHDu96UCAUYyXhtAygPQ9A1CoVwIoLQJ1ZcRKATti6KPQ5sfOd+iQf1WvL
rcUGAREcroaw1hj+QTlgVU8cI82ZSxCL3xc68+NjqKemcuUB74PTuye7Azw4/XLu
zIW91RutdjRAPTgwcO8GeVlcOoT8CDih7EvyhGO+CTg9cTNF0IqAgbLciHTdjHg9
r05TZ9j+BbAYy0EGozuuRqFLALGY66G9zZsuFjFP2ldgn9kqy8Z/FByTsFSNf1fy
fGXoM7pZC8TY6Tk27dLO
=jvqo
-----END PGP SIGNATURE-----

--hUH5gZbnpyIv7Mn4--
