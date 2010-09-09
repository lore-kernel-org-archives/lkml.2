Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab0IILGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:06:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59395 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab0IILGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:06:41 -0400
Date: Thu, 9 Sep 2010 21:06:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: monstr@monstr.eu
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 08/43] memblock/microblaze: Use new accessors
Message-Id: <20100909210624.713183ed.sfr@canb.auug.org.au>
In-Reply-To: <4C88BD8F.5080208@monstr.eu>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
	<1281071724-28740-9-git-send-email-benh@kernel.crashing.org>
	<4C5BCD41.3040501@monstr.eu>
	<1281135046.2168.40.camel@pasglop>
	<4C88BD8F.5080208@monstr.eu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__9_Sep_2010_21_06_24_+1000_3GV7i0YsjOJR2V1T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Sep_2010_21_06_24_+1000_3GV7i0YsjOJR2V1T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Thu, 09 Sep 2010 12:57:19 +0200 Michal Simek <monstr@monstr.eu> wrote:
>
> Benjamin Herrenschmidt wrote:
> > On Fri, 2010-08-06 at 10:52 +0200, Michal Simek wrote:
> >> Benjamin Herrenschmidt wrote:
> >>> CC: Michal Simek <monstr@monstr.eu>
> >>> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >> This patch remove bug which I reported but there is another place whic=
h=20
> >> needs to be changed.
> >>
> >> I am not sure if my patch is correct but at least point you on places=
=20
> >> which is causing compilation errors.
> >>
> >> I tested your memblock branch with this fix and microblaze can boot.
> >=20
> > Ok, that's missing in my initial rename patch. I'll fix it up. Thanks.
> >=20
> > Cheers,
> > Ben.
>=20
> I don't know why but this unfixed old patch is in linux-next today. Not=20
> sure which tree contains it.

It came in via the tip tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__9_Sep_2010_21_06_24_+1000_3GV7i0YsjOJR2V1T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMiL+wAAoJEDMEi1NhKgbsDcwIAIybFy2fc20CUeAlDh11uDKn
Ns72FQioH6oK2G+3pF3xCADKFRVkF1U3oEz0sw7clNtfUy05H5JUdYRkXjlbM/Df
CgQDDubV5cty8qRq4LAV4jfEWEmFDbnmthUZXSjPcwkEgwhJp3L4+VD/nYwa16GD
i3unmEmBO8T6YoQ8LAup/C6Z8RhLRu+9qRh+QwJh1knK+7U5nKpqDUQbtb6OGvXf
tQPfOrBlRwNNWIbl7zPEYqzEL//so7WfqI2AQkmnZLTV4fHSjLUFKhZyO15hqU7J
iIIeP8emzCnQ5JXqdeQGoewbQqTslIPwicNuByS5+25sdpkmAOCf+mebw3ugLpQ=
=g82Z
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Sep_2010_21_06_24_+1000_3GV7i0YsjOJR2V1T--
