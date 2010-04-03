Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0DCAHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 20:07:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48579 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab0DCAHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 20:07:18 -0400
Date: Sat, 3 Apr 2010 11:07:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/17] mfd: update gfp/slab.h includes
Message-Id: <20100403110706.e7557a4c.sfr@canb.auug.org.au>
In-Reply-To: <20100402162546.GL8010@sortiz.org>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-13-git-send-email-tj@kernel.org>
	<20100402101159.GC8010@sortiz.org>
	<20100402160855.GA15928@rakim.wolfsonmicro.main>
	<20100402162546.GL8010@sortiz.org>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__3_Apr_2010_11_07_06_+1100_j4l3Xg2=pGxASHft"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__3_Apr_2010_11_07_06_+1100_j4l3Xg2=pGxASHft
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel, Mark,

On Fri, 2 Apr 2010 18:25:47 +0200 Samuel Ortiz <sameo@linux.intel.com> wrot=
e:
>
> On Fri, Apr 02, 2010 at 05:08:55PM +0100, Mark Brown wrote:
> > On Fri, Apr 02, 2010 at 12:12:00PM +0200, Samuel Ortiz wrote:
> > > Hi Tejun,
> > >=20
> > > On Tue, Mar 30, 2010 at 02:52:40AM +0900, Tejun Heo wrote:
> > > > Implicit slab.h inclusion via percpu.h is about to go away.  Make s=
ure
> > > > gfp.h or slab.h is included as necessary.
> > > The davinci MFD driver is sitting in Mark's tree, so I guess he shoul=
d take
> > > this patch.
> > > Mark, feel free to add my:
> > > Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> >=20
> > > to this patch.
> >=20
> > Unfortunately drivers/gpio/rdc321x-gpio.c isn't in mainline yet so the
> > patch doesn't apply cleanly to ASoC either.  I've applied the DaVinci
> > hunk, the other will need to go via your tree.
> Thanks, I'm pushing the rdc321x part.

Thanks, guys.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__3_Apr_2010_11_07_06_+1100_j4l3Xg2=pGxASHft
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku2hqoACgkQjjKRsyhoI8wrqQCcDF+EPz8LwAMybABld8uDPcr/
2CQAoKUxtfo0rg4dodh+X3WFCW/+6ksV
=tACF
-----END PGP SIGNATURE-----

--Signature=_Sat__3_Apr_2010_11_07_06_+1100_j4l3Xg2=pGxASHft--
