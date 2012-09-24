Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab2IXQH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:07:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52490 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736Ab2IXQH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:07:56 -0400
Date: Tue, 25 Sep 2012 02:07:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Simon Arlott <simon@fire.lp0.eu>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Chris Boot <bootc@bootc.net>, Dom Cobley <popcornmix@gmail.com>,
        Dom Cobley <dc4@broadcom.com>, Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: linux-next: Tree for Sept 24 (irqchip)
Message-Id: <20120925020744.cc5beb9e65473605e5ca2240@canb.auug.org.au>
In-Reply-To: <50607E99.6040303@xenotime.net>
References: <20120925005328.f748dfa3d077cebb345a4291@canb.auug.org.au>
	<50607E99.6040303@xenotime.net>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_02_07_44_+1000_/L4OzoaAEfqd_q2p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_02_07_44_+1000_/L4OzoaAEfqd_q2p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Mon, 24 Sep 2012 08:39:05 -0700 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> On 09/24/2012 07:53 AM, Stephen Rothwell wrote:
>=20
> > Today was a train wreck, with lots of new conflicts across several trees
> > and a few build failures as well.
>=20
> I agree.  I mostly get this:
>=20
> drivers/Kconfig:157: can't open file "drivers/irqchip/Kconfig"
>=20
> i.e., no such file.
>=20
> How does this happen?  :(
>=20
> who handles irqchip?

Hmm, commit 89214f009c1d ("ARM: bcm2835: add interrupt controller
driver") from the arm-soc tree adds that file as an empty file (I have
the empty file in my tree).  Nothing adds anything to it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Sep_2012_02_07_44_+1000_/L4OzoaAEfqd_q2p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYIVQAAoJEECxmPOUX5FEGQ0P+gJfLMfVtc3UpCbO0ILXwx4v
vU8dXZhNkcxnY3x5keeOmGUuW+UywazKbh4wrtjkCOI0thyMLfCvR/QALp9WG/yv
SmEFUVYOdWNKjimYFxQh8jlwmkNXFem+L6jD5GRSjYodQ1Q/WxX83gIodfxpCNe0
ZPI8puLUVZlPagdlGz0beHfdC3RBGDCmDk6D2FR7YHEamDx2A8cstEKVV7Na4WBW
0M+rwsREdKgKsTfN0LwpqQAiAMJj98DlIx7msgnF9/IHlfVjSNXdwyPF+umYh7fX
92Zy+z6TSw5BKJJ8c6Lqdxuq01prnfvUT9yQy5vKO6TbSgaK1QWcxzuwpVkwArJj
m+oxePxYo3PGROPGU1E3IWtd0H2si/OJqeAcGVSHjHwUoT31zGE6TEFMV6ts0WfX
e9RyHcwjqDy0Fd32XhQwnBnWAjnHTXGPlVxU83nvQdrgLxQvUpnzLenHf/Fx08cj
UC7HNbuBMGteQTZ/D8UX9cyAhQyeOf1j9qGt6GUMvK6c3WuVyaDkzw9yp0Rn8X38
kDxd95wKOdgGBq6+jGHv9THdZ7d3sEMpixqqBI2K6rJil9nvw2tUZ+ttLSmZB89Q
0o1PjK3Sc6boUgtMgHZaNRNYHz17i8OOMTYEl3LvEwy6e0vp2/4v0S5KrD3y0WaA
OIV3hIppaeGSs/23hv3u
=fNY+
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_02_07_44_+1000_/L4OzoaAEfqd_q2p--
