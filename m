Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0C2Xbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 19:31:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49168 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab0C2Xbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 19:31:35 -0400
Date: Tue, 30 Mar 2010 10:31:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 09/17] pcmcia: update gfp/slab.h includes
Message-Id: <20100330103129.b76a70e3.sfr@canb.auug.org.au>
In-Reply-To: <20100329193203.GA8450@comet.dominikbrodowski.net>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-10-git-send-email-tj@kernel.org>
	<20100329193203.GA8450@comet.dominikbrodowski.net>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__30_Mar_2010_10_31_29_+1100_j0GwR2J9BE8V8F+_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Mar_2010_10_31_29_+1100_j0GwR2J9BE8V8F+_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dominik,

On Mon, 29 Mar 2010 21:32:03 +0200 Dominik Brodowski <linux@dominikbrodowsk=
i.net> wrote:
>
> On Tue, Mar 30, 2010 at 02:52:37AM +0900, Tejun Heo wrote:
> > Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> > gfp.h or slab.h is included as necessary.
> >=20
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>

The plan here is for you to put this in your tree now.  It is safe to do
so and Tejun can't carry it because this does not apply to mainline.=20

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__30_Mar_2010_10_31_29_+1100_j0GwR2J9BE8V8F+_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuxOFEACgkQjjKRsyhoI8wdKgCgnGfQHcxCNklpPiYp/3hFTowc
mj4An35Bf9Gri74vvmfHyetbfYh4tK7L
=EekT
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Mar_2010_10_31_29_+1100_j0GwR2J9BE8V8F+_--
