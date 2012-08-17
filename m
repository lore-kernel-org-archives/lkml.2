Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab2HQLGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 07:06:51 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:38943 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755269Ab2HQLGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 07:06:49 -0400
Date: Fri, 17 Aug 2012 14:02:57 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: balbi@ti.com, Roland Stigge <stigge@antcom.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, aletes.xgr@gmail.com, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop
 interface
Message-ID: <20120817110256.GG4651@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345131276-28982-1-git-send-email-stigge@antcom.de>
 <502D1A49.20603@linutronix.de>
 <502D1CC2.9020901@antcom.de>
 <502E0A7B.1040607@antcom.de>
 <20120817105103.GE4651@arwen.pp.htv.fi>
 <502E2498.4090106@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pE2VAHO2njSJCslu"
Content-Disposition: inline
In-Reply-To: <502E2498.4090106@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pE2VAHO2njSJCslu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 17, 2012 at 01:01:44PM +0200, Sebastian Andrzej Siewior wrote:
> On 08/17/2012 12:51 PM, Felipe Balbi wrote:
> >>Sounds reasonable?
> >
> >no it doesn't. Please remove that static global. Sorry but one of the
> >goals with udc_start/udc_stop was really to get rid of all those
> >nonsensical static globals.
>=20
> I wouldn't insist on it. If you look at pxa25x, " static struct
> pxa25x_udc memory =3D {" they do the same thing. It is only a simple way
> to onetime initialize variables.

fair enough. Though that's wrong too and should be changed. The whole
idea of allowing multiple UDCs on the same kernel image is mostly to aid
development. Specially on pre-silicon phase. We could have a bunch of
PCIe FPGA boards and instantiate a different controller on each one and
have the same kernel work with them all.

--=20
balbi

--pE2VAHO2njSJCslu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQLiTgAAoJEIaOsuA1yqRE3koQAJwPnJ2mV2vjVKLi/hNUFFoR
zqKyCaoMNP17d5WVEspv807uuT0c75l5wSxpw7eUisQQOHyXooxi6doWfjXb7qkY
r28JH7Q0QZk5+rcUQ/nLhM5teSJ0d83ZRl35SKkesl+fE77lh4yr0eazOHac31K/
GuaiD7PsxWvOYYvRGKkCY6ryjO1IlVbAQXAsRMKvknRM0c9/newlE1Z3u/Gkm+3f
DGAxJuPtJGZh06vmSkEC4u9V+D9gyWfRo8MqYDpyDRo4dA05R36OwozImYybOkVH
dWpVOmUIDP1AZsi2PXufsPjHKm1Eq/1vcV2G465zIZZNNgjWVDC3VgqHAudBFFoA
uVTDZb2VbO109ZIvdTSL3LRNYxA6vLauXI5HWwZaSIAlSw2JORuQ7zgpyUl8PkvX
vOyDPW0IbFL+xEoInQFVEbILLVnWwIAJhGx/wHtuODDkeoDYii3lF2J76pzxUNRv
cdi0m9N9kaVDHwdff/YEbk0UhJeuvWwTSj11Ebm9ibQ6Uyl88hsyv0r/SUGNyY3V
eN20vv1ITwRsfLilTmziWa5opuSRi2HflN0E1bnq49sQctA0GAqcTokJiZJ0aZLs
w51Qfr3Xe81H3bkLNTxtyyqd45zUCP0t5V3x67bblS721uueG5rMpuAFJs39ArbP
MmK1ljgaHoV+izEp2YWU
=kB1R
-----END PGP SIGNATURE-----

--pE2VAHO2njSJCslu--
