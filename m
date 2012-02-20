Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2BTCYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:24:47 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60885 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753885Ab2BTCYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:24:45 -0500
Date: Sun, 19 Feb 2012 18:24:33 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v5 3/5] Extcon: support multiple states at a device.
Message-ID: <20120220022430.GI3194@opensource.wolfsonmicro.com>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
 <1328856038-21912-4-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hUH5gZbnpyIv7Mn4"
Content-Disposition: inline
In-Reply-To: <1328856038-21912-4-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hUH5gZbnpyIv7Mn4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 10, 2012 at 03:40:36PM +0900, MyungJoo Ham wrote:

> +	[EXTCON_AUDIO_IN]	= "Audio-in",
> +	[EXTCON_AUDIO_OUT]	= "Audio-out",

Can I suggest making these more specific - how about

	[EXTCON_LINE_IN]	= "Line-in",
	[EXTCON_LINE_OUT]	= "Line-out",
	[EXTCON_MIC_IN]		= "Microphone",
	[EXTCON_HEADPHONE_OUT]	= "Headphone",

as a starting point?  The distinction between line and the other two is
often pretty important from a UI/system interaction point of view.

> +	/* TODO: remove before submit */
> +	pr_info("[%s][%d]\n", buffer, enabled);

:)

--hUH5gZbnpyIv7Mn4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQa6hAAoJEBus8iNuMP3dPvQQAIlhBMhLz0pTOfSkIODDtnzy
M0go3UAQS9HXkBEtqpx8r+/1L8pYqX0k59uc146R9MVnc2suijvfvkIhrisAdU83
bJUoA9K5AdQHcyQPMSzbphMCvdr546VqmoRx27sPBEuiUBBoozqtKvFyVpRWORU2
31Aig/nylL5bh/X/lO9r44IILLIdrGa9+jxqWrIG2U+MR3WDBm7hkweQrWEzY0+m
idJNK9dBUgU4c+7mMz1cYGkDONSgoKH+M9Uf/ChVM4zsHmORSYLtykRWek/X1R3u
0i3PUXYpmTpoVXW4XZBXnIK0AOZssNmqRtkksbvSCo4cQxxoPet2IsnwF+wfBd40
4Rc6S50rtgJQOqhDt6ibcU5IpFYRcYvthGwNUg28kvpwYwk5n2BqRK4nM5mPv4u4
dxzXStSKJn0+SmGWzCa56rjYdpUu/HAMglzdRCzzwVpIdXp4RPdjSatyP8NeDwj0
/AYGFcu84IzQgvv7bgZv0f5ERyLwlHRmTqHYyk8SKy5Gs278DcqcrpMZmTf51wit
UiN9Lfgm7pR2WyGOfVuD2ShQJgKfz8jZHSYWa5Nay5xF/cA7Md1pUXwLDvyA0dXI
UB8mTExY8dvas9vP4ABkTE8T9DIbJv3RPGx4kVzWKNRli0/I+9BwpHJ81Vudx97A
uIQJhiJDE2MoXZmC9oMf
=pr/j
-----END PGP SIGNATURE-----

--hUH5gZbnpyIv7Mn4--
