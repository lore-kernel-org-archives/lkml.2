Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab2GYBJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 21:09:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59462 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2GYBJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 21:09:55 -0400
Date: Wed, 25 Jul 2012 11:09:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>
Subject: Re: [GIT PULL] KVM updates for the 3.6 merge window
Message-Id: <20120725110943.e0c429afbffd2cf8b6c92aac@canb.auug.org.au>
In-Reply-To: <1343169516.3715.25.camel@pasglop>
References: <500D1573.3030406@redhat.com>
	<CA+55aFygKruOf1G5bjfE3mpvaMP3B7Eg3Hh2=HpMO=M8fDX=tw@mail.gmail.com>
	<1343169516.3715.25.camel@pasglop>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__25_Jul_2012_11_09_43_+1000_Trx_OL2QHlHKa7oH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Jul_2012_11_09_43_+1000_Trx_OL2QHlHKa7oH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Jul 2012 08:38:36 +1000 Benjamin Herrenschmidt <benh@kernel.cras=
hing.org> wrote:
>
> On Tue, 2012-07-24 at 12:04 -0700, Linus Torvalds wrote:
> > Ok, this caused conflicts with the s390 and ppc trees. I think I fixed
> > them correctly, but the respective arch people really should take a
> > look.
>=20
> A quick peek at the merge commit looks allright, but Alex mentioned that
> there's some more fallover that needs an actual patch to fix (the
> changes to enforce a cleaner ASM syntax need to be applied to some new
> code from Avi's tree that didn't actually trigger merge conflicts).
>=20
> I'll follow up with Alex and send you the relevant patches if any.

There was at least one, but Linus got it (I checked all the mentions of
VCPU_GPR).  His merge resolution matches the one that has been in
linux-next for quite some time.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__25_Jul_2012_11_09_43_+1000_Trx_OL2QHlHKa7oH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQD0dXAAoJEECxmPOUX5FEwSMP/jdugUT1BvLgJHnnwlqloZ1y
rvViuVPRWbO++oAE5I5K6Tj/9velKetCpDTVLq7JXAlHNwmnk+bUwq+YQW7tWZLh
B74OJIwNxd25A+KwweyJS1wX6Vj5xXIlwzotIDcf9lnezwjxwDOIq0YiBtBZZ/We
EFNBU+UoLia4JyDUgjVRBlutMbHiG5MDxUTH806DCRW+RLxx6LuKESKUsBDrGWth
0bi2U6JsIf4G+FajbcO/TqIJeXcdraQLSd1sAEQ4w4DVtnsSELsCt1bX/APvcoSh
44rJJXzQp3IAYX0OruVbptAzosOVJyZ9Wg0Uci0u630ISMZa2eBcM+cEE5N75tmv
HVFAEJDdsoECVjvN9iX88yzGodMTYqOCRYVd/JasJmmbbCDWziTudbF5Lj182QNV
p7DwC6Nh+Je+T5ZPyFJiWmVLu0+6tP8/z0dmG/VQxVKpXPnSHChTzVetnv1YiJPy
/smWq+xTJHRHiEaYnOlLwOBTR7i60Ry2o7o92/jL42QpaRKWGUAer2dbt0gYZpuG
7Z9DiaLN9k1v/IEfKWpnJERWLx4jslvIOB24pROIObEgO1INBUPHA27hPIV5TsVV
pN1N3N08+c13lNux9sBfVgyHPzK1VyyvE3x32vuIriGdyoKeKluy6/yMtXKlSEnn
PiMQfNJyK55rqfBRH67b
=oLHm
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Jul_2012_11_09_43_+1000_Trx_OL2QHlHKa7oH--
