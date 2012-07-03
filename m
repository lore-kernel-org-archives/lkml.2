Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361Ab2GCGSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:18:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34468 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab2GCGSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:18:53 -0400
Date: Tue, 3 Jul 2012 16:18:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: linux-next: build failure after merge of the final tree (pwm
 tree related)
Message-Id: <20120703161846.59fee8d3815993bcea122eeb@canb.auug.org.au>
In-Reply-To: <20120703061115.GA27989@avionic-0098.mockup.avionic-design.de>
References: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au>
	<201206301920.21158.arnd.bergmann@linaro.org>
	<20120630194139.GA24300@avionic-0098.mockup.avionic-design.de>
	<201206302012.32476.arnd.bergmann@linaro.org>
	<20120701065639.GA25470@avionic-0098.adnet.avionic-design.de>
	<20120703154318.9e32d4a490c0b32e7d955ca4@canb.auug.org.au>
	<20120703061115.GA27989@avionic-0098.mockup.avionic-design.de>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jul_2012_16_18_46_+1000_x/IB3M4MkQKmz7+_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jul_2012_16_18_46_+1000_x/IB3M4MkQKmz7+_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

On Tue, 3 Jul 2012 08:11:15 +0200 Thierry Reding <thierry.reding@avionic-de=
sign.de> wrote:
>
> I don't see how that can happen. If you have CONFIG_TWL6030_PWM=3Dy, then
> you should also have CONFIG_HAVE_PWM=3Dy, which would in turn conflict
> with CONFIG_PWM=3Dy.
>=20
> I'll have to fetch a powerpc toolchain and try to reproduce this.

CONFIG_HAVE_PWM only exists on arm, mips and unicore32 ... so the "select
HAVE_PWM" will not do anything on any other architecture.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__3_Jul_2012_16_18_46_+1000_x/IB3M4MkQKmz7+_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8o7GAAoJEECxmPOUX5FE3zQQAIEQkJ5bc+wrd+/8d9qyrjd3
ru1HI7QtdBjSRmqFR78HdeJB/voHh4lIU7e2jgWoHi7MZgE9mVcyIbLhKHRZy23W
E8eSvXD+ubtnnHObiKrZ5eefYcx190CXXqJ24hbHdaq88ti+VdV/3R9wVWRRtInh
fnjPMEjUSEBDzbda0lgK5MtEagelnFthzgUo+mdvYRIxdLpm7ykNWLhzq1jUezA7
vky9gS8mWx564ynZih3a+qTRdEbP9rPQEGVwgGSf5bu07q/sNw8ze8Cy7PYxZ5iJ
L94XyDU881UsXiyJHNnU8MTS2SMr6G4CncK4hCA+n7nwgu8aODCMmrD1acGW8w04
YGHAQhX6LIqg08R5mmrWYFhfNW1/LZiavDAqyvqfj/5aKeIw30kQl0NXF1yVREOE
majNVE8pyGmVLQNXHCoUHjzj713CdRUrgXzg5GpMNdbqen8NHxADZVt4B6CTSXRl
spSMk6nORQ9Ss8Lc/Ajgp6YDpdRL9IRzyeYg3QYlWEdgh+mcF/jPTmESga3sGyjl
NL/d8LrdbUchfLgbV9mGyPcPN2a1rvmu/Ie4zO7W+9/zry92aniBhi+l6C4fShIY
TWc/gp8U9ezyAoD2z8JariO1VDKNyUQ2Ol/qjVbu/I2CHVAttRhqSA4kXwUYmUBG
5SV0k/IYjBuzrQsT8/ee
=EUMc
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jul_2012_16_18_46_+1000_x/IB3M4MkQKmz7+_--
