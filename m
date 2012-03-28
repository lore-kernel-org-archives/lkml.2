Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750826Ab2C1EHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 00:07:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab2C1EHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 00:07:17 -0400
Date: Wed, 28 Mar 2012 15:07:07 +1100
From: NeilBrown <neilb@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the md tree
Message-ID: <20120328150707.0e59c7c8@notabene.brown>
In-Reply-To: <20120328143204.134662a493ade33ddd523821@canb.auug.org.au>
References: <20120328143204.134662a493ade33ddd523821@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/R_qGJJf4cVHMR3gltFpYWMr"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/R_qGJJf4cVHMR3gltFpYWMr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Mar 2012 14:32:04 +1100 Stephen Rothwell <sfr@canb.auug.org.au>
wrote:

> Hi Neil,
>=20
> After merging the md tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> drivers/md/raid5.c: In function 'analyse_stripe':
> drivers/md/raid5.c:3209:33: error: 'struct stripe_head' has no member nam=
ed 'devs'
>=20
> Caused by commit 85e25cfc6bed ("md/raid5: fix handling of bad blocks
> during recovery").
>=20
> I have used the version of the md tree from next-20120327 for today.

Sorry 'bout that.  I noticed not long after I had pushed out for-next and
fixed it.  You must have pulled during that window :-(

Thanks,
NeilBrown

--Sig_/R_qGJJf4cVHMR3gltFpYWMr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3KOaznsnt1WYoG5AQKQuQ//Z/jmZ23dbIHSyHks0BMN4Zz5gvAi+8xF
WuHOBFT3a9ZY5qVwvNdppyTzS9BOo9d07UxI67SHzmU4IRpXxJ4qnfQrCRQIIVGI
b2eRdk3GpGZUdNQZvocr4yKuQUTv5/ArdNdx5ZXXbQVFDIWz/+uetUvh0XjZjazQ
3l7fO1uuvBy+110Ts0HQ5OItXPQa3MYj48l+PpnRYaPLLEnHIqUKoDNOl22G1VnB
isvFASyEhKTqqZ//n63BmeCwIbdVskkuPjEcr2PN74+vKbbVPPCU9b/jdMujnvPk
hzU3pg3cPffNQDP44qI60haU3fpDCPG7wDC7zMOzHJkhPv5yb3EFrE/GnDliqFc2
eALLliHQ3he6EytbOfON2ONapwqVYbOsuvZyYDqVUY30dN+1UBYkn+EZg0rsBP6I
pgM+WaLhEL81eTMkZBXrXlbEeH0XItV57zGHKt3bPYhHpuoRKy48TAVhpqcduwZY
BLmuhqm/c89W/oy9xeNDMU7cnkCGqtWLe3bZCmJn0PjjS0/s6s2boiPQD3BHS0kr
+eOQPfu4oTPKSi2qtdiHWAazGz4kcPqrOOQf1+3AtFe6zDxRdXGelRE9olaD4RAa
9abfKOufixlPukEP2nNTKYqAoCGhd1KmunI0mc9/1q9zkX+Xgw9R1u4ch5RDp2I0
rQ7QZcW01nw=
=xp6O
-----END PGP SIGNATURE-----

--Sig_/R_qGJJf4cVHMR3gltFpYWMr--
