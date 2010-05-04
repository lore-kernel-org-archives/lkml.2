Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab0EDV0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 17:26:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52436 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab0EDV0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 17:26:51 -0400
Date: Wed, 5 May 2010 07:26:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
Message-Id: <20100505072645.abdee42d.sfr@canb.auug.org.au>
In-Reply-To: <1272991333.4813.1.camel@c-dwalke-linux.qualcomm.com>
References: <20100504110725.0b44d877.sfr@canb.auug.org.au>
	<1272991333.4813.1.camel@c-dwalke-linux.qualcomm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__5_May_2010_07_26_45_+1000_A3rjgrnLnqzZSXg6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_May_2010_07_26_45_+1000_A3rjgrnLnqzZSXg6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Tue, 04 May 2010 09:42:13 -0700 Daniel Walker <dwalker@codeaurora.org> w=
rote:
>
> On Tue, 2010-05-04 at 11:07 +1000, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the msm tree got a conflict in
> > arch/arm/mach-msm/Kconfig between commit
> > 4b53eb4f5d78416456bb969ce30e3bed2731d744 ("arm: msm: allow ARCH_MSM to
> > have v7 cpus") from the arm tree and commit
> > e17047ea51cc2eac3e920e5a669f99efd44f446f ("arm: msm: smd: use either
> > package v3 or v4 not both") from the msm tree.
> >=20
> > I fixed it up (see below) and can carry the fix as necessary.
>=20
> Ok .. I'll merge the changes in Russell tree into my tree, that should
> fix it I think.

OK, thanks.  For simple things like this, I have no problem carrying
fixes until they are repaired in the normal course of events.  "git
rerere" does all the work for me.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__5_May_2010_07_26_45_+1000_A3rjgrnLnqzZSXg6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvgkRUACgkQjjKRsyhoI8wM6ACgrVDoBybv6nE5Hsw7xMQVyfm+
qrgAoLJLF/LUiXcjAFwO9DwPVJUGPiiW
=MY9O
-----END PGP SIGNATURE-----

--Signature=_Wed__5_May_2010_07_26_45_+1000_A3rjgrnLnqzZSXg6--
