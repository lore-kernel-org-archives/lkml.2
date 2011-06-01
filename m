Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295Ab1FAXs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 19:48:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55365 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab1FAXs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 19:48:57 -0400
Date: Thu, 2 Jun 2011 09:48:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: Re: next phase of tmem into linux-next
Message-Id: <20110602094850.92063cbe.sfr@canb.auug.org.au>
In-Reply-To: <dedd3fa5-5dc3-4ce1-9ab4-dc77e23a6d7d@default>
References: <80f7ab04-7ae6-48cb-b254-e99343147bf0@default
 20110601142544.62494a52.sfr@canb.auug.org.au>
	<dedd3fa5-5dc3-4ce1-9ab4-dc77e23a6d7d@default>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__2_Jun_2011_09_48_50_+1000_dKCgw.ySLX8rCpjs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Jun_2011_09_48_50_+1000_dKCgw.ySLX8rCpjs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Wed, 1 Jun 2011 09:22:59 -0700 (PDT) Dan Magenheimer <dan.magenheimer@or=
acle.com> wrote:
>
> OK, I see "Already up-to-date" in merge.log.  I'll assume
> that the new frontswap commits will lag a day.  (Thanks,
> Konrad, for helping me find this info and pointing out the
> probable lag.)
>=20
> (A thought... perhaps the merge.log generation script should
> do a "date" at the beginning and end, so one knows if one
> has just missed your merge window?)

Yeah, well I am out of sync (timezone-wise) with most people, so good
thought.  Though I actually fetch all the trees before I starte merging
them, but it will give people some idea.

> > The tree is still called "cleancache" in linux-next.  Should I change
> > that to something more generic?
>=20
> Yes please.  A good short name would be "tmem", but if you want
> something longer and more descriptive maybe, "transcendent_memory".
> I expect in the future that this might be the path for, for
> example, tmem-related code that is promoted from drivers/staging.
> E.g., the generic tmem.c code in drivers/staging/zcache could
> probably end up in lib at some point if/when there are multiple users.

OK, I have renamed it to tmem (much easier to type :-)).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__2_Jun_2011_09_48_50_+1000_dKCgw.ySLX8rCpjs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN5s/iAAoJEDMEi1NhKgbsjY8H+wVY2PjhDoxfcX1CA/dOgbGm
DPIjMfV564zKExkABWRagQomR3gUQcOz+xzrsp/nEoVrSDArjsMeb2QURJsioqNr
D9qz+k0eHHwgVwOq5n0IYfydZSaqnWKoRfpaBAJSQluo4hRQKZFPR/22iO7gLXpA
dzCkqJfeR0n7crQ320fny2bZYt+yPz52tbC7nhJ++su1gBMkkKuuksYg9ejVhGTK
UCqCsLfLDqopUbOEOCcUDh8NXLQNeKmm3irU0vQc5bo7c0XH/njb5i2gmoktz0pE
XJa1Xxzs6x+HogAvOia/FIkon7lWZju6E/YRTfk8XU69UPkliK72yKPFo/my90w=
=IghV
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Jun_2011_09_48_50_+1000_dKCgw.ySLX8rCpjs--
