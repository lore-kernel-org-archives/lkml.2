Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab2KZVkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 16:40:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38408 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561Ab2KZVkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 16:40:31 -0500
Date: Mon, 26 Nov 2012 21:40:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Joe Perches <joe@perches.com>, Sangho Yi <antiroot@gmail.com>,
        cbow@mail.ru, dwmw2@inradead.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] wm831x: Add and use a wm831x_irq_byname convenience
 function
Message-ID: <20121126214028.GQ9411@opensource.wolfsonmicro.com>
References: <n>
 <1350486076-3784-1-git-send-email-antiroot@gmail.com>
 <1350486076-3784-3-git-send-email-antiroot@gmail.com>
 <1350488383.3072.46.camel@joe-AO722>
 <1350496855.3072.55.camel@joe-AO722>
 <20121126213515.C7AED3E08B7@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AFQGHouA0VN8Ovbt"
Content-Disposition: inline
In-Reply-To: <20121126213515.C7AED3E08B7@localhost>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AFQGHouA0VN8Ovbt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 26, 2012 at 09:35:15PM +0000, Grant Likely wrote:
> On Wed, 17 Oct 2012 11:00:55 -0700, Joe Perches <joe@perches.com> wrote:
> > Add and use a convenience inline to get an irq by name.
> >=20
> > Signed-off-by: Joe Perches <joe@perches.com>

You'll probably have more luck getting your patches applied if you send
them to the relevant maintainers...

--AFQGHouA0VN8Ovbt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQs+HGAAoJELSic+t+oim9hDAP/iQSBZCJgwPrpyfgak+F2Vue
FYHr0uqcNVgpEgx/ecwOMcooJ1nmdCM1Wf9guymQFFoyIII2QisJLkLKEj4gknZj
0RpBMlpOJZFkkFIHVQ5UWbJwVHclyrGa4YNR8P/Is9M7JmOXDxZskWBZ+HWer0m9
U17U8AmfyKcJi1oWrF071DmmHJCDDACk6SKm6YG+R1hBpoTg4aeSfkU6zigqApmo
jWprlOl6UV3cesmZt4jcGkqyWIR9Cim6zsiCkd7490YGshAU++6fwt+Jl4bE1r8t
EZJNYDuKlT8hEgbGBUdPtG8PmsAzTPKAiu14eZdOE+NjSBL9k84IvsXBYE719hTu
dmibAJCU4IfTodGNMYMbVma6QOyjN4fccR1FsRO3Xoe7llREOn4pLg4Qe+oCg4Xd
BYQZXOwWDOXqS1FNVe33nTVInr6FB8oa8DBNBOKGq9GIgJJ7Lv9/L6t38wBmqZOi
fBBAt8u6mv/l3RSrQEdAQPkiqQuo/5TZ3nNBbgaYLpdM8ulyD5OxhEauKgF4DQdk
M2U7CkpKwz3lzcqZieT62OAxP6lSCAnsKDJR2W43HBFR0BLfE+5WfFOT8ea4Wa10
UBaFri3Ww43N2Hr3dKoxOdJWVdnO5zI1++GfmxI53CVMpLkE2ZeKIzMfggLEYcKB
F91zYvV2hmEOPCM9p5fx
=kNdQ
-----END PGP SIGNATURE-----

--AFQGHouA0VN8Ovbt--
