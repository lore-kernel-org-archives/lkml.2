Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab2BGHTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 02:19:51 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55067 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2BGHTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 02:19:50 -0500
Message-ID: <1328599312.22240.43.camel@sauron.fi.intel.com>
Subject: Re: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 07 Feb 2012 09:21:52 +0200
In-Reply-To: <20120206171152.GG23916@ZenIV.linux.org.uk>
References: <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
	 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
	 <20120202012258.GQ23916@ZenIV.linux.org.uk>
	 <20120202212400.GR23916@ZenIV.linux.org.uk>
	 <CA+55aFzHSv2eHKenVhxnSFMJMXtJCnxD2xu6QjMiMLEGLCZ2uQ@mail.gmail.com>
	 <20120203011612.GS23916@ZenIV.linux.org.uk>
	 <20120203170825.GX23916@ZenIV.linux.org.uk>
	 <1328518244.22240.25.camel@sauron.fi.intel.com>
	 <20120206135655.GF23916@ZenIV.linux.org.uk>
	 <1328547955.22240.39.camel@sauron.fi.intel.com>
	 <20120206171152.GG23916@ZenIV.linux.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-24E/TCKH5xcUivb7UF5c"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-24E/TCKH5xcUivb7UF5c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-02-06 at 17:11 +0000, Al Viro wrote:
> On Mon, Feb 06, 2012 at 07:05:55PM +0200, Artem Bityutskiy wrote:
> > On Mon, 2012-02-06 at 13:56 +0000, Al Viro wrote:
> > > On Mon, Feb 06, 2012 at 10:50:44AM +0200, Artem Bityutskiy wrote:
> > >=20
> > > > WRT 'sen_nlink()' - I can use it instead of 'drop_nlink()'/'inc_nli=
nk()'
> > > > of course. But I do not really see why is this better. E.g.,
> > > > 'drop_nlink()' additionally gives me ' WARN_ON()' in case of 'i_nli=
nk'
> > > > wrapping.
> > >=20
> > > So does inc_nlink() when you are asking to get from nlink=3D0 to nlin=
k=3D1.
> > > I.e. on failure exit in your unlink()...
> >=20
> > Indeed! I'll switch to 'clear_nlink(inode)' and 'set_nlink(inode, 1)'
> > for those inodes which are being unliked.
>=20
> Huh?  I thought ubifs allowed link(2)... IOW, i_nlink could've been great=
er
> than 1 when you called ubifs_unlink().

You are right, I'll take this correctly when I change the code rather
than writing an e-mail. Thanks! I think I'll submit a patch this week.

--=20
Best Regards,
Artem Bityutskiy

--=-24E/TCKH5xcUivb7UF5c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPMNEQAAoJECmIfjd9wqK0c7MQALappDT5PoGvjfs37KU2qdiE
SVvLKdS81CY1jJVmSxaFXemqlLkzOlz2QFlUEi1/SS/CrPdgD4te/YL31TjMLcLZ
A5NU12muTY/YdmproUOL544Y6YmoLfueotNEFL2skyqzenbJmO51aSCR3CqpAMHl
67JeQLFhV2+i+XSccJ5ea+KhRuoCvwr3aPh+RjXme4NEmmsNJ8Yrj/b75PU8MSha
ob0Go/TWGtoFU1DPB+29br53qJrLnSQV/e2nkgc5sVh3Fk7T3QUOpx/P6Zq0CD+H
lbjY00WMoYuHEb8fvGMhDQsxWllF9o+w4k5+aKRjs6RNQEZFHePtqDqKoHFvBGhO
OxZETJlhjzuWv669/pfnl7N/UGRfyXv9X710K8yRPL4BxXz7uE/220wH56cXz6qO
yR/2/5Myy4GGqUsbwhhlm9zdKqul7xpCXiLqYMEJkD80woqirXfLEwyXjVFFhIoF
fQQU+pmnpcjUTW25xzTOFmJyBxIMYvOFjG0eFIHn2KYD2QdRpdPwpDSlHJBqVJi4
d8PsPpG50FzRl8DSG/ifkuO2rvkyRRzWGiy3EpCAXUdrsCZkrbDEXWZ9a0SoHIBb
Wvcv4+sUMkZC1tMF+BBHQqDp4XTPuTbZZyqGseW1iGUbTG7acRvRF7cVziZOfF15
huzCP+EWdzIjU0j8inxv
=067o
-----END PGP SIGNATURE-----

--=-24E/TCKH5xcUivb7UF5c--

