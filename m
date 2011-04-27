Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214Ab1D0NMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:12:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49659 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759118Ab1D0NMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:12:53 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <4DB7FBD8.20109@suse.cz>
References: <1303580576.4815.3.camel@localhost>  <4DB7FBD8.20109@suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-mkjVeT0/pHGtJ/Z5lGkW"
Date: Wed, 27 Apr 2011 14:12:38 +0100
Message-ID: <1303909958.3032.407.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] kconfig: Avoid buffer underrun in choice input
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mkjVeT0/pHGtJ/Z5lGkW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-04-27 at 13:19 +0200, Michal Marek wrote:
> On 23.4.2011 19:42, Ben Hutchings wrote:
> > commit 40aee729b350672c2550640622416a855e27938f ('kconfig: fix default
> > value for choice input') fixed some cases where kconfig would select
> > the wrong option from a choice with a single valid option and thus
> > enter an infinite loop.
> >
> > However, this broke the test for user input of the form 'N?', because
> > when kconfig selects the single valid option the input is zero-length
> > and the test will read the byte before the input buffer.  If this
> > happens to contain '?' (as it will in a mips build on Debian unstable
> > today) then kconfig again enters an infinite loop.
> >
> > Signed-off-by: Ben Hutchings<ben@decadent.org.uk>
> > Cc: stable@kernel.org [2.6.17+]
> > ---
> > Roman has failed to respond to this after 5 weeks and one reminder, so
> > please take it directly.
>=20
> I applied this on 8th April, see
> http://www.spinics.net/lists/linux-kbuild/msg04431.html.

Sorry, I forgot that.

> Please check=20
> linux-next before reposting patches next time, now I either have to=20
> rewind the kconfig branch or let Linus merge it with a duplicate commit :=
-(.

But the fix belongs in this release (2.6.39), not the next.  So I looked
in Linus' tree.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-mkjVeT0/pHGtJ/Z5lGkW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATbgWRue/yOyVhhEJAQqszw//f3ffnu13sN3XtvlSHGnxP/7ojBJGhr/8
s2N7l94IVbrivd0HRB2q771UxTaCCtAVLnOvDZdapfqqRQEdT1Nd8i0Clk5rFsxe
7U70dMsVGPEQWExuptxa51vdfi8svOT6whj9Ty0wJNWK76UrBDuITK+MoQxYutP+
NjdlH0din0rxxa6DoYKB87ZbNRPAzl64332zTUwIV5B8bPPH5P4XzcKM1vFnBUEz
q50MRoInqepm3DpLwfLN6eC49vBGLosjqlwxCnPy8HpFjNImtA3q1R9uRyWSrMVo
hoAl7khJcYMO0pFObJiLuI8EK1hJYEtxhVwGBrmtBzrFO8mFI0G3MqgkbRd/xG3i
DWnlf2lxmQmW+xC8E+/ppl/wQ1XJ/89sRTCm7W4ng93+1wo+ddUNrPiVvRf2QQUa
iAHHho9ltHh+eh2jqiAcbEuXKGERVpislj1fJN06hbN7RH3yk8NwDWoGtDHjZ2NR
XoF+G/bx/B4Z54dYosmK/7yQK24X7Kq4FuxxgyXldDpxefjyJfSfuQ/b/0ko7GJL
wv4+4N07Q8yXyhh0qMOav3ZEq//Ty9qKm6QRAXGBfaJ8EvKUyn8Kb1XIy+eLeksW
ESn2SrIy6vhVOyjVs9/x7LpxveaRHwikGo1q3V56QFdGq+iTf+3G2vHRMtvA9kJp
x9zmlUr+S3Y=
=21Qe
-----END PGP SIGNATURE-----

--=-mkjVeT0/pHGtJ/Z5lGkW--
