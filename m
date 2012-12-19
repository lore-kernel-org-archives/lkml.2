Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2LSPTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:19:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53772 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2LSPTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:19:47 -0500
Date: Wed, 19 Dec 2012 16:19:37 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc-pcf8523: Add low battery voltage support
Message-ID: <20121219151937.GA21212@avionic-0098.adnet.avionic-design.de>
References: <20121219140456.GA14217@axis.com>
 <20121219144225.GB7837@avionic-0098.adnet.avionic-design.de>
 <20121219151054.GB14217@axis.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20121219151054.GB14217@axis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:z3WvqXsTh1QeeZgjL7KZ1M9cNiRn6fgGuTX2x31901J
 sOrqcGEhXB2rWuTxJgCpM5BEMDNiD0Ch8yyCpoD+FVJnZ4qaBM
 OQmGSjAPewjkCrlCCEWJ27ZIr0V5Yp3Ga531XbY5KnkM1yxSzz
 bJRIz9sHmHDWDEXm+FoO8BQOUFNZqsenuMHbKKJwA/XECGox+D
 uk73XLpgtDLY3mkys8V7VW7BpCFS4kLs0KAK+Q3LTpM3Kr062q
 l+iUjh6B3aX4umfce6tEbxyxpwBYaL8uPV5UXZCjVsy64FwlME
 Bm9BEb7MKN3OB6ZZ654bPtR6WRCjYj/H4OEz634T0TebAsSIDJ
 URXJLARw5NWcA2sYfsel/oz3T5aL5cj0Ljw7/cv3Ewd7xZ/1j4
 Fm3upziHK5EyTmj803dGXcYcdVNIdJj6vU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 19, 2012 at 04:10:54PM +0100, Jesper Nilsson wrote:
> On Wed, Dec 19, 2012 at 03:42:26PM +0100, Thierry Reding wrote:
> > On Wed, Dec 19, 2012 at 03:04:56PM +0100, Jesper Nilsson wrote:
[...]
> > > +	.read_vl	=3D pcf8523_rtc_read_vl,
> >=20
> > What tree is this based on? None of the trees I have contains .read_vl
> > in rtc_class_ops.
>=20
> Hm, I've tested this against a local 3.4 kernel since that is what my
> device had, I didn't realize that we already had some local changes for
> the voltage low stuff.
>=20
> I'm guessing the right way is to do it as the pcf8563 in the mainline ker=
nel,
> I'll respin my patch and resend.

=46rom a quick search through the mainline kernel history, there's no
trace of this field.

Thierry

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ0dsJAAoJEN0jrNd/PrOhszMP/ilgOaRiJ5JPfvCZgHZlb2zJ
1LTeiJEKYtO7CEKw01waKaX5gAYDVYvJ9CmrK/Q4V1vFFAOtcTUTsczFtbV0UAFT
WCIrM4rwhJdruv53V0vDJGPOZIMc7334b/oEOrqY3EGOobi3FXVV0ioDVwES++kB
Yvt5Sbws9JIqcu/HR6iTps3hfOaKAOsqiXSWpwYQjx1/+68ynYD16uQG0KBMogEF
QNP1MFkTVzTS3IcTh+AG7lIHyG9UMkm6Big07acbbe0fjrcVNnhx2kXFxmMtXapD
UIU55rhdHEK9KTbsSG3I2ytD4YYv4OJsdDrHeUH3LyoYsdt79WIy+vqV8/AW/4j9
+QRhQ9SQGBvlIOwxDShSt4owXaYRtCWm1kzib7QO3I6Jmq10XF4upNFPWVZegvYf
DRTxH228emxOeShQ4vevhbXN4/9DPjirw7jxC/v/cVyqmZXGzdGJu5ACUOaKpsBH
ktb5pl1okbWEyUx0NZ6ieI+zbe/Qc+dk6n+t4UWp0sXa9Mlbwz+0jIUsesdWJ/Ql
plszfjqTYG1+2/XNtvLz8eoCWVxHM9qMCDdjY9G3iJWyyaDEXlOTFej8FrNzvr0N
MzFWDGzmuCCN7FRxQF6+IoasR2/6SYp9pg1dfpGs+UqZYD1ovimq4Nvqqs4lwwIQ
k6oqFBUhhMeWvyxE7Lzm
=7vPN
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
