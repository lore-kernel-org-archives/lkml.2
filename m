Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab1EWLNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:13:40 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:39792 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939Ab1EWLNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:13:39 -0400
Date: Mon, 23 May 2011 14:13:32 +0300
From: Felipe Balbi <balbi@ti.com>
To: Liam Girdwood <lrg@ti.com>
Cc: "Balbi, Felipe" <balbi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux@slimlogic.co.uk" <linux@slimlogic.co.uk>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>
Subject: Re: [PATCH v4 2/2] USB: TWL6025 allow different regulator name
Message-ID: <20110523111326.GD5663@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1306095684-7732-1-git-send-email-gg@slimlogic.co.uk>
 <1306095684-7732-3-git-send-email-gg@slimlogic.co.uk>
 <20110522225103.GB15882@opensource.wolfsonmicro.com>
 <4DDA2FC3.20009@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
Content-Disposition: inline
In-Reply-To: <4DDA2FC3.20009@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 23, 2011 at 10:58:27AM +0100, Liam Girdwood wrote:
> On 22/05/11 23:51, Mark Brown wrote:
> > On Sun, May 22, 2011 at 09:21:24PM +0100, Graeme Gregory wrote:
> >> The twl6025 uses a different regulator for USB than the 6030 so select
> >> the correct regulator name depending on the subclass of device.
> >=20
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>=20
> Acked-by: Liam Girdwood <lrg@ti.com>

Maybe it's better for you to carry this one Liam. I'm done taking
patches for this merge window and this is related to the same series
adding support to twl6025. Either that or this will be pending until
2.6.41 merge window.

--=20
balbi

--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN2kFVAAoJEAv8Txj19kN1vQgH/AtlhAZPY5tpxj7+6NPoqxDy
JnfXkXdLABjZI39LQjzI8yIa1CfiFRwSV26wDHucsFUBgV2N1EWt2kEMDelHZg7z
rN1KL6YwNB5qRhMwKKHA7Fijf+ZkuB8YwUEUnvGH+agyYXn5eTuGT0x3vMN3vTbF
jhnTdrrqfpwqZ6jKrCFx1w8v6QU9MQmhXwMHgtQFb70HWac5xxXSNjNJWE+8UojX
gfG6TrSWPI9+UFRD0abaTmZEOV5DoCooYxhGOxSF3N3MCmCvdYiRXJsrHQAUpSL2
DwpPXlPtQ1EElQDXKrBRxBGV+5fElXR0lbLsJd/YSwho9m81ehLpqOwuYiosxIk=
=gEeo
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--
