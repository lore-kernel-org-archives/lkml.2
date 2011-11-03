Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab1KCFUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 01:20:11 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:42443 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab1KCFUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 01:20:08 -0400
Date: Thu, 3 Nov 2011 16:19:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: linux-next: build failure after merge of the pci-current tree
Message-Id: <20111103161959.a2130732d0cc781fc2e50d10@canb.auug.org.au>
In-Reply-To: <20111103143256.216308862667829a1fccfdf2@canb.auug.org.au>
References: <20111103125325.c1e20275e3a68498465b5ddf@canb.auug.org.au>
	<20111103143256.216308862667829a1fccfdf2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Nov_2011_16_19_59_+1100_f3yyK43LuFCHuTLU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Nov_2011_16_19_59_+1100_f3yyK43LuFCHuTLU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 3 Nov 2011 14:32:56 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Thu, 3 Nov 2011 12:53:25 +1100 Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
> >
> > After merging the pci-current tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/pci/ats.c:13:26: fatal error: linux/export.h: No such file or d=
irectory
> >=20
> > Caused by commit 571eba1b8aa9 ("PCI: Fix compile errors with PCI_ATS an=
d !
> > PCI_IOV").
>=20
> I have added that patch as a merge fix where I merge the module.h split
> up tree.  (Included below for Paul's benefit.)

Actually, this was already in the moduleh tree.  Sorry for the noise.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Nov_2011_16_19_59_+1100_f3yyK43LuFCHuTLU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsiR/AAoJEECxmPOUX5FEQ+MQAJpbd4bYaeAaoC4ezrSuMHyn
a+UvjwpReSpuAqJP4k/5//r2rLpVSVc+5cAUZ9lMwflaAM8BhNNznAQ6bF+ktGQE
nNseREOzDplDDiufoDRRtV5AaEperS1Y37i53WU5+EXNNVF/YTv04CDekB8x5RTM
I271LZ61PlTxOe67+oPlgNRNJsqgJ3MeWIoyx7GzG8UmoTS57hOxGXlChKzXr8IB
5ZDkD6ryGVQcnaVPTkD1lkQ3ZxfQ1BDo6BZEwBzGVjPK400kN4goPZyzh6cbZbzK
1IxvgoUVUsWhJmwbioup2rHR/LCL/lELBCiiSWadQVHbqBn8TYnO0bae7DOVtVXi
1lCzJBNKTGm4yWfmor/yzd4Dkm/R+E9nB2AaDb4RgnJ8oVSyG/fpBLkavoWHMecU
gH2o925G88HhiHryaSFI1CQy+1W8fn9rTZdne+Hzg6Ijcdn31HXbVCmlERglL8Yx
xpwVYc0lALH72BjqYklr8Nkq6ruXnYhkW7yzgYdtXdvuWPF6X7PeIPKgmCMiJceK
m8MNMclNG6CDS/66+zKXITZcu8ESSjcXiTuK+0DoHspyVhmJZ51dyHkWf7m1pQOf
SetpgtOFeqkfZEqRNxOIEUuMVDN8stOYKBilfpnhvzbjaOoyTiXqSV7EGQJBgoD/
P8f+zajHSOnryWt3/oRA
=Kg6c
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Nov_2011_16_19_59_+1100_f3yyK43LuFCHuTLU--
