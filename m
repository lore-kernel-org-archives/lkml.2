Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533Ab2HJCYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 22:24:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46768 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759047Ab2HJCYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 22:24:05 -0400
Date: Fri, 10 Aug 2012 12:23:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Amit Kachhap <amit.kachhap@linaro.org>, Guenter Roeck <linux@roeck-us.net>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: thermal patches in linux-next
Message-Id: <20120810122355.8d6429ac84aa26d296a89e7b@canb.auug.org.au>
In-Reply-To: <1344562866.1682.698.camel@rui.sh.intel.com>
References: <1344308038.1682.637.camel@rui.sh.intel.com>
	<1344494746.1682.669.camel@rui.sh.intel.com>
	<20120810090859.7ec67594f794c38c52096544@canb.auug.org.au>
	<1344562866.1682.698.camel@rui.sh.intel.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__10_Aug_2012_12_23_55_+1000_O7UZpVJ=ricykkiG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Aug_2012_12_23_55_+1000_O7UZpVJ=ricykkiG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rui,

On Fri, 10 Aug 2012 09:41:06 +0800 Zhang Rui <rui.zhang@intel.com> wrote:
>
> > > And could you please drop these commits
> > > ef25a0fe0087963c1611c1c8903886fbea053f76
> > > 09ec52fca274ba88d68df3198de92abdaaff417b
> > > ab6d2f029358c917508bf88bbd6a9193a8e39fc8
> > > 66447fa993cbce56b4076f169a56f62350f6c7b8
> > > ec62abb8b46021ca9ee6b8692b26974ace9007f0
> > > 5ecbaf57d7885eedd924e391d91847d3df9fe0f8
> > > 851414b2249afd8c128d29912dfd7060eaea8932
> > > and pull my next branch instead?
> >=20
> > That is not how linux-next normally works.  Those commits are in Adnrew=
's
> > quilt series, so you need to ask him to drop them.  However, because of
> > the way the akpm tree works, any duplicate patches will disappear from =
my
> > copy of Andrew's series.
>=20
> could you please drop these patches?
> these commits either will be or has been re-based on top of my tree.

You should always quote the summary line of commits.  Andrew is using
quilt to manage his patches and so those commit ids mean nothing to him
(and they have changed in today's linux-next anyway).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__10_Aug_2012_12_23_55_+1000_O7UZpVJ=ricykkiG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQJHC7AAoJEECxmPOUX5FE6+MP/R8IiQf26cXZN8CKM/t6bIY1
aKdJ/MXTU+hBsVYMZk3zUN/Ed/4yQRCO/AA0abqVt7aN22fR0ugNmYYmT5r6RisY
d2e1OUaJsZph2Oy8jwmqYFo2+IRpIv/1ZsNDRaV9tHNcxassa86jKcmTpUwRo7yo
J+I3AwKgLG3/dKs/PCofEiJhcJIbCbYYf9TTa0SxcOzRph4kQT6XQBE9M5HWUWxo
b6w02Wq6F8rnU2pw4Qvc1NxFu5oV8elMcJJyJymTuLjlqECjUUPA9YaudWcYXntp
rZwfhAEkzorindngk8caMzOTCdwpZVHtP59evCku273cX9TylWu4WhIiciNUJbrt
PNEvnR46k5JLqH9c0XATHHNN+AEegEUAS5oNxRRY8uyWOAC0kayyFTMo6+VaJaSQ
EG312ra1lVYl7NpdfjFPYLHqudYogB7g/KBmvXzKP4g65YYWKSXRXE72FuUQSFz4
WWYdCyeu4NO4guMLPZAZkPjPTm/jnZYe4g+N8bwQ/uZIhxIIxIz6gr2J7efFF2Au
aJF23+QxLRAkS9+vZJee+1xNy/Ej54Usa3Fe70T0gblAKva05O9DdSlX3ZWt4Gd/
ISn9JvQ8wOw8bqWrkUy9QvCV0R0neTXTiqYXJZKAyDQue1rqPA8A6djUmIRNrJEH
H1fnnQdr9nsc+qOjZh4o
=hPzY
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Aug_2012_12_23_55_+1000_O7UZpVJ=ricykkiG--
