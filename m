Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab2GCOV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:21:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53315 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023Ab2GCOVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:21:25 -0400
Date: Tue, 3 Jul 2012 15:21:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
Message-ID: <20120703142123.GQ29030@opensource.wolfsonmicro.com>
References: <1341316788-12730-1-git-send-email-lee.jones@linaro.org>
 <20120703123552.GC25995@sirena.org.uk>
 <4FF2EEA1.6080204@linaro.org>
 <20120703132447.GN29030@opensource.wolfsonmicro.com>
 <4FF2F82D.9080507@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1MCZUn4MZNv/LeVo"
Content-Disposition: inline
In-Reply-To: <4FF2F82D.9080507@linaro.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1MCZUn4MZNv/LeVo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 03, 2012 at 02:48:29PM +0100, Lee Jones wrote:
> On 03/07/12 14:24, Mark Brown wrote:

> >I'm really unconvinced that instnatiating the MFD cells from device tree
> >is in general a good idea.

> Well it just doesn't work the other way.

In what way does it not work?

> >>See c5395e7ed8f16cc7bb72a783de68659db5aed515 for a short description
> >>of the troubles we faced.

> >$ git show c5395e7ed8f16cc7bb72a783de68659db5aed515
> >fatal: bad object c5395e7ed8f16cc7bb72a783de68659db5aed515

> Sorry, looks live I've rebased since.

> 5f3fc8adeec9bb12742fbfa777fa1947deda21a2

This doesn't explain any of the issues, it just says that they exist.
My best guess would be that at least some of the issue is due to
instantiating the MFD cells from the device tree but it's hard to say
clearly.

--1MCZUn4MZNv/LeVo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8v/bAAoJEBus8iNuMP3d7XMP/i/KZQoSeuTt6dl25pnDYAbq
oLymsqKhOZNMuTr7mpXhFfqCAOSyHgSaPFRmpvC7rSXi1KmvU24qBfQu1IxLJHB8
TfbBXBzwWaERJEOoXseUsoNzBX/uRnE9QNwV/8U59KpH0Ii0ir+zd69d6Fji3gX5
8pOr1Z9cvm+SyukOakqdrfNHxdmX46WThRQ1FHdJoR/JFQo9O3gaM662rkQMCOUq
mVCSzzNzJ/vYaVBIM2Bore3giM9C+d+H8I7KEZvyBPqMxrTFvgkrL+Fu/lkvvCap
1vhoP0GBhwDqyT97uvAWtEh0h68d4BWo4f0jk3GatboQzw/+/qNYSeePtdh9VsZ4
/WqeNDKNjhhQNKRQP3ZE/oEbW9RUokXEl+taK7okxwpHv9bs6CXTEQjNi2i/EaTe
o/XwT4QglpI40Npt64y+Frb2OGK+99PX0vsJjE6Welvmm2+Cf0rD/+1sqBrFAIwR
7ROEH706NZEg3JVDd7paSAJTPrsWpfzJcd3CR3jiA7oCtjsZy9a7MaP8bF0ZS5Po
fmbHiUADN8UTDQ3tn/4K6a5I2d3MG7Btp0KBTd61Yoe75PxEfUF9QnBmTmS4tVv1
SXMUYkHynDHgFGelMjkqpjbm5sDhZVAa7aVTwUP1HX/cWit29pERmdA10yN6gPGc
JZI5SHPESAtRT9Lu/+iI
=LFka
-----END PGP SIGNATURE-----

--1MCZUn4MZNv/LeVo--
