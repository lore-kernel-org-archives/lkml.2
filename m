Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab1HDVy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 17:54:28 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:34242 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab1HDVyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 17:54:21 -0400
Date: Thu, 4 Aug 2011 18:54:13 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Nitin Gupta <ngupta@vflare.org>
Subject: Re: linux-next: Tree for Aug 4 (zcache)
Message-ID: <20110804215412.GE2919@nautilus.holoscopio.com>
References: <20110804145834.3b1d92a9eeb8357deb84bf83@canb.auug.org.au>
 <20110804142437.34e3a1ae.rdunlap@xenotime.net>
 <20110804214441.GA697@kroah.com>
 <20110804145145.4af47989.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="924gEkU1VlJlwnwX"
Content-Disposition: inline
In-Reply-To: <20110804145145.4af47989.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--924gEkU1VlJlwnwX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 04, 2011 at 02:51:45PM -0700, Randy Dunlap wrote:
> On Thu, 4 Aug 2011 14:44:41 -0700 Greg KH wrote:
>=20
> > On Thu, Aug 04, 2011 at 02:24:37PM -0700, Randy Dunlap wrote:
> > > On Thu, 4 Aug 2011 14:58:34 +1000 Stephen Rothwell wrote:
> > >=20
> > > > Hi all,
> > > >=20
> > > > Just in case anyone needs reminding:  Please do not add anything de=
stined
> > > > for v3.2 into linux-next included trees until after v3.1-rc1.
> > >=20
> > >=20
> > > on i386:
> > >=20
> > > drivers/built-in.o: In function `zcache_pampd_create':
> > > zcache-main.c:(.text+0x159b8f): undefined reference to `__udivdi3'
> >=20
> > Very wierd, what would cause that?
>=20
> I don't see what's weird about it.
>=20
> Probably one of these divisions:
>=20
> 		if (curr_pers_pampd_count >
> 		    (zv_page_count_policy_percent * totalram_pages) / 100)
> 			goto out;
>=20
> or
>=20
> 			zv_mean_zsize =3D xv_get_total_size_bytes(cli->xvpool) /
> 						curr_pers_pampd_count;
>=20

The second one. xv_get_total_size_bytes returns u64. I am just
compile-testing a fix.

>=20
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code =
***


--924gEkU1VlJlwnwX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOOxUDAAoJEEWxSg7udFZI34kP/RNVistdtE2QXbHtpV5FXonm
9Fv+djhhU4qmuk47kLVxZwnwjzgdLBjAdCKANaLtW3telLJ2lctXdyUoIc6YG0ZN
MXVUX102aas91mnshzy6ObaazNdaCJrbomCwLgEBopXY0I5QCwpGhG9LF+Gf6wGb
7sGU6DQYFA9XoNWLiGKaHDQxGomhvAssYN4DLWUTXuFNXgta73tHvHFjGiGh7br7
8wLiHx6+9K1arDSUP/B79JNzNvESZWSyvWqoYwmQ+0kUO2yH7tCjCPwyAjvM+21D
BYEAhKtF7zkZLHwAlgmpADIiq6A62IueoiY8sbmP4xnsBa1E1I0Lyf/WeMvzZ7cl
LqiZmyApPKUx3NQZJ7HxWEUUuAQBXynjfMaOhTwUYEtbJVjGsEXLBK77I1325hqH
Di0AP6qjTxmBD3rhHsdWO9uQzxWSEHbqoFShXA6xyccjQ4PrQaScannIwS5ZThT6
d83dAwlR7FExzbekQIZnCZ2ZDOXlY+cnqSntRo/kZYAI3b/hBRRlE+X2hHpTZbNe
b54xKW5hrVFZ8tlmeZRLwRUGe7mrG0it7I03oZP5/pUapvAe+goNWEeORzPbaOK1
xerqUOWyCBUsffyKsJQZlppOuDGm6nvEdrYkXKu5ivqoEEt7W3J9FT5pBEttw12r
VY/e4Zifsl7aNyxbHmun
=sRt6
-----END PGP SIGNATURE-----

--924gEkU1VlJlwnwX--
