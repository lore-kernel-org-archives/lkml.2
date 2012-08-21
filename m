Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2HUN4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:56:44 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:47472 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246Ab2HUN4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:56:40 -0400
Date: Tue, 21 Aug 2012 16:52:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <balbi@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: smsc: Add support for smsc gpio io/keypad driver
Message-ID: <20120821135240.GJ10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
 <1345545940-2232-2-git-send-email-sourav.poddar@ti.com>
 <20120821124146.GA21557@sirena.org.uk>
 <20120821124243.GG10347@arwen.pp.htv.fi>
 <20120821132222.GF7995@opensource.wolfsonmicro.com>
 <20120821132741.GI10347@arwen.pp.htv.fi>
 <20120821134936.GH7995@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aRzsUE0Mp86t8N62"
Content-Disposition: inline
In-Reply-To: <20120821134936.GH7995@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aRzsUE0Mp86t8N62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 02:49:37PM +0100, Mark Brown wrote:
> On Tue, Aug 21, 2012 at 04:27:44PM +0300, Felipe Balbi wrote:
>=20
> > I still beg to differ. Even if it fails, dmesg will still contain the
> > message (provided you have it enabled). I really don't think we want
> > this to print to console on every boot.
>=20
> Only if it's enabled which is the trick...
>=20
> > If you're still testing your new batch of boards, you're not just a
> > simple user and you will have debugging enabled anyway. dev_info() will
> > be visible to anyone who's got a console running. Not sure how useful
> > that would be to my neighbor.
>=20
> Also think about hobbyists and so on, and ideally at some point the
> people using distros.  We shouldn't be requiring kernel rebuilds for
> this sort of diagnostic information.  I guess sysfs is another option

but we don't. We have dynamic printk for that, right ?

> but frankly the overhead on boot just doesn't seem meaningful in the
> context of the overall kernel boot style - I'd really expect people who
> are bothered by this sort of output would be raising the minimum log
> level appearing on the console.

Well, if you consider a single driver then surely it doesn't make a
difference. But when you add many drivers, each with its own dev_info()
output, it can delay bootup rather significantly, actually.

Fair enough, we have "quiet", but I'm not sure that's enough argument to
allow any simple driver to start poluting dmesg with whatever random
messages.

my 2 cents

--=20
balbi

--aRzsUE0Mp86t8N62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM5KoAAoJEIaOsuA1yqREQKsP/3E34vS8oEcaD3dMKz78HOZd
StMut+NuWyEVTU1j9aqXxi76IGNzMtF6PZkmPRGWOnrTrThMNbcYObBZRoKH9AJc
tAOww49V1UTtE+rJYHz6rh0AJweMFUST8qyvJK/f3QJjm6mpZBsC0NF/vXqFOvVk
X11INrjKpDH+FAdiAM0psk9ZPjTcHA8F5+sobgyOUm/usqeIYqG8KSe7GPJq99yJ
qn1uTNFAixSs2zdSbK++ZYR7xT3wvd5IWlFLFECnrJG7wf4B/Z/h33MaJXu1ji0n
wvpVvQaXMlqfqK1j+ampSJXYq9O6YQjZYmz7xor/Ti8ymWXi/B+PmgPkBPH2CGOe
0xkgLe0PVQlQ/uPL7SBJzYPMWwqWto0gCuHLEX0Ubf6rc9824E1qiHoa5ET5SerZ
pw9tZeMTktYkYszlgei5dluJNvl2HuCGp7n0eaYtEgivWKOu+ppNJLQgYrxEmHjD
V2Bk1StD3ylWbxOujYOV6zuIDZ2rDUtQz6+oBe2JeKA8pp7UrmbfYHaozcYHfAw5
csvzrdJ/BElqwkk7lxA4nDfSHv8TVGu6EvNGlLTzYVg+AqBT1cGF33m2fLskueyv
FDxsfgl5fHxsUA4zM/0dFF8gakeLBO0m2lMbkv/lxaUj7ZHT2wzANO3/DSlPWlHx
/fJcLeKaYfmZRSMvJriJ
=KzOm
-----END PGP SIGNATURE-----

--aRzsUE0Mp86t8N62--
