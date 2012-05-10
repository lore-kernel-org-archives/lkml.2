Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab2EJJGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:06:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41992 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474Ab2EJJGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:06:11 -0400
Date: Thu, 10 May 2012 19:05:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: linux-next: manual merge of the sound-asoc tree with the regmap
 tree
Message-Id: <20120510190554.6055315139a68ef0b1c48261@canb.auug.org.au>
In-Reply-To: <20120510085355.GC3908@opensource.wolfsonmicro.com>
References: <20120510142552.35f8e15042053707a2086905@canb.auug.org.au>
	<20120510085355.GC3908@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_May_2012_19_05_54_+1000_UFqacnDV5ed4u7YA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_May_2012_19_05_54_+1000_UFqacnDV5ed4u7YA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 10 May 2012 09:53:55 +0100 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> On Thu, May 10, 2012 at 02:25:52PM +1000, Stephen Rothwell wrote:
>=20
> > Today's linux-next merge of the sound-asoc tree got a conflict in
> > drivers/base/regmap/regmap.c between commit 6560ffd1ccd6 ("regmap: fix
> > possible memory corruption in regmap_bulk_read()") from the regmap tree
> > and commit edc9ae420f98 ("regmap: implement register striding") from the
> > sound-asoc tree.
>=20
> That's the right fix - it's already included in the regmap tree itself.

Yeah, this conflict arises because there a set of patches in the
sound-asoc tree that are also in the regmap tree.   They really should
have been in a stable branch of the regmap tree that both trees could
merge.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__10_May_2012_19_05_54_+1000_UFqacnDV5ed4u7YA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPq4TyAAoJEECxmPOUX5FEnjwP/AupQP52lpEQwmNVGT7qI21+
/VARBWK79GOf3I39PiDZhKipzHezFl4ussy6X2niWjUb/koahm2liYMoajoDAfAA
pm2f/c+bGeZWMkv94EZMZ7j+HfFCYYeb/5Q7uFqgKmu7S2KI8I63oswEnG0QTPqh
Nn0Y48saVoSYm4Ds8/Zy7tFVaTI9xYikZxLRg5gxQBUsHQ8n0DrFZepSeD7S7oFh
e+Fm+euuLBlnf8t3f/jTL8EjxC9nyHQIcY8IdLSM0FK7ySqF3N/nsHsmL1l88kwq
nGPHchQOU7KAm4QhD1kE/VzYPOc2zH7deGKj6JbslXeRbYZrrMoz0kFKI+ahiZmj
OhlXntMg2HSkMd9Ii1dJhyiNZevW8oX5LvfKg+U/heTBP/hxM3SKVMhTElDAGmm4
TTwxD6Y5ci6weVJImWiDll7UFiOX44DrtjxjYLe87RmhJR7AOF9IXZKqDUClVNiL
s6kOaXM+rRsJ/jfKRbW+S6sRvW/b/S6OQcgHkloKXPxJwWb0LjTsp9HOPHH13OTT
YyFP0t3bYCQ0Rx73rwf/rGFblIi0HcJYa0XVXtR5EHqBwDGPEUHyiTEgoy08beTZ
g2+DQMHbOypIvWc6YATTumgYog4fh9xayo+ii0uYYv/aqOQdsj6R9RhV+ONPGbII
66kGZ/LQ7eFLVHE3kKwb
=gzNz
-----END PGP SIGNATURE-----

--Signature=_Thu__10_May_2012_19_05_54_+1000_UFqacnDV5ed4u7YA--
