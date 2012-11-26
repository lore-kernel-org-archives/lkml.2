Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab2KZVG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:06:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab2KZVGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:06:52 -0500
Date: Tue, 27 Nov 2012 08:06:30 +1100
From: NeilBrown <neilb@suse.de>
To: Karel Zak <kzak@redhat.com>
Cc: Jaegeuk Kim <jaegeuk.kim@gmail.com>, util-linux@vger.kernel.org,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: util-linux bug: was Re: [PATCH 00/16 v3] f2fs: introduce
 flash-friendly file system
Message-ID: <20121127080630.788665f7@notabene.brown>
In-Reply-To: <20121126132700.GA28200@x2.net.home>
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
	<201211021439.02797.Martin@lichtvoll.de>
	<CAOtxgye-sqJFe17EyfJQ0RrMwQqsPbDv5m+4cJT0BjnRnGv56w@mail.gmail.com>
	<201211101933.38434.Martin@lichtvoll.de>
	<8A3372F6-6294-404E-909B-3FDE0C2368B7@dubeyko.com>
	<1352634168.1893.9.camel@kjgkr>
	<20121123112309.52429ceb@notabene.brown>
	<20121126132700.GA28200@x2.net.home>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5OcpnO67Uyqb3Ql.9SobFOT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5OcpnO67Uyqb3Ql.9SobFOT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Nov 2012 14:27:00 +0100 Karel Zak <kzak@redhat.com> wrote:

> On Fri, Nov 23, 2012 at 11:23:09AM +1100, NeilBrown wrote:
> > This is a bug in util-linux.
> >=20
> > If 'blkid' doesn't recognise the filesystem, mount reads /etc/filesyste=
ms
> > and tries everything listed there.  If that file ends with a '*', it sh=
ould
> > read /proc/filesystems and try everything else listed that (that doesn't
> > start with 'nodev').
> >=20
> > However it currently ignores the '*' and just adds everything
>=20
>  Fixed. Thanks for the report!
>=20
> > The following patch (against git://github.com/karelzak/util-linux.git) =
fixes
> > it for me,  though I suspect it should possible ignore 'ENODEV' too -
> > otherwise if /etc/filesystems contains an invalid filesystem name, it w=
ill
> > silently ignore all others.
>=20
>  Good idea, implemented.
>=20
>  ... all will be fixed in stable v2.22.2 release.
>=20
>     Karel
>=20

Looks good,
thanks,
NeilBrown


--Sig_/5OcpnO67Uyqb3Ql.9SobFOT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULPZ1jnsnt1WYoG5AQK4oQ//daau5dXELjbUorn14GwkRofQdz7TbINI
ct3flpfKbJOWf43/5ty60oLSf431sz0S9ywokOMNyHmEx3G5TjBNrdAx7SX2eUBW
XDA8tT8B26xWrKtYPJ1Od0JoD3OMyb9mFdt4cDra4cDEbmDmFNHF14vHhWZocMG3
Z8A/a3B2qx3Sqoobop8JZiO7QsNxcia6KTPwE1GHDB19Q7nc6vV8EmkliOpvRg3t
bkZN5ppFPo5krphMOA7Y/pLDA9+wit0MmFde5iWsfnH03Z9G+glTtkignE+V7rPU
ZDeAvUHf5WitjWSBtiRipwfpsPcHUoqToqMq/lx926wtIL8DtuMTM0ukBflaeD1X
Ne2S1CD+wGvY36w4v3qzqHhxdvMGXWFuXsIMCly+pmP33xdye6YScJVksoAsvomW
vp+mBSqEMpG/kqhwvtSPmtgPvtLI+P28hHfseUSduf0sDKy8NB6IWWxaJQTK4ep1
FzCRD4k8WZerRhbFwZ8OwRx2Z+5gyYpe8p9/EALBdl0L2HWz047VIiKbQKVprwAC
N9hlVAIjHrlSDN1DBBrBCwqo0ZYvV0HU/AwuXzIi2vLDErtJO9Vv9XWhwIk4U1Xz
/p23gjr0x8S4ZSwCE3JtBEI0AIkvhKLPvbhGaZKsO3w8G1PssdGVlUVr9plgu4bM
3SjRC/nnCz0=
=FUVa
-----END PGP SIGNATURE-----

--Sig_/5OcpnO67Uyqb3Ql.9SobFOT--
