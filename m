Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820Ab1EXVw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:52:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41100 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933755Ab1EXVw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:52:56 -0400
Date: Wed, 25 May 2011 07:52:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
        Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20110525075230.da671a0e.sfr@canb.auug.org.au>
In-Reply-To: <20110524124833.GB31776@kroah.com>
References: <20110520161816.dda6f1fd.sfr@canb.auug.org.au>
	<BANLkTimjzzqTS1fELmpb0UivqseLsYOfPw@mail.gmail.com>
	<20110524025151.GA26939@kroah.com>
	<20110524135930.bb4c5506.sfr@canb.auug.org.au>
	<20110524124833.GB31776@kroah.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_May_2011_07_52_30_+1000_gAJguTc_PC6AUYGI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_May_2011_07_52_30_+1000_gAJguTc_PC6AUYGI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 24 May 2011 05:48:33 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Tue, May 24, 2011 at 01:59:30PM +1000, Stephen Rothwell wrote:
> >=20
> > The cause was a patch from Linus ...
>=20
> Ah, ok, that makes more sense, sorry for the noise.

And it doesn't show up in many builds because musb depends on ARM ||
(BF54x && !BF544) || (BF52x && !BF522 && !BF523).  So it probably appears
in some of the overnight builds, but not the ones I do while creating
linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_May_2011_07_52_30_+1000_gAJguTc_PC6AUYGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3CieAAoJEDMEi1NhKgbs86cH/1yLYRVQyjBOXJfZTaRUJo4Y
aVUNOctPKJ1Tgt56GfV/QRQ/F7cqpY8qgEqy726wMEuPFJnpdYcqrqlGRr6eCs26
A2OlCctyr8BeXMlBk4MwCT2C6WJoJy/nY7ey7wNszkSqB+z/1KzjY63FYQrvyh9V
eqyv5A7GZmPOq60fNsm+Rns090SwrKGuvtHKYnLUFDaGhx20u745gLDw5J7LvCvS
FjbHb0XoT0RAxNY7VoPkYF0A8vVLvgcl8a1PZnwhunsWpTx4cVgoLlFvIl2raNNk
9KrSfvQDWQ+tGhl/0g0shmjn44PPQNwyeLCC9i8hBXLYOuPSx+HG8nyfDWZ+xuU=
=Q27Y
-----END PGP SIGNATURE-----

--Signature=_Wed__25_May_2011_07_52_30_+1000_gAJguTc_PC6AUYGI--
