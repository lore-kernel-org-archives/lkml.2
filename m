Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab2I0TtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 15:49:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59398 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2I0TtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 15:49:00 -0400
Date: Thu, 27 Sep 2012 21:48:53 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Antony Pavlov <antonynpavlov@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: Re: [PATCH v2 0/3] MIPS: JZ4740: Move PWM driver to PWM framework
Message-ID: <20120927194853.GC5483@avionic-0098.mockup.avionic-design.de>
References: <1347278719-15276-1-git-send-email-thierry.reding@avionic-design.de>
 <20120922074144.GC2538@avionic-0098.mockup.avionic-design.de>
 <20120923135635.GB13842@linux-mips.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <20120923135635.GB13842@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:oMkfZfoD11ctEJ9jhDnsi3tJsXXC89cHmpuBbbGDbg1
 PpxFQpTwN/EHyNngVXmlXCbnY+7nejXxvh5qmjLEHQQnDFOw4k
 UYxOyawxSe2Vnsym+JcedDNtrnzEFpyqk5KkYF19Mky/MuD/16
 DG76UylM95QufKX1ao30MyiyoQpPrL44YHbL0BUoMJbe2SyPEo
 NhMW4Q//rSJJnn/2IIiZQ0xO5xaaogQ5yUyNN4OepAQh3zclDk
 K1Zu89nXhv1+7rWrDTEbwFGB9m5q4peK+aeKEs1evvZBAhpSlX
 1YUTJqdKFK64Su/2I4/4i5caMWiAYFupIT607Bmhuhjl2cEdk0
 DkUA2LaprgBE+hK8An5B+F0qT0sKIG8zogAKokQwF15HKnZIPt
 4TB0t3ifo2mS51VAIDWDOy+6N1CQ7XsvV8KHiI8VvXldIDIAqo
 nx84v
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 23, 2012 at 03:56:35PM +0200, Ralf Baechle wrote:
> On Sat, Sep 22, 2012 at 09:41:45AM +0200, Thierry Reding wrote:
>=20
> > Have you had a chance to look at this? It is the last remaining PWM
> > driver that isn't moved to the PWM framework yet. All the others are
> > either in linux-next already and queued for 3.7 or have recently got
> > Acked-by the respective maintainers (Unicore32). Patches 2 and 3 were
> > already acked and tested by Lars-Peter who did the initial porting.
> > Patch 1 can probably be dropped since I seem to be the only one running
> > into that issue.
> >=20
> > I really want to take this in for 3.7 so I can use the 3.7 cycle to
> > transition from the legacy API to the new API and possibly even get rid
> > of the legacy parts altogether. However I don't want to do this without
> > the Acked-by from the MIPS maintainer.
>=20
> Acked-by: Ralf Baechle <ralf@linux-mips.org>
>=20
> for 2/3 and 3/3.

Applied both patches, thanks.

Thierry

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQZK2lAAoJEN0jrNd/PrOhLiIP/1dTDMwqxiErExsuC1mtvG6N
Pg8UOHukLOLJYJlAf46gCvLN9BOQFYwQQMgmfS25fnxvpEdNAZIPFZ3NwHAJ/gju
vgxGeBPmDKyCaCeOXcZ/4SiS6R06C2CloTWqCZA3198ywbFEIPIwYk66qeF0CH4D
J5rIhBXH08eQQqA6lgFSZbFQGnNr6jtk1G65CUVxwzXmEFJCd7UVGbORiqK0/oOg
/Bvi+uhJbcZ2ZlZhPMyc3wVtCTyz3F7I1CARuyTGcjBwsxr4mXaqcf9d7Uln1wyU
P5DZFAiO/sfH3hlrjjD8a+0+d8XsHbbaYpCIMv2XXpYZGOm1JruWD6LhENzT3iEm
hssMgh0+TU1ARy2WuJhAc2izJPze5I09qGvXOwmtQvNf9JpqwqpeySS38wlEK+6h
YZEtSFHj9aLdrMG45Y/rhrHsvjk9rZE8aTyGOHJzfQZjNLc/hsypc3W9sw8ZUdsT
Ddmeydx/9/r04HXo4mc1DVioXLLWjc6XyASj32iwh8AWJ305lkr1uc9TXRZXuO04
fBJXGZQ7L6X9wkkRVSP42KPmjguMEaJ/psMjWeYqjwUXhiBJ9U8EQ5h6+zj0r3Bm
X5v3Ax6BOqUu/rOTcj5VeYSyLlzoDciyf/MvPEcS7Brmv2OW6AN2lcjyTKDnr0vk
0xZJtrHR/Bnw18Lq06x9
=X+hw
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
