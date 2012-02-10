Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060Ab2BJUCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:02:23 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:58535 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760035Ab2BJUCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:02:21 -0500
Date: Fri, 10 Feb 2012 12:02:17 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: svaidy@linux.vnet.ibm.com
Cc: Ram Pai <linuxram@us.ibm.com>, Yinghai Lu <yinghai.lu@oracle.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH] pci: set pci sriov page size before reading
 SRIOV BAR
Message-ID: <20120210120217.6bb5c836@jbarnes-desktop>
In-Reply-To: <20120202174120.GA3753@dirshya.in.ibm.com>
References: <20120202174120.GA3753@dirshya.in.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PkuNm076j/WqJkd0F81xqaG"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PkuNm076j/WqJkd0F81xqaG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Feb 2012 23:11:20 +0530
Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> Hi Jesse,
>=20
> The following patch fixes a regression introduced when an SRIOV card
> is used as a PF in a 64k base page size configuration.
>=20
> Reference: https://lkml.org/lkml/2012/2/1/165
>=20
> Please queue this bugfix patch for the current release cycle.

Applied, thanks.  Ram please shout if this isn't ok and you'd prefer a
different fix.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/PkuNm076j/WqJkd0F81xqaG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNXfJAAoJEIEoDkX4Qk9hUaAP/3Ky/6j9cYfYa3s/IUskAO3O
+U2cjoCK9cqVzE8weqBc68P27/aCrTix1UkWDiXjGJRjEgRorCUz1fnXW2eXv09q
QHkT7DnHn5rphwplzMlSNkjcgkcm/MRzlRwDMgRWbTH1s6RnTcHYcWcj5ioCSIvU
fPyLmytiqqLCl5FmLGJp//sM6G7Jt/giF9vqV158tTjdJeQeT06mOZ4EhcvBmFqJ
cu9bkIL4b9yb0aneU75ynlN0qWcuKQSiHb3r0cn8rLSKE0j0y9ANEeaNsF6WeeH1
PhhL4TRmj4XABVL/YGx/aZtFp5KdKNHj/VHWEGYS2LFjONtXkAOKqz+mSpzXUtTm
AU2E6RGQYvDWRpPKORnLJWrgkSUpJR+wd/wAg88hscufTTqto5xPEg3C3e+xo3mS
36qKXGIu/88zE5uzr8pmvq4VhHKFvwrRlO/dMY/poHiBjYdnwAwRc6PcClNQ5xqp
NV+T8FCHgx63lQi1yUkTjdLTBD8X5KwzDCnXTSRea8YM3XL1bWCUuEaN1qyb6gpL
URZHHYM3go0JUni8io2nSRdmKyjpntcSAwTlaHFdqLvWzzZYIS5swChTC61BzPbG
raekZ7Ubj8aKU45lFgxN6nKhDPHbfx66UZPx0CK7aCYE64jNhbp4EPJONJ6q9/hH
rlDAfrsTwNPPx7xGQJsq
=/y6H
-----END PGP SIGNATURE-----

--Sig_/PkuNm076j/WqJkd0F81xqaG--
