Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab2FHAu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:50:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49915 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab2FHAu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:50:27 -0400
Date: Fri, 8 Jun 2012 10:50:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: linux-next: boot problem with next-20120607
Message-Id: <20120608105020.532915a90f3e5322ee28c05f@canb.auug.org.au>
In-Reply-To: <20120608095755.2676d319863e46b87b907774@canb.auug.org.au>
References: <20120607135320.7a1298385346bc238a0f92b0@canb.auug.org.au>
	<20120607150549.63f3ab81.akpm@linux-foundation.org>
	<20120608095755.2676d319863e46b87b907774@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Jun_2012_10_50_20_+1000_M926uvDHEx+8AxpJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Jun_2012_10_50_20_+1000_M926uvDHEx+8AxpJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 8 Jun 2012 09:57:55 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Thu, 7 Jun 2012 15:05:49 -0700 Andrew Morton <akpm@linux-foundation.or=
g> wrote:
> >
> > On Thu, 7 Jun 2012 13:53:20 +1000 Stephen Rothwell <sfr@canb.auug.org.a=
u> wrote:
> > >=20
> > > My boot of next-20120607 in PowerPC produces lots of these warnings:
> > >=20
> > > BUG: Bad rss-counter state mm:c000000278508000 idx:0 val:-27
> > > BUG: Bad rss-counter state mm:c000000278284000 idx:0 val:-27
> > > BUG: Bad rss-counter state mm:c000000279e13000 idx:0 val:-27
> > > BUG: Bad rss-counter state mm:c000000278285400 idx:0 val:-27
> > >=20
> > > And so on (with different mm, idx and val numbers).  Searching showed=
 me
> > > commit "mm: correctly synchronize rss-counters at exit/exec" which se=
ems
> > > to be there to fix this exact problem?
> >=20
> > Well that's a worry.  Are you really sure
> > mm-correctly-synchronize-rss-counters-at-exit-exec.patch was applied at
> > the time?
>=20
> Yes.  This was exactly next-20120607.
>=20
> > There's been an extended amount of inconclusive waffling on that patch,
> > but I thought it concerned the best way to fix it, rather than
> > *whether* it fixes it.
>=20
> Ah, well, it may fix it for some, but not for me - I have never seen
> those messages before yesterday.

And with that patch reverted, I get no messages ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__8_Jun_2012_10_50_20_+1000_M926uvDHEx+8AxpJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP0UxMAAoJEECxmPOUX5FEO2UP/RXCHmSy5Gv9zFG5Egg/G3tX
w4TnOJTiBCTSxtZNUe3kE136zo9ncsThzsJJ+58jeNaXAKlIzPVmToZTygY591fb
JGZhQtCIX8xC2H+UaXeJg6N5Ck5qeEes8hxNAkRkvjCzwd1vJQJOdyG/ohEEcdHp
i8pwzGlauPbLniGplvakry6wMdfXNQg4e01SLfl/LkwRHKr61HqSrVGscDD4EdPB
99HeTO+WABFwpVNC9ToY6x5M0x4Z7HmRj/qmMu0C7IpUqN/WeDDSlLK3a+6Yi2vX
wDAX8EooDgQMeOn91KFq0WAEoyBUoquNM+YM4WTzztSc6jfgDGlVkvHSbBHk2OL3
R5vpWU24DsrA3Xj5aARb5dEou4UbuvaX7Dm5F3wQZQQXhuJzsUfgtAO9gcaO0QLh
OSGDfU6Mtp92/iNFTUCKrQnRIsT15cc+uHxnuoL9LfWv4yLuMWDNh/bN2+G28V/l
Uz1x0LbSNSPo5dzbBj4DAK8QL35GeQO01PhUZWKtEJ/QDgj25lbyZs0Q7FmX9lik
vY1O6rUbZ7JRFv05XaXAkXSSkGgrruCqeWm/d+XSDqiMrv97M0nGOxnogFcDIN2w
PMDVUkIwVgEdQudkx7sdmDptiZm/sz34fJzVgMFrCsUyX3mcDnBKVVQm18Vw9PNz
OkYxVyXvVc56iQTqQA/j
=3UB2
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Jun_2012_10_50_20_+1000_M926uvDHEx+8AxpJ--
