Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab2BGIAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 03:00:06 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47909 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab2BGIAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 03:00:04 -0500
Message-ID: <1328601726.22240.45.camel@sauron.fi.intel.com>
Subject: Re: linux-next: build failure after merge of the l2-mtd tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Feb 2012 10:02:06 +0200
In-Reply-To: <20120207135815.b551929e844a3824d7943e76@canb.auug.org.au>
References: <20120207135815.b551929e844a3824d7943e76@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-VZjxbr3sl+mkN+o7pp/a"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VZjxbr3sl+mkN+o7pp/a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-02-07 at 13:58 +1100, Stephen Rothwell wrote:
> Hi Artem,
>=20
> After merging the l2-mtd tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/mtd/devices/pmc551.c: In function 'pmc551_erase':
> drivers/mtd/devices/pmc551.c:157:2: error: implicit declaration of functi=
on 'pmc551_point' [-Werror=3Dimplicit-function-declaration]
> drivers/mtd/devices/pmc551.c: At top level:
> drivers/mtd/devices/pmc551.c:194:12: error: static declaration of 'pmc551=
_point' follows non-static declaration
> drivers/mtd/devices/pmc551.c:157:2: note: previous implicit declaration o=
f 'pmc551_point' was here
> drivers/mtd/devices/pmc551.c: In function 'pmc551_unpoint':
> drivers/mtd/devices/pmc551.c:229:1: warning: no return statement in funct=
ion returning non-void [-Wreturn-type]

Hi, thanks a lot, I missed this. Fixed and build-tested with ARCH=3Di386.

--=20
Best Regards,
Artem Bityutskiy

--=-VZjxbr3sl+mkN+o7pp/a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPMNp/AAoJECmIfjd9wqK090IP/isG9UTwQRYleh9hOxE0sSud
FzynQePid42FvdIUJhjIaJ+EUSPnxZtwQZ/4cekcubq8tdNCP+3yU3dbPwWicyF8
vPkMRQvJiZI7wtIfbsqBJ+OY4YxAEe8QmrE6EoiQYGjaYzksvVsv8eCCvefZCUNP
GiOoxbtWc8du5Iio2LVDaepzhTv58ZKYR05avFn2FbbGxyvTHD0+S8k/6eWu7pOZ
0JnQH7Dicop456Kj5Za4OQmqt4brPeuLrmu/15evqsab1Z0IV7rICKucVqn+1oZD
OzDmbXb+etTh81NJ6wz6ieQ5Q3PEFiVfjO7UXpVrorxxrJOyzPO8YHGykhaQztiP
SYZzwhp+AJQhNftnUyuQUSO2Pb77wuOdS5s8M7M2ks6wKdAhjrN4ff24u7GzOto/
xriE85SKhMLbAImneJDA1bPPKNCq4bCQ7aSsiBzLno/qFtcVnACCTi20+j5Z6wEG
pcleh0lYAbNMYdqQNqaBERKLTqecoOtb9ubS+X8yLB42eSlCykrNziJMbAFCMpac
5ekEZxVXX/sIGIdEfrCn5Zr5MLHKI2OYrvl7wU9H2jbFge2DPPc0SHgOj0WfVPC8
w2qm64L01R4fh0gZEH050fCYkK/ka/9/9Uu0MHEmQXRz6UKl13FHwkBDRzdfLCwa
p2T+bCT6vO9hHBq5rsGn
=6xxF
-----END PGP SIGNATURE-----

--=-VZjxbr3sl+mkN+o7pp/a--

