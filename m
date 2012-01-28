Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab2A1HXF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 02:23:05 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:17744 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2A1HXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 02:23:04 -0500
Date: Sat, 28 Jan 2012 10:24:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: devel@driverdev.osuosl.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: [PATCH 1/2] Staging; bcm/CmHost.c: Style cleanup
Message-ID: <20120128072417.GU3294@mwanda>
References: <alpine.LNX.2.00.1201242338500.27508@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1201242345140.27508@swampdragon.chaosbits.net>
 <20120125062658.GR3294@mwanda>
 <alpine.LNX.2.00.1201280037080.13952@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="niUlcCfh/sMBwTxc"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1201280037080.13952@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F23A24E.00AA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--niUlcCfh/sMBwTxc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 28, 2012 at 12:43:39AM +0100, Jesper Juhl wrote:
> On Wed, 25 Jan 2012, Dan Carpenter wrote:
>=20
> > This is probably going to need to be redone on top of the other bcm
> > cleanup patches anyway.
> >=20
> If that turns out to be so, well, so be it. I was not aware of other=20
> patches, so my bad...
>=20
> > On Tue, Jan 24, 2012 at 11:46:31PM +0100, Jesper Juhl wrote:
> > > +		pstClassifierEntry->ucDestPortRangeLength
> > > +			=3D psfCSType->cCPacketClassificationRule.u8ProtocolDestPortRange=
Length/4;
> >=20
> > Put the equals on the first line when you break something up like
> > this. Also the real fix here is to choose shorter and better names
> > than "cCPacketClassificationRule.u8ProtocolDestPortRangeLength".
> >=20
> > If you're breaking up a condition normally the && or || go on the
> > first line as well.
> > 	if (foo &&
> > 	    bar &&
> > 	    baz) { ...
> >=20
> > Although that's not in CodingStyle so it's not a "redo the patch"
> > situation.
> >=20
> As you say, "not in CodingStyle", so I guess it's down to your personal=
=20
> preference vs my personal preference vs what's most common in the kernel=
=20
> vs maintainers preference.
>=20
> I did it the way I did for a reason.
> I personally find that if one puts the '=3D', '=3D=3D', '&&', '||', '+',=
=20
> <whatever> at the end of each line on a multi-line statement, then they=
=20
> are easy to overlook when just reading the code casually. If, however, on=
e=20
> puts them at the start of each line, they stand out and are easier to see=
=20
> (harder to miss). That's why I did as I did. You may not agree, but at=20
> least now you know my reason for doing it the way I did.
>=20

The '=3D' certainly should go on the first line.  That one doesn't
need to be in CodingStyle because it's just obvious.  ;)  Anyway it
is the overwhelmingly prefered way in the kernel with 31449 cases
on the first line and 603 on the second.

For the others, I don't care, but in the kernel the clear preference
is to put them on the first line.  I've redone at least one patch
because someone complained about && placement.

regards,
dan carpenter


--niUlcCfh/sMBwTxc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPI6KgAAoJEOnZkXI/YHqRjxgP/i6XXFj3+CTJhkbXSyyBqHWp
wUJUvA4jgXYHLlKGiKlZvc/KPsuMx/T4KGTZ+30zQtjAiumG/2eF/Jlvb+uFw0K0
+aJSyqZfqVZw6bpVlbnhqAIqIsHs1Lo3z5NqiI+Dd/nIam+KOFjs49uqRHQM35le
tPv1suiWiLP0099Z4w5u0w5ACfU5qDTu350DQT94N66y3vrOIwavcQU78Q1Buhik
yGhiWiKFxdQXAjTkDC24XNE2V0Ao2NMrOIkxRLXRErJSCKDs3ILjMpCRByXVvHBM
ZKiuaDRLiceFYivUWaV76RdEwPYn/eNRKLNINpxVQd57qG+yTUabjT7mNqN75qdt
SENMBLepcnCKc71THYdMxD2Wo26T2D8humclrwu6FkxrRZiPEjpFh1RXQwOGhvUG
Pnp6HVy0T+Z4W3E0V8xZKZlVmTPrp/XWGt3KyxMoF0Q3D8kWpv+7KSnkecsXlWU/
8uOgePaAiHLKWuPzDrs1d4uie6pGlMfjqka92OaRWpsMQRsvmvqdNFKTbsrGzlRX
7s+emRC136CniDzb3nt7fgbEMPRiJB2+kh+JcJICNTkn3Mn9/wP8BaEY6kobOich
np09xkuUNagg0qpaeNKbyQgm2kIOTkqTQ6EVVdS5zQznttDY6Fj6SnpAWYiXy7rv
w45qXHNCcLmtNQW5Z0+5
=nQYx
-----END PGP SIGNATURE-----

--niUlcCfh/sMBwTxc--
