Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab2DSMph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:45:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59714 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632Ab2DSMpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:45:36 -0400
Date: Thu, 19 Apr 2012 13:45:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>, "Jett.Zhou" <jtzhou@marvell.com>
Subject: Re: [PATCH] regulator: 88pm8607: Fix writting value to vol_reg in
 pm8607_set_voltage_sel
Message-ID: <20120419124533.GF3046@opensource.wolfsonmicro.com>
References: <1334805358.22839.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eDB11BtaWSyaBkpc"
Content-Disposition: inline
In-Reply-To: <1334805358.22839.2.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eDB11BtaWSyaBkpc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 19, 2012 at 11:15:58AM +0800, Axel Lin wrote:
> commit 4ca1e1d "regulator: Convert 88pm8607 to set_voltage_sel" accidentally
> changed the value writing to vol_reg.
> What we want is to write val instead of selector to vol_reg.

Applied, thanks.

--eDB11BtaWSyaBkpc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPkAjnAAoJEBus8iNuMP3d6xUP/jhhky8uX4BmniSTIDn/fh3t
0uN4A8QFIJA9itOx+4WWWIFtwNrAZlAugRveX2vEVPKufQoQeh2raHfxx0LWvToe
7cXm58QDk8rTsJPJUAxiDLm/hbH59xsRn2qvWieTMqs3n2MJIpeYtik/1WuQKZMw
U5EnWhmCk7QPHGUmO9p2d8dXdMLYa0XWesyGHx1trY3Ot1cFvfjnCBGq5Zu3q3HO
yEuzfF2gkXydsImchhqGixqgymbNn7u8fIB6/XH2C/fcrsgsOenSX4OjmdY22HMX
l5WeWrblNpbeNx1UCaF6e95egKbFK/obVC4gC+HPdwGyzA7kdkFBr9yUSfXJLgyb
dMeR8VBfdzQ7x5GFXdLAxO3ytBDuey4d+FQU411hlDLpgwQ5ApRr8EAgi/bMUytR
k4B/El7sBAwywWC87+nyfa/ef4ubw+SukEIzueVJX2JxB+Iajv3utqLlR9+mDojO
ryPxAZqHMgFmNSGPkuoy08Cj38hBPb8kn1zxxHgmkAFsTCk/jQ6h9znAoonhOShc
5ZmRlj0GMIf/lVzDZu6KruS75B0D89G4f+4lRDWMd3gfo2EG16y+U2dwPo+RNLFJ
rILItan5m6LW7TV1L3HMK6nIz1D5uISIeV9z/8GsjAvPa8wpWXOmR0l5sVSKz2lt
14JUf1Ds0JkojZPpsj+j
=hfkA
-----END PGP SIGNATURE-----

--eDB11BtaWSyaBkpc--
