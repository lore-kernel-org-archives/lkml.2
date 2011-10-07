Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab1JGX2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 19:28:23 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:43445 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab1JGX2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 19:28:20 -0400
Date: Sat, 8 Oct 2011 10:28:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <roland@purestorage.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Mike Marciniszyn <infinipath@qlogic.com>, linux-rdma@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] infiniband: fix ipath_chip_init.c build errors
Message-Id: <20111008102814.ca235496f72423e215cbe8ac@canb.auug.org.au>
In-Reply-To: <4E8F77B8.3000805@xenotime.net>
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
	<4E8F683D.9020604@xenotime.net>
	<CAL1RGDXoiRfR1Ku67tRgbhxzyWQmDrjKCztnVd6wbwi0Uud90Q@mail.gmail.com>
	<4E8F77B8.3000805@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__8_Oct_2011_10_28_14_+1100_50GbdkWsV/hd1iro"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__8_Oct_2011_10_28_14_+1100_50GbdkWsV/hd1iro
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 07 Oct 2011 15:05:44 -0700 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> On 10/07/11 14:21, Roland Dreier wrote:
> > On Fri, Oct 7, 2011 at 1:59 PM, Randy Dunlap <rdunlap@xenotime.net> wro=
te:
> >> Add <linux/stat.h> to fix build errors:
> >=20
> > When did this break?  I build ipath in my test config all the time...
>=20
> First I saw it was in today's linux-next (20111007).

Its probably associated with the module.h split up.  But see Rule 1 in
Documentation/SubmitChecklist.  Implicit inclusion of files can easily
break when built for a different architecture or config ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__8_Oct_2011_10_28_14_+1100_50GbdkWsV/hd1iro
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOj4sOAAoJEECxmPOUX5FE+bEP/05mdE6nFwRFEStsN6b8k8YT
W6DoQptlHRBFjoDjk5KDYwIIWL4lsoG46GEiRO4xoNuZAVGKK8cIr0DuzfHNoNDT
PHf/pcaIril0MZJa9bZ/XrEeEaPU/aLY7Cp90xKsST/b2eejgR4sZhg7YUbx5/6W
xzTxFQbgjHxrtZ+SPQkVVNfX3jGqKkvwldRMY7O/KrZZzkmZcOTQi6Vtf9SJzmDf
eNpdCn1fwwpHaywC/6zC06GUKt+gn491hAm1jMFR8mnPSjEEq43FN3LhapzmTK4x
N/LPTO32rI1wuAyM71qp+g0qsjtlAlupbC92IXjPoGJBW+TCqC4uXRMRBmZTyd2J
ww1B2pT70OKLeVYS8aIuoMLHNaI5JS95dwnEZGy838Hb03rJS8KMpNVxLjQpF22j
lACqbaU/AF65F7U0cZh5eZ97xtnjD0qDvDGbh5OC1YDh4MHOS9DAqCF1n4sqJQ3b
3pLFk9S227StGa0GS4e5gwXlsknVZ7FHMMmltmf7TJ9898BKrXDul8k5VJX70U8s
+DM2C76/TmlaO8QFiloJHGLMabSmRs1rhhZ7MUUEBCCML/Hn4RsfXqmWj8waEcax
Gq4WP5ybNXvY4mTdTZEJOU/8arI9A1hyOdel1w1YfJ0qI5z3zQ2aoe+CZi638/52
NcElVmkX7w7lnCLf0G7t
=80ES
-----END PGP SIGNATURE-----

--Signature=_Sat__8_Oct_2011_10_28_14_+1100_50GbdkWsV/hd1iro--
