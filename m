Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1AJAuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 19:50:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53482 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab1AJAuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 19:50:08 -0500
Date: Mon, 10 Jan 2011 11:49:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warnings after merge of the tty tree
Message-Id: <20110110114959.691c20f1.sfr@canb.auug.org.au>
In-Reply-To: <20101221194204.GA11611@kroah.com>
References: <20101221181158.53f62590.sfr@canb.auug.org.au>
	<20101221194204.GA11611@kroah.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_Jan_2011_11_49_59_+1100_PS_x3pP2t25j2HwG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Jan_2011_11_49_59_+1100_PS_x3pP2t25j2HwG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg, Kay,

On Tue, 21 Dec 2010 11:42:04 -0800 Greg KH <greg@kroah.com> wrote:
>
> On Tue, Dec 21, 2010 at 06:11:58PM +1100, Stephen Rothwell wrote:
> >=20
> > After merging the tty tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced these warnings:
> >=20
> > drivers/tty/tty_io.c: In function 'tty_init':
> > drivers/tty/tty_io.c:3309: warning: ignoring return value of 'device_cr=
eate_file', declared with attribute warn_unused_result
> > drivers/tty/vt/vt.c: In function 'vty_init':
> > drivers/tty/vt/vt.c:2997: warning: ignoring return value of 'device_cre=
ate_file', declared with attribute warn_unused_result
> >=20
> > Introduced by commit fbc92a3455577ab17615cbcb91826399061bd789 ("tty: add
> > 'active' sysfs attribute to tty0 and console device").
>=20
> Oops, Kay, care to make up a patch to fix these warnings?

These warnings are now in Linus' tree ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_Jan_2011_11_49_59_+1100_PS_x3pP2t25j2HwG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNKle3AAoJEDMEi1NhKgbsSk4H/1Pxi/lnAdBWK1TgNcGFChN0
XciycWwaoqIWZdFy08OhO1BMTRzbibs8Ul0xuZ/OEh+6EJY+s9tWLFjMr3sNvLhT
Zq4rz7gVSn2um7f4SB6bflq4fu5V8Sc5BtU5ACQHVa4TInv5FC1yGjwR7fAAbVqT
kiryrzBb294uO3kAM+2jlOjLtcGjOCY+Z/p+u/BPdTRTKZelvlyPW1WVWaFIYU7N
VlU0o2c6MAOeIeAAHyXeDyceHB9GMFnLBHYQTU99tB2dVRLrf45FkguPUQKqqA4S
Frx2NfJ2MqUXMnS5HhfDR+x2DL/oJdpDBIFP3UKtpJ8QrtOs4mK/o/th17m/PTw=
=t7Xg
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Jan_2011_11_49_59_+1100_PS_x3pP2t25j2HwG--
