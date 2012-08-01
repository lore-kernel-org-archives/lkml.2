Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab2HAOB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:01:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55580 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2HAOB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:01:27 -0400
Date: Wed, 1 Aug 2012 16:01:21 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alex Courbot <acourbot@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
Message-ID: <20120801140121.GB19957@avionic-0098.adnet.avionic-design.de>
References: <20120731105640.GD16155@avionic-0098.adnet.avionic-design.de>
 <20120731141328.GS4468@opensource.wolfsonmicro.com>
 <20120731142216.GA19591@avionic-0098.adnet.avionic-design.de>
 <20120731142607.GV4468@opensource.wolfsonmicro.com>
 <20120731143235.GA21126@avionic-0098.adnet.avionic-design.de>
 <20120731153941.GF4468@opensource.wolfsonmicro.com>
 <20120801074113.GF29673@avionic-0098.adnet.avionic-design.de>
 <20120801132651.GU11892@opensource.wolfsonmicro.com>
 <20120801133814.GA19771@avionic-0098.adnet.avionic-design.de>
 <20120801135531.GW11892@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <20120801135531.GW11892@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:JTD4ESdW+5PZ3wN/nCvph9YE85LHpXOMf7t5C/cL0GF
 XHbA+jT58piMBpmfwDrVu1dqe7ZXDh2qUK/Xtb9eX5I0FQvX1K
 4U8lLi/bYng1XHl4hnPvFqcjCYtN7jUYkMk3lLr/U/JRIa0adF
 sfLA+/oRmwtjL2WXxyh/oZmQfTnoDkDA9wwYxMz/JYhb28ujXI
 aaBNH1Z58/geYE5ABamxzsjI93XlodzBu6XYeLsP6WUAxuBNHm
 0jUI7LVQLnwL5WqsOSECpDaUT053zrFnjmkXzd/rrk/4HdSBTO
 yQ4FsIseYK5Ww/gFgT1b5gF1KW43+4QhcVfM0kcc537qDZHj6+
 ieVvCB3ywXlJGHxOl2NRziXl2sFpzo+xovWFyUXhYvqREPXOC+
 u4gm5ok2NKMMA9ORIZy3WR35+PkW+NG+t8xS9H70PGQ62TbfC8
 99nFk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 01, 2012 at 02:55:31PM +0100, Mark Brown wrote:
> On Wed, Aug 01, 2012 at 03:38:14PM +0200, Thierry Reding wrote:
> > On Wed, Aug 01, 2012 at 02:26:51PM +0100, Mark Brown wrote:
>=20
> > > This is why __devinit data will only be discarded when this is not
> > > possible.
>=20
> > That's exactly my point. But I seem to have miserably failed to get that
> > across. =3D)
>=20
> We must be talking at cross purposes then.  What I'm saying is that the
> framework shouldn't rely on platform data and should assume that the
> kernel might be configured so it can be discarded (by copying most
> likely).

Yes. I think this should be solved by the power_seq_build() function
which uses the platform data description of the sequence and builds it
into something for internal use that doesn't rely on anything in the
platform data.

Thierry

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQGTaxAAoJEN0jrNd/PrOhLqEP/05y+bxKQvC1868DzGqLgol/
2SXAJyQp3CZrc3QNcOB8gxa8cocnTlwIpAmDN8tyBnNYH8YJTcGTI4N2xEQDsTMh
7mhCUdbONE0DwprM29vIzcWKHcUNz/chZMAhdFTugcVgIx0+FUOF9LeYcvlkl67a
ilYszPoMlVldvkLHy/A0/SCYjNJNAs2elHGWYlEmqsxFe8PxpMBpT2/eD/2VMZs3
JunOJsCyW+DNmS+uJBnuqzU9Kvkb8hOkO3dE+/4/2b08f+D8O82ekkQHB9XkWV2j
auqtMDf9yFSo/W1pyAHcHY9Fmz0x0GEGK85Ea3PL12BZOPkI0oAvJBCIRSXb1jBG
LC8VZmbV6UViS7qO5msB4CMY/kp6mtIhtdKWKrm9CyfDzZXvNqBHqhAU4LRxahk9
aqEYmJUDSAKudOq51TisaiHQoicOMNxnMwXD/KLwGUV+Xo/niNOttX2kiSP888Q7
NP0fcwCEc67EIchfBlxsN1PCr5sM8N6rTDjaB+VKfJhgqKsthr0o8/Hxar09UFzS
bbSIjxknnJVDWKIz/qU3DwnTRzpVx+7d+Si45ghfbzCGuuNdP/sw3MhLrFogkmwf
Lqc3J93uNpPy7zdDK8nFtOFu1Hr3PGDgMq8cAXH49OM8bJCHUvApyehdgTzdEHiL
b/DdJl+5uojR3XkIGElt
=Qr+A
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
