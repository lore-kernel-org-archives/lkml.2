Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704Ab1KCPCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:02:42 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:54862 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932495Ab1KCPCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:02:41 -0400
Date: Thu, 3 Nov 2011 08:02:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: linux-next: build failure after merge of the pci-current tree
Message-ID: <20111103080237.2b1b5d41@jbarnes-desktop>
In-Reply-To: <20111103161959.a2130732d0cc781fc2e50d10@canb.auug.org.au>
References: <20111103125325.c1e20275e3a68498465b5ddf@canb.auug.org.au>
	<20111103143256.216308862667829a1fccfdf2@canb.auug.org.au>
	<20111103161959.a2130732d0cc781fc2e50d10@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tsV5oDTCTsenJRYe_OKMCBS"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tsV5oDTCTsenJRYe_OKMCBS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Nov 2011 16:19:59 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
>=20
> On Thu, 3 Nov 2011 14:32:56 +1100 Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
> >
> > On Thu, 3 Nov 2011 12:53:25 +1100 Stephen Rothwell <sfr@canb.auug.org.a=
u> wrote:
> > >
> > > After merging the pci-current tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > >=20
> > > drivers/pci/ats.c:13:26: fatal error: linux/export.h: No such file or=
 directory
> > >=20
> > > Caused by commit 571eba1b8aa9 ("PCI: Fix compile errors with PCI_ATS =
and !
> > > PCI_IOV").
> >=20
> > I have added that patch as a merge fix where I merge the module.h split
> > up tree.  (Included below for Paul's benefit.)
>=20
> Actually, this was already in the moduleh tree.  Sorry for the noise.

Ok I'll drop it from my tree then.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/tsV5oDTCTsenJRYe_OKMCBS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsq0NAAoJEIEoDkX4Qk9h3dMP/R8Xj8Gg4u2FjHXxQ88sikar
3TvDhzRpT1BeHvmWzvYlKu+DzJKySe92SK8XToK7+p3/pmKDRnbQ4zlo75+7Wzu5
yBes6j/sV3RP5oFBsD2RyTjx1aFU3RLiuWEE4Fey06Dq2Hcyd0AqUVwqdwCX+M+3
fwSp4tGHIHnxMRSjGZ9LwwXW+qCqBhQrgh8fy0PY/2MQBmPrnOK/BaDHsRuVEbg5
tBDdG9cPgtfkFBKMkNK8AW4U7YXRTB1YHNI2bycIOykd3nQQErYUnDTYLuFx9lAC
z5XEqnLOji8Id5YzdywLigYmejKJDb3Vqh8gju/JHuHQLTYdN42LyhSXLQzt5HLQ
AghIGXqMzHI+bRwKjBULHXFMh0p9ya/47KXDap2CW9hR/lS5iLsSAuG21GJm3FqM
/KUVrVHCmN7OPV5KIM0PVBzIpqCAnH9cmBCJLc07zDkPOY9vPHy3nIMCfNhVGwhf
9qbIkEUMvT1lAd4zjFTeIjYeJeN6aZgOzlcWBplKj5bJKrjKcWjjwrKUKrlkwd5s
goOFmmKfIFd8VOel4UVGH5sSGF51xA9R9Lb6eLQ9csmlGI9HQaFfVSmsIWHFtyMr
Jg4fjaAi/YXfLvOtQaLWW2/HHHtyhMmqfPqmydm6O/k74F2YJnSAv20vfw/793gW
onrDSqcwyUXx0PbMqtRP
=EjRK
-----END PGP SIGNATURE-----

--Sig_/tsV5oDTCTsenJRYe_OKMCBS--
