Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425Ab2C2Xi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:38:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55724 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760346Ab2C2Xiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:38:50 -0400
Date: Fri, 30 Mar 2012 10:38:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        arnd@arndb.de, hpa@zytor.com
Subject: Re: [GIT PULL] Disintegrate and kill asm/system.h
Message-Id: <20120330103840.790c6486dbe71e5ff901321e@canb.auug.org.au>
In-Reply-To: <CACxGe6sokpFa_KEi+jxPX3caF4CpfxzZ4f53S1Y_+caXVLBNtg@mail.gmail.com>
References: <5599.1332958811@redhat.com>
	<30702.1332989444@neuling.org>
	<1332994469.3010.7.camel@pasglop>
	<20120329210117.A9A073E06B4@localhost>
	<20120330095020.a2e01d86c2d09f186c53d63d@canb.auug.org.au>
	<CACxGe6sokpFa_KEi+jxPX3caF4CpfxzZ4f53S1Y_+caXVLBNtg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Mar_2012_10_38_40_+1100_ZVyG4WeEOZB/1FkN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Mar_2012_10_38_40_+1100_ZVyG4WeEOZB/1FkN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Thu, 29 Mar 2012 16:52:25 -0600 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> Cool.  If that checks out in linux-next, then I'll ask Linus to pull.
>=20
> BTW, can you add that branch permanently to linux-next?  That's the
> branch I'll use when queuing up irqdomain fixes for mainline.

OK, I have added that branch.   Meanwhile, Linus has merged that branch
as well, so I will remove it from my fixes tree again :-)

I *may* get linux-next for today started soon :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__30_Mar_2012_10_38_40_+1100_ZVyG4WeEOZB/1FkN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPdPKAAAoJEECxmPOUX5FENgYP/3AcM4jCtROCqhyrdPDyVQBu
tpkGp+a2QJS71vJ0uE1gUZ77i1sIrdMVMuSxZ0OOCBj9Lml/cHQocT56cgHUIRCm
ZJMzzD1VFqKgCOIB2Rwquilwb6kXeDQPqzJaTEBYftiimJ7t000omwkQn2GSW45r
c768/jLZni54AYjKKIyNVLLQ+oZPjrrpW4wI6RqbHCyqNXsV2TZCkm16gllWGcPc
RNdJDdCJY3RoWYBApgvn3VGvyp5abieNbpRfnW2h3oSOn5bw26zj2JlbtnucVxWa
4B5rH9DTfjJMIuMXkkP3DFIsJA9AtMSm1q1+X+pkZm7VTyKz6eeus+HDbhHYKczx
/6QNachzI1SeXDMW30SMuftL8/3Oq3w9/cbs71DDGBjc/yt0oRd2518y6Z+LLmpg
5s+wolFafsrTxFYVkw46O50Lgy3m4wyxIa38p7+ZFgZ8MCJsAyXr0ZxI0YwlzyiO
cGO/CgIcRZU1N8ZwXZRskNboIypKwo/abRvWlKi+fo8NTLUgl7R60T0JR4fntSHH
EqRREoIKQnNCYTbXq7BuS5dQfm9TYkMFVKZJz3XtEa+0FLYs499OV9U0aY4V4rM1
wZ46sqvFS4AoAZYxG4atxD5TThrbI3KA5BFStuvPUaCVPM/f7Y9pm+of7Z4vGnkK
q9pPoez/b82tG9vU1+GV
=oc4z
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Mar_2012_10_38_40_+1100_ZVyG4WeEOZB/1FkN--
