Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153Ab2KNFY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:24:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48271 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2KNFY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:24:58 -0500
Date: Wed, 14 Nov 2012 16:24:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
Message-Id: <20121114162448.e2b05b1be8c62bcb64cc7d42@canb.auug.org.au>
In-Reply-To: <20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
	<20121016134129.2fcd7c8ebe1235065aea929e@canb.auug.org.au>
	<CA+55aFzz66Y1MtOoqEMrQCVzdL-2pgr43e1sXUa=eM5GXL9XSA@mail.gmail.com>
	<20121020180436.c42b7325431fe87104b008fa@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Nov_2012_16_24_48_+1100_o8kaMzl7r5pOY=LX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Nov_2012_16_24_48_+1100_o8kaMzl7r5pOY=LX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all again,

On Sat, 20 Oct 2012 18:04:36 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Tue, 16 Oct 2012 07:50:52 -0700 Linus Torvalds <torvalds@linux-foundat=
ion.org> wrote:
> >
> > On Mon, Oct 15, 2012 at 7:41 PM, Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> > >>
> > >>   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git kv=
mtool/for-linus
> > >
> > > So you have not taken this in the v3.7 merge window.
> > >
> > > Will you ever merge this?
> >=20
> > I have yet to see a compelling argument for merging it. It's tons of
> > code, it doesnt match the original "small simple" model, and I think
> > it would be better off as a separate project.
>=20
> So are there any compelling arguments from the proponents, or can I
> remove this from linux-next (and have it removed from the tip auto-latest
> branch)?

So, where did we get to?  I *think* the consensus was that the KVM tool
did not need to be in the kernel tree, right?  In which case:

	1) I need to remove the kvmtool tree from linux-next
	2) the same code needs to be removed from the tip tree

hmm?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__14_Nov_2012_16_24_48_+1100_o8kaMzl7r5pOY=LX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQoysgAAoJEECxmPOUX5FE00gP/0qL6qsJxho479VubeMIX/Zz
/BI28bvlz1E6JoDiYdbAX4JZzrewfUIcIxugXmgNYZXOu8HEq3q2ePuMUt+i0TpT
q86N8HRoroxxvWgQgNSbe9Ux5yJb+YcokKJTLonN9A3XvesTnH+9JTfd1LYPARj/
BURhH76IWUXbX+emJEX3/y/FbWrWHi1hosoTEXrsYVWZ47sEizCMfVjIhhdp0hdh
ghpUGzUl/mDHXWj+jWXKO/AmcSc9maqWfzKpNskyj/tnYyksnWZ2rOqyJpz9UuOK
sAij9qjOdnRVB3iALAjw2YOJirrS/f57K4xC4iWqcJvUCxiIx+n+V+gPNxJO4ycd
B3GjikjHIWOzCgFjfr94g1iVMcmQd83KVD/Ss+gOIzm7TfmIEn1sUbQnkcYS0wan
Taj2UcUrnqNDVghUkAbSCsmgoK9ZcYRt+N/W/WwWJG5B/oLiRUXBAeJVeGQFeplC
ztzjOZJDYvTsf7z79qijjwHZTvh6N4WkGRmdOTtkbqe3i0ne8czCBKb7K0TabKWL
RGTxuckEyFpcJIW/BnpPsRvmQzKPzwUwicQR9QjRLpCFvuS0LqaRogDHYqHvTEtD
Z7tEOeGyBRtNdHrkeKbCDViXSfcP+u/Ku8lKdiyyAyHeYZpIsPfR4Bywm0UcEkAu
v79214ZxswDDR9X9rklo
=5ywe
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Nov_2012_16_24_48_+1100_o8kaMzl7r5pOY=LX--
