Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab2KTIIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:08:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37354 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280Ab2KTIIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:08:17 -0500
Date: Tue, 20 Nov 2012 17:08:09 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: max8973: add regulator driver support
Message-ID: <20121120080805.GU10560@opensource.wolfsonmicro.com>
References: <1353288509-26703-1-git-send-email-ldewangan@nvidia.com>
 <Pine.LNX.4.64.1211190900110.11024@axis700.grange>
 <20121120004356.GC4483@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1211200840590.21420@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O0IT7rLmWuveAsNR"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211200840590.21420@axis700.grange>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O0IT7rLmWuveAsNR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 20, 2012 at 08:55:47AM +0100, Guennadi Liakhovetski wrote:
> On Tue, 20 Nov 2012, Mark Brown wrote:

> > The thing I'd like to see factored out here is the LRU mechanism,
> > otherwise I think the situation is pretty good.  Some of the older
> > devices should use a different scheme to modern ones as the hardware
> > they have to interoperate is different.

> So, do you consider the LRU algorithm to be the preferred way to configur=
e=20
> such regulators? I realise that in practice it will work well in most=20

Well, there's not really many other options.

> cases, usually users do only want to preconfigure such a regulator to 2=
=20
> fixed voltages and switch between them at runtime, right? OTOH, do you=20
> think it is too unlikely, that someone will want to switch, say, between =
3=20
> voltages: X-Y-Z-X-Y-Z-X...? In this case the LRU will just lead to=20
> constantly reprogramming the regulator. Whereas if the user had a way to=
=20
> say "configure context A to X," "B to Y," and then only reprogram B=20
> between voltages Y and Z, we'd save 1/3 of re-configuration accesses?=20
> Maybe even in some such case, quickly switching to voltage X is more=20
> important than to voltage Y or Z.

Modern devices tend to use multiple GPIOs for this control for a jolly
good reason.  If you've only got two levels then the wm831x algorithm is
probably the most sensible.

> > > > Add regulator driver for this device.

> > *ALWAYS* delete irrelevant text when replying.

> Not sure what you mean, sorry. If you mean all the text, that followed th=
e=20
> above line, then it wasn't all irrelevant, there were more comments down=
=20
> there. OTOH, if you just meant, that I could have deleted even more text,=
=20
> than what I've done, then right, sorry, there's always a balance between=
=20

I actually thought you'd just quoted the entire mail and just deleted
the rest after a couple of screenfuls so a bit of both. =20

> deleting too little and too much, and the decision is subjective. I=20
> usually tend to keep somewhat more, tnan most would consider required, I=
=20
> think, it is easier to hit "Page Down" a couple more times, than to have=
=20
> to guess what the missing context was. But I'll try to reduce unneeded=20
> context next time.

The extra content is profoundly unhelpful to people reading on phones,
and to people on slow connections (I spend an awful lot of time in
hotels with dodgy internet access for example).  It also (as happened to
me) makes it hard to find new comments in the middle of reams of stuff
you're paging down through.

--O0IT7rLmWuveAsNR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQqzpSAAoJELSic+t+oim9jSoQAJ57hLR8gKUUEAcX8CMt+YGA
t3RO2nPEgyyXO5Cz2oGczdbYr26e7yyDONYU33vU83Yttwj1lwVb/LyCbz7zkVYN
pFz5DTHkPIU0k+JBSV+Xyqz5bb1hBxEpiR9pdUWHfi2WHBYth6InYvyxwtuv/ERM
LLftxebon2uUGftcSjm5IWfK5Ta8om7Wbv2sDAwCesuuWGZKXAIRKrWc/m8aABqJ
Jn3j902Fm5Nj5WkX1v7GcaT5sWCsUTEROO7ychqUYVXrIksT1EspgTKCDw2yZwnv
JD/5Fq+ec/aovgjrg2Q/drQkr/eG7aVAxSQGF5Q2+NmCHQY1Q1L19iiBe84bdwud
rMKsn8HUIlJV+s+/MWWNljv+1ZeZ4g0ZrT3mK4C8iN9NuGJDJutaKknmwqMz5JH9
YVTjqnq0sjXlPkH/N1gcN+3ZH3lslVtIcmxOlpVVqx58icuD6/VWLxGSI2kUIGHj
epb59+3yNoidRWq3DZmASohLjrxVgJvaIKhe2wrXIfqmgcYxJcA0VboiewwOxPAj
bd0+L+wYqrwFsfGDeqROvv6pkZqJ/Y4FcOOi3RDDLPHYGgEJ8/eo09kyLobPLqbt
7yxiH5VBG9BK4ZqHOq3jp95NRYfKPN6erfEjs619S4sNMQQASce/kg0Lwu/43RPV
ANYOigAR/XhQYMLjPgEt
=+Xs1
-----END PGP SIGNATURE-----

--O0IT7rLmWuveAsNR--
