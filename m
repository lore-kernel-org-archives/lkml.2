Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1AJB7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 20:59:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47142 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab1AJB7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 20:59:14 -0500
Date: Mon, 10 Jan 2011 12:59:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warnings after merge of the tty tree
Message-Id: <20110110125908.4251eb45.sfr@canb.auug.org.au>
In-Reply-To: <20110110005601.GA19570@kroah.com>
References: <20101221181158.53f62590.sfr@canb.auug.org.au>
	<20101221194204.GA11611@kroah.com>
	<20110110114959.691c20f1.sfr@canb.auug.org.au>
	<20110110005601.GA19570@kroah.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_Jan_2011_12_59_08_+1100_M=f4O=V+p1arUaEh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Jan_2011_12_59_08_+1100_M=f4O=V+p1arUaEh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Sun, 9 Jan 2011 16:56:01 -0800 Greg KH <greg@kroah.com> wrote:
>
> Yes, Kay just sent me a patch to fix this, which I will queue up after
> .38-rc1 is out.

It is surely a pretty obvious patch, why not just do a quick test and
send it on to Linus (or at least your tty-current tree)?

/me gets annoyed by more warnings than necessary - especially when they
should have never been introduced in the first place.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_Jan_2011_12_59_08_+1100_M=f4O=V+p1arUaEh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNKmfsAAoJEDMEi1NhKgbsk3sIAKAW0/AqffBfdUp/z2zsT5Rn
mCnCGNLCDP3idxpFa7Mec2djGTIevXnv7Wp+1LUmE6orR4duB+H5xaGxJJaMP4Ev
StqsyUEm64NQ8OTmaqNvHlKuoXQ1pcmyNSAFFwkKK4VJKYML5HPVhHL3P5pO4BjY
rVpjTgV5D7xyOpAnqvRQbGyZNwCu6j2LI5YNC/bTH9iYg1FqYUfYmX6cs/4qKk7n
LV4/WFs30U51yfC9jW5zlVMi83oY2oLq7amyViMxq0lxcEU3AO+G3yjm/i49Vu6g
ia3IV5zw0QGyDbTWC3yHdp7CURoCeJUA6pOVbpIic3MD2VWaoflN4NHZ5b5X1KU=
=vwrQ
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Jan_2011_12_59_08_+1100_M=f4O=V+p1arUaEh--
