Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab0D1GOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 02:14:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39115 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab0D1GOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 02:14:31 -0400
Date: Wed, 28 Apr 2010 16:14:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tobias Klauser <tklauser@distanz.ch>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-Id: <20100428161425.eff4c40a.sfr@canb.auug.org.au>
In-Reply-To: <20100427151305.GA7653@kroah.com>
References: <20100427141224.834a102a.sfr@canb.auug.org.au>
	<20100427151305.GA7653@kroah.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Apr_2010_16_14_25_+1000_gtGT3mzV0RmCruX4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Apr_2010_16_14_25_+1000_gtGT3mzV0RmCruX4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 27 Apr 2010 08:13:05 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Tue, Apr 27, 2010 at 02:12:24PM +1000, Stephen Rothwell wrote:
> >=20
> > After merging the staging tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > ERROR: "uart_console_device" [drivers/serial/altera_uart.ko] undefined!
> > ERROR: "uart_console_device" [drivers/serial/altera_jtaguart.ko] undefi=
ned!
> >=20
> > Introduced by commits 76bdbd933febe791fee114e7bb6c42bbd1a3f4f3 ("serial:
> > Add driver for the Altera UART") and
> > 11c59b34b299d7214b466cf799410a9a540476e3 ("serial: Add driver for the
> > Altera JTAG UART").
> >=20
> > I have reverted those commits for today.
>=20
> Those came in through the tty quilt tree, not the staging tree, right?

Yeah, I just don't do a build between merging the tty and staging trees.

> Tobias, care to send me a patch to resolve this?  I already fixed one
> Kconfig issue in these patches (forcing the driver to always be built
> in.)  Is that what caused this symbol issue?

I have reverted those commits again today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Apr_2010_16_14_25_+1000_gtGT3mzV0RmCruX4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvX0kEACgkQjjKRsyhoI8w+8wCffuXYIHSSzxcFtojAHyiBgQST
CosAoKB0p3M0dnEn1H8eAOSoVTvOWEVL
=904y
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Apr_2010_16_14_25_+1000_gtGT3mzV0RmCruX4--
