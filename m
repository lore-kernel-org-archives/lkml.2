Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934630Ab1JEMgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:36:36 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:51452 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934243Ab1JEMge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:36:34 -0400
Date: Wed, 5 Oct 2011 23:36:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Valdis.Kletnieks@vt.edu
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Oct 5
Message-Id: <20111005233625.a5a6e83e53a338c7b4e205ff@canb.auug.org.au>
In-Reply-To: <27222.1317816559@turing-police.cc.vt.edu>
References: <20111005193750.78af4ac777e9b69230d62375@canb.auug.org.au>
	<27222.1317816559@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Oct_2011_23_36_25_+1100_hfj=muv/6rMzRwZd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Oct_2011_23_36_25_+1100_hfj=muv/6rMzRwZd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 05 Oct 2011 08:09:19 -0400 Valdis.Kletnieks@vt.edu wrote:
>
> On Wed, 05 Oct 2011 19:37:50 +1100, Stephen Rothwell said:
>=20
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).=20
>=20
> So I managed to bodger up my local linux-next tree, decided to start from
> scratch. Had a good 'git pull' of Linus's tree from yesterday, so I did a=
 'git
> clone -l' of that. Then:
>=20
> [/usr/src/linux-next] git remote add linux-next git://git.kernel.org/pub/=
scm/linux/kernel/git/next/linux-next.git
> [/usr/src/linux-next] git fetch linux-next
> fatal: The remote end hung up unexpectedly
>=20
> Am I pointing something in the wrong place, or does git need to be kicked=
 at
> the kernel.org end? It's apparently tree-specific - pulling Linus's tree =
from
> git.kernel.org works just fine.

Yeah, linux-next is not back on git.kernel.org yet.  See the note at the
top of the email you quoted above:

"The linux-next tree is now available from
git://github.com/sfrothwell/linux-next.git as a temporary measure while
the kernel.org servers are unavailable."

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__5_Oct_2011_23_36_25_+1100_hfj=muv/6rMzRwZd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjE9JAAoJEECxmPOUX5FErYsP/2ltW4rdpTi+v3fbltPMRhtX
PLbwCoCIoaI+YmOU+jobnvknRl/RLEhFL9VHxAIbrYrLoikVkgdx0DYpoXDjNcrW
uOobgyWyVEufiEJG9zJ8zCDGyvX1E/iz5AsPF2IHynCCQ5fKI5M2+pwwyML1sIl8
td1SrZR8JKY0SaHHMr9DI1nIkBIXqBWWJD/QgD+Nw+VNS51pNssI1EsLKt2hPI3K
uQSCmzo4wtFQ6i5+hClK4O2kSlzbS7HGFgDK3GuPYbrP96xfEVQv3ZW9wgJwRxXz
TMEUtxU59gZIhTuqMJe/u393N3QettNFWU0/ZAE369vcWPr7SvAdTX8OTKtYUWN6
Xgj0iEuoOaR5aJiyw2Lfraaioyuxys5Sa2HI+CuzZ6ifr+9tfTqRTfuf9pu0ss0V
dv0uXiq5bBmBgLhjf2veTFXRtf9j5gBQuEgRvf/PVROM74XEI4xX0BAS3EBpC47c
sIyEpdKNKNIhflnS4pmOVNL2Ay0aWP9FYWMy9dLI0mwZuXuJ6OdpWNhNSL92GZML
twqhy2/HxOgFd5wOa+4LEEGHMv8DBtazFWgsd1eY6fxwVosSzKdbWfGJ4IXuWSiJ
Js1fCA+w2sIjnnXlV+j9Uw4STuFSI6cGvw1WI5wtrOLfIK0D5ISfYj3sOi8nxaYg
VB2KiwOLHCwAQNK9eN+f
=NTWq
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Oct_2011_23_36_25_+1100_hfj=muv/6rMzRwZd--
