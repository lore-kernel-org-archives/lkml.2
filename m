Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab2JRA2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 20:28:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52283 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab2JRA2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 20:28:39 -0400
Date: Thu, 18 Oct 2012 11:28:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: linux-next: build failure after merge of the l2-mtd tree
Message-Id: <20121018112830.7649de7fb703a63dee285254@canb.auug.org.au>
In-Reply-To: <20121012111451.ad2a5db59d470cf24393226a@canb.auug.org.au>
References: <20121012111451.ad2a5db59d470cf24393226a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Oct_2012_11_28_30_+1100_mad=jOeVAU69I.Th"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Oct_2012_11_28_30_+1100_mad=jOeVAU69I.Th
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

On Fri, 12 Oct 2012 11:14:51 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the l2-mtd tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> ERROR: "denali_init" [drivers/mtd/nand/denali_pci.ko] undefined!
> ERROR: "denali_remove" [drivers/mtd/nand/denali_pci.ko] undefined!
>=20
> Probably caused by commit 305b1ee29c8e ("mtd: denali: split the generic
> driver and PCI layer").
>=20
> I have used the l2-mtd tree from next-20121011 for today.

This is still broken today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__18_Oct_2012_11_28_30_+1100_mad=jOeVAU69I.Th
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQf00uAAoJEECxmPOUX5FE2HwP/0SH2fNk8pDFlUCvSBFao373
ArMgnAC1fw8KvKTiziqNwJ0o3Sc4XB0qDovEeu5bs2bP7lAyhU/LyOvmEbZG5myD
69V5kLYBTy2WtZUhu38IrCEzNrcSoXIHazlgPrYAejl5or0azoQNwnRYkc9a/iXq
oPLZAiHqAcYNYquuMKnGevwZRKcohip7Hgk9it8ryIqeDghZiRXS6fEj99z6tlsn
UAyTBsLNN0puzHug2fLDqn0LvyMiaNxdrhv+kZeqtEnD9gJtgKRDMeSnOHeWlwUV
tgIeGE2KB8u2N10GoHvD0wBRqQxrzBxc8ELiLoz23k/OHJqDrxRIZSGSc7NEAECb
YJx4bQxE2V70xiyQN5p0Z8jEXHPHuRX2u8xSfCY46dP4eikOfBPbzfhxAxKm8htz
xmozvj5xPNRGtTMoYMNAFkMkQkJ1heoPCUqs1JlkFg4A5KAunqT+dF+KSLwDbBik
n9JExu2cJsz2gqY/bhyQp6oU0occfBsF705yvzDxm0ANf2YzotvAaRDK8HHHA65o
YVbnC8tDErTuoXQXRdzqre6H4bnVkx+1yIjl7Q3dzKScuYEoZWYDNqfly9xrDgaR
JMpcgapsL5N9KBg1dG7PCFs4Z+yAptL00479yftlwrA9iG94/BGF5M3q/AEwK0iJ
dxVyBbOay/HDzk0MMCUc
=U6O8
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Oct_2012_11_28_30_+1100_mad=jOeVAU69I.Th--
