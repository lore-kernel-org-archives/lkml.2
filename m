Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab1J2Gur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 02:50:47 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:43321 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1J2Gup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 02:50:45 -0400
Date: Sat, 29 Oct 2011 17:50:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Teigland <teigland@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: currently missing kernel devel trees
Message-Id: <20111029175029.cd25e5eb99b255a06e355abc@canb.auug.org.au>
In-Reply-To: <20111026204515.GA29207@redhat.com>
References: <20111013174358.b20fedb97c7b53db2ba82ff6@canb.auug.org.au>
	<20111026204515.GA29207@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__29_Oct_2011_17_50_29_+1100_z1Gv/ZKdm+ODQFWj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__29_Oct_2011_17_50_29_+1100_z1Gv/ZKdm+ODQFWj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Wed, 26 Oct 2011 16:45:15 -0400 David Teigland <teigland@redhat.com> wro=
te:
>
> On Thu, Oct 13, 2011 at 05:43:58PM +1100, Stephen Rothwell wrote:
> > dlm
>=20
> Just restored as linux-dlm (no commits for 3.2)

I am now using the "next" branch of
git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git (it
used to be .../dlm.git).  But it is, as you say, empty, so I guess it the
the right thing.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__29_Oct_2011_17_50_29_+1100_z1Gv/ZKdm+ODQFWj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOq6I1AAoJEECxmPOUX5FEFOEP/0H7JXpwNqvItRrOOImmDKoA
rcOoSwmMXE3M/K927zLHbYe0/w45ZoL//gnU24joVSrI9Baa3u15qR48kRrpwjKd
L+ioy6Bm5v4lVJMAz61uOOjl9Q5pUcSLTrfUuouL9cMOPIjm6fI1zsyhR5n4dXDG
YL8APinALC6mABzGldh9rymi4UxwR4eWB6qhPXkgWkLWh3vS2I7YY7kiA3XAAgjl
laLwADPwD/nNM07FXAF+BaRA4ViaVFkQvlBLDEh1JLKCY8Hv2MsJcvh7K8bqKVwk
mOI9rUGvC6jk80ORfZP+NzWdTVrK34Ydd50cImXk7PPpTv1eDjygXXc1VSTWFcQP
UH6/Q+byo4CTJYaOW6A/xrhtKnGqFygwd8aphAucGb8SAKfI5oyQUj7JbwXhEPG6
xLKX/Fzy/OphzH26b0ntQFRYI9mantd0mOotUpccQWlO0tjZGcCfx//89Tq9S10D
PgYpQBjriDMZa5rETbHe+pZY2t2JNnDyimZ8H03TArTVIxB3rYUW+PoRD2ld65XV
dcicFG7yak4mrCl+3JEG3CGDO1RINMjyWzTYmqGbgqQ3kusxH6KpPR6oXPPmNtHF
XvcPGmee72Q8ubdsYXzhMSeTFUSQDA6FGAHS6tdF2xGXwRSMD9p3evp8P3op8dvU
25y90NYoQ2zMNrBm0YMn
=C7gb
-----END PGP SIGNATURE-----

--Signature=_Sat__29_Oct_2011_17_50_29_+1100_z1Gv/ZKdm+ODQFWj--
