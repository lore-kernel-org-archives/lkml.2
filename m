Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab2JaNfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:35:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60487 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab2JaNfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:35:51 -0400
Date: Wed, 31 Oct 2012 15:29:51 +0200
From: Felipe Balbi <balbi@ti.com>
To: Virupax SADASHIVPETIMATH <virupax.sadashivpetimath@stericsson.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Rajaram REGUPATHY <ragupathy.rajaram@stericsson.com>,
        Praveena NADAHALLY <praveen.nadahally@stericsson.com>,
        Shuai WEN <shuai.wen@stericsson.com>
Subject: Re: [PATCH] usb:musb: Dequeue urbs on device unplug
Message-ID: <20121031132951.GR10998@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1349843763-24716-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
 <20121015121836.GN24333@arwen.pp.htv.fi>
 <A3217089E06965468FCEC60ADC3A8F925CBF1878ED@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IpljlC28XhFjURzf"
Content-Disposition: inline
In-Reply-To: <A3217089E06965468FCEC60ADC3A8F925CBF1878ED@EXDCVYMBSTM006.EQ1STM.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IpljlC28XhFjURzf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Mon, Oct 22, 2012 at 06:51:39AM +0200, Virupax SADASHIVPETIMATH wrote:
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Monday, October 15, 2012 5:49 PM
> > To: Virupax SADASHIVPETIMATH
> > Cc: balbi@ti.com; stern@rowland.harvard.edu; linux-usb@vger.kernel.org;
> > linux-kernel@vger.kernel.org; linus.walleij@linaro.org; Rajaram REGUPAT=
HY;
> > Praveena NADAHALLY
> > Subject: Re: [PATCH] usb:musb: Dequeue urbs on device unplug
> >=20
> > Hi,
> >=20
> > On Wed, Oct 10, 2012 at 10:06:03AM +0530, Virupax Sadashivpetimath wrot=
e:
> > > Flush queued urbs on receiving device disconnect interrupt. This is
> > > required for successful disconnect and successive enumeration of the
> > > device.
> > >
> > > In a failure case khubd hangs on usb-storage thread for completion.
> > > Seen in the below trace.
> > >
> > > [ 1355.764526] SysRq : Show Blocked State
> > > [ 1355.768341]   task                PC stack   pid father
> > > [ 1355.773620] khubd           D c06a1fbc     0   503      2 0x000000=
00
> > > [ 1355.780151] [<c06a1fbc>] (__schedule+0x3f0/0x8ec) from [<c06a26a0>]
> > > (schedule+0x58/0x70) [ 1355.788330] [<c06a26a0>] (schedule+0x58/0x70)
> > > from [<c06a2af8>] (schedule_timeout+0x1d8/0x31c) [ 1355.796997]
> > > [<c06a2af8>] (schedule_timeout+0x1d8/0x31c) from [<c06a1994>]
> > > (wait_for_common+0xd8/0x180) [ 1355.806396] [<c06a1994>]
> > > (wait_for_common+0xd8/0x180) from [<c06a1b14>]
> > > (wait_for_completion+0x20/0x24) [ 1355.815887] [<c06a1b14>]
> > I would like to get some Tested-bys here.
>=20
> Can you please add=20
>=20
> Tested-by: <shuai.wen@stericsson.com>

as soon as you reply telling me how you tested. Which kind of testcases
did you run ?

thanks

--=20
balbi

--IpljlC28XhFjURzf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkSfPAAoJEIaOsuA1yqREih0P/iEGB1Ofb9ze0CrfPJuTHf7E
xA88qDxv7WLI59qS8kJy/QTRXGB7O36pLMDomt/FzcUJTDSuK87ZLfLzP5tc+X6T
svW21pXe7ONNQs1qWnx8BQFI5VA0hqfYYV3Yo4KJr1nMHJo5gyj20V5vzAUcmC8J
MBwJURhCC7oR50HTbc7rVeK1WN5Ul1LOuG4AY+QUVgKYaOIW5cvY91/VnAU27mO1
Zdip/8nLAGjveuuK5OQnoxk38feDFYibuIeMQ8bqaERUk3hQHlXQrWRT4ivMj2p2
vP6De0keja2rps3MGPd6CN9ef8G0P6lpbxVA3KkqZb0D5hDbGaYTYHti5fEfRIPF
IHsEMFnOGpBjpqyYatCdERfZvyNIDgISp6vnXwhjUyVB6Okd0QlCt4XxUo6sxlzh
ENKF0f12L+W8L7dWnG+DaJMaJZejRa1MRUG94J1OWuLJ5sdAhjhsBcD2XAgdiQgz
n4V3dwx0CtfGDZqyWqwKyDF3aEKf4NjsqOsk974/ZJQrSu5ePkxjydoJPeMdk276
bMIwq0NRxOMWQg/A1RfGlQlDEuvq6mG7Lg/PMfQYbleSzZHQfAjhFEjt81vSwwkh
g8OYZdIiFtLZ6suo8Us1nJFmbgRrBAFIUYK0rjpswzOWLsYifzlcHcYu45xdTxLL
u9/aD5p1Xh2cehvzOWqC
=UHsH
-----END PGP SIGNATURE-----

--IpljlC28XhFjURzf--
