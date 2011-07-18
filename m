Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1GRJhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 05:37:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38852 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab1GRJhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 05:37:15 -0400
Date: Mon, 18 Jul 2011 19:36:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ondrej Zary <linux@rainbow-software.org>
Subject: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-Id: <20110718193646.33fb3f41db9d84974913657d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jul_2011_19_36_46_+1000_lXeCts7Q5dtQX6FO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jul_2011_19_36_46_+1000_lXeCts7Q5dtQX6FO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allysconfig) failed like this:

In file included from drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c:26=
:0:
drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: In function 'ft1000_read_reg=
':
drivers/staging/ft1000/ft1000-pcmcia/ft1000.h:80:2: error: implicit declara=
tion of function 'inw'
drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: In function 'ft1000_write_re=
g':
drivers/staging/ft1000/ft1000-pcmcia/ft1000.h:86:2: error: implicit declara=
tion of function 'outw'
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jul_2011_19_36_46_+1000_lXeCts7Q5dtQX6FO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOI/6uAAoJEDMEi1NhKgbsGjMH/AnYoBMMRm/nVY2/CX6fz71r
DQfA2Ha3PxyGCtQZBTeinISIR90RPKuyPRm4XjfJ4dl4luhNtK2htg/qwPEimS+/
XxiY2zQ/KDBc3uuvYtNzYLXYxRXcm3KYQx2hcUu0wBBvrMnxreZJQ7mwlj+z/eAZ
Nilen2GWB7BwDrRIHwu1b7k/8mQegiEu6sLongJa21LSA3k+XRTZW827KgZdGid/
21t53ATlLWaOGO7T5wbW2zZVbBNTS5/h2CVrTP19Cn5jpjLToXVRKRrr6h3mnQbl
B1fvCe44Q+G07IHdR3zUjgsQbUl1k2pWNEtIq78zzaTnwWxx+t6OXaOJSZ9sHXI=
=c+sM
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jul_2011_19_36_46_+1000_lXeCts7Q5dtQX6FO--
