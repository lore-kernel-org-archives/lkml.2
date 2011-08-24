Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1HXXSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:18:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54765 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab1HXXSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:18:46 -0400
Date: Thu, 25 Aug 2011 09:18:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the mips tree
Message-Id: <20110825091837.ebf61e307d65fb77e29b2ca3@canb.auug.org.au>
In-Reply-To: <20110822104809.451b0e8d7b231d70d73aa256@canb.auug.org.au>
References: <20110821094302.e46933704cd74ab7728bfc74@canb.auug.org.au>
	<20110822104809.451b0e8d7b231d70d73aa256@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__25_Aug_2011_09_18_37_+1000_72.j1l2L+gc8.lpV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Aug_2011_09_18_37_+1000_72.j1l2L+gc8.lpV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

On Mon, 22 Aug 2011 10:48:09 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Sun, 21 Aug 2011 09:43:02 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > The mips tree today seems like a complete mess.  It seem to be some
> > historical tree including commits with commit dates going back to 1994
> > and v1.1.68!  Please fix it up as it is unusable in its current form.
>=20
> Since it hasn't been fixed yet, I have reset the mips tree to be what it
> was in next-20110819.

Still not fixed :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__25_Aug_2011_09_18_37_+1000_72.j1l2L+gc8.lpV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVYbNAAoJEDMEi1NhKgbsNNoH/2ECygV87TvAKybFzvz5BLwp
eE6V09A2eJ3iqRoCdqbeFA523gUHusgccCY0MB/G3TX1eChgjU5Msc18/MIu9meE
qlnyknQXrVCsGq3zJgZ00ywdx6AXieVE0Xt6UpJDZlTs3cPG6D+d8q24MLTiOdiq
TT1t9OyB63FF4ozDdSQpn7lmu93f6Byuo5+hRWJi/NH/VviTi6/9pFvGvJ2NFkYn
RoEF9UZfb1GGLHzMhbtFrw2fcXB8O6zrk861o428GuKPFntIg4wg5SfXmXg53szS
Qac4NUf3k/farkBwpBWpFW1bYUIikoqommPVAyOwRaoA7Io4j+scynyKVyQKZXE=
=oQ0m
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Aug_2011_09_18_37_+1000_72.j1l2L+gc8.lpV--
