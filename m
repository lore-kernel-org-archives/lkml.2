Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab2AXILZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 03:11:25 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:42177 "HELO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755010Ab2AXILX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 03:11:23 -0500
Date: Tue, 24 Jan 2012 10:11:19 +0200
From: Felipe Balbi <balbi@ti.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH] renesas; Silence uninitialized variable report in
 usbhsg_recip_run_handle()
Message-ID: <20120124081116.GF27414@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <alpine.LNX.2.00.1201162239110.16712@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RE3pQJLXZi4fr8Xo"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1201162239110.16712@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RE3pQJLXZi4fr8Xo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 16, 2012 at 10:42:10PM +0100, Jesper Juhl wrote:
> In drivers/usb/renesas_usbhs/mod_gadget.c::usbhsg_recip_run_handle()
> the Coverity Prevent checker currently flags a warning about possibly
> uninitialized use of 'ret' i usbhsg_recip_run_handle(). It does this
> since it assumes we take one of the non-default branches in the switch
> and then subsequently take the false branch in the 'if (func)' case
> below. This exact scenario will never happen, but Coverity can't see
> that for some reason. This patch initializes 'ret' to '0' when it is
> declared which should shut up this report and won't really hurt - so
> why not? At least then it's clear that 'ret' is always initialized..
>=20
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

applied, thanks

--=20
balbi

--RE3pQJLXZi4fr8Xo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPHmekAAoJEIaOsuA1yqREfnYP/3NbUAMYHDKfH0Yxp0+0o2do
fuYgHYGwK7pZ5v93UPWd1+0bvFRqzl5QiKiXBxOGf5llmV1fHIssgTpfKe0T4e3D
NqVJ6t4p4HVAlSokYt+zeNHwO2KHlSOYHEapTMEOoHS2LaQqGf3umRCY7OIx4WeH
Y3k+stqh2wSPf6TueeH1vvgv9jqF74SY0xvfc584HzeCX7DUwhYWwlAx/ctpUqj1
26iDGpEmz2UzhjCfjBahuWJhwmDMJnrBln27mi3pMtExKYbUOSmNgPQ0qzBv+7hp
uxEOwK4cSQ6Qf7yKjMdHzLDCCCk/lOcBessHjo0hIlRdUry22MVKgVoAUe7xhQ//
thiDm07yszqMTs7IHRUTe76hgf4kK2AeQXem+fdY2kknCtAIFlv/153GckYfcz8f
2lJ2eYEzA3gOk8lukN0HHkQkt4dD7sr/u2Osemk33c5ENq7GiF2B9kBKxnAFzS07
lu761QX2E3d0W7o9bnrZYeyjyyZ1IvHHxoyeUADLsCec0G68/5/Fq28jZHNEdGxa
gnSOaoOMSYQu4bhpU3SXvqpyCnWNLRmCUZE3uylxlCjL7cs//5V02LgQ3obJdg1d
MPGkVR2y8iu+nhGrh6Ija4/NY+l5jQ51WfqMAIbIIN6ewksLyE+9wS2y94ZsXeEw
XyymimInOKpbi7nE1IDf
=Apbe
-----END PGP SIGNATURE-----

--RE3pQJLXZi4fr8Xo--
