Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2FNLuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:50:10 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:50062 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755814Ab2FNLuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:50:09 -0400
Date: Thu, 14 Jun 2012 14:48:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, ben-linux@fluff.org,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 06/17] i2c: omap: improve 1p153 errata handling
Message-ID: <20120614114804.GS13602@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1339669250-9183-1-git-send-email-balbi@ti.com>
 <1339669250-9183-7-git-send-email-balbi@ti.com>
 <20120614111746.GB31187@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pd495SECmvzXpBRb"
Content-Disposition: inline
In-Reply-To: <20120614111746.GB31187@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pd495SECmvzXpBRb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 14, 2012 at 12:17:46PM +0100, Russell King - ARM Linux wrote:
> On Thu, Jun 14, 2012 at 01:20:39PM +0300, Felipe Balbi wrote:
> > -static int errata_omap3_1p153(struct omap_i2c_dev *dev, u16 *stat, int=
 *err)
> > +static int errata_omap3_1p153(struct omap_i2c_dev *dev)
> >  {
> > -	unsigned long timeout =3D 10000;
> > +	unsigned long	timeout =3D 10000;
> > +	u16		stat;
>=20
> Eww, no, not more of this "lets add tabs to align auto variable
> declarations".  This is detrimental when you add another variable whose
> type is longer than the current indentation - you have to reformat the
> entire block.
>=20
> It's really not worth it.  Stick to just using one space, like the rest
> of the kernel code.  Like the code which Linus writes.  And thereby help
> to avoid future "pointless churn" whinges.

fair enough, no need to get so over the top like that, it's just a tab.
Will fix it.

--=20
balbi

--pd495SECmvzXpBRb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2c90AAoJEIaOsuA1yqREqWwP/1L/byV1tKu697GN5ppq9lZf
JmS7y2+HVmnuqMIIxSX2dZAyJb4Md0n3oJJQW5eUvSVhY3m/lm8lAjCWIWl6paib
r3SdqRWSN2sixurb8RSn7P2231bp/W/K5agwnlfQP/nz6fXM8zNPomz5OiQ4udUx
6pSv5gMq9JYoPxDCg1A7mAlHbBUlSB/LSO4P4e65fUodGEAoCcyPbssudHt7W5bA
sAb/yaZfPSSWIlm+hhKbbDkQbKVKY4Ga5C8hvWBxk3+aLwCCtlg1o+Frwj8t0Xos
aSdsnSv5kfjStDXSJM8vRU63QOe6xbZlECpRaFIfPqSfIfIZN6JunnXsZ+l8q7Hh
qN4l5yNMwsZG+ieaF1HlU5ApreDuD0KuR4thQuEYI/WZKpX1KE63pAzTazyrvEqS
vdb5cXCfhtnQC6I7rrBQaAJznJ04LY/qQsu2gU0QNZ4gCO+wfjSz6ntpofakqz+O
bSpv5jXQTY61V8ZpBjhB12N8PPOfWsvHa+XcZ9b7EXbigg+MvCdB28ofBIyl2YAl
BzhcSlzPg3W/pkzBLDPIpAEDnz7FxOIMqlxJoya+DCZpuIkZWjbHPKyRh79sL7Ny
Wxj2yIA4ibDL8m3UL6bSuTvEX2PLFIjFYsqJ5Vv7QLlwOMLUJ6126MmuvOHTAx4m
YcHOHkSLoLgSr6CC6syU
=xbuS
-----END PGP SIGNATURE-----

--pd495SECmvzXpBRb--
