Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103Ab2CUUKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:10:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35226 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758439Ab2CUUKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:10:19 -0400
Date: Wed, 21 Mar 2012 20:10:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
Message-ID: <20120321201015.GP3226@opensource.wolfsonmicro.com>
References: <4F6A2042.9030302@codeaurora.org>
 <20120321190741.GL3226@opensource.wolfsonmicro.com>
 <20120321193304.GO9859@atomide.com>
 <4F6A2EF5.3010008@codeaurora.org>
 <20120321195656.GN3226@opensource.wolfsonmicro.com>
 <4F6A3446.9020809@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YyxzkC/DtE3JUx8+"
Content-Disposition: inline
In-Reply-To: <4F6A3446.9020809@codeaurora.org>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YyxzkC/DtE3JUx8+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 21, 2012 at 01:04:22PM -0700, Saravana Kannan wrote:

> Sure, prepare/unprepare are already there in the .h file. But they
> are stubs and have no impact till we move to the common clock
> framework or platforms move to them with their own implementation
> (certainly not happening in upstream, so let's leave that part out
> of this discussion).

> So. IMO, for all practical purposes, common clk fwk forces the move
> to these new APIs and hence IMO forces the new APIs.

Sure, if you want to look at it from that point of view - anything
wanting to run on a platform which uses the generic API needs to use
them, but there's no blocker on the user from this (it can convert with
or without the platform it runs on) - but it's hardly a tough sell.

--YyxzkC/DtE3JUx8+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPajWeAAoJEBus8iNuMP3dr90P/iP3QwWct+huHt9NwLF6l52a
wqAgfS+yAkv46amrotklM19cmeq1PUOJDcqYam3FSRKJsxYHYxlSIMmo5JKSfNi4
gTctluIBaqzqeARGKrNyQQomv/Wr6HBJ8828f0cQZIXfp/ON4OHrUAs7uAwemnbN
CoIr0xAR7UFeUdHQOAXQtdgQY/XDb+hFRw6pt3yqbc9R7rAwdDG0P8b6iBVdBleU
GOrSnPldtK3FyMDlS0vebKoqP1uHq8AadQvkAV3JCxhbegg3LbamrQG+XmbVrF7p
M2vT8YbMdyivAOUMnLCyzNwyTbIAmuMPsbw/gxn75bx7iTmhO1J5N8J1Ciu6/s3R
l5/sCd62nUlis1VjO3CxXbZDvci/MiAxqrrUDocYDhWjrtMj1B4crzZeLSeGhm9D
l/1dABrwaoya/KWDQwRSaEy2pxy1rUD8gg8IQBtOZJ84mM7SdnNc/UrgImUOoh/a
HvrTm02TdMUu4Kn6LG0PxFhiZZhNj5IQJR30dxWS8G6hVFfvOnlGeAr9AV0r09hh
rgmefnvLREqVlejtwH5wjtAt2B0qCyjYMsnY0AmSlq+H0fiX41ASQlGlEvcBx5Ty
ulCsWv7gk2cHWTmLQTqp7bEqwlFZ9nJ75lqSJzY2eLnSHehe3HvSL9v8OF+z3lWb
JRne5dV5SJX8s8DYo0Pl
=om5a
-----END PGP SIGNATURE-----

--YyxzkC/DtE3JUx8+--
