Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab2HRLSI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 07:18:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52843 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2HRLSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 07:18:05 -0400
Date: Sat, 18 Aug 2012 13:17:45 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Daniel Kurtz <djkurtz@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-i801: Add device tree support
Message-ID: <20120818111745.GA15702@avionic-0098.mockup.avionic-design.de>
References: <1344409609-1904-1-git-send-email-thierry.reding@avionic-design.de>
 <20120818094846.GA24812@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20120818094846.GA24812@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:cHjSu/VABAxBv3gX20Cb34+FDz39prD9Ct+8JbBldJv
 KB7/LkhkKPdeodrShIAgmO+2nM+9zYF8JX7OxfPvjTuMddFdWw
 N4ytuIwfl3dlWdNC8rkoALIagBZGAcTQIkZqpA2lTY1sfY351G
 BZ1GtDbA/ZDbo40wQS338co/B2MkPeiaB7dKcRxsO4AWjTsKOm
 cTrGs5RyUDcRuirogNowBXFyL/1vqkn2AfvTkFwSgKCs72sVt6
 qtp8LnBRuUS89c94E9QQfsa1PbelJ9ECnWPESmmIpdHoVsME2C
 nAnxQHY4h/H5B9rzwEeoT+b65nPWNSrm4He7eMIQ1ygHDnDbSg
 bg5dEXBUfzaW9dp854tmdcgI0YU56PhpWYjwRwgJFFp69+l5e5
 +yIxOh6pF68HOx5GcZPwNCed3fzzZrpW+DVoZxG/D/WiSzgLzP
 R13ik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 18, 2012 at 11:48:46AM +0200, Wolfram Sang wrote:
> On Wed, Aug 08, 2012 at 09:06:47AM +0200, Thierry Reding wrote:
> > This commit adds support for probing slave devices parsed from the
> > device tree.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> How are the devicetree nodes of the slaves connected to this PCI device
> which should not have a node itself?

The matching is done by pci_set_of_node() and pci_set_bus_of_node().
The latter will eventually call pcibios_get_phb_of_node(). What makes
you say that PCI devices shouldn't have nodes themselves?

Thierry

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQL3nZAAoJEN0jrNd/PrOhSxEQAIS8NBwXdp7WeVUznYH+rwoE
L7Z4wjtaBX8Xo55/3rM3DuXciQDdMiNAnLG+kT1TcnUTidmKrXroWSnI7Tm5OTdB
Y6o4aneggDWlHJlv0tCkuHGUN6u0fYh6yfOL07Nc0KmC20fNxkkoNIaFR2x5+UB8
orggxWqu6MT5vqQpKwP/Y1n8CdMZiXcITolazsDUZw7UA75tiCA/XIqi+Zvp8+P7
SqOG44Gw4dSytMjcYFKweHI3zb3qiztbBAuMo2j7idf/jTQ1TzG9OJpJbIsA7n+8
ZErce+LX6fPcno+FL4q6xMZVHribE3DEMozP913q9zOT5pj9/h5QhQfE+QRhHXen
eirsYDmMpSQUvcwMhCxGMB41rKiuq6wGieF9JRWyVkTMEg3eTFpYavy/Ew69IdJ3
pOSdpM9tXi73XkUYO2BTv9DSRvYCV6IblPx5yC6GOx9B+a4qA4nd0oPGKkxIU3ei
n2dYtrL85jxc16QbgpKXqCUsG9VjA436FWL04kNnMr2DYcfEHq32YetTcJA9g8ij
UrAF2SIOueW4qGOvczXpvrliy16JZCdrddWs+IuLYTFSPNeNhRv2oNWPs6Gw1xOx
Yxx9nXIIz04RTbSlvwa/xc6knxPeCYabvFOF77DjTUxYU07vwOcGkW8BrHb69py/
Xed9sXKJrNLhnE3Db0Fm
=EmG3
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
