Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1JKJ1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:27:47 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:60035 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab1JKJ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:27:46 -0400
Date: Tue, 11 Oct 2011 20:27:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warnings after merge of the writeback tree
Message-Id: <20111011202736.2c0a7ac57a4a5c9c43564f13@canb.auug.org.au>
In-Reply-To: <20111011091725.GA31349@localhost>
References: <20111011195704.67c267dbb3c6eaaacf5d7a39@canb.auug.org.au>
	<20111011091725.GA31349@localhost>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_20_27_36_+1100_HWe=IYHnX3r.Eeac"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Oct_2011_20_27_36_+1100_HWe=IYHnX3r.Eeac
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 11 Oct 2011 17:17:25 +0800 Wu Fengguang <fengguang.wu@intel.com> wr=
ote:
>
> On Tue, Oct 11, 2011 at 04:57:04PM +0800, Stephen Rothwell wrote:
> >=20
> > After merging the writeback tree, today's linux-next build (powerpc
> > allnoconfig) produced these warnings:
> >=20
> > mm/page-writeback.c: In function 'bdi_position_ratio':
> > mm/page-writeback.c:622:3: warning: comparison of distinct pointer type=
s lacks a cast [enabled by default]
> > page-writeback.c:635:4: warning: comparison of distinct pointer types l=
acks a cast [enabled by default]
> >=20
> > Introduced by commits 6c14ae1e92c7 ("writeback: dirty position control")
> > and 8927f66c4ede ("writeback: dirty position control - bdi reserve area=
").
>=20
> Ah sorry!  The below patch should fix it. Shall I update the original
> commits in place, or append this patch as a new commit?

That choice is up to you as the maintainer of that tree.  Either works
for me (appending is easier for you and me, and the warning is not a
problem as far as bisection is concerned).

> Fix powerpc compile warnings
>=20
> mm/page-writeback.c: In function 'bdi_position_ratio':
> mm/page-writeback.c:622:3: warning: comparison of distinct pointer types =
lacks a cast [enabled by default]
> page-writeback.c:635:4: warning: comparison of distinct pointer types lac=
ks a cast [enabled by default]
>=20
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

If you do keep it separate, you could add a

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>

above your SOB line.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Oct_2011_20_27_36_+1100_HWe=IYHnX3r.Eeac
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlAwIAAoJEECxmPOUX5FE1JgP/2pZatXGEMPcFaOgTuwMRBYX
raZ2d8yE0WLoFVnYPEhIY4tcgn89qmzBXP4ScGJ1G/ZiHHAmDcPLx+JSLhUhS+0f
c7qY41b8T3VN/kNi/+qgZdRYOeEl0hxagFGKZqtR/1MXx2Rn0SgfCL32PtD2lKX0
YKpNs09whbsJDutg7oth5cMcyswZ7E4/vikzRMaL5RmFLNWYwPORmBRhV2vyubu+
57OTPYksSYs+KgcOVd+JMxb/XY0qnViKyCdZIiztfsqDkK9SIM9HHRBGo88qYrQ0
H6aFl/cixGTpqyIxOqLTzyxPHCv3xtoRDaQb5SCBxrYdYNPieyr5EBsqhGJJmsTG
y6FpLkVbWZOOwsLlHyReZ5vhVtVCQAe0ex8NdtMYuXAisozN0Nxp1O60RgGmf4eb
2obXzDxb6BrY7ryKLzZakXjvlds0dXo42iHA0wz3WV9jAyp8y7/B7p+YMr75bMZo
AeMqnwppHM4OMGEFl8aqpRJ2lMVzsj5AmyqqpB+ECc0yI+/aIYmZczt/6HUUcmjl
YP2sGSzWXK7QE5D0tWsoQVGed9W2SvwRlVq3a2dR73DOjfVI7zZbwn8sYMW1t+4B
uCpQ4LQMPLHh7iZYO4JXXhDGj3hSkUTeSvHWidDGVvT247iPW6fmJHaNmVH64mOu
LksYJ2inR32bdqQn6X2s
=76Uw
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_20_27_36_+1100_HWe=IYHnX3r.Eeac--
