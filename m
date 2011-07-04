Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab1GDN10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 09:27:26 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:36848 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044Ab1GDN1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 09:27:24 -0400
Date: Mon, 4 Jul 2011 16:27:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
Cc: "Balbi, Felipe" <balbi@ti.com>, "Girdwood, Liam" <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: [PATCH v6 08/18] mfd: twl6040: Add initial support
Message-ID: <20110704132714.GM2820@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
 <1308663556-29120-9-git-send-email-peter.ujfalusi@ti.com>
 <20110704125330.GI2820@legolas.emea.dhcp.ti.com>
 <4014234.U3Af1Vqyz9@barack>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R+Rs1qz93vBJxC1z"
Content-Disposition: inline
In-Reply-To: <4014234.U3Af1Vqyz9@barack>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R+Rs1qz93vBJxC1z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 04, 2011 at 04:09:30PM +0300, P=E9ter Ujfalusi wrote:
> Hi Felipe, Samuel,
>=20
> On Monday 04 July 2011 14:53:30 Balbi, Felipe wrote:
> > > +		ret =3D twl6040_request_irq(twl6040, TWL6040_IRQ_READY,
> > > +					  twl6040_naudint_handler, 0,
> > > +					  "twl6040_irq_ready", twl6040);
> >=20
> > why don't you use the normal request_threaded_irq() ?? This is a bit of
> > obfuscation IMO.
>=20
> I have left this 'macro' in since it is also used within the twl6040-vibr=
a,=20
> and twl6040 ASoC codec driver to request the irq for them.
> But if you think it is better to replace the twl6040_request_irq with dir=
ect=20
> request_threaded_irq in those drivers as well, I'll do that.

IMO, yes it's better. But you can do it on a separate patch, of course
;-)

--=20
balbi

--R+Rs1qz93vBJxC1z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOEb+yAAoJEAv8Txj19kN1RSoIAKGmPZyMvUUyiNwDbH9x85RQ
Bt9iYYe+epDCvgrURK3aNLsBB2Csnkp1Higdn4GBCpHxgAeylT90W/gaX+O+flCp
skJRQ3P3uBlzXE8NITzZFJsqjT7auwakrux9qrgpFfrt9ncLw/uzpX6gFmrDTl55
eZ3gAYw1tih7jRQnZ6sCd1heohxjZa1yFv9MdNt3VXEk36kbtSCGTbL5hNKwVwvJ
FA8sNlCHkfemfJCF4ahvZreuBDleVrd4fFUqj9uYVChubXb2lgwPeNCRXDtcY8XO
7eqnJclbVWRNb2gciLqQTQ+uedyZ6N8+vuRXv/Yj70RUi4WHK5K64t0FG6acSEE=
=SVrX
-----END PGP SIGNATURE-----

--R+Rs1qz93vBJxC1z--
