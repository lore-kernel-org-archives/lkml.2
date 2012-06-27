Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab2F0O3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:29:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46415 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab2F0O3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:29:44 -0400
Date: Thu, 28 Jun 2012 00:29:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, rnayak@ti.com,
        viresh.kumar@linaro.org, amit.kucheria@linaro.org,
        linus.walleij@stericsson.com, shawn.guo@freescale.com,
        mkl@pengutronix.de, sr@denx.de, pawel.moll@arm.com,
        maxime.ripard@free-electrons.com, linux@arm.linux.org.uk,
        arnd.bergmann@linaro.org, olof@lixom.net
Subject: Re: linux-next: adding the common clk tree
Message-Id: <20120628002925.dd144b4782398042593b6b47@canb.auug.org.au>
In-Reply-To: <20120626230503.GA4402@gmail.com>
References: <20120626015551.GW4402@gmail.com>
	<20120626132502.7584f6acbfc23bdc3d6a8f8e@canb.auug.org.au>
	<20120626230503.GA4402@gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__28_Jun_2012_00_29_25_+1000_B5cCt=U9x.qqqF_5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Jun_2012_00_29_25_+1000_B5cCt=U9x.qqqF_5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Tue, 26 Jun 2012 16:05:03 -0700 Mike Turquette <mturquette@ti.com> wrote:
>
> So please let me know if I still have the concept wrong and I'll change
> things up.  Otherwise my clk-next fulfils all of the guidelines you've
> mentioned below for inclusion into linux-next.

OK, that all seems to be fine.  I would make one suggestion: that you
create the clk-next branch like this:

git checkout clk-next
git reset --hard clk-3.x
git merge clk-fixes
git am patches/clk/next/incoming/*.patch

or maybe just merge clk-fixes directly into clk-3.x when necessary or
from time to time and base clk-next just in clk-3.x.
--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__28_Jun_2012_00_29_25_+1000_B5cCt=U9x.qqqF_5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP6xjFAAoJEECxmPOUX5FEqHEP/i+Wcb5Ja0nUmKKoH1sgm7xA
S2t3Pu7/x76voQYt3Z9INCJD2Wc70uNL90RfJD9gwJKh9k13Zu3+1QNqyIyf6X1d
BoYUOf7ffSKV++ImHtbHkYINsw5O9D/P/Nwzywls96NSBQunqOkajBSB99nADF7O
13zBHgl2PxoftgdZcJWTcma4l6NePYHKyvjmBVTUL7Hka+lOtzI8Kglj1RcDyA+j
PUBGMNXHPAp8PJp4aqyUhh3WfzWDHDnwm0MY3KlNzujK07kcPhFyE7qPLVETMgyn
4BDFt7iUifPgR9DdYe80itbOoA8i5n9V5IRaaugWobPO0m0n4Ap3C+9yv/TxtZkg
f8IcW+JZNO1IvJUtWilQmknf9YnK3df80xYwI/SUtMWtr5fWSm+h0v1lDQ4brdu8
kWvRlbCl1gEZ74o25H57TwilFglQPFMMcpHTJpJ5xRe1LjwrhxvzeSeCbulxYw0u
laVl/mrRcCMsI1sk5ql4SBpprMmKg4W1HfS4/V0AVKFDAaPsgeyiFyeqb8LAjBMP
Lb5pVjwC5ehQffE9zHrYwuclDhSj5xIBebgwbN5oI+NkwyBObQMWB09i6Wz7tw0s
WtcI+TwVTNjfCGgPCiFmnng9uw4g7pscGhyOa8Hk7uEVRHBs+19somQzs55S1slZ
cO4kxef9oQ7hC9mvJ8rU
=iNE0
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Jun_2012_00_29_25_+1000_B5cCt=U9x.qqqF_5--
