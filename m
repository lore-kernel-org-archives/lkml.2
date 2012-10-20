Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab2JTCcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 22:32:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40598 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576Ab2JTCck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 22:32:40 -0400
Date: Sat, 20 Oct 2012 13:32:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (tip/s390 trees related)
Message-Id: <20121020133238.3d83aa02d8d9492cf9ce7d38@canb.auug.org.au>
In-Reply-To: <20121019224345.GC12658@gmail.com>
References: <20121018172201.b81dcc8fe40868256f532364@canb.auug.org.au>
	<20121018182953.GA20658@gmail.com>
	<20121019140702.39b6e85901be2e39254b576a@canb.auug.org.au>
	<20121019224345.GC12658@gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__20_Oct_2012_13_32_38_+1100_MTbuLHdPuHAS0MFC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__20_Oct_2012_13_32_38_+1100_MTbuLHdPuHAS0MFC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Sat, 20 Oct 2012 00:43:45 +0200 Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > It looks as though you have not gone back far enough - you=20
> > removed a couple of merges of sched/numa, but there are more.=20
> > I have two of the problems resolved with merge patches that=20
> > supply pmd_pgprot() for s390 and mips, but there is another=20
> > problem with mips (see Ralf's other email).
>=20
> Yeah. All of this should be resolved now in principle. Next time=20
> you'll integrate linux-next is on Monday, right?

Excellent, thanks.  Yes, the next linux-next will be Monday (my time).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__20_Oct_2012_13_32_38_+1100_MTbuLHdPuHAS0MFC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQgg1GAAoJEECxmPOUX5FEvyIQAKGDy+iqD7ox4ns6w3l650jS
fBN7eZk2l0ZUqrZctEq0oj26hkUnfx+WhvZ15qlUIBGangJVyeuVJP1Li6FFIU4e
if6ZNYobAZoCl+W0d+JfWtWuZhapxJx3giAri3y9OKVIOBK2r+nm2WYbtz6pvt+H
kVWf9en4AiryC7rcfc0yWfbqJWbUvnlV0k5kDV9xD1yiyopektreF4LwgcMmI+MK
m6AJOMFla+gmfGhLaa13bfbwsd7fxjxFu/YqNiKHYIWJ/xxk1odzU0Y4CEwzUFCE
5LuYFJ+2GfG1VcWNWOJ9nT0QySyM0Oc486wEfY2aI1y8YrE/8F4RKnUSh+URIsuH
TWWwgfsobuSrK38JsQTSuaLfdNYoJzUCdFU/G9XGfzomyCZC2jO50bnKxzPCeOfi
GBg4kncIKng6YHJZKDIVHzv00wsXr2vxL+TabDlHI4EtB+kEaA/ezxXhaLrlTOJA
JZBbxXrBJrnUrrkCaG6TsP8SWeRsgq3Qi1PRXJNspvHpvsmFtwdrp2LJ8JztbSvd
Xo6B5Lli+zHQFDm3SNqiD8ApBXatVJ/b4+vtrfKoEjdqHds+eJkPNb6jMdfcBTyb
XR4QRFxOmyE6GWFA9qcGlUylh9dnqSa3tbv1t2dRjJS0OloLf4YIqzqLvL7nRHoW
VKZ+z12P8/C4/KPYrZml
=NOZe
-----END PGP SIGNATURE-----

--Signature=_Sat__20_Oct_2012_13_32_38_+1100_MTbuLHdPuHAS0MFC--
