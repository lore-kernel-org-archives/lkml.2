Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab2BWT6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:58:08 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:46639 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756255Ab2BWT6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:58:06 -0500
Date: Thu, 23 Feb 2012 11:58:00 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] PCI: Skip reset cardbus assigned resource during
 pci bus rescan
Message-ID: <20120223115800.1ef0cf78@jbarnes-desktop>
In-Reply-To: <1328916832-6588-4-git-send-email-yinghai@kernel.org>
References: <1328916832-6588-1-git-send-email-yinghai@kernel.org>
	<1328916832-6588-4-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XzrrrH+.OkjS16k+KZf3Qcr"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XzrrrH+.OkjS16k+KZf3Qcr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Feb 2012 15:33:48 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> otherwise when rescan is used for cardbus, assigned resource will get
> cleared.
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Tested-by: Dominik Brodowski <linux@dominikbrodowski.net>

Applied 1-3, thanks guys.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/XzrrrH+.OkjS16k+KZf3Qcr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRppIAAoJEIEoDkX4Qk9hfUUQAIlSJ/NBKJkjyaJRqB/kv+F6
1udh6Y+T76UJzMBZ/asJFTX/kCEKK3/BnyK2husAHPGuTJ94xGrqz8w3GLtWGIKq
XzkCSyFC8hTIqPQwJpZjVHQFdKkXneu2zIXQ6+XrDllCpsov5Zo/X8ePmEfM/tHH
/85HAUIsbBZELTrZ1st0H+2nxS7KdT4cb1Mm/lK4xjBC/Pu+e1fNnk2JchQqlo8g
3J78qzC4jhcIzg3uHj7YQFIV+1eCNKWipFSfTahr7ETnnia6is83NYj35BKFAnsO
4Ie6ust+Gn2+grCyDVQC/KP3L/fAM8tJiMVJWeHql4Opidt4KYWuquAy64Pjq4UO
5erVE+Ax8K82X/CmPyrR9JptdHE9WPYQRdNkYVZVM0G4l4x9Rf/Fgnk10gwXA86h
DdSuqiIm+HaVWaWJpUl+hT/GT4D1tU584NWTV43ZPU88QMSyCFcIkLwBHAHJZk45
m70bx5WWDolhFsL15BajL2bxEtyHZLKKr4TX+saOwmmgazcNDxAUQlnA7WEsDvOZ
eiNRf4cMQIfq/4GUzgUWuT3ggCGONvKtiqlUD+G/zA1mMKWITRQOCdfrC36v04My
Cge+5Ei0CPNrgt8BDsjJifnLMQi4xWVchOIO4s2nexiuEdBJ25NJeaFEF5/TOJ2p
JFYIgwPGZlGpRIANSzf7
=SqYE
-----END PGP SIGNATURE-----

--Sig_/XzrrrH+.OkjS16k+KZf3Qcr--
