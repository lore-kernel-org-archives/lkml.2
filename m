Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab2JRJ0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:26:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:52682 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab2JRJ0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:26:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="asc'?scan'208";a="229142355"
Message-ID: <1350552398.5769.304.camel@sauron.fi.intel.com>
Subject: Re: linux-next: build failure after merge of the l2-mtd tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dinh Nguyen <dinguyen@altera.com>
Date: Thu, 18 Oct 2012 12:26:38 +0300
In-Reply-To: <20121018112830.7649de7fb703a63dee285254@canb.auug.org.au>
References: <20121012111451.ad2a5db59d470cf24393226a@canb.auug.org.au>
	 <20121018112830.7649de7fb703a63dee285254@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-yPUsoUkWFNJnR7B/lr55"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yPUsoUkWFNJnR7B/lr55
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-18 at 11:28 +1100, Stephen Rothwell wrote:
> Hi Artem,
>=20
> On Fri, 12 Oct 2012 11:14:51 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > After merging the l2-mtd tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > ERROR: "denali_init" [drivers/mtd/nand/denali_pci.ko] undefined!
> > ERROR: "denali_remove" [drivers/mtd/nand/denali_pci.ko] undefined!
> >=20
> > Probably caused by commit 305b1ee29c8e ("mtd: denali: split the generic
> > driver and PCI layer").
> >=20
> > I have used the l2-mtd tree from next-20121011 for today.
>=20
> This is still broken today.

Sorry for slowness, now it should be fixed.

--=20
Best Regards,
Artem Bityutskiy

--=-yPUsoUkWFNJnR7B/lr55
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQf8tOAAoJECmIfjd9wqK08xgQAJZ7LvLUo8qPiUccmWafJy7M
fbv6BjATcuwoNDcycHDql/DQj8xg+FEnIsu32399wG80uUci3rIZDXvgcKzMQyAf
PS6pR3o1QGR81aB4brGafWTTlwKniQwFFKvkx1YXApOWa49dlwrxxsSlYgXzd62F
r1RqCetD847WNcxvdAQ6qkRxH1NyZsm2swnUpy0ap/R05gV1Jf0k4jp8oUO5BS1O
Erk4l7ZunD8amF/FMPUDsrEHhZmPtwWK3KXggQbFsQaD0zFmd682cq6G3jprwK6X
1qLkbqlIOSug2ZCpchwPpzT2BjZK5dKMNcfv/+6qjb30+7LlUtQ1SDctfsZYLOmM
baFOlPSv/KqZcuXyZCmkZ5I1yd8yM9gPKWNxJ+SH478iDWU0putfCwLJilbCeB7p
M6OWlYFqgO27pTTan/lfDY/m2d1zEyFY1YJY/KHVk+I5I45m7yfS1rcRdwc6/+C4
vNlLwiXBNmQzAGSCnWGfTfa3xMpi6Md5DDovw/sBLqp0XKoDOf8r1i3x3nwOdApy
Whcn+Ce/ypaAPAjWw+LhTCXd1OBDIhp6FYv4gNxjRlAtlIw9K/R+VRlvSv6Jccqf
QyE9CC9lpdh+5PTGO47JnE5r62T5VEir9KhMc9xAI1mRpNJ9TTxeiLbGPaggRekb
bQIyRXzLBEimGmBRipyi
=QgMJ
-----END PGP SIGNATURE-----

--=-yPUsoUkWFNJnR7B/lr55--

