Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1CPXbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 19:31:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49252 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab1CPXbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 19:31:40 -0400
Date: Thu, 17 Mar 2011 10:31:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>
Subject: Re: linux-next: build failure after merge of the final tree (block
 tree  related)
Message-Id: <20110317103131.6c6be7a5.sfr@canb.auug.org.au>
In-Reply-To: <4D79CB66.2020302@kernel.dk>
References: <20110311175830.29a387b2.sfr@canb.auug.org.au>
	<4D79CB66.2020302@kernel.dk>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Mar_2011_10_31_31_+1100_bSuDZTQECf/l=Ewm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Mar_2011_10_31_31_+1100_bSuDZTQECf/l=Ewm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Fri, 11 Mar 2011 08:12:38 +0100 Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2011-03-11 07:58, Stephen Rothwell wrote:
> >=20
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >=20
> > drivers/char/tpm/tpm_tis.c:96: warning: 'is_itpm' defined but not used
> > drivers/block/drbd/drbd_bitmap.c: In function '__bm_change_bits_to':
> > drivers/block/drbd/drbd_bitmap.c:1287: error: implicit declaration of f=
unction 'generic___test_and_set_le_bit'
> > drivers/block/drbd/drbd_bitmap.c:1289: error: implicit declaration of f=
unction 'generic___test_and_clear_le_bit'
> > drivers/block/drbd/drbd_bitmap.c: In function 'drbd_bm_test_bit':
> > drivers/block/drbd/drbd_bitmap.c:1438: error: implicit declaration of f=
unction 'generic_test_le_bit'
> >=20
> > Caused by commit 4b0715f09655 ("drbd: allow petabyte storage on 64bit
> > arch").
> >=20
> > I have applied this patch for today (surely there is a better way):
>=20
> Thanks for not dropping it, I'll let the drbd guys send in a proper fix
> and get it committed.

Ping?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Mar_2011_10_31_31_+1100_bSuDZTQECf/l=Ewm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNgUhTAAoJEDMEi1NhKgbshu8H/R2uopYWplW5UvRNsfvBTYxL
gDteVNyNV/qYagK9B42b4M9pbcn6tzJxQcr0LpT8ApMhfQ/hWt/3eJzB/FNNY0ws
vxZT87W7U3rGl5JHOameYIURKs43cqQutZ3RyEHbSZQsGpnD2ghDMt9EckBhBnII
WoZ0ch74Ch3MghJ9RU+R29SwDdFm62vUC4NgtbmmqV+z71ohtFxjQ5yvKonrIQTi
aCmP8KZOudj32+TjSHL3GuGba/G1yRvQI1PARjTL8QNWjWHr7aBOiJHQkaX+nlla
fa9rRbdCFcmwCmm/z61Ex8kASgJQe5bce1WHzxjmJflj349vSeb0uytWVIh01xI=
=4OQO
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Mar_2011_10_31_31_+1100_bSuDZTQECf/l=Ewm--
