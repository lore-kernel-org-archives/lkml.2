Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab0EZQuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:50:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56871 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab0EZQuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:50:44 -0400
Date: Thu, 27 May 2010 02:50:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, matt mooney <mfm@muteddisk.com>,
       Kirill Smelkov <kirr@mns.spb.ru>
Subject: Re: linux-next: manual merge of the kbuild tree with the kernel-doc
 tree
Message-Id: <20100527025020.da0c1bb7.sfr@canb.auug.org.au>
In-Reply-To: <4BFD42A6.6060206@oracle.com>
References: <20100526115346.da5a02aa.sfr@canb.auug.org.au>
	<4BFD42A6.6060206@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__27_May_2010_02_50_20_+1000_AFhcd=WD=JW8pIr_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_May_2010_02_50_20_+1000_AFhcd=WD=JW8pIr_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Wed, 26 May 2010 08:47:50 -0700 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> On 05/25/10 18:53, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the kbuild tree got a conflict in
> > Documentation/kbuild/makefiles.txt between commit
> > 74bb7003010ff0998e280a6ade09381168ff20ec
> > ("docs-kbuild-make-examples-content2") from the kernel-doc tree and
> > commit e8d400a933fa44e2fba3849b084e1ae5814d7fca ("kbuild: fix a couple =
of
> > typos in Documentation") from the kbuild tree.
> >=20
> > The former also fixed the typo, so I used that.
>=20
> If Michal has merged it, I'll drop it.
>=20
> Michal, can I view your tree by using gitweb?  (i.e., http)
> or is it only accessible by pulling/cloning?

The kernel-doc tree is a quilt series :-(

You can, of course, see the above commit in the linux-next tree via
gitweb on kernel.org.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__27_May_2010_02_50_20_+1000_AFhcd=WD=JW8pIr_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv9UUwACgkQjjKRsyhoI8yyMQCfdJ29teP/DpA51fS4rXessOpy
/ZMAn21lJmkB0mQgCIPcAIn73RWK4/RP
=Sk00
-----END PGP SIGNATURE-----

--Signature=_Thu__27_May_2010_02_50_20_+1000_AFhcd=WD=JW8pIr_--
