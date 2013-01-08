Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3AHEaC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 23:30:02 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41710 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3AHEaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 23:30:00 -0500
Date: Tue, 8 Jan 2013 15:29:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-Id: <20130108152951.9fa6165c918e52ab5cfac435@canb.auug.org.au>
In-Reply-To: <20130108042730.GA3936@kroah.com>
References: <20130108132352.dbabdc281512cdaffbae5ae9@canb.auug.org.au>
	<20130108042730.GA3936@kroah.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Jan_2013_15_29_51_+1100_b0=_fJ.IjRA_idG="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Jan_2013_15_29_51_+1100_b0=_fJ.IjRA_idG=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 7 Jan 2013 20:27:30 -0800 Greg KH <greg@kroah.com> wrote:
>
> On Tue, Jan 08, 2013 at 01:23:52PM +1100, Stephen Rothwell wrote:
> > Hi Greg,
> >=20
> > After merging the staging tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/staging/comedi/comedi_fops.c: In function 'comedi_unlocked_ioct=
l':
> > drivers/staging/comedi/comedi_fops.c:1665:4: error: 'dev_file_info' und=
eclared (first use in this function)
> >=20
> > Caused by commit 4da5fa9a439f ("staging: comedi: use comedi_dev_from_mi=
nor
> > ()") interacting with commit 7d3135af399e ("staging: comedi: prevent
> > auto-unconfig of manually configured devices") from the staging.current
> > tree.
> >=20
> > I just reverted the latter commit in the hope that the bug is fixed in
> > some other way in the staging tree.
>=20
> Yes, I had to do some manual fixup when merging the branches together to
> get it to work properly, which is what I did in my staging-next tree.
> As the fixup was done in the merge commit, maybe you didn't get it when
> you did the pull?

Presumably not (my top of staging-next is d7f9729f6e06) - it was changing
pretty rapidly this morning as I was fetching trees ...

At least it will be OK tomorrow.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Jan_2013_15_29_51_+1100_b0=_fJ.IjRA_idG=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ66C/AAoJEECxmPOUX5FEmyAP/29B5ttOdTo9M3lK1rxl2eiy
IBrPPP8nzxvpMa5QQoABI5s5e5RFDrJ3/ZtbUPay3BTBWXm4p6tNPyh31lYePnX8
c8v4EXi++q5nfivEXqkQFI7oSBPL9AItfmPB9xe33jlc0iBu3GJlN7ckOmKldGh6
0pBzqEEzrqVKo/Etv9hmotlET4WgNELT1JJRjaa430loDhVxEj8ptxtiB20QGtyX
mSxV+YsTQageveWqseHiD4KAXTAjR6jssiAoU5U4GS5vrXZLvmIci0wH4DQ2BvtX
ZA2hmi2eN/4EinKOYGJbGFuJ/C4m6qRHKVCaDQ+IJbet6/Quzs3sDTy7KJilLSBk
K07sYXsLxjMvcEdukp9RKRuvGEF1gpF1aHUN0hS4DncTEJG2GY4G0i1YjT9f3S73
PSzwY+xksb6ZDGT02ciOQdCRH4v1Bhsc5ejRAdIM64v1t4PCYJFo+K7q5Le1o7W7
CBJA0oHVJOvkr5KvwSRVNWuH7xpGcpuQ/F2wBXFHSzM+s2VIwOPy0pQfYipl1OY7
ayWY6mfrVHdNpDaUp7W7johjvLhZWQzLbPXwxnzvgmCueNpMwCzkfZZwTXULgfJm
JWgJ6lSKeVp3x0cy8Bk/Gan1X05WzdceHg487DtH+k86KN7gIzrcMgPzKo+t+FEs
966R2v6weDoZ/JBpw0W8
=VDrw
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Jan_2013_15_29_51_+1100_b0=_fJ.IjRA_idG=--
