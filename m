Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab2JaMoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 08:44:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56651 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab2JaMoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 08:44:01 -0400
Date: Wed, 31 Oct 2012 14:37:49 +0200
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Randy Dunlap <rdunlap@xenotime.net>, Felipe Balbi <balbi@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb/gadget: let file storage gadget select libcomposite
Message-ID: <20121031123749.GE10998@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20121018144614.b61961cfae2274d52d340882@canb.auug.org.au>
 <50809624.30601@xenotime.net>
 <20121024144435.GF4368@breakpoint.cc>
 <xa1thapjlqv1.fsf@mina86.com>
 <20121024174508.GA6014@breakpoint.cc>
 <xa1tehknlnbr.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ytoMbUMiTKPMT3hY"
Content-Disposition: inline
In-Reply-To: <xa1tehknlnbr.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ytoMbUMiTKPMT3hY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 24, 2012 at 08:47:04PM +0200, Michal Nazarewicz wrote:
> > On Wed, Oct 24, 2012 at 07:30:42PM +0200, Michal Nazarewicz wrote:
> >> At first it looks strange as FSG does not use composite, but yeah:
>=20
> On Wed, Oct 24 2012, Sebastian Andrzej Siewior wrote:
> > Yeah. However, it should be removed in v3.8 anyway :)
>=20
> Yep, that's what feature-removal-schedule.txt says. :]

except that it was dropped by commit
9c0ece069b32e8e122aea71aa47181c10eb85ba7

nevertheless, I should be receiving a patch right about now removing
that file. Alan, care to send a patch for that ?

--=20
balbi

--ytoMbUMiTKPMT3hY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkRudAAoJEIaOsuA1yqRE7tkP/jxzrPqT9823Luez6hFdmSzu
Y6l/qoEKeZXs7PF0L0ffOllFaE0YR5DvKi02ZyfMq1hZkqIxtUTSKXbSt+EMltqL
a9Z/oZ2kyCwlagykJLmXvGFCeN6la7MP0zB8UQkaXfGiBDoEnF1omkn2wF7F5Kt1
BRpvCTdesZH8xndc9cXoXe7yEGZDxy9E8KCmR68GdFqqj2/WrpnhtWu7+QhALrzf
msIrhQBp5HYUFaoqNQXVx1GkNUUAh0gBCto/EHNsL9zWkFaNlvtNqd4QidjZDRYI
Eaz66q6yQTzz11dHoxEosz25nqD/gTos123U2Qccz2vwxMcbpBR2HeUWcURLepOd
g8biwxSd7zptzI2r9OSd6e9+e54ajyVyEXV0QKS7e9y2IsycbEbCJJG0Xd/zvHwZ
dDklAjiLZkJSd8q3cTjt9VB4y1eR4yKX7J9FsorNauMIOmOOV3rMnSxED52BM1x1
2f+YHnah1sk+SPqdG/E4Ex6TmSmjd6YI8iNzR3Bqp+octle/LqUURlW0jykzlPns
ROQgtwC2OJ6r9FHeCTF5043IBJ83LNPya9zCtY4viBDOolJDMuOk3bEY/muvSa4f
1K02XCkXfuGf82ZGUesbqHti/+KbT+75qE5SuA8E+E80N1TEhfa/r4eP1qQuxgec
0rcutgU/kYQ6zfIy/DvL
=MIh9
-----END PGP SIGNATURE-----

--ytoMbUMiTKPMT3hY--
