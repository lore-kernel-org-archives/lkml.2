Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab2B1RpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:45:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37441 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175Ab2B1RpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:45:08 -0500
Date: Tue, 28 Feb 2012 17:45:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: myungjoo.ham@gmail.com, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PULL-REQUEST] EXTCON Patches (Re: [PATCH v6 0/5] Introduce
 External Connector Class (extcon))
Message-ID: <20120228174505.GP3683@opensource.wolfsonmicro.com>
References: <CAJ0PZbRsh_Cnqy8Vtf1FWLajBr=R5iQ=Jog+w+qPE-uKrh5XQA@mail.gmail.com>
 <20120228164413.GA11021@kroah.com>
 <20120228165727.GO3683@opensource.wolfsonmicro.com>
 <20120228170246.GA11415@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QLVwfW7TUsi22t4P"
Content-Disposition: inline
In-Reply-To: <20120228170246.GA11415@kroah.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QLVwfW7TUsi22t4P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 28, 2012 at 09:02:46AM -0800, Greg KH wrote:
> On Tue, Feb 28, 2012 at 04:57:28PM +0000, Mark Brown wrote:

> > There's a few more kernel changes needed there before full acceptance
> > would be possible - for example, should have an integration into the
> > audio stack as one of the uses of the switch API on Android is for
> > headset detection.

> Is this integration planned?

Don't know if anyone has a specific plan at the moment, though there's
enough people care that I'd imagine it'll happen if Android decides to
use this stuff.

That said I don't see this as a blocker myself - it's more like an
afternoon or whatever of work than a serious development effort to do
the updates, but a similar thing applies to most of the Android
userspace updates.

--QLVwfW7TUsi22t4P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTRJiAAoJEBus8iNuMP3d7AMQAJMdLLWh3KgkPQkZ16CaB89y
Ja+d0yRuTv7T+7PthquL9Qk2e0QrKtB9HDekeHXmxevLCjEJb/6i+a7fyd9hjZGC
+QeQIEDmnf35/n0e4rhhCLQD59Gjy2GOWNsIZqwZYzSo8jrdtMDs2HImkrwBSaCB
u7hXKqnL5y6bmGBrV0pgJAF6P9qOB53N3DFF7XlLTcRYD3WwtuK8Py2uXRp2V6Qd
s50fhCzSsxbnpBXqnTJbov1854k+X+PLUSNI5svBbc1sHSrdevDagRGqy4uzVVMP
Tyrn+fN1K6TlDN1He+hd70ONuU0NXg+yA8kKqsXTu1V9q3RzJPYT80MhbhzL+XL6
5mqMV3InMskukVWZt+Lzbpmf+R4HILcIv/LnYghw0yrXn3Xoz7BGRLrgG++IirLa
78Mue0HTHKrnADQxHKEQEUhp7SV79IjoUQZGTkma6rawBwwufm4stDo7i2GuoRIE
TvXbEV2rDDQAjscCuRZI9EZv2SFT7iHdn0586EV6LsdDX30PPIjLUXoRuWl1sN9t
ghdnGL95p0905EQQWQTf66EIg+n7xS8emPCFy4s7s7BwCR42SC+/HAk1Fn2KZnVN
XqyhwdGadLa9UV+GliVbRB85ZQHVr9MbVcAFm1iS1sUx2EMLWs5eIqa8PROqB7/G
gXNVFBiovMvd+EjgOTa3
=79Rr
-----END PGP SIGNATURE-----

--QLVwfW7TUsi22t4P--
