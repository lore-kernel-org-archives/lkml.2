Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab2AMUMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 15:12:15 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:40283 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932781Ab2AMUMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 15:12:14 -0500
Date: Fri, 13 Jan 2012 22:12:07 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: usb: musb: Adding CPPI4.1 DMA driver under drivers/dma
Message-ID: <20120113201205.GK3133@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <201201120753.00667.oneukum@suse.de>
 <Pine.LNX.4.44L0.1201121037340.1384-100000@iolanthe.rowland.org>
 <20120112215014.GC5735@xanatos>
 <20120112215459.GA1161@kroah.com>
 <20120112222947.GD5735@xanatos>
 <20120112223513.GA2925@kroah.com>
 <20120113061144.GA30569@suse.cz>
 <47CEF8C4B26E8C44B22B028A650E0EA9317A6B8B@DBDE01.ent.ti.com>
 <20120113180932.GB29700@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o+ZCuNqY+dEAKBWl"
Content-Disposition: inline
In-Reply-To: <20120113180932.GB29700@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o+ZCuNqY+dEAKBWl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 13, 2012 at 10:09:32AM -0800, Greg KH wrote:
> On Fri, Jan 13, 2012 at 10:40:50AM +0000, Gupta, Ajay Kumar wrote:
> > Hi,
> >=20
> > CPPI4.1 (Communication Port Programming Interface) is a TI specific DMA
> > controller used in multiple TI platform such as AM33x, DA8x, AM35x, TI8=
1x.
> > The DMA engine is mainly used by musb controller on above platform.
> >=20
> > Earlier version of the driver was submitted by Sergei Shtylyov at [1] b=
ut
> > was not merged due to disagreement on the location of driver in kernel.
> > Refer the discussions at [1] for more details.
> >=20
> > [1] http://marc.info/?l=3Dlinux-usb&m=3D125087318308323
> >=20
> > The new implementation of the CPPI4.1 DMA slave driver will be in the
> > drivers/dma folder, complying to dmaengine framework.
> > It would involve changes in existing musb driver also for which current
> > plan is to maintain the compatibility of non-CPPI4.1 DMA in musb driver=
=2E=20
> >=20
> > The task is planned to be spitted into below subtasks.
> >=20
> > (1) Post RFC on the API details, changes envisaged in musb driver and o=
ther
> > challenges
> >=20
> > (2) Implement and post RFC for the CPPI4.1 DMA driver and changes neede=
d in
> > musb driver.
> >=20
> > Let me know if you have any thoughts/comments on this.
>=20
> First off, don't highjack threads (you responded to a linux-usb thread
> here, get a better email client please.)
>=20
> Second, that sounds fine, please post patches.

I'm with Greg here, please post patches.

What I suggest is:

- first create a dma-engine.c file on drivers/usb/musb which will simply
  translate dmaengine into the MUSB-specific API.
  	this will allow us to slowly convert other platforms without
	breaking the legacy stuff.

- Then move CPPI to drivers/dma

- Test it all out ;-)

--=20
balbi

--o+ZCuNqY+dEAKBWl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPEJAVAAoJEIaOsuA1yqREaT8P/iWtoGRmWUYAgePvDAWNihxw
EvR5TvjtHJZkxH9czB+wJELYDesZmvS6neM9rb1DROL2Hjaa4Ghg/vk1oB03kylZ
JtBW2w28/p7jRgcUuQglcvyilI4ura5dNtuxWPn7c/8OO7oGxMMmaA4WcA+gKxGK
nCUt6HexyTTQC6NhELwl16jZGe4ZV9wnKgl7C5TypvMVqrgdgkoCUjFOSwjFDN+f
K6fCZ1+IxPU+iqd5lEfHUyOU8fiV3W5/SRDRfkYgryyiMUcYyg6oXMk1mP/7/Ae5
qP8nAwA2h3qMY/wtFFnBNq4s5HDzAsKmM6dpzPPJs0OB9AsNVCAHREVdJnJQwBQp
pvEPoRVWN8HxCLAv04gwTlCMu3fb6MUkvm84KcMOo+bEQojLwv730oB8vua+Kn0J
65g+7Gv80hxGZ1+WsXstO/cvQ3oV32SQWbrjKjCL2NOFVxm8vXpoDRs4XAl21iCx
AwY3Y1aK+ut/4gG4DcN4eKU3Xv56w2Rl899q7Vg+nwt04tLD3nYRAytxh5ptqSoF
dvac8d7P86PaNaiCD1Wz6wvjIS8SZlpysN/0U32UYvWz2h3E1IOxYUsIHQRXKKkf
vCEO7bm50spLnWUd+AdXaYDEAIQ8hegdN1lm6a3etBBE8imP2MNzzx/4Kce7ruAC
UINkz3afCJmHWJEr4+OT
=J/ws
-----END PGP SIGNATURE-----

--o+ZCuNqY+dEAKBWl--
