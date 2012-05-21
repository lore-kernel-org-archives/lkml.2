Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab2EUJPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:15:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46619 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab2EUJPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:15:16 -0400
Date: Mon, 21 May 2012 19:15:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20120521191508.9a5f6d7ea9e71fc924ba9f64@canb.auug.org.au>
In-Reply-To: <20120521091257.GF31407@gmail.com>
References: <20120521185412.aca92107d0a8c4fdd8474e34@canb.auug.org.au>
	<20120521091257.GF31407@gmail.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_19_15_08_+1000_A5aafPaR/DTAefZf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_19_15_08_+1000_A5aafPaR/DTAefZf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Mon, 21 May 2012 11:12:57 +0200 Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > After merging the final tree, today's linux-next build (i386 defconfig)
> > failed like this:
> >=20
> > Invalid absolute R_386_32 relocation: jiffies
>=20
> Hm, that's our fault: seems like a linker bug fallout, one which=20
> we fixed in -tip.
>=20
> > I am not sure what caused this (it may even been a bad merge=20
> > on my part).  I have left it broken for today.
>=20
> While we've fixed this, to simplify merge window integration of=20
> linux-next I've excluded tip:x86/trampoline from the linux-next=20
> branch for now, so this build failure should go away tomorrow.

OK, thanks
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_May_2012_19_15_08_+1000_A5aafPaR/DTAefZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPugecAAoJEECxmPOUX5FEuNMP/RboH1KyTCv+qMB7Jgg4GBAw
Us75WnmaCYQObglZmtgQ6cOeUkjJ3MKh09fQ2Yle8MYVXHZ9ohrN9qIrKYrARhYs
dn5NvW9B8qP9rMI3dd/TIor9vVOXmapxHS9FYhNGT9sLe03hD+3kWOkbCw2EP+OX
pQcfsvspQFc7DH04m+OGREzaaWHQd98iqnQjkq4L4w1Ep7l5+kssFvhSI3xNXUJM
ShNPv6SdcLyA+b5vp939ahhhL0qoYBK+6t/o5UH5SOFYv4R2rZhs1laWNGUikx/n
HLKKFVSlDw51WOh2WuVAGAmxlfbk8VlLd74LJc1gSFqA8lbBe6nn4BstMQBjAvrb
cG2eqy4unpADB5JGSsed9Rer1iSadzbtDjTjPOfIUioP6ELDAcg/Ifd2K8eNlZhO
di0PFLrPa9M3EJ7WQmgjTTn1nLk1LenTl7zSuDkMmqzGEY0zaKmjNqqVRlRR8gHU
QSrJkoGJ/zVRI6JA5e9fngDXgAghf2aFVZkb9p8UiUU+i+LXxkdJtl6w0VPaAZLe
OX1nbFd7SzTdEd6d7DcaUJ4+8OKoBhSiaqr0BnBiYYZNzyjaGSaM/qNGhMxytrpK
5yKC9J/qiL0LzpPJBqCyZPtROtUX9wUh348rNM6rJeq+uBYLIC5ODNY2Ve0Dish1
6PFVhoiZu154urYYI7z/
=wHRN
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_19_15_08_+1000_A5aafPaR/DTAefZf--
