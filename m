Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0C3WjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:39:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56423 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab0C3WjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:39:21 -0400
Date: Wed, 31 Mar 2010 09:39:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] libata: update gfp/slab.h includes
Message-Id: <20100331093915.98479e39.sfr@canb.auug.org.au>
In-Reply-To: <4BB22EBB.1070507@pobox.com>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-16-git-send-email-tj@kernel.org>
	<4BB22EBB.1070507@pobox.com>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__31_Mar_2010_09_39_15_+1100_vbN5C8j2VEmjcFua"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__31_Mar_2010_09_39_15_+1100_vbN5C8j2VEmjcFua
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

On Tue, 30 Mar 2010 13:02:51 -0400 Jeff Garzik <jgarzik@pobox.com> wrote:
>
> On 03/29/2010 01:52 PM, Tejun Heo wrote:
> > Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> > gfp.h or slab.h is included as necessary.
> >
> > Signed-off-by: Tejun Heo<tj@kernel.org>
> > Cc: Stephen Rothwell<sfr@canb.auug.org.au>
> > Cc: Jeff Garzik<jgarzik@pobox.com>
> > ---
> >   drivers/ata/ahci_platform.c |    1 +
> >   drivers/ata/libahci.c       |    1 +
> >   2 files changed, 2 insertions(+), 0 deletions(-)
>=20
> applied

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__31_Mar_2010_09_39_15_+1100_vbN5C8j2VEmjcFua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuyfZMACgkQjjKRsyhoI8xkIgCglML3eMc55R1/I+dWsPvjpZz2
LDgAoKBKh7A1G8f397RBrC3G50qdoTxd
=rOuR
-----END PGP SIGNATURE-----

--Signature=_Wed__31_Mar_2010_09_39_15_+1100_vbN5C8j2VEmjcFua--
