Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab1CAXOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:14:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49633 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757298Ab1CAXOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:14:06 -0500
Date: Wed, 2 Mar 2011 10:13:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the bkl-config tree with the tty
 tree
Message-Id: <20110302101357.7d2a3d81.sfr@canb.auug.org.au>
In-Reply-To: <201103012324.27725.arnd@arndb.de>
References: <20110228174007.b6faf01e.sfr@canb.auug.org.au>
	<201103012324.27725.arnd@arndb.de>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Mar_2011_10_13_57_+1100_MH9D7RK5fo5Bewch"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Mar_2011_10_13_57_+1100_MH9D7RK5fo5Bewch
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Tue, 1 Mar 2011 23:24:27 +0100 Arnd Bergmann <arnd@arndb.de> wrote:
>
> I have cleared the branch in my repository now, since the contents
> were very outdated. I have a newer branch named 'final' with all the patc=
hes
> that are needed on top of -next to kill the BKL for good.

Thanks for that.

> I'll send the patches out for review again and if everyone is happy,
> I can update the config branch so they get into -next.

So can I remove the bkl-trivial, bkl-llseek and bkl-vfs trees?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Mar_2011_10_13_57_+1100_MH9D7RK5fo5Bewch
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNbX21AAoJEDMEi1NhKgbsUeMH+gPed1pVafgryq0txT7kHfDR
xnE/D/XnX24Qh8HQuHaFTdNgwitOyz3pshcXu+r7AJSGGbMxg/yIM0kGPc4j4gro
GVga8YQOjWV6hfFIoUY44I/WCwYG1seo/ay24elEdaZwz7tnBjFw1FLUuq3+xRpj
dDrSeRs3yxOHFfXmXR2cvTNptey9VLJ7yHVGUBk7Ra/tU5K1NMJZ6c7rwsPs8y/b
PK5NwVp5B05OytTJJHrVww9emLoUhgUUi2mi6QFMs5yWbm/8SaiHeds7IlOSWkwd
DuhlhRpA9XWQAvSTICwKK2pvcwxClqh7XGbXVeneZgo+4k9p93o8dcG7DBksMVU=
=8yHa
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Mar_2011_10_13_57_+1100_MH9D7RK5fo5Bewch--
