Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418Ab2DLRxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:53:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58353 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932108Ab2DLRxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:53:17 -0400
Date: Thu, 12 Apr 2012 18:53:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120412175313.GB18049@opensource.wolfsonmicro.com>
References: <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk>
 <20120410151943.GM7499@opensource.wolfsonmicro.com>
 <20120410175632.5c11c36e@pyramind.ukuu.org.uk>
 <20120410175846.GQ7499@opensource.wolfsonmicro.com>
 <20120411112411.11825eec@pyramind.ukuu.org.uk>
 <20120411103827.GH3163@opensource.wolfsonmicro.com>
 <4F856173.8000901@cam.ac.uk>
 <20120411121309.4b8f8e40@pyramind.ukuu.org.uk>
 <4F8568A8.5060206@cam.ac.uk>
 <20120411133035.25fa00b0@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <20120411133035.25fa00b0@pyramind.ukuu.org.uk>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 11, 2012 at 01:30:35PM +0100, Alan Cox wrote:
> > needs to be abstracted as well.  Consumers might not care that the gain=
=20
> > just doubled because someone else requested it, but I suspect many of t=
hem will.

> At the bottom layer I'd expect a second consumer of the same data to get
> -EBUSY, but you are then going to tell me there are ADCs with one gain
> control for several channels no doubt 8)

There's also some sensible use cases like the multiple system monitoring
subsystems we've got wanting to monitor the same power rail where it's
useful to have multiple consumers sharing the ADC, though with those
ones changing the gain probably doesn't make much sense.

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhxZ8AAoJEBus8iNuMP3dEE0QAJHng7SxcE6isxbq2wQAMbWb
rw4PDNXNUPsAQFDuvyDZANTGO2nRuuSIR0+XAEDLv6+OMH2Q7jIKEkHu9zdvmILf
Z3VGvWokmDnZijkr/BdbZarMnpL49acbJCmKdI4RNhpimLLmJn41KYE6sjn2b07y
2fVCPXELa2mzn0N7HQ1xl8ou6jAjv5PUqdmXcbU6WEndQD+hvb8i+1cUmBe5V+U6
jcWmczuhg9T033Fh3EVtI6YiHuClIAgZI+xrwHJiou/wxz0VmCPrRPct27y0brKM
y531iaE+twF5H2Vv23PBw0BdyxU2ZX5Apk1OHjLvFUESjXPv143ZAvFN5suSFnYy
XkNpDnVgn/gpb8vFBFuUtt3Y4BgD3Z4emjyKu3R43qSGCO/iwwzjm6DBtagUpNfB
VUixqpC5YhvaYFq5bKoy0OGo8bX6cH9mHUyCw4Kyq0/SogZkKwG2l1RSx35LlSh/
ZzTzU9ZZxZ5nI/tO7QC8SusWhwpLD7Nbegr4xlrbCRdAFyn0XOeJug0erJ46bPIz
Gc9fe4HYcAIB5HO+sNmBdJk5nG8DrdJNAMBSwhAxGbWpH+5AlwI15RsbBD+DsCSa
AN5hMN1zTutYaVlqX7NP37EqlLltBuwX6C9gykkFmhTwX/T/MemgBprNPf30dg73
fs2uStMnz+BXn6Y3HprB
=44Pi
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
