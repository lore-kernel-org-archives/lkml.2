Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203Ab1KCR7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:59:01 -0400
Received: from www17.your-server.de ([213.133.104.17]:57360 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab1KCR7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:59:00 -0400
Message-ID: <1320343132.29441.20.camel@localhost.localdomain>
Subject: Re: Bug: [Toshiba Satellite A200] SD card recognised but not
 automounted
From: Thomas Meyer <thomas@m3y3r.de>
To: Avdelas Lamprakis <lamprakisa@yahoo.gr>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Date: Thu, 03 Nov 2011 18:58:52 +0100
In-Reply-To: <CAM5dq2CBBEf0S2FpRtWCLfG_7k2PK8TbZTPqW29ouj+io8p0XQ@mail.gmail.com>
References: <1320269478.98312.YahooMailNeo@web27408.mail.ukl.yahoo.com>
	 <1320271853.29441.8.camel@localhost.localdomain>
	 <CAM5dq2C7oaO9NGmg0v9euT8cAWwv-Go4DQNyxHuDXHoZbWbsoQ@mail.gmail.com>
	 <CAM5dq2CBBEf0S2FpRtWCLfG_7k2PK8TbZTPqW29ouj+io8p0XQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-7nIKwI1d2iIAFN7i4A9L"
X-Mailer: Evolution 3.2.1 (3.2.1-1.fc16) 
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7nIKwI1d2iIAFN7i4A9L
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Donnerstag, den 03.11.2011, 18:22 +0200 schrieb Avdelas Lamprakis:
> Here is the bug report with all the relevant information:
>=20
> Lamprakis
>=20
> [1.] One line summary of the problem: SD card is recognised but not autom=
ounted
> [2.] Full description of the problem/report: SD card is recognised but
> not automounted
> [3.] Keywords (i.e., modules, networking, kernel):SD card, kernel
> version 3.0.0-12-generic
> [4.] Kernel information
> [4.1.] Kernel version (from /proc/version): attached
> [4.2.] Kernel .config file: attached

hi,

I fear I cannot help you. you may try to get in contact with the
original driver author of the tifm.

you could also try to enable the dev_dbg() calls in the tifm driver
sources. maybe the output of these debug printk calls help you to
further diagnose the problem.

you can either:

a.) put a "#define DEBUG" in <linux/tifm.h> and rebuild your kernel

or

b.) build a kernel with "CONFIG_DYNAMIC_DEBUG" enabled and enable the
relevant tifm files/modules for dynamic printk in configfs.

kind regards
thomas

--=-7nIKwI1d2iIAFN7i4A9L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOstZdAAoJEK2Y/UtDbsHsSAcH/2vXXxGcVGQ6NcbyL3v8Icnq
Did2ZtVjEN6pwNkUmuQjAg6N5QjbxT7/rSdkyvfdIXnmREN0YMxWqDfZI3skeg/W
Yu2YtM1bbiI0HSlA1yii/UBo+tfi84MAlD4yNEsm3HSHvxAFqPNAas/2CXYYk7a0
9GY1BObDD6J0J6u5rH+VjoZQqSq5g6JJ8VRjVzF2dzWqY13AHiGR8uRwqNqx7Rcx
p6Quu8HAY2AdtE90cemAK1+Um0JhIzxD9VJB9k8vOJdIF27tvtiQ96x08A48VJ7U
OSqy7T8G3IGwEfRcK50XRwTEthSwfypA++j8/KOBXA3evsnZSMGE1dFC84YtDjM=
=zQ5I
-----END PGP SIGNATURE-----

--=-7nIKwI1d2iIAFN7i4A9L--

