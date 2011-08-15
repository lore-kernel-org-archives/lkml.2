Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab1HOEFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 00:05:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46888 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab1HOEFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 00:05:14 -0400
Date: Mon, 15 Aug 2011 14:04:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the security-testing
 tree
Message-Id: <20110815140457.e26185cd86f51defd5e562a3@canb.auug.org.au>
In-Reply-To: <20110812124723.30fe0e364394fdd4900cb2e3@canb.auug.org.au>
References: <20110812124723.30fe0e364394fdd4900cb2e3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Aug_2011_14_04_57_+1000_GXF1FaSmIrT6gkFt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Aug_2011_14_04_57_+1000_GXF1FaSmIrT6gkFt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Fri, 12 Aug 2011 12:47:23 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the security-testing tree, today's linux-next build
> (powerpc ppc64_defconfig) failed like this:
>=20
> init/mounts.o: In function `security_old_inode_init_security':
> (.opd+0xf0): multiple definition of `security_old_inode_init_security'
> init/main.o:(.opd+0x108): first defined here
> init/mounts.o: In function `.security_old_inode_init_security':
> (.text+0x50): multiple definition of `.security_old_inode_init_security'
> init/main.o:(.text+0x110): first defined here
>=20
> etc ... (lots and lots)
>=20
> Casued by commit e1c9b23adbe8 ("evm: building without EVM enabled fixes").
>=20
> Please, please, build test this stuff.  This is the same error that that
> patch was supposed to fix but on another function ...
>=20
> I have used the security-tree tree from next-20110809 again.

I am still getting this ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Aug_2011_14_04_57_+1000_GXF1FaSmIrT6gkFt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOSJrpAAoJEDMEi1NhKgbs7VEH/RbUcTnS+fbTwjblR/RCexAK
c09NVBLOsSs0PLTx9YtX+JWqV9SSHClK9oPQABGF4PxrYSjs67aW0NbTjohosO+D
XhZI4p0GtooS/zXEnIsSuCwxT4WKpnyAcE11it24zfZHPhqwpTSibYHt4zxEwRIz
whv/NRaoCqmOK8A8YTpsBZx7huxHbu8vwgegz0F/TpTEqAvqKbhZRISCHm9MZd6N
6N1Sl6CVixfaiLxpbgi2UNrZTOaKfVVGWnxEyukdhNJE1r2W4rWuPfVR7x0iyATl
4oMyBGU7ife6woM2jJ53+4nKTVjyZXAVMKc/Ii1clLlftpme9emqmXnjQncpvqw=
=/UxF
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Aug_2011_14_04_57_+1000_GXF1FaSmIrT6gkFt--
