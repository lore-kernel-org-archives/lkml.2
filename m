Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab2LLJKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:10:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53052 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab2LLJKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:10:30 -0500
Date: Wed, 12 Dec 2012 20:10:16 +1100
From: NeilBrown <neilb@suse.de>
To: =?utf-8?Q?Ond=C5=99ej_B=C3=ADlka?= <neleai@seznam.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] AES instead of SHA1 for /dev/urandom
Message-ID: <20121212201016.5342ce32@notabene.brown>
In-Reply-To: <20121212085815.GA3151@domone.kolej.mff.cuni.cz>
References: <20121212020354.GA30879@domone.kolej.mff.cuni.cz>
	<20121212130826.7940b428@notabene.brown>
	<20121212085815.GA3151@domone.kolej.mff.cuni.cz>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cm/RLB08c9K4EYNf.rS5H4m"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/cm/RLB08c9K4EYNf.rS5H4m
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Dec 2012 09:58:16 +0100 Ond=C5=99ej B=C3=ADlka <neleai@seznam.cz=
> wrote:

> On Wed, Dec 12, 2012 at 01:08:26PM +1100, NeilBrown wrote:
> > On Wed, 12 Dec 2012 03:03:54 +0100 Ond=C5=99ej B=C3=ADlka <neleai@sezna=
m.cz> wrote:
> >=20
> > > I consider to speed-up /dev/urandom on recent intel processors by
> > > using hardware aes. Same for accelerated aes crypto.
> > >=20
> > > Would you accept a patch if I wrote it?
> >=20
> > Have you read  https://lwn.net/Articles/525459  ?
> >=20
> Yes
> > In particular the paragraph containing:
> >=20
> >    A member of the audience asked why the kernel couldn't just do away =
with
> >    the existing system and use the HWRNG directly.
> >=20
> > Does that answer your question in any way?
> >=20
> No as AES is a HWRNG about as much as horse is type of automobile.

Yes, of course.  Thanks.

NeilBrown

--Sig_/cm/RLB08c9K4EYNf.rS5H4m
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUMhJ+Dnsnt1WYoG5AQKpYxAAldSDNnY1vz/XprtYz4cEsFRUhjfv3E/c
/nhlWHc1hJE/TALp4ULfV3AH5wL05YkCP9xR6p3jM31mwisJoSqOGXr0gb+bxdtV
nxosHUiNU4611iKRoGPo8t9cMSLiCHrmbBuFX7aEEU7DJ8niunR8i0nqk9qgoabp
zLQ2nyOfwWO4mWSJC0rwtjPQWuGhKcvrtXkdFzG64f/6MZtRIEttBmtD7gGZV7Tf
MUzabkFZ9w3yL6ZeMIignqoYqv8DVPv/YiOkHlbCHC4xQWUOB42EEFjW+VyliuJJ
glB7p96uhVDjCESzMLC9KEzcjYLcBnOKy9qCFdJZpazDV2ol2nnLYIQ2QxeULkGh
9qZzaVcDvTGDRyURIQBCLehsIHshhv9WrT5r0PL9LTMiCMRzEokkFZAid3hC7GoK
rclRM48m8HpPLDDInwAy46rGsJpKl4LYPKEHG0JAKo/UQety6UEeee2XPTmBiyw7
2NQMPhwRCvf4Atg/JWnDw8zYAHhwsQnaXki+J4MADGDtQhjm9VmpzXchrQqG3N+6
VLbIhkq9Cgavy5rHeBgery9gi3aKSLBqUtc2dXdK1LMspbJ7SkSb5QU8eBLk23jt
2R2jrgCN9xstr4Sq/SggvEoeUiZUfaF0vGi8rJKhaUm5KCD1dmCRJABK7Vfo4fKs
z/kcmL6h/OQ=
=p6rG
-----END PGP SIGNATURE-----

--Sig_/cm/RLB08c9K4EYNf.rS5H4m--
