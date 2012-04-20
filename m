Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2DTRF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:05:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55988 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751976Ab2DTRFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:05:25 -0400
Date: Fri, 20 Apr 2012 18:05:20 +0100
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
Message-ID: <20120420170519.GB3080@opensource.wolfsonmicro.com>
References: <20120420033209.GA17930@kroah.com>
 <1334898987-7800-1-git-send-email-myungjoo.ham@samsung.com>
 <1334898987-7800-7-git-send-email-myungjoo.ham@samsung.com>
 <20120420162529.GA31744@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <20120420162529.GA31744@kroah.com>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 20, 2012 at 09:25:29AM -0700, Greg KH wrote:

> Ok, I've applied this, but I don't know if we really need this in the
> kernel tree.  How many out-of-tree android switch drivers are there?
> Who needs to know this information?

Every phone with a headset jack will have at least one switch if it's
running on Android.  People doing system integration will generally need
to know about this, at least until we've got the ALSA detection stuff
integrated with extcon.

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPkZc7AAoJEBus8iNuMP3dfVYQAIgto9RwhbXDN8t5kmS0+TJ6
BOhC90xbE+ZL1T8LTJHVwT+/f2JAuG3iFGIEejS6vlwVpuDR0d93WNzmeILCStaT
Jgle3fD4VrQV71iDsHWdd1FLeiLPrOeepJQqCcO2lBZnF5tUePXWNV11CNGPArop
BLOa6oye3RPrQkiqjnOzTiMYPeCiSUisodZEsb9gicvq4hawTD4xntx7LqTqwboH
mxb1UXjXJ6ASHFa9Zws1oLDlyN0B/cUFhmjTZN/ds5JXHANmk3bLwRabWO7CE4xj
XiSOPykP2CIwx2uEal9u3zwKhxbGYPtphdbCHAbUHHOWGBCwbdn4aq5ntjOPx4A/
/G0hT5sq+ulk8nLgiDJyvFKxLPGj4O/j6o6+knETTt7IDwCeCErga5aB7Zr8w5iD
fd+21mN4e6D8W/rPGunMDF+qYtyGnjAIqkWUSuxHWThy03ezx7K7CdR1koTLTiRo
yjTUcjPCaOjM+n/GMZKJH1ilPZQMQiDVaO+pcUBvgKzXOFiIaneMXxw9JGxHZTMZ
VUdb/hpKmb9XRgmgwxbg1qD3Z1uHStBIrgD0ZTCBVghKI/Ibc0A8z14q5hJ7lZka
n5pwHvVAC6WEd+Ib3h/UOO+hFNlAekBmp6qCGTLdo0O8XJtm69VT1sFVssNptxDN
k2h8uQk5eh5JT6mi4QI+
=24/1
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
