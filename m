Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2DTV7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:59:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41228 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427Ab2DTV7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:59:08 -0400
Date: Fri, 20 Apr 2012 22:59:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>, myungjoo.ham@gmail.com,
        cw00.choi@samsung.com
Subject: Re: [PATCH v8 resend 6/6] Documentation/extcon: porting guide for
 Android kernel switch driver.
Message-ID: <20120420215902.GA3088@opensource.wolfsonmicro.com>
References: <20120420033209.GA17930@kroah.com>
 <1334898987-7800-1-git-send-email-myungjoo.ham@samsung.com>
 <1334898987-7800-7-git-send-email-myungjoo.ham@samsung.com>
 <20120420162529.GA31744@kroah.com>
 <20120420170519.GB3080@opensource.wolfsonmicro.com>
 <20120420171534.GA29519@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20120420171534.GA29519@kroah.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 20, 2012 at 10:15:34AM -0700, Greg KH wrote:
> On Fri, Apr 20, 2012 at 06:05:20PM +0100, Mark Brown wrote:

> > Every phone with a headset jack will have at least one switch if it's
> > running on Android.  People doing system integration will generally need
> > to know about this, at least until we've got the ALSA detection stuff
> > integrated with extcon.

> Ok, but where are those drivers at?  Any pointers to them so I can start
> sucking them into the tree and doing this conversion?

The actual code is all obviously out of tree, I'd expect any Android BSP
to contain at least some usage of it (though often just the basic GPIO
one for CPU vendor ones).

> Is this, and the wakelock stuff, holding back a torrent of drivers to be
> submitted somewhere?  Or are they buried in vendor trees, never to be
> seen?

I'd not characterise it as a massive problem (and wakelocks won't hold
back anything that doesn't have other problems).  I suspect that the
code for a Samsung phone with the 30 pin connector will show something
interesting, though I can't say I've actually looked.  For things like
headset detection there's already ways to support things in mainline and
we should just end up hooking extcon into the central support for these
things.

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPkdwgAAoJEBus8iNuMP3dI04P/35kVpPT9PUbkHtjnrMYq5oh
M3bNmvK9GYNY4MmtoOoS9cfFlfJ3CCs4+yZgUpYV39ekzYie8rzjOBWBRSy7uaWH
jILFRtHJW4hcxXj+t4wwtO5Dn+Sb2cFoKakcG/UaRslAmXqtiK2Hb9Gb3uE5fZvZ
Tfvtl+Tfq0fWzlRfHqf3RB4zWNHF0RrfXJagC19PMy5f+kDEqqiLcw8Ob1N/Eh2P
Z2FwJJ6SIH15k5pEMrV94QDmagFolB2MYqvRmvvSxHjElZBHbdsoTLnJAXlh9yeB
t+gnD/0puHiZhxsVssQ++iWTqacnqPs3Q+jEKduK7ZqQLKZzb+F22XUyLbNTM/Q4
WbV0J2su5DpY4M6zoXRDgqJWJC7I0h69c6wFzsUtSVMMbAWFspC56jsgo12PQECo
Nwpng9DVofrZEnh77I3JXGdDHXbdBSbvcKbuzLygAsM1U5IQeS2TED/LpQ0csdSp
PEPcQ0M5shKu2iqjVqwA/EqQiLs4DrZE2l0OlnZu/f93JyOpYZZsDTS7Mjowf7v5
nAAePd9ta5To/DcaAZmJaL56+lxPoeU5HupKtPg+oG5lLVFSFzRwf7UfOUez+qpD
zKoZTAueBbfuDCFc5t501tVdn8XBJUpqdNmOVCWDHkiIYEnoNcSqHGTMluW0x4nO
m8IaZxQoniD7cmuFCeA2
=o+Mf
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
