Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0IWGEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:04:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54636 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab0IWGEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:04:30 -0400
Date: Thu, 23 Sep 2010 16:04:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Valdis.Kletnieks@vt.edu,
        Anton Blanchard <anton@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-09-22 - build error in drivers/staging/zram
Message-Id: <20100923160423.06c5bf34.sfr@canb.auug.org.au>
In-Reply-To: <20100922212653.6f55104c.akpm@linux-foundation.org>
References: <201009222343.o8MNh9Mp023931@imap1.linux-foundation.org>
	<56264.1285212366@localhost>
	<20100922204305.2fdc5b66.akpm@linux-foundation.org>
	<20100923042134.GA29818@kroah.com>
	<20100922212653.6f55104c.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Sep_2010_16_04_23_+1000_SXkYwkLBTh/nYb7C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Sep_2010_16_04_23_+1000_SXkYwkLBTh/nYb7C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 22 Sep 2010 21:26:53 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> ooh, intentional dumbness!

:-)

> What was the reasoning?

It was done when the staging stuff was added to linux-next - otherwise my
builds (and many others) would fail most of the time (it may be better
now, but at the beginning, there was a lot of mess in staging).

The reasoning is that build failures in staging should in no way hold up
the rest of our development.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Sep_2010_16_04_23_+1000_SXkYwkLBTh/nYb7C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMmu3nAAoJEDMEi1NhKgbsdvYH/jrrYJEyqIvIYC2VWg9Zssrb
rJCWb0ykWyB7dIewOugEsHP9r7xD904gOt6OPtzpYwQtaJ3LbWeeMIM/MBa/6QQU
QhZkQWbeDc1i1mXtYs0Kk1ZwftF8mCAhDZc2zSAusFugZpQYAYMK328JrDDIxmub
aumfaUJ3Fm/RWTARm4iOOgNBWiE7mr4v4rXFCX/odgAp/SeLhtP2t8iTe1BERD5r
mJ3N7anp6qdgS3uDBmJcrWcQxVzj6p7O/fD/vImrTQOnKCSTT7nFlrln0bE0kCgE
DlpnnEuoxVMTcyExmQkLsMPkFH6shXfQxQO6Z2HKqVfF6jrkiFdS+DMcHYTeKS8=
=vn5E
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Sep_2010_16_04_23_+1000_SXkYwkLBTh/nYb7C--
