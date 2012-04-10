Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab2DJNdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:33:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54726 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856Ab2DJNdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:33:43 -0400
Date: Tue, 10 Apr 2012 14:33:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120410133339.GK7499@opensource.wolfsonmicro.com>
References: <20120410131930.28186.85370.stgit@bob.linux.org.uk>
 <20120410131206.GB31551@sirena.org.uk>
 <20120410142501.6045c6c0@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xsn3knLL3qrmRbVI"
Content-Disposition: inline
In-Reply-To: <20120410142501.6045c6c0@pyramind.ukuu.org.uk>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Xsn3knLL3qrmRbVI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 10, 2012 at 02:25:01PM +0100, Alan Cox wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > The decision seems fairly settled that general purpose ADCs like this

> It's far lower level than things like IIO. It provides very low level
> services to other drivers not to user space. You could in theory write an
> IIO driver to use the interface but at the moment all the consumers are
> low level hardware drivers and likely to remain so.

Right, but fundamentally it's just a general purpose ADC which looks
just the same as all the other SoC/PMIC ADCs.  Like I say the decision
for that hardware was to push it in via IIO.  If we don't do that we're
just going to be stuck with two subsystems doing very similar things.

--Xsn3knLL3qrmRbVI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhDarAAoJEBus8iNuMP3d/w8P/i4nFhJF+H9No5he6x6Q7lKk
hiQAUfQm1+bvkHESxs0YBMnuD7QQ3twX1n2LENV3rk26N6mxNRXR+Vy3qpzwNLA4
tV1Ni0x4qtUZDPDIsySdDwERMTN6Vp2cQTaEwhJAi2g0u3oqHiVLw+x4Z6S+w/Mb
zbMHdJj8ju1Y94yiSHkdSCE53cCsO+Z4z0ZaG0ponbpiggPbPrGIevN3xAgHsrm5
1hsVHFCvx7pCyyE30lO01Q1cqVYM2rF6ejnfFcl+3Lw5AdQrW1/vX/5oYjIV9cn0
utTXFaaA+iGFg7xVJQTGcTsr8ythacgBXLVBvX9YfQBWlDfkKfXccLyBl7Bn4wxw
MlB2SVvlJlXz66m9qGGHsQOJNxboaGnjOjXHyRgsI42wqh3Fsr/ILuS90PifTWtp
q2V0Ykqm8YCnfRe6Kltcz8WdPxLeog2BRw2eZqSeBT3LCkjWfjzqpuv1ipr0oqdY
s4DzELN7gveZ2Elmp5/jKV8jyk6qayjsvkz78FHX0rBRXBh+MdFwZDAPt/VzTpw+
Psyt6kDnvu+Tem85bhyAGEqe9gUBDmGZDDVkfX88Qjq/l5Bjw2r6AYiONiK+VXz+
cFipF/fZELNx9U7HFX0SKN+oI4MDWCv1avfcUgK8dO/efb7Hihr0neh7cp5rGAbl
fInJ5RgkIE6oQx/sUh1q
=74K+
-----END PGP SIGNATURE-----

--Xsn3knLL3qrmRbVI--
