Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab2C2C4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 22:56:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35451 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab2C2C4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 22:56:12 -0400
Date: Thu, 29 Mar 2012 13:55:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michael Neuling <mikey@neuling.org>
Cc: David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, arnd@arndb.de, hpa@zytor.com
Subject: Re: [GIT PULL] Disintegrate and kill asm/system.h
Message-Id: <20120329135555.06593144b65bf81cc9191f8a@canb.auug.org.au>
In-Reply-To: <30702.1332989444@neuling.org>
References: <5599.1332958811@redhat.com>
	<30702.1332989444@neuling.org>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Mar_2012_13_55_55_+1100_+Sz8x5i=ERevKuqy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Mar_2012_13_55_55_+1100_+Sz8x5i=ERevKuqy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Mar 2012 13:50:44 +1100 Michael Neuling <mikey@neuling.org> wrot=
e:
>
> > Here are a bunch of patches to disintegrate asm/system.h into a set of =
separate
> > bits to relieve the problem of circular inclusion dependencies.
> >=20
> > The following changes since commit 437538267b672f9320833907f1b5acbb2605=
f4be:
> >=20
> >   Merge tag 'fbdev-updates-for-3.4' of git://github.com/schandinat/linu=
x-2.6 (2012-03-22 20:43:40 -0700)
> >=20
> > are available in the git repository at:
> >=20
> >   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-asm_syst=
em.git split-asm-system_h
>=20
> It would have been nice to have this in linux-next for a day or two to
> sort out the merge issues,  hence....

Um, what can I say but "yeah, it would have been nice" :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__29_Mar_2012_13_55_55_+1100_+Sz8x5i=ERevKuqy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPc887AAoJEECxmPOUX5FEU/AQAI1Zwtb8A5CcTf5Z7DizPGKc
O1MxOCC+eORfajR/iGpGNrRjHxlQL/LEf7a2dNyHazyBPq8s2+OrGctLMLTMis+y
VBtqSX4sAUYRxScEY4WaLJ51Zh2R4YF5w0qO2L4pLhPp2e2t9lGC/5kG/xO+9Adc
sBPf3zPAzYEh4scJSOjjBc7tlws+gnEBRm0o7ws4kRXC/Mj6uIQDZsxNYX/tBOS1
h8ERrgTWo0s6LzAz+VViLx/QoAH58W2u0YVQfPD7bItAYgs+6nyl3LOXa0JXKGM+
ABeuO90gMwZ2BGlf5QRvKvRfQIc331jQyasGUxuHYQ36+rpzsoTNGAz4GrU1RDX2
NrgHdlrM1WiJX/Pjig5yqoz2n+NnIt3p5fbAL5VkbvrDKQtkuprM3A/WOVL6uekT
kXPtntNpNxGwAxgdpsJriZvXLiZ3ltgL9o2HFKHNx9t6jeUb1Lg2MfBv+Sc7o+bX
ikUJ8EsjaXDkK2zMV2dkjMIXZvE6fbX5HTLX5D9MI3Gq8iasuBFkaQ8smXGV1kiG
bGjH+Hu9EtKjZgjiqGRUHzhzHB2WzXbbo5Y0pp0MgpGrSmUeuvs/Qflr9mnI4Lxh
K2cIoRk3wFZUM66AQ8rOETlf8MkXn4a53JhB+e8RlxAosIMKGi80MwgLIqlonRrn
YgD8ntFAJtiBazHU6/x5
=RtUV
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Mar_2012_13_55_55_+1100_+Sz8x5i=ERevKuqy--
