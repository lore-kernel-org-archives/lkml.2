Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab2DTWE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:04:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42872 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755340Ab2DTWEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:04:53 -0400
Date: Fri, 20 Apr 2012 23:04:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Subject: Re: [PATCH] regulator: Provide a check for dummy regulator
Message-ID: <20120420220450.GB3088@opensource.wolfsonmicro.com>
References: <20120419162905.GA3084@opensource.wolfsonmicro.com>
 <CAJe_Zhd0H6kXBhqdynuZqhbcPq8ARWu5SMbs=hQT2n8stzRvXQ@mail.gmail.com>
 <20120420114602.GB3259@opensource.wolfsonmicro.com>
 <CAJe_ZhdKv_7fTj9ZhJE0JzmuhxEZn-JmSbHu615YMXoWZUei9A@mail.gmail.com>
 <20120420130134.GA5957@opensource.wolfsonmicro.com>
 <CAJe_ZhdKtK8YKo1qc8g18XrdnrQRZw2aFSkW8x3koELU10EsHw@mail.gmail.com>
 <20120420144256.GA6828@opensource.wolfsonmicro.com>
 <CAJe_ZhdzuHo8P5WHguKMaikht8aN4RU-j_Q9FB+xOSw=roFZ=w@mail.gmail.com>
 <20120420184806.GA3092@opensource.wolfsonmicro.com>
 <CAJe_ZhcfcTGjmy-n1hrVjvQ-8+Si4VAWaCf18cpap3NW5b+M=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
Content-Disposition: inline
In-Reply-To: <CAJe_ZhcfcTGjmy-n1hrVjvQ-8+Si4VAWaCf18cpap3NW5b+M=g@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 21, 2012 at 12:41:18AM +0530, Jassi Brar wrote:
> On 21 April 2012 00:18, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > In any case, the solution is very clear - just do proper regulator
> > support and turn off dummy regulators and everything is fine.

> You earlier said there are always going to be 'new' platforms that would
> need dummy enabled.

When I say "need" I mean either "are at the point where just booting is
massive success so who cares if there's the odd bit of breakage" or
"have been randomly broken and need investigation as to what went
wrong".

> Now just imagine if one of those platforms happen to share the consumer
> due to which you suggest disabling the dummy (omap_hsmmc in this case).
> If we re-enable dummy, then your's isn't really a solution.
> If we require that platform to come with full compliance, why can't we
> ask every platform to do the same?

We do ask every platform to do the same, but enough people run into
problems that it's been useful to provide a standard crutch people can
pick up to get their systems up and running.  The theory is that dummy
regulators are enabled to help keep things running and as a debugging
aid, they're not intended for ongoing use.  If nothing else the log
message that gets printed out whenever a dummy regulator is used can be
helpful in identifying what's missing from the board setup.

--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPkd17AAoJEBus8iNuMP3dnvAQAIk/G0DsU/GWOw/VYFwKPzYB
sfd1TIMrkuoafiZun0dRD4k3K5rZoHLmgpy7OUEnZ6W5w3ZgzvULwJga55zSp7Sk
A8Nf0/tYbRovzHuy42EXLekWYVTc6xlKhMvQtqYa+QzyTVg8lzMl/jHjJlFhGOqg
H2Iu5eyfaBV/XQoAFj5ls4rYcgmgf4Z1580Rcf7MuTGaK+62L08j/4GYdY/QIC4v
OIZpenWG84d+QGQA0vHaWFOhg5vLeZxI86SH2eIgTR8p3UrDYl0nxHWPbX+l9IZ5
xis+ukVmFs7coZm0VZEilD4JEWKKIh0gSvwAf4QAOZlSb8YoN3p2nipdgbnl36pY
0y2+P2Kr88QQxPelfY/QPfCfz4ViV7ef1y0tw/wI7BRS5zpPcIITllkOVwPHvmN7
Nb9DjAb4DDZvku7FRr5ZVb7XtfwDzeLbc80j91fY/3Vsm0cPDJBDnRAJVkXlcV1v
/H1q2pMbOK4M5dnTJOQuVjn+hC1joKAa3nDDjTp2jYFr6ziakznOvqpNjrBFgPyh
xgsmB7NEcGco5tbGghTHb1IyzXC8i8t5ybqRfDVlMMEnxNAurBRTVXf2yn1qlnRh
VbVD2bNhgJIbvuha/4B9AS65qwLPyo/42UVURsWeMNniqDN+7bn71zTo422IC1Oo
8EU4sMq26CBnfICTyc1x
=L5vW
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--
