Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab2IKEnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 00:43:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab2IKEny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 00:43:54 -0400
Date: Tue, 11 Sep 2012 14:43:43 +1000
From: NeilBrown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Alasdair Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v10 0/8] Block cleanups
Message-ID: <20120911144343.6148050d@notabene.brown>
In-Reply-To: <20120906234805.GD9426@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
	<20120906234805.GD9426@google.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8emAo+PhD2f90fcVY5=r3k5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8emAo+PhD2f90fcVY5=r3k5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Sep 2012 16:48:05 -0700 Tejun Heo <tj@kernel.org> wrote:

> Hello, guys.
>=20
> (cc'ing Jens, Alasdair and Neil)
>=20
> On Thu, Sep 06, 2012 at 03:34:54PM -0700, Kent Overstreet wrote:
> > Screwed up the bio_reset() patch in the last patch series when I went t=
o edit
> > the description, fixed that here.
> >=20
> > Only other change is the dm patch - made the front_pad conditional on
> > DM_TYPE_BIO_BASED.
> >=20
> > Kent Overstreet (8):
> >   block: Generalized bio pool freeing
> >   block: Ues bi_pool for bio_integrity_alloc()
> >   dm: Use bioset's front_pad for dm_rq_clone_bio_info
> >   block: Add bio_reset()
> >   pktcdvd: Switch to bio_kmalloc()
> >   block: Kill bi_destructor
> >   block: Consolidate bio_alloc_bioset(), bio_kmalloc()
> >   block: Add bio_clone_bioset(), bio_clone_kmalloc()
>=20
> This series looks good to me now.  If someone can ack the dm patch, I
> think it's good to go.  Jens, what do you think?
>=20
> Thanks.
>=20

I'm very happy with them from the perspective of 'md'.  Great work!

 Acked-by: NeilBrown <neilb@suse.de>

for the few patches which touch drivers/md/md.c


NeilBrown

--Sig_/8emAo+PhD2f90fcVY5=r3k5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE7Bfznsnt1WYoG5AQJ5Uw//Wn0m3tnxkfuDE/vXQi3v//WYXb4t8PTv
iqqv3Yzusjg55dxtJ0Bj43PssyYdj9YZ8c5GDL4CDPC7c0rpm88kq+Ybm4X7c3Ih
fEPq0g9lEyzKUfalZT0YP0DJYWQqlyPI51geNbPL7Pzy3AcSCeA5YPyrJAFLF6Rm
DOKLssnNL+SRJ3+/WWLJl14OrBCdAlKRuuS9NhT6njRDS0BI8WrThdD0IcBEQB8E
EuOJmHesmyy3up1jAGR+wVjB9Hj9ZZ9aNzGgVneK+M4BitvW+0PEhTLe+HFDyvN7
DEu4H/v+5QMyXfzoWVdvvoGqY4m336NuquveUwKx8QdesRJhFZDJ5/vsF/wsFT2k
0evozZvgOuQOOnEl9ADjFs3fAABIk4itSD0tV9waQ8WB06q/eT4QPnlHWs+9vlF5
wrcCkJrzmAKIfXvd7azfhSNdmhiltELTbTQKa8MK1UBYS3hmPyr/XgFl9q2hK2UP
zN7nc59Qlo+6ai56XxgfQ7WHzA+Rv7y+ScqFPvnKbxrNv8IDVzBabmQQbsw2KcsT
bQSDzo9ZmRYPLN/pBrt8l7ZTbrL8d8BYA+werLaIZrFCVwS6fwcG0YlDfQxvkaNU
JWIlRagAa8WxhH/Hz/lgbIdAh45BibkZ2S2PREiCGvccy8EhAjj0XiaDO83T1QHk
3cuhsfkTZ8M=
=hRQB
-----END PGP SIGNATURE-----

--Sig_/8emAo+PhD2f90fcVY5=r3k5--
