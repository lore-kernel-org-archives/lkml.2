Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab2F0JPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:15:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:47305 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab2F0JO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:14:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="158712815"
Message-ID: <1340788739.29342.5.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2 1/7] affs: stop setting bm_flags
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Date: Wed, 27 Jun 2012 12:18:59 +0300
In-Reply-To: <CAMuHMdXW80+jyp3te+uG+=kE5sCs=wRgKzE4CXAZVe3xGdFpmw@mail.gmail.com>
References: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
	 <1338998217-5010-2-git-send-email-dedekind1@gmail.com>
	 <CAMuHMdXW80+jyp3te+uG+=kE5sCs=wRgKzE4CXAZVe3xGdFpmw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-1Fd11qzwP1NN9/fort5q"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1Fd11qzwP1NN9/fort5q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-06-16 at 20:49 +0200, Geert Uytterhoeven wrote:
> > I could not find good documentation describing this field, except of on=
e random
> > piece of documentation in the internet which says that -1 means that th=
e root
> > block is valid, which is not consistent with what we have in the Linux =
AFFS
> > driver.
>=20
> The book "Amiga Intern" (German version on the 'net, which is faster to a=
ccess
> than the Dutch version somewhere in my attic ;-) agrees with this ("Diese=
s Flag
> enth=C3=A4lt -1 (TRUE), wenn die Bit-Map der Diskette g=C3=BCltig ist").

Thangs Geert for confirming.

--=20
Best Regards,
Artem Bityutskiy

--=-1Fd11qzwP1NN9/fort5q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP6tADAAoJECmIfjd9wqK0FZ8P/0OVW3Z2BWvKH8tDFID6GoiX
7flMWnaBXLxajnmXGUtrz9v/lPiEmbEIMnH0TmC5LLesgDkZk6+6SSCeHwIViJpi
t9mjFOF90HC/V8mMMX5szSZhBDs6tzK0+Ryx32X5vpg+sdC4+O4K7J5JTM4ulhXg
aaca3rR+tjV7QiDJdjrUx3C7JAIO4WIyzx6zB68hmbj6m7V9/4fA+p/ZNyOzUmXm
hrGPO/dakGgefLVXyvnEoRJ3dFkKBkCu96Ij+14SXqX2qo2C+H7VJ1Stc4Pyg5iv
MqIhOk0aRyvGJsAsN3mrUnQrC1+go2iMRhgi2/O8KOtigG2jz/pJiXBFiJvp1uV8
QXTLQcnpCMlYsIR3u3eCvgxs/9DFv7/zF12jksS+0FPXA+CCuQDfWcwkkOgqLYvk
iIfte1UnOGjR9cYn/pGUSAxcEnzKR0sEDb9Jc4ttSo4v43kenzQgL84Ofqr6KPqQ
qOKmWbxh6sxy8D8qYX+5b8pVle29uqAhNWoBDJe+Ait8Jyj9L2OOXlVwi6d+f9Je
tqMmv+8Jex12QtbIhUWuOFr+80xxNdsRzAxlfg/ujLZRb/np0EAF8U+v8wqAKuFz
31YRgMsafKDBg0tEIRhLCy2f8MN25mOxBibyinjimYd6rYh5kf+TTdJ1JLiHXwBY
3dnioSUJNcrA3eVLA486
=V/B1
-----END PGP SIGNATURE-----

--=-1Fd11qzwP1NN9/fort5q--

