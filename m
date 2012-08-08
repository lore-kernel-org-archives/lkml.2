Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab2HHWdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 18:33:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53486 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab2HHWdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 18:33:23 -0400
Date: Thu, 9 Aug 2012 08:33:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: linux-next: removal of some trees
Message-Id: <20120809083312.cd9cd8f19cf2f329c8758288@canb.auug.org.au>
In-Reply-To: <097401cd7473$ce075320$6a15f960$%kim@samsung.com>
References: <20120802084154.875a13db0ec1ebd3f5a4dab3@canb.auug.org.au>
	<097401cd7473$ce075320$6a15f960$%kim@samsung.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__9_Aug_2012_08_33_12_+1000_WaEK7169T8i=lw1Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Aug_2012_08_33_12_+1000_WaEK7169T8i=lw1Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 07 Aug 2012 17:08:18 +0900 Kukjin Kim <kgene.kim@samsung.com> wrote:
>
> I think, now, the 'samsung' can be removed from linux-next but I'm not su=
re
> about 'bjdooks-i2c'. If so, please change the name of my tree 's5p' to
> 'samsung'.
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> #for-next

Done.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__9_Aug_2012_08_33_12_+1000_WaEK7169T8i=lw1Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQIukoAAoJEECxmPOUX5FEuJcP/RgQIWFpEcqxEWpFGo6ymOHX
7sw0Y0YVtYNb/ckIUz+/NU0MvV3DsQfCONh3aJWF3plZN+161Yif6DpmgmW+YKiT
JCVnlBZmR7LQLPUiD13wQpc+yblChGPqpakcRJ1JsJAqAUuEKc+guSq2o656x4cC
F9a7/NsaWh8DDdQzYEEuqjtwc5l0sgbkfpllLDL8NwPYXo9uMRf6FJQa39s4APj9
LGP5rMmvzVa99AnP1++YfxU8CDW54fJkvd659ceNgx+GyCUx7/JwAhyBg9hDNLff
e6N7a1TQ6cXBnftOUeeEQmgOaz7yshAyLgXTbJEb3jNh2415HEIGfjD7FwCHwOHf
adpHTXviB7SOv4eSMfYfT+rVvAWD/Pu0Sq75XOvqsND52tIRpR/Y+xOcCsFGbUWS
LExlEhraOtixSL8WIGJNgylCdzz9keKPYN7+W8DzlLOkwVn8+uphJCMpJZ9l1dEz
4dAnQ6fWzb01YaMeLupYoibx9ZG/cSuEuDaPuvoCLRaNDUa9ooAD90vKdrbfsfSh
3IcqFSmg9h8otAejUp5dNvPp2Z6ZTBezl8NvjqUmr3BTNOPTnC6ZFtKoOM0bwBUQ
LRkEIdrKFh6WFt07E14Prmwul5bSPmuEIpjim/z8sm1mSmeMsJ3GE3SspvXkoGUQ
GwlxH3VizdZqln2VvS3n
=IqGX
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Aug_2012_08_33_12_+1000_WaEK7169T8i=lw1Z--
