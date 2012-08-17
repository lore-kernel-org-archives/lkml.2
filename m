Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030993Ab2HQK42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:56:28 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:58766 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964874Ab2HQK4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:56:25 -0400
Date: Fri, 17 Aug 2012 13:52:33 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Roland Stigge <stigge@antcom.de>, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, aletes.xgr@gmail.com, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH] usb: gadget: lpc32xx_udc: Port to new start/stop
 interface
Message-ID: <20120817105232.GF4651@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345131276-28982-1-git-send-email-stigge@antcom.de>
 <502D1A49.20603@linutronix.de>
 <502D1CC2.9020901@antcom.de>
 <502E0A7B.1040607@antcom.de>
 <502E11F7.4080300@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JcvBIhDvR6w3jUPA"
Content-Disposition: inline
In-Reply-To: <502E11F7.4080300@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JcvBIhDvR6w3jUPA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 17, 2012 at 11:42:15AM +0200, Sebastian Andrzej Siewior wrote:
> On 08/17/2012 11:10 AM, Roland Stigge wrote:
> >Also, since this device is a single controller in the LPC32xx SoC, I
> >would keep it until some other silicon uses several of this IP core
> >(which I doubt), at which point we would probably still keep the (global
> >static) controller and memcpy it to a dynamically allocated struct.
> >
> >Sounds reasonable?
>=20
> Yes it does.
>=20
> Some minor things:
> - please use to_udc() in start then
> - would it make sense to use platform_get_drvdata() in
>   lpc32xx_udc_shutdown() ?
> - could you please remove struct usb_endpoint_descriptor from struct
>   lpc32xx_ep? It has been removed a while back from other drivers.
>=20
> Your proc_udc_show() makes me sad. Felipe, didn't we want something
> like this in udc-core?

Yes we do, though not a single file with a bunch of values. We want one
value per file as it should be.

--=20
balbi

--JcvBIhDvR6w3jUPA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQLiJvAAoJEIaOsuA1yqREZ0wP/A4WEIBXF4dbr9sGFCxqIa3Z
Q4PAF6tfqtmraJwkzg08kx83szyKTFKaFwTfNY59/ZTwxrBg0GgY2R1UO/DDvmuJ
cutnUO3e3kbhaPtLOWJQRkXN6DvkK8gL91b/RxFCPTOW+NwWDKFJEXJt91ROz6Cz
QEgzwxFE1JPEN1/v8GtgspaPwF8/cBHF9iG4YJW6tcJChtEVsxN8sIfXVsdAPZNK
DcSQSQ2L8etjkPPPUyu7KNduZdin7CTB1N98aB7XAdfNXe/aFdAx7qpQdM0/NXWN
Valpn1CFiQ5836Dmp8bniX2w5nZ7e0k48j7QmfkBo5Pv48Xx2m3NKVeaYelIzgGF
bHiqXkeKCJ4ZsWMm0muVW5RiOJb8ctkeGuEgO0qbcx6hlUKbagMs6RxtN+A1TLhC
crP+T1uQHco3xiYwsHQ9TATW3yI+9p7zBZxml+qIdQdarEBpHVRtn07wrHwJdXdP
p2qYyTrOQtI6dmiX/gXYzhaoV/0C5LvTROdGTxlfCfK25wPFyQzcSOB1/IhYatNf
2C1sA/2M2xc9HSPgaEzJao5wBfe5ywojB4QYytnLJ/nS9SwjRpfTeuScX7JUt5jM
o9WD3XFmgEE/DAZkJsqdrKFURh6YfmDncgCc4f/8Crns2VxvUJqSuCclVCf3/Nq/
eW3BHkB70xiiVNp8RGuY
=DifK
-----END PGP SIGNATURE-----

--JcvBIhDvR6w3jUPA--
