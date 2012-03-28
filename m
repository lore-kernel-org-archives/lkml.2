Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab2C1KKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:10:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51172 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943Ab2C1KKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:10:24 -0400
Date: Wed, 28 Mar 2012 11:09:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: rnayak@ti.com, lrg@ti.com, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: Regulator supplies when using Device Tree
Message-ID: <20120328100957.GD3232@opensource.wolfsonmicro.com>
References: <4F6BCF47.4090200@codeaurora.org>
 <20120326130005.GQ3098@opensource.wolfsonmicro.com>
 <4F726B96.8070508@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Content-Disposition: inline
In-Reply-To: <4F726B96.8070508@codeaurora.org>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 27, 2012 at 06:38:30PM -0700, Michael Bohan wrote:
> On 3/26/2012 6:00 AM, Mark Brown wrote:

> >Supplies are *always* specified using the name from the part data sheet,
> >anything to do with regulator-regulator supplies is a Linux
> >implementation detail.

> So before filling out the supply_name when calling
> regulator_register(), does that mean we should expect regulator
> drivers that optionally support supplies to always check with
> of_get_property()? And which name should we check? It sounds like

I have no idea what this means, sorry.

> the answer is that we should invent another binding to portray the
> name of the supply the driver should be checking against. But then
> it would seem silly to have two bindings that pertain to supply
> names.

Absolutely not, that would be broken.  The whole point here is that
supplies of all kinds are always requested with the name the chip uses
for the supply.

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcuNnAAoJEBus8iNuMP3dHvYP/03VbvgOeXh4vy/IP3K73hQJ
G7NtO35T1Ez3GHIyWZiSt9J65ibGMa2CZKA/080wyEI/FRgUBXRNhdW06cycV4T2
BJSjzBymBEuHKLYxUFIAPqW2BDf84QXVKScllfZh4pIglkJzRMKYXLmQ9Hw+Ke2a
eLMsblp7mQpyOKT3QIWRUGW/IypZua/CnzVEDACknvH/5UXC6ls+wro2QFCczhlc
aA1Xhe10KwyixYdV26joOgogvrwglO4lGbUp0FjvjKrfPy4BZj81gaU7v/zv8MKw
lJ6qvSny4iusoqX7adyiLlwIRuqI4gIQuZaVqCWIL0h9ne3ldBBZ4Q+u7PAozTmr
I9LUuNFuiaixRs/FxMi+WGYzOeGT6BTArFrrvTU7gvTDPCm+9X5y0rN85A4JSqla
CU+ckTD/suJOm8elZ4yjyFiGko+wMFYhgHxf6EGsFjFn4s4XaPp3ss+SWqv9V3Nf
8bs3railipHYNiQaLGnp4DlNEKHz1+GmrUPWKKtAuoU11MoQmsKcCpecCODYxYeV
lv5waZidi5CtKzbdmyqSmOQh2bnrYBkjVqXG9PPL/0e9SG74xAodt105pOXNxdZ/
FZdtVYkxz7dSqtkefEUzu9Aq/FWFXtwfwt1+K2+RfOqWRccTnstwf5YvxRysEVf2
FpYZco5+HGWS4IDc39QF
=+/hv
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
