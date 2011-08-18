Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab1HRLZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:25:01 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:34172 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755547Ab1HRLZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:25:00 -0400
Date: Thu, 18 Aug 2011 14:24:55 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
Cc: Anand Gadiyar <gadiyar@ti.com>, "Balbi, Felipe" <balbi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] mfd: omap-usb-host: Make TLL mode work again
Message-ID: <20110818112454.GS14514@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1313664271-694-1-git-send-email-gadiyar@ti.com>
 <CAP05o4J01FpphHgV5tpkFGNfTBbjhtScKjWZm4iLi3H1V=EKDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aJ74fq0Y6SrIeKCM"
Content-Disposition: inline
In-Reply-To: <CAP05o4J01FpphHgV5tpkFGNfTBbjhtScKjWZm4iLi3H1V=EKDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aJ74fq0Y6SrIeKCM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Thu, Aug 18, 2011 at 04:52:22PM +0530, Munegowda, Keshava wrote:
> On Thu, Aug 18, 2011 at 4:14 PM, Anand Gadiyar <gadiyar@ti.com> wrote:
> > This code section seems to have been accidentally copy pasted.
> > It causes incorrect bits to be set up in the TLL_CHANNEL_CONF
> > register and prevents the TLL mode from working correctly.
> >
> > Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> > Cc: Keshava Munegowda <keshava_mgowda@ti.com>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>

Sam, you can apply this one:

Acked-by: Felipe Balbi <balbi@ti.com>

But I think it needs to be resent with Cc: stable@kernel.org

--=20
balbi

--aJ74fq0Y6SrIeKCM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTPaGAAoJEAv8Txj19kN1H5IH/29np6/oaaZubpUlIDELes7c
+N67DbhJQwYcxVi1IBGYDGAITSM0u5szMYbrl34j9dDmw4edZgdkO/yyvGa6bAXF
Jfun8ENUk0uhZ6rN93pWWSox/vma+2u1HMdRPIFrUvyefJtUPcjSOglND4+aRndS
fpsGLtu7MK27CjWNFu5Yv+69OS4LJT0jqpDnsq2uH3xP8VVO9JMeOba+laDQYM6/
M/aftBVfCeXI88L08QWnMGc9VUiCixXR/ruGSy46V0N4JvyhuSjPfwpR4+UZuFkb
Nz7GY96cSovQiKn/jTevou9zVzwhTde61buYGP3rm1u1LfRmcNFkaPOb9e3qPf4=
=t1HC
-----END PGP SIGNATURE-----

--aJ74fq0Y6SrIeKCM--
