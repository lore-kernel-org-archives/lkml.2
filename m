Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1JNQHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:07:10 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:55784 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754434Ab1JNQHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:07:05 -0400
Date: Fri, 14 Oct 2011 09:06:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 1/4] PCI: Move ATS implementation into own file
Message-ID: <20111014090655.500a50cb@jbarnes-desktop>
In-Reply-To: <1317131836-11822-2-git-send-email-joerg.roedel@amd.com>
References: <1317131836-11822-1-git-send-email-joerg.roedel@amd.com>
	<1317131836-11822-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XS78kfNkMyNYNAHHEgGKnny"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XS78kfNkMyNYNAHHEgGKnny
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Sep 2011 15:57:13 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> ATS does not depend on IOV support, so move the code into
> its own file. This file will also include support for the
> PRI and PASID capabilities later.
> Also give ATS its own Kconfig variable to allow selecting it
> without IOV support.
>=20
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---

Applied this series to linux-next, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/XS78kfNkMyNYNAHHEgGKnny
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOmF4fAAoJEIEoDkX4Qk9htiAP/2zCmRFUZKMgZxgIhnbDOsLE
sMIdO83EmNXaV3aimH2dpRlbGMNqEWNc1wM/4/9g4ut4uymVoIKeNf67mR4Bd9Kx
MeBlIrjJaxt3vVlA4r1ifJwBx+6K/n8zukVtu8bSh6r8ksG3htYVCs8gTcI1x+Lh
j3hKZ94BJJeAIZzMa3nQYJkNO0AD1rgjYhVJIH2jWkq1x9GlQjq495SqMtlsAmlH
cM/lnnjI7m3HviMDvybhVj3NQ05oN0wRrEB/rfEkFNCQzYXNYePLOKmvD+BHpWxe
F11Q/Gq07DWxQbTbGGLBYfyCqQhLtbt2bEJqLoG5mnXYQrMrsJhcPvGPY1PPLvze
FiG/4h28luv85ydobL9lYWunBADJ14Bae42V1v9wso2lilpoDnHZO3RWdm3NAgkT
wHMA8xHuZGmfh5IZsCWKAW90RcwHBnkG4bJCYs6ftB7UB1uyxO9EWuh1XmP9CIWW
wBewmuuxxrmg1fs5dDt3oddrMhsnvnV3CciATSW/pirJ2Gq+qspvMvf1ouwp4pa3
BDLt/UN1qxHoxX4eX192r30r2kqljIieO240G/nfp9jUROKOlBOf2nP/+CIDPueb
Ii20qmvkBUJ3VpJJ1sg8XamCdCAt1K1OD7YMb8AA60xIn/yx8xXP1Ctl19Rm6tiw
DyddJ1Ey9+kgw/Put6C2
=l2dI
-----END PGP SIGNATURE-----

--Sig_/XS78kfNkMyNYNAHHEgGKnny--
