Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab2KEAe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 19:34:27 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60770 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab2KEAeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 19:34:24 -0500
Date: Mon, 5 Nov 2012 11:34:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IkRhdmlkIEjDpHJkZW1hbiI=?= <david@hardeman.nu>,
        =?UTF-8?B?IkJy?= =?UTF-8?B?dW5vIFByw6ltb250Ig==?= 
	<bonbons@linux-vserver.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20121105113409.d3f52085b5f7227b03df0ba4@canb.auug.org.au>
In-Reply-To: <20121029111403.911c815a3c7d8d9572ff8e89@canb.auug.org.au>
References: <20121029111403.911c815a3c7d8d9572ff8e89@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Nov_2012_11_34_09_+1100_J_YIqzu/20/5svPy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Nov_2012_11_34_09_+1100_J_YIqzu/20/5svPy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Mon, 29 Oct 2012 11:14:03 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the v4l-dvb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/hid/hid-picolcd_cir.c: In function 'picolcd_init_cir':
> drivers/hid/hid-picolcd_cir.c:119:27: error: 'RC_TYPE_ALL' undeclared (fi=
rst use in this function)
>=20
> Caused by commit c003ab1bedf0 ("[media] rc-core: add separate defines for
> protocol bitmaps and numbers").  The new reference was introduced in
> commit ae08e324146c ("HID: picoLCD: Add support for CIR") which was
> merged by Linus on October 2 into v3.7-rc1 via the hid tree.
>=20
> I have used the v4l-dvb tree from next-20121026 for today.

I still get this today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__5_Nov_2012_11_34_09_+1100_J_YIqzu/20/5svPy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQlwmBAAoJEECxmPOUX5FEfF0P/20lGCmJn/5J3XloVv2xURd2
G2nHTW+7pNAhg6BqK7gdYFu/7yKJP9eQXznYpDtcgaTzKIrWrouzNLFw4GL5icjX
7VV70nnY3QiamFG4zaKAZDw2S6QBYgOf1TEvJXQEncJdjDIGy3jMzwtWlzpFEymi
ZRcilygvV+QvhMHFnsHv42VAIbcRvR1ZvC6zYe3yhRGDY/+i/VTwiDp4ThYDnUZg
3Tljwk3+6FjDuMy4sbYHeVhKRC26/nUbVJ3HH39Z71LrmLMU3h/XiPXCorHsV3kT
GGl8toQwHvQvEN3eN9jA6gXD5ubtxqdxrNU1vzx9F6g1+n1G2osYL4DDy6ART/Qs
NrGP0s4yfFQSvdUdFMYAR+/lYLy7Xe7Qg793v20YHlGnJekJTqJiak8sVz/1KHGR
6SXqqmjFCC54hI4BXpXoyt06/2+qyImcOblJ1XwtHPgmnEVtxhqIGhtLAcKDqxEr
Fdcgh9P18bBMkMm5XP7+Dtl9cdLXP0kMXWLPwPad+rRuMjPuLcYsaeVjwA4+kQKN
4HA1k2FGbEyzbNWC39HTwqkM2koYOSIQ5JQ+jzZsvkNJ3MIM132AkRlkuE6X+oWU
oO/Fsz2bnXvplN6Vn6UldNC2c/VekkvHPyTfboh1RNZziLJfPrAI+Id/3dnIyvBb
JODtr0qsDy5r8VxU4L/S
=dXgh
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Nov_2012_11_34_09_+1100_J_YIqzu/20/5svPy--
